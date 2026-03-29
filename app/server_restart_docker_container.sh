#!/usr/bin/env bash
set -e

docker_service_name="$1"

if [ -z "$docker_service_name" ]; then
  echo "Usage: $0 <docker_service_name>"
  exit 1
fi

docker_containers=$(docker ps --format "{{.Names}}")
echo -e "🚀 Running containers:\n$docker_containers"


echo "📦 Rebuilding $docker_service_name ..."
docker compose up -d --build $docker_service_name