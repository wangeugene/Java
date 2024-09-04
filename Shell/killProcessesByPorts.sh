# Usage: sh killProcessesByPorts.sh

PORTS=(8080 9229)

for PORT in "${PORTS[@]}"; do
    PID=$(lsof -t -i:$PORT)
    if [ -n "$PID" ]; then
        kill -9 $PID
        echo "Killed process $PID on port $PORT"
    else
        echo "No process found on port $PORT"
    fi
done
