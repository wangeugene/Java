# Usage: sh killProcessesByPorts.sh
# alias kp='sh ~/Projects/Java/Shell/killProcessesByPorts.sh'

# take an array of ports to kill processes by arguments from command line
ARG_PORTS=("$@")
PORTS=(8080 9229)

# append ARG_PORTS to the PORTS array
for PORT in "${ARG_PORTS[@]}"; do
    PORTS+=($PORT)
done
echo PORTS: ${PORTS[@]}

for PORT in "${PORTS[@]}"; do
    PID=$(lsof -t -i:$PORT)
    if [ -n "$PID" ]; then
        kill -9 $PID
        echo "Killed process $PID on port $PORT"
    else
        echo "No process found on port $PORT"
    fi
done

# Killing all the cypress process
CY_PIDs=$(ps aux | grep cypress | awk '{print $2}')
for CY_PID in $CY_PIDs; do
    kill -9 $CY_PID
    echo "Killed cypress process of pid: $CY_PID"
done

GRADLE_PIDs=$(ps aux | grep gradle | awk '{print $2}')
for GRADLE_PID in $GRADLE_PIDs; do
    kill -9 $GRADLE_PID
    echo "Killed Gradle process of pid: $GRADLE_PID"
done

# Killing the node process on port 443
# NPID=$(lsof -i:443 | grep node | awk '{print $2}')
# if [ -n "$NPID" ]; then
#     kill -9 $NPID
#     echo "Killed nodejs process $NPID on port 443"
# else
#     echo "No nodejs process found on port 443"
# fi