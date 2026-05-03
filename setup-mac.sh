#!/usr/bin/env bash
# Coleman Parks — One-time Mac setup for Claude Code skills and tools.
# Run this once on your Mac: ./setup-mac.sh

set -e

BOLD='\033[1m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
YELLOW='\033[1;33m'; RED='\033[0;31m'; RESET='\033[0m'

echo ""
echo -e "${BOLD}Coleman Parks — Mac Setup${RESET}"
echo "Installing Claude Code skills and design tools."
echo ""

# ─── Check for Node / npx ────────────────────────────────────────────
if ! command -v npx &>/dev/null; then
  echo -e "${RED}Node.js is not installed.${RESET}"
  echo "Install it first: https://nodejs.org (choose LTS version)"
  echo "Then re-run this script."
  exit 1
fi

NODE_VER=$(node --version)
echo -e "${GREEN}✓${RESET} Node.js found: $NODE_VER"
echo ""

# ─── Claude Code skills ──────────────────────────────────────────────
echo -e "${BOLD}${CYAN}Installing Claude Code Skills${RESET}"
echo "These give Claude design intelligence, accessibility rules, and UI patterns."
echo ""

install_skill() {
  local name="$1"
  local pkg="$2"
  echo -e "  Installing ${BOLD}$name${RESET}..."
  if npx skills add "$pkg" 2>&1; then
    echo -e "  ${GREEN}✓${RESET} $name installed"
  else
    echo -e "  ${YELLOW}⚠${RESET} $name — install manually: npx skills add $pkg"
  fi
  echo ""
}

# Anthropic's official frontend design skill
install_skill "frontend-design" "anthropics/skills@frontend-design"

# UI/UX Pro Max — visual hierarchy, colour psychology, 50+ styles
install_skill "UI-UX-Pro-Max" "nextlevelbuilder/ui-ux-pro-max-skill@ui-ux-pro-max"

# Vercel web design guidelines — 100+ rules: spacing, typography, hierarchy, a11y
install_skill "web-design-guidelines" "vercel-labs/agent-skills@web-design-guidelines"

# Web accessibility — WCAG from day one
install_skill "web-accessibility" "supercent-io/skills-template@web-accessibility"

# shadcn-ui — accessible component patterns
install_skill "shadcn-ui" "giuseppe-trisciuoglio/developer-kit@shadcn-ui"

# ─── Impeccable CLI ──────────────────────────────────────────────────
echo -e "${BOLD}${CYAN}Installing Impeccable CLI${RESET}"
echo "Anti-AI-slop design detector. Catches 27 bad patterns before you ship."
echo ""
echo "  Installing impeccable globally..."
if npm install -g impeccable 2>&1; then
  echo -e "  ${GREEN}✓${RESET} impeccable installed"
  echo -e "  Run: ${CYAN}npx impeccable detect path/to/index.html${RESET}"
else
  echo -e "  ${YELLOW}⚠${RESET} Could not install impeccable. Try manually: npm install -g impeccable"
fi
echo ""

# ─── Impeccable Claude Code skill ────────────────────────────────────
echo -e "${BOLD}${CYAN}Installing Impeccable Claude Code Skill${RESET}"
echo "Adds /impeccable commands: audit, polish, critique, animate, colorize, typeset..."
echo ""
install_skill "impeccable" "pbakaus/impeccable"

# ─── Summary ─────────────────────────────────────────────────────────
echo "────────────────────────────────────────"
echo -e "${BOLD}Setup Complete${RESET}"
echo ""
echo "Skills installed in Claude Code. Restart Claude Code if it's open."
echo ""
echo -e "${BOLD}What you now have:${RESET}"
echo "  /impeccable audit    — full technical QA pass (a11y, perf, responsive)"
echo "  /impeccable polish   — final quality pass before ship"
echo "  /impeccable critique — UX design review with heuristic scoring"
echo "  /impeccable typeset  — fix typography hierarchy"
echo "  /impeccable colorize — add strategic color to flat designs"
echo "  /impeccable animate  — add purposeful animations"
echo "  /impeccable layout   — fix spacing and rhythm"
echo ""
echo -e "${BOLD}Design check before every push:${RESET}"
echo -e "  ${CYAN}./check.sh slug/index.html${RESET}"
echo ""
echo -e "${BOLD}New client build:${RESET}"
echo -e "  ${CYAN}./new-client.sh \"Client Name\" \"slug\"${RESET}"
echo ""
