# Usage: sh killProcessesByPorts.sh
# alias kp='sh ~/Projects/Java/Shell/killProcessesByPorts.sh'

# take an array of ports to kill processes by arguments from command line
# example: kp 8080 cypress 9229 3000 node 
ARG_ARRAY=("$@")
PORTS=()


ARG_PORTS=($(printf "%s\n" "${ARG_ARRAY[@]}" | grep -E '^[0-9]+$'))
ARG_PROCESSES=($(printf "%s\n" "${ARG_ARRAY[@]}" | grep -E '^[a-zA-Z]+$'))

if [ ${#ARG_PORTS[@]} -eq 0 ] && [ ${#ARG_PROCESSES[@]} -eq 0 ]; then
    echo "No ports or processes provided. Exiting."
    exit 1
fi

if [ ${#ARG_PORTS[@]} -gt 0 ]; then
    for PORT in "${ARG_PORTS[@]}"; do
        PORTS+=($PORT)
    done
    echo PORTS TO BE KILLED: ${PORTS[@]}
fi

if [ ${#ARG_PROCESSES[@]} -gt 0 ]; then
    echo PROCESSES TO BE KILLED: ${ARG_PROCESSES[@]}
fi


for PORT in "${PORTS[@]}"; do
    PID=$(lsof -t -i:$PORT)
    if [ -n "$PID" ]; then
        kill -9 $PID
        echo "Killed process $PID on port $PORT"
    else
        echo "No process found on port $PORT"
    fi
done

if [[ " ${ARG_PROCESSES[@]} " =~ " cypress " ]]; then
    CY_PIDs=$(ps aux | grep cypress | awk '{print $2}')
    for CY_PID in $CY_PIDs; do
        kill -9 $CY_PID
        echo "Killed cypress processes of PIDs: $CY_PID"
    done
fi

if [[ " ${ARG_PROCESSES[@]} " =~ " gradle " ]]; then
    GRADLE_PIDs=$(ps aux | grep gradle | awk '{print $2}')
    for GRADLE_PID in $GRADLE_PIDs; do
        kill -9 $GRADLE_PID
        echo "Killed Gradle process of pid: $GRADLE_PID"
    done
fi

if [[ " ${ARG_PROCESSES[@]} " =~ " node " ]]; then
    NODE_PIDs=$(ps aux | grep node | awk '{print $2}')
    for NODE_PID in $NODE_PIDs; do
        kill -9 $NODE_PID
        echo "Killed node process of pid: $NODE_PID"
    done
fi

if [[ " ${ARG_PROCESSES[@]} " =~ " sshagent " ]]; then
    SSHAGENTs=$(ps aux | grep ssh-agent | awk '{print $2}')
    for SSHAGENT in $SSHAGENTs; do
        kill -9 $SSHAGENT
        echo "Killed ssh-agent process of pid: $SSHAGENT"
    done
fi