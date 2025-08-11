#!/usr/bin/env zsh

set -euo pipefail

# Config
FRONTEND_PORT=${FRONTEND_PORT:-5050}
BACKEND_PORT=${BACKEND_PORT:-3000}
STATIC_DIR=static
OPEN_BROWSER=${OPEN_BROWSER:-1} # set to 0 to skip opening the browser


# Kill any process already listening on PORTs (macOS)
echo "Freeing ports $FRONTEND_PORT $BACKEND_PORT if occupied"
ports=($FRONTEND_PORT $BACKEND_PORT)
for p in "${ports[@]}"; do
    echo "Checking port $p"
    port_pids=$(lsof -ti tcp:$p || true)
    if [[ -n "$port_pids" ]]; then
        echo "Killing processes on port $p: of PID: $port_pids"
        echo "$port_pids" | xargs kill -9 || true
    fi
done

echo 'using serve command to start frontend service at port $FRONTEND_PORT'
if command -v serve >/dev/null 2>&1; then
	SERVE_CMD=(serve -p $FRONTEND_PORT "$STATIC_DIR")
else
	echo "\`serve\` not found, using npx to run it without installing globally"
	SERVE_CMD=(npx --yes serve -p $FRONTEND_PORT "$STATIC_DIR")
fi

echo "Starting BACKEND_SERVICE server on http://localhost:$BACKEND_PORT serving itself"
node server.js &
echo "Starting FRONTEND_SERVICE server on http://localhost:$FRONTEND_PORT serving '$STATIC_DIR'"
"${SERVE_CMD[@]}" > ".serve-$FRONTEND_PORT.log" 2>&1 &
SERVER_PID=$!
echo "FRONTEND Server PID: $SERVER_PID (logs: .serve-$FRONTEND_PORT.log)"

if [[ "$OPEN_BROWSER" == "1" ]]; then
	echo "Opening FRONTEND-service at port $FRONTEND_PORT"
	if command -v open >/dev/null 2>&1; then
		open "http://localhost:$FRONTEND_PORT" || true
	fi
fi

echo "FRONTEND Server started. To stop: kill $SERVER_PID  # or: lsof -ti tcp:$FRONTEND_PORT | xargs kill -9"
echo "This demonstrates frontend and backend separation, the backend serves at port 3000, and the frontend serves at port 5050"
echo "Script finished and returning to shell."