#!/usr/bin/env bash
echo "🛳️ Starting a Docker container for Rule Synchronizer Node.js app on your dev machine (e.g. your macOS)..."
set -euo pipefail

docker build -t rule-synchronizer:local .

LOCAL_DEV_WWW_DIR="$(cd "$(pwd)/../www" && pwd -P)"
CONTAINER_WWW_DIR="/app/www"

echo "LOCAL_WWW_DIR=${LOCAL_DEV_WWW_DIR}"
echo "🚀 Starting container with live code mount..."
docker run \
  -e WWW_DIR="${CONTAINER_WWW_DIR}" \
  -v "${LOCAL_DEV_WWW_DIR}:/app/www" \
  rule-synchronizer:local 
