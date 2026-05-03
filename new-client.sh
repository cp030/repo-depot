#!/usr/bin/env bash
# Usage: ./new-client.sh "Client Name" "client-slug"
# Creates a new build subfolder from the template and opens it.

set -e

NAME="${1}"
SLUG="${2}"

if [[ -z "$NAME" || -z "$SLUG" ]]; then
  echo "Usage: ./new-client.sh \"Client Name\" \"client-slug\""
  echo "Example: ./new-client.sh \"SPN Dallas\" \"spndt\""
  exit 1
fi

SLUG="${SLUG,,}"   # lowercase
SLUG="${SLUG// /-}" # spaces to hyphens

if [[ -d "$SLUG" ]]; then
  echo "Error: folder '$SLUG' already exists."
  exit 1
fi

mkdir -p "$SLUG"
cp _template/index.html "$SLUG/index.html"

# Swap in the client name
sed -i "s/CLIENT NAME/$NAME/g" "$SLUG/index.html"

git add "$SLUG/index.html"
git commit -m "scaffold: new build for $NAME ($SLUG)"

echo ""
echo "Done. New build ready at: $SLUG/index.html"
echo "Live URL (after push): https://cp030.github.io/repo-depot/$SLUG"
echo ""
echo "Next:"
echo "  1. Open $SLUG/index.html and paste your generated HTML"
echo "  2. git add $SLUG/index.html && git commit -m 'build: $SLUG' && git push"
