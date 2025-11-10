#!/usr/bin/env bash
set -e

echo "📦 Rebuilding rule-updater..."
docker compose up -d --build rule-updater

echo "✅ Restarted rule-updater"
docker compose logs -f rule-updater
