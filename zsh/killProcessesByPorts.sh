# kill the process using the localhost port 8080
# Usage: sh killProcessesByPorts.sh
kill -9 $(lsof -t -i:8080) 2> /dev/null
