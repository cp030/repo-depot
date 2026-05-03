#!/usr/bin/env bash
# Design quality gate — run before every push.
# Usage: ./check.sh path/to/index.html
# Usage: ./check.sh slug/           (checks all HTML in folder)

set -e

TARGET="${1:-.}"
PASS=true
ERRORS=()
WARNINGS=()

# ─── Color output ───────────────────────────────────────────────────
RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

log_pass()  { echo -e "  ${GREEN}✓${RESET} $1"; }
log_warn()  { echo -e "  ${YELLOW}⚠${RESET} $1"; WARNINGS+=("$1"); }
log_fail()  { echo -e "  ${RED}✗${RESET} $1"; ERRORS+=("$1"); PASS=false; }
log_head()  { echo -e "\n${BOLD}${CYAN}$1${RESET}"; }

echo ""
echo -e "${BOLD}Coleman Parks — Design Quality Check${RESET}"
echo -e "Target: ${CYAN}$TARGET${RESET}"

# ─── Collect HTML files ──────────────────────────────────────────────
if [[ -f "$TARGET" ]]; then
  FILES=("$TARGET")
elif [[ -d "$TARGET" ]]; then
  mapfile -t FILES < <(find "$TARGET" -name "*.html" ! -path "*/_template/*" ! -path "*/node_modules/*")
else
  echo -e "${RED}Error: '$TARGET' not found.${RESET}"; exit 1
fi

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo -e "${YELLOW}No HTML files found in '$TARGET'.${RESET}"; exit 0
fi

echo -e "Checking ${#FILES[@]} file(s)...\n"

# ─── Run impeccable if available ─────────────────────────────────────
if command -v npx &>/dev/null; then
  log_head "Impeccable AI-Slop Detection"
  if npx impeccable detect --help &>/dev/null 2>&1; then
    for f in "${FILES[@]}"; do
      echo -e "  ${CYAN}→${RESET} $f"
      npx impeccable detect "$f" 2>&1 | sed 's/^/    /' || true
    done
  else
    log_warn "impeccable not installed — run: npm install -g impeccable"
    log_warn "Skipping automated slop detection, running manual checks only"
  fi
else
  log_warn "npx not found — install Node.js to enable impeccable detection"
fi

# ─── Manual checks on each file ──────────────────────────────────────
for FILE in "${FILES[@]}"; do
  echo ""
  echo -e "${BOLD}── $FILE ──${RESET}"
  CONTENT=$(cat "$FILE")

  log_head "Head / SEO"
  grep -q '<title>' <<< "$CONTENT"                          && log_pass "title tag present"      || log_fail "missing <title>"
  grep -q 'name="description"' <<< "$CONTENT"              && log_pass "meta description present" || log_fail "missing meta description"
  grep -q 'name="viewport"' <<< "$CONTENT"                 && log_pass "viewport meta present"  || log_fail "missing viewport meta"
  grep -q 'lang=' <<< "$CONTENT"                           && log_pass "lang attribute present"  || log_warn "missing lang= on <html>"
  grep -q 'rel="icon"' <<< "$CONTENT"                      && log_pass "favicon linked"          || log_warn "no favicon linked"
  grep -q 'og:title' <<< "$CONTENT"                        && log_pass "og:title present"        || log_warn "missing og:title"
  grep -q 'og:description' <<< "$CONTENT"                  && log_pass "og:description present"  || log_warn "missing og:description"

  log_head "Accessibility"
  grep -q 'skip-link\|Skip to main\|skip to content' <<< "$CONTENT" && log_pass "skip link present"      || log_fail "missing skip link (add as first <body> element)"
  grep -q 'id="main"\|role="main"' <<< "$CONTENT"          && log_pass "main landmark present"   || log_fail "missing <main id=\"main\">"
  grep -q '<h1' <<< "$CONTENT"                             && log_pass "H1 present"               || log_fail "missing H1"
  # Check imgs — warn if any img lacks alt
  IMG_COUNT=$(grep -c '<img' <<< "$CONTENT" || true)
  ALT_COUNT=$(grep -c 'alt=' <<< "$CONTENT" || true)
  if [[ $IMG_COUNT -gt 0 ]]; then
    [[ $ALT_COUNT -ge $IMG_COUNT ]] && log_pass "all images have alt ($IMG_COUNT)" || log_fail "some images missing alt ($ALT_COUNT/$IMG_COUNT have it)"
  else
    log_pass "no images (alt not required)"
  fi
  grep -q 'aria-label\|aria-labelledby' <<< "$CONTENT"     && log_pass "aria labels present"     || log_warn "no aria labels found — check interactive elements"
  grep -q 'for="\|htmlFor=' <<< "$CONTENT"                 && log_pass "form labels linked"      || { grep -q '<input\|<textarea\|<select' <<< "$CONTENT" && log_warn "form inputs found but no for= labels"; }

  log_head "Design Quality"
  # Ban: side-stripe borders
  grep -q 'border-left:\|border-right:' <<< "$CONTENT"     && log_warn "side-stripe border detected — check if it's a card/callout accent (banned pattern)" || log_pass "no side-stripe borders"
  # Ban: bounce/elastic easing — look only inside <style> blocks, not text content
  STYLE_BLOCKS=$(grep -oP '(?s)(?<=<style[^>]*>).*?(?=</style>)' <<< "$CONTENT" 2>/dev/null || true)
  if [[ -n "$STYLE_BLOCKS" ]]; then
    echo "$STYLE_BLOCKS" | grep -q 'bounce\|elastic\|spring(' && log_fail "bounce/elastic easing in CSS — use ease-out-quart instead" || log_pass "no bounce easing in CSS"
  else
    log_pass "no bounce easing detected"
  fi
  # Ban: background-clip gradient text
  grep -q 'background-clip.*text\|webkit-background-clip.*text' <<< "$CONTENT" && log_fail "gradient text (background-clip:text) detected — banned pattern" || log_pass "no gradient text"
  # Ban: pure black/white
  grep -q '#000000\|#000;\|#fff;\|#ffffff\|color: black;\|background: white;' <<< "$CONTENT" && log_warn "pure black or white found — tint toward brand hue" || log_pass "no pure black/white"
  # Motion: check for layout property animation
  grep -q 'transition.*width\|transition.*height\|transition.*margin\|transition.*padding' <<< "$CONTENT" && log_warn "CSS layout property animated — use transform instead" || log_pass "no layout property animations"
  # Check for prefers-reduced-motion
  grep -q 'prefers-reduced-motion' <<< "$CONTENT"          && log_pass "prefers-reduced-motion handled" || log_warn "no prefers-reduced-motion — add for accessibility"

  log_head "Performance"
  IMG_LAZY=$(grep -c 'loading="lazy"' <<< "$CONTENT" || true)
  IMG_TOTAL=$(grep -c '<img' <<< "$CONTENT" || true)
  if [[ $IMG_TOTAL -gt 0 ]]; then
    [[ $IMG_LAZY -ge $IMG_TOTAL ]] && log_pass "all images lazy loaded" || log_warn "some images missing loading=\"lazy\" ($IMG_LAZY/$IMG_TOTAL)"
  fi
  grep -q 'display=swap' <<< "$CONTENT"                    && log_pass "Google Fonts using display=swap" || { grep -q 'fonts.googleapis.com' <<< "$CONTENT" && log_warn "Google Fonts loaded without display=swap"; }

  log_head "HTML Structure"
  grep -q '<main' <<< "$CONTENT"                            && log_pass "<main> element present"  || log_warn "no <main> element"
  grep -q '<nav' <<< "$CONTENT"                             && log_pass "<nav> element present"   || log_warn "no <nav> element"
  grep -q '<footer' <<< "$CONTENT"                          && log_pass "<footer> present"        || log_warn "no <footer> element"
  # Check for inline styles (warn only)
  INLINE=$(grep -c 'style="' <<< "$CONTENT" || true)
  [[ $INLINE -gt 10 ]] && log_warn "$INLINE inline style attributes — move to CSS classes" || log_pass "inline styles minimal ($INLINE)"

done

# ─── Summary ─────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────"
echo -e "${BOLD}Summary${RESET}"
echo "  Files checked:  ${#FILES[@]}"
echo -e "  ${RED}Errors:   ${#ERRORS[@]}${RESET}"
echo -e "  ${YELLOW}Warnings: ${#WARNINGS[@]}${RESET}"

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo ""
  echo -e "${RED}${BOLD}Failed — fix errors before pushing:${RESET}"
  for e in "${ERRORS[@]}"; do echo -e "  ${RED}✗${RESET} $e"; done
  echo ""
  exit 1
else
  echo ""
  echo -e "${GREEN}${BOLD}Passed — safe to push.${RESET}"
  if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    echo -e "${YELLOW}Review warnings when you have time.${RESET}"
  fi
  echo ""
  exit 0
fi
