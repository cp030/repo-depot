#!/usr/bin/env bash
# Usage: ./new-client.sh "Client Name" "client-slug" ["Description"]
# Creates a new build subfolder and adds a card to the hub page.

set -e

BOLD='\033[1m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; RESET='\033[0m'

NAME="${1}"
SLUG="${2}"
DESC="${3:-Brand website}"

if [[ -z "$NAME" || -z "$SLUG" ]]; then
  echo "Usage: ./new-client.sh \"Client Name\" \"slug\" [\"Description\"]"
  echo "Example: ./new-client.sh \"SPN Dallas\" \"spndt\" \"Sports performance brand\""
  exit 1
fi

SLUG="${SLUG,,}"     # lowercase
SLUG="${SLUG// /-}"  # spaces to hyphens

if [[ -d "$SLUG" ]]; then
  echo "Error: folder '$SLUG' already exists."
  exit 1
fi

LIVE_URL="https://cp030.github.io/repo-depot/$SLUG"
TODAY=$(date +%Y-%m-%d)

# ─── Create the build folder ──────────────────────────────────────────
mkdir -p "$SLUG"
cp _template/index.html "$SLUG/index.html"
sed -i "s/CLIENT NAME/$NAME/g" "$SLUG/index.html"

# ─── Inject build card into hub index.html ───────────────────────────
python3 - <<PYEOF
import re

card = """
        <!-- BUILD: $SLUG — added $TODAY -->
        <a href="$LIVE_URL" target="_blank" rel="noopener" class="build-card" style="text-decoration:none">
          <div class="build-meta">
            <span class="build-slug">$SLUG</span>
            <span class="build-status status-draft">draft</span>
          </div>
          <div class="build-name">$NAME</div>
          <div class="build-desc">$DESC</div>
          <div class="build-footer">
            <span class="build-url">cp030.github.io/repo-depot/$SLUG</span>
            <span class="build-arrow">→</span>
          </div>
        </a>
"""

marker = "<!-- ═══ BUILDS GO HERE ═══"

with open("index.html", "r") as f:
    html = f.read()

html = html.replace(marker, card + "\n        " + marker)

with open("index.html", "w") as f:
    f.write(html)

print("  Hub index.html updated.")
PYEOF

# ─── Commit both files ───────────────────────────────────────────────
git add "$SLUG/index.html" index.html
git commit -m "scaffold: new build for $NAME ($SLUG)"

echo ""
echo -e "${BOLD}Done. Scaffold created.${RESET}"
echo ""
echo -e "  Build folder:  ${CYAN}$SLUG/index.html${RESET}"
echo -e "  Hub updated:   ${CYAN}index.html${RESET} — card added"
echo -e "  Live URL:      ${CYAN}$LIVE_URL${RESET}"
echo ""
echo -e "${BOLD}Next steps:${RESET}"
echo "  1. Paste your generated HTML into $SLUG/index.html"
echo -e "  2. Run the design check: ${CYAN}./check.sh $SLUG/index.html${RESET}"
echo "  3. Once the build is live, change status-draft → status-live in index.html"
echo -e "  4. Push: ${CYAN}git add . && git commit -m \"build: $SLUG\" && git push${RESET}"
echo ""
