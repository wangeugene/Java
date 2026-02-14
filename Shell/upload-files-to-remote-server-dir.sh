#!/usr/bin/env bash
set -euo pipefail
# Using bash to make it compatible with macOS / Linux / remote AWS EC2 instance / alibaba cloud server

# Local and remote settings
SCRIPT_DIR="$(pwd)"
LOCAL_DIR="$SCRIPT_DIR"
REMOTE_DIR="/app"

# Remote host: prefer .env REMOTE_HOST, otherwise default to ssh alias "aws"
DEFAULT_REMOTE_HOST="aws"

# Load env vars from the project .env (portable even if script is invoked from another directory)
ENV_FILE="$SCRIPT_DIR/.env"

# Optional: upload only specific paths passed as args; otherwise upload whole LOCAL_DIR
SCRIPT_ARGUMENTS=("$@")

if [[ ! -f "${ENV_FILE}" ]]; then
  echo "❌ .env not found at: ${ENV_FILE}" >&2
  exit 1
fi

set -a
source "${ENV_FILE}"
set +a

# Default REMOTE_HOST to the ssh alias "aws" if not provided in .env
REMOTE_HOST="${REMOTE_HOST:-$DEFAULT_REMOTE_HOST}"

# Validate required environment variables
: "${REMOTE_HOST:?REMOTE_HOST is not set (check .env or use ssh alias aws)}"
: "${DOMAIN:?DOMAIN is not set (check .env)}"
: "${EMAIL:?EMAIL is not set (check .env)}"

echo "📁 Local dir:   ${LOCAL_DIR}"
echo "🖥  Remote:      ${REMOTE_HOST}:${REMOTE_DIR}"
echo "🔄 Step 1/2: Syncing local → remote with rsync..."

echo "Rsync -a option will preserve file permissions and timestamps."

RSYNC_EXCLUDES=(
  --exclude '.git'
  --exclude 'node_modules'
  --exclude 'certbot'
  --exclude '*.list'
)

if (( ${#SCRIPT_ARGUMENTS[@]} > 0 )); then
  echo "Uploading only specified paths: ${SCRIPT_ARGUMENTS[*]}"
  # Use --relative to preserve paths when uploading multiple files/dirs
  # Use --delete to remove files on remote that are deleted locally (be careful!)
  rsync -avz --relative "${RSYNC_EXCLUDES[@]}" \
    --delete \
    "${SCRIPT_ARGUMENTS[@]}" \
    "${REMOTE_HOST}:${REMOTE_DIR}/"
else
  echo "⚠️  No file arguments provided. Nothing will be uploaded."
  echo "Usage: $0 <file-or-directory> [more files...]"
  exit 0
fi

echo "✅ Upload complete. Verify files on remote: ${REMOTE_HOST}:${REMOTE_DIR}"
