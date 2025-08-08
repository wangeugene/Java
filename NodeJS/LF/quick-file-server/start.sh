#!/usr/bin/env zsh

set -euo pipefail

# Config
PORT=${PORT:-5050}
ROOT_DIR=${ROOT_DIR:-static}
OPEN_BROWSER=${OPEN_BROWSER:-1} # set to 0 to skip opening the browser

echo "Ensuring \`$ROOT_DIR\` directory exists"
mkdir -p "$ROOT_DIR"

# Kill any process already listening on PORT (macOS)
echo "Freeing port $PORT if occupied"
PIDS=$(lsof -ti tcp:$PORT || true)
if [[ -n "$PIDS" ]]; then
	echo "Killing processes on port $PORT: $PIDS"
	echo "$PIDS" | xargs kill -9 || true
fi

# Choose serve command
if command -v serve >/dev/null 2>&1; then
	SERVE_CMD=(serve -p $PORT "$ROOT_DIR")
else
	echo "\`serve\` not found, using npx to run it without installing globally"
	SERVE_CMD=(npx --yes serve -p $PORT "$ROOT_DIR")
fi

echo "Starting file server on http://localhost:$PORT serving '$ROOT_DIR'"
# Start in background so the script can return
"${SERVE_CMD[@]}" > ".serve-$PORT.log" 2>&1 &
SERVER_PID=$!
echo "Server PID: $SERVER_PID (logs: .serve-$PORT.log)"

if [[ "$OPEN_BROWSER" == "1" ]]; then
	# Best-effort to open the default browser
	if command -v open >/dev/null 2>&1; then
		open "http://localhost:$PORT" || true
	fi
fi

echo "Server started. To stop: kill $SERVER_PID  # or: lsof -ti tcp:$PORT | xargs kill -9"
echo "Script finished and returning to shell."