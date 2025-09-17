#!/usr/bin/env zsh

# Safety settings
set -euo pipefail

# Config
PORTS=(5050 3000)
ROOT_DIR=${ROOT_DIR:-static}
OPEN_BROWSER=${OPEN_BROWSER:-1} 

(
	echo "Ensuring \`$ROOT_DIR\` directory exists"
	mkdir -p "$ROOT_DIR"
)

for PORT in "${PORTS[@]}"; do
	echo "Processing port: $PORT"
	PID=$(lsof -ti tcp:$PORT || true)
	if [[ -n "$PID" ]]; then
		echo "Killing processes on port $PORT: $PID"
		echo "$PID" | xargs kill -9 || true
	fi
done

(
	echo "Starting the frontend server on http://localhost:5050 serving '$ROOT_DIR'"
	if command -v serve >/dev/null 2>&1; then
		SERVE_CMD=(serve -p 5050 "$ROOT_DIR")
	else
		echo "\`serve\` not found, using npx to run it without installing globally"
		SERVE_CMD=(npx --yes serve -p 5050 "$ROOT_DIR")
	fi
	# Start in background so the script can return
	"${SERVE_CMD[@]}" > ".serve-$PORT.log" 2>&1 &
	SERVER_PID=$!
)

(
	echo "Starting the backend server on http://localhost:3000 serving APIs"
	# run the dev script in the mock-srv folder in the background, log output and save PID
	LOG_FILE=".mock-srv.log"
	if command -v npm >/dev/null 2>&1; then
		echo "Launching backend (npm --prefix mock-srv run dev) in background, logging to $LOG_FILE"
		# Use nohup so the process keeps running if the terminal/session closes.
		# If you prefer not to use nohup you can drop it and just append '&' to run in background.
		nohup npm --prefix mock-srv run dev >"$LOG_FILE" 2>&1 &
		BACKEND_PID=$!
		echo "The backend server is running with PID '$BACKEND_PID'"
		echo "You can check the log file '$LOG_FILE' for details."
	else
		echo "npm not found; cannot start backend"
	fi
)

(
	if [[ "$OPEN_BROWSER" == "1" ]]; then
		# Best-effort to open the default browser
		if command -v open >/dev/null 2>&1; then
			open "http://localhost:5050" || true
		fi
	fi
)
