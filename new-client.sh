#!/usr/bin/env bash
# Usage: ./new-client.sh "Client Name" "client-slug"
# Creates a new build subfolder from the template.

set -e

BOLD='\033[1m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; RESET='\033[0m'

NAME="${1}"
SLUG="${2}"

if [[ -z "$NAME" || -z "$SLUG" ]]; then
  echo "Usage: ./new-client.sh \"Client Name\" \"client-slug\""
  echo "Example: ./new-client.sh \"SPN Dallas\" \"spndt\""
  exit 1
fi

SLUG="${SLUG,,}"     # lowercase
SLUG="${SLUG// /-}"  # spaces to hyphens

if [[ -d "$SLUG" ]]; then
  echo "Error: folder '$SLUG' already exists."
  exit 1
fi

mkdir -p "$SLUG"
cp _template/index.html "$SLUG/index.html"
sed -i "s/CLIENT NAME/$NAME/g" "$SLUG/index.html"

git add "$SLUG/index.html"
git commit -m "scaffold: new build for $NAME ($SLUG)"

echo ""
echo -e "${BOLD}Scaffold created: $SLUG/index.html${RESET}"
echo -e "Live URL (after push): ${CYAN}https://cp030.github.io/repo-depot/$SLUG${RESET}"
echo ""
echo -e "${BOLD}Next steps:${RESET}"
echo "  1. Open $SLUG/index.html and paste your generated HTML"
echo "  2. Run the design check:"
echo -e "     ${CYAN}./check.sh $SLUG/index.html${RESET}"
echo "  3. Fix any errors the check flags"
echo "  4. Commit and push:"
echo -e "     ${CYAN}git add $SLUG/index.html && git commit -m \"build: $SLUG\" && git push${RESET}"
echo ""
echo -e "  Live at: ${CYAN}https://cp030.github.io/repo-depot/$SLUG${RESET}"
echo ""
