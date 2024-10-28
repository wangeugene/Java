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

NPID=$(lsof -i:443 | grep node | awk '{print $2}')
if [ -n "$NPID" ]; then
    kill -9 $NPID
    echo "Killed nodejs process $NPID on port 443"
else
    echo "No nodejs process found on port 443"
fi