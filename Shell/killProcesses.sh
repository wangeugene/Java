# Usage: sh killProcessesByPorts.sh
# alias kp='sh ~/Projects/Java/Shell/killProcessesByPorts.sh'

# take an array of ports to kill processes by arguments from command line
# example: kp 8080 cypress 9229 3000 node 
ARG_ARRAY=("$@")

ARG_PORTS=($(printf "%s\n" "${ARG_ARRAY[@]}" | grep -E '^[0-9]+$'))

# to filter out the processes by names: support letters and hyphens
ARG_PROCESSES=($(printf "%s\n" "${ARG_ARRAY[@]}" | grep -E '^[a-zA-Z-]+$'))

if [ ${#ARG_PORTS[@]} -eq 0 ] && [ ${#ARG_PROCESSES[@]} -eq 0 ]; then
    echo "No ports or processes provided. Exiting."
    exit 1
fi

if [ ${#ARG_PORTS[@]} -gt 0 ]; then
    echo PROCESSES TO BY KILLED BY PORTS: ${ARG_PORTS[@]}
    for PORT in "${ARG_PORTS[@]}"; do
        PID=$(lsof -t -i:$PORT)
        if [ -n "$PID" ]; then
            kill -9 $PID
            echo "Killed process of by ports of PID: $PID"
        else
            echo "No process found by port $PORT"
        fi
    done
fi


if [ ${#ARG_PROCESSES[@]} -gt 0 ]; then
    echo PROCESSES TO BE KILLED BY NAMES: ${ARG_PROCESSES[@]}
    for PROCESS in "${ARG_PROCESSES[@]}"; do
        echo "Trying to kill the process by names: $PROCESS"
        PIDs=$(pgrep $PROCESS)
        if [ -z "$PIDs" ]; then
            echo "No process found by name: $PROCESS"
        else
            echo "PIDs found by names: $PIDs"
            for PID in $PIDs; do
                if [ -n "$PID" ]; then 
                    kill -9 $PID
                    echo "Killed processes by names of PID: $PID"
                fi
            done
        fi
    done
fi

