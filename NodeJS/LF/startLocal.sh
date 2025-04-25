#!/bin/zsh

# Kill any existing processes on port 5050 (macOS friendly version)
echo "Checking for existing processes on port 5050..."
PORT_PID=$(lsof -ti :5050)
if [ -n "$PORT_PID" ]; then
  echo "Found process $PORT_PID using port 5050. Killing it..."
  kill -9 $PORT_PID 2>/dev/null && echo "Successfully killed process $PORT_PID" || echo "Failed to kill process $PORT_PID"
  sleep 1
else
  echo "No process found using port 5050"
fi

cd ~/Projects/Java/NodeJS/LF/

# Start the server in the background
echo "Starting server..."
npx serve -p 5050 static &
SERVER_PID=$!
echo "Server started with PID: $SERVER_PID"

# Let the server start up before opening the browser
sleep 2

# Open the URL
echo "Opening browser..."
open http://localhost:5050

echo "Server running at http://localhost:5050"
echo "Press Ctrl+C to stop the server"
wait $SERVER_PID