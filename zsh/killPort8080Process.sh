# kill the process using the localhost port 8080
# Usage: sh killPort8080Process.sh
kill -9 $(lsof -t -i:8080) 2> /dev/null
