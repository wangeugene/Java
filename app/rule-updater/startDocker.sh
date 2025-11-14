#!/usr/bin/env zsh

set -euo pipefail

echo "🔨 Rebuilding Docker image (no cache)..."
echo "Skip this step because network issues can cause long delays."
# docker build --no-cache -t rule-updater:local .

echo "🚀 Starting container with live code mount..."
docker run --rm -it \
  -p 3000:3000 \
  -e WWW_DIR="/app/www" \
  -v "$(pwd)/../www:/app/www" \
  rule-updater:local