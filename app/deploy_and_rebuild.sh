#!/usr/bin/env zsh
set -euo pipefail

# Local and remote settings
LOCAL_DIR="$HOME/Projects/Java/app"
REMOTE_HOST="ali"     # defined in your ~/.ssh/config
REMOTE_DIR="/app"

REMOTE_CMD="cd ${REMOTE_DIR} && ./rebuild_docker_compose.sh"

echo "📁 Local dir:  ${LOCAL_DIR}"
echo "🖥  Remote:     ${REMOTE_HOST}:${REMOTE_DIR}"
echo "🔄 Step 1/2: Syncing local → remote with rsync..."

echo "Rsync -a option will preserve file permissions and timestamps."
rsync -avz \
  --delete \
  --exclude '.git' \
  --exclude 'node_modules' \
  --exclude 'certbot' \
  "${LOCAL_DIR}/" \
  "${REMOTE_HOST}:${REMOTE_DIR}"

echo "🐳 Step 2/2: Running remote Docker rebuild script..."
ssh "${REMOTE_HOST}" "${REMOTE_CMD}"

echo "✅ All done. Remote docker stack rebuilt."