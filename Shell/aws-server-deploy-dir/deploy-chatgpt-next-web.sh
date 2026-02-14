
#!/usr/bin/env bash
set -euo pipefail

# Load .env (export variables so curl can see them)
set -a
source .env
set +a

: "${OPENAI_API_KEY:?OPENAI_API_KEY is missing. Put it in .env}"
: "${CHATGPT_WEB_PASS:?CHATGPT_WEB_PASS is missing. Put it in .env}"

IMAGE="yidadaa/chatgpt-next-web"
CONTAINER_NAME="chatgpt-next-web"

# Stop & remove any existing container with the same name (fresh start)
if docker ps -a --format '{{.Names}}' | grep -qx "$CONTAINER_NAME"; then
	echo "Stopping old container: $CONTAINER_NAME"
	docker stop "$CONTAINER_NAME" >/dev/null
	echo "Removing old container: $CONTAINER_NAME"
	docker rm "$CONTAINER_NAME" >/dev/null
fi

# Optional: delete old image to force a full re-pull
if [[ "${1:-}" == "--clean-image" ]]; then
	echo "Removing old image: $IMAGE"
	docker rmi -f "$IMAGE" >/dev/null 2>&1 || true
fi

echo "Pulling image: $IMAGE"
docker pull "$IMAGE" >/dev/null


# If port 3000 is already bound, stop/remove any RUNNING container publishing it.
# docker "publish" filter is unreliable for stopped containers, so we check running ones explicitly.
PORT_CONTAINERS=$(docker ps --format '{{.ID}} {{.Ports}}' | grep ':3000->' | awk '{print $1}' || true)

if [[ -n "${PORT_CONTAINERS}" ]]; then
	echo "Found running container(s) using port 3000. Stopping & removing them:"
	docker ps --format '  - {{.ID}}  {{.Names}}  {{.Ports}}' | grep ':3000->' || true
	
	# Stop containers
	docker stop ${PORT_CONTAINERS} >/dev/null 2>&1 || true
	
	# Remove containers
	docker rm ${PORT_CONTAINERS} >/dev/null 2>&1 || true
fi

echo "Starting new container: $CONTAINER_NAME"
docker run -d --name "$CONTAINER_NAME" --restart unless-stopped -p 3000:3000 \
	-e "OPENAI_API_KEY=$OPENAI_API_KEY" \
	-e "CODE=$CHATGPT_WEB_PASS" \
	"$IMAGE"

echo "To verify environment variables, run: docker exec $CONTAINER_NAME printenv CODE"