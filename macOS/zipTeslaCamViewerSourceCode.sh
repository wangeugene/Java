#!/usr/bin/env zsh
set -euo pipefail

PROJECT_DIR="TeslaCamViewer"
ZIP_NAME="TeslaCamViewer.zip"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "Error: Project folder '$PROJECT_DIR' does not exist."
  exit 1
fi

echo "Step 1: Removing the old zip file if it exists..."
rm -f "$ZIP_NAME"

echo "Step 2: Compressing the project into a new zip file..."
zip -rq "$ZIP_NAME" "$PROJECT_DIR" \
  -x "*/build/*" \
  -x "*/DerivedData/*" \
  -x "*/.git/*" \
  -x "*/.DS_Store" \
  -x "*/xcuserdata/*" \
  -x "*.xcuserstate"

echo "Step 3: Verifying the zip contents..."
unzip -l "$ZIP_NAME" | sed -n '3,5p'

echo "Done: $ZIP_NAME"

echo "Step 4: The final zip file size is: "
size_mb=$(du -m "$ZIP_NAME" | awk '{print $1}')
echo "Final zip file size: ${size_mb} MB"
