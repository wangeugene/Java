#!/bin/zsh

echo "Killing all existing processes on port 5050 and port 3000 (if it exists ofc)..."
source ~/.zshrc
kp 5050 3000

cd ~/Projects/Java/NodeJS/LF/

echo "Starting the static web page server at the port 5050..."
npx serve -p 5050 static &
SERVER_PID=$!
echo "Static Server started with PID: $SERVER_PID"

# Let the server start up before opening the browser
sleep 2

# echo "Starting the mock server using server.mjs at the port 3000..."
# node server.mjs &
# SERVER_PID2=$!
# echo "Mock Server started with PID: $SERVER_PID2"

echo "Starting the mock server using Fastify (mock-srv) at the port 3000..."
cd mock-srv && npm run dev &
SERVER_PID2=$!
echo "Mock Server started with PID: $SERVER_PID2"

# Open the URL
echo "Opening browser at the port 5050..."
open http://localhost:5050

echo "Press Ctrl+C to stop the server"
wait $SERVER_PID
wait $SERVER_PID2