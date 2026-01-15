#!/usr/bin/env bash

set -euo pipefail

echo "🔨 Rebuilding Docker image (no cache)..."
echo "Skip this step because network issues can cause long delays."
docker build --no-cache -t rule-synchronizer:local .

echo "🚀 Starting container with live code mount..."
docker run --rm -it \
  -e WWW_DIR="/app/www" \
  -v "$(pwd)/../www:/app/www" \
  rule-synchronizer:local
#!/usr/bin/env bash

set -euo pipefail

# Run from anywhere
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"

IMAGE_NAME="rule-synchronizer:local"
CONTAINER_NAME="rule-synchronizer-local"

WWW_HOST_DIR="$PROJECT_DIR/../www"
WWW_CONTAINER_DIR="/app/www"

# Optional flags
BUILD=0
NO_CACHE=0

for arg in "$@"; do
  case "$arg" in
    --build) BUILD=1 ;;
    --no-cache) NO_CACHE=1 ;;
    -h|--help)
      cat <<EOF
Usage: ./startDocker.sh [--build] [--no-cache]

  --build     Build the Docker image before running
  --no-cache  Build without cache (implies --build)

This starts the container for local development and mounts ../www into /app/www.
EOF
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

if [[ "$NO_CACHE" -eq 1 ]]; then
  BUILD=1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed or not on PATH." >&2
  exit 1
fi

if [[ ! -d "$WWW_HOST_DIR" ]]; then
  echo "Expected www directory not found: $WWW_HOST_DIR" >&2
  echo "Tip: run this script from the rule-synchronizer repo; it mounts ../www." >&2
  exit 1
fi

if [[ "$BUILD" -eq 1 ]]; then
  echo "🔨 Building Docker image: $IMAGE_NAME"
  if [[ "$NO_CACHE" -eq 1 ]]; then
    docker build --no-cache -t "$IMAGE_NAME" "$PROJECT_DIR"
  else
    docker build -t "$IMAGE_NAME" "$PROJECT_DIR"
  fi
else
  echo "ℹ️  Skipping build step (use --build to build the image)."
fi

# Load environment variables safely (do not bake secrets into the image)
ENV_ARGS=()
if [[ -f "$PROJECT_DIR/.env" ]]; then
  ENV_ARGS+=(--env-file "$PROJECT_DIR/.env")
fi

echo "🚀 Starting container: $CONTAINER_NAME"

# Stop any existing container with the same name (in case a previous run didn't clean up)
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

# Mount only the www directory. If you want live source-code mounting too, consider docker compose
# or mount ./src into /app/src and run a dev command inside the container.
docker run --rm -it \
  --name "$CONTAINER_NAME" \
  --init \
  "${ENV_ARGS[@]}" \
  -e WWW_DIR="$WWW_CONTAINER_DIR" \
  -v "$WWW_HOST_DIR:$WWW_CONTAINER_DIR" \
  "$IMAGE_NAME"