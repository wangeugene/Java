#!/usr/bin/env bash
set -e

echo "This script is running on the remote server."
echo "📦 Rebuilding Docker images... avoid changes not synced into the docker image (Node.js Docker image)"
# --no-cache is not needed, it breaks the previous anonymous docker volume, and it is not needed because we are using a bind mount for the source code
docker compose build 

echo "🚀 Restarting services..., docker compose up is not needed, it breaks the previous anonymous docker volume"
docker compose up -d

echo "🧹 Removing unused images..."
docker image prune -f

echo "✅ Done!"
docker compose ps