#!/usr/bin/env bash
set -e

echo "📦 Rebuilding Docker images..."
docker compose build --no-cache

echo "🚀 Restarting services..."
docker compose up -d

echo "🧹 Removing unused images..."
docker image prune -f

echo "✅ Done!"
docker compose ps