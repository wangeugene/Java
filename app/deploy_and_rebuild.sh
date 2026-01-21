#!/usr/bin/env zsh
set -euo pipefail

# Local and remote settings
LOCAL_DIR="$HOME/Projects/Java/app"
REMOTE_DIR="/app"
REMOTE_CMD="cd ${REMOTE_DIR} && ./rebuild_docker_compose.sh"
# Load env vars from the project .env (portable even if script is invoked from another directory)
ENV_FILE="${LOCAL_DIR}/.env"
if [[ ! -f "${ENV_FILE}" ]]; then
  echo "❌ .env not found at: ${ENV_FILE}" >&2
  exit 1
fi
set -a
source "${ENV_FILE}"
set +a
# Validate required environment variables
: "${REMOTE_HOST:?REMOTE_HOST is not set (check .env)}"
: "${DOMAIN:?DOMAIN is not set (check .env)}"
: "${EMAIL:?EMAIL is not set (check .env)}"
#REMOTE_HOST from .env file also is defined in your ~/.ssh/config

echo "📁 Local dir:  ${LOCAL_DIR}"
echo "🖥  Remote:     ${REMOTE_HOST}:${REMOTE_DIR}"
echo "🔄 Step 1/2: Syncing local → remote with rsync..."

echo "Rsync -a option will preserve file permissions and timestamps."
rsync -avz \
  --delete \
  --exclude '.git' \
  --exclude 'node_modules' \
  --exclude 'certbot' \
  --exclude '*.list' \
  "${LOCAL_DIR}/" \
  "${REMOTE_HOST}:${REMOTE_DIR}"

echo "🐳 Step 2/2: Running remote Docker rebuild script..."
ssh "${REMOTE_HOST}" "${REMOTE_CMD}"

echo "✅ All done. Remote docker stack rebuilt."