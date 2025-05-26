#!/bin/zsh
source ~/.zshrc
kp 3000 

echo "Starting the dev mock server with Fastify..."
npm run dev &
SERVER_PID=$!
echo "Mock Server started with PID: $SERVER_PID"

# Open the URL
echo "Opening browser at the port 3000..."
open http://localhost:3000
echo "Pausing for 2 seconds..."
sleep 2
open http://localhost:3000/confectionery/
echo "Pausing for 2 seconds..."
sleep 2
open http://localhost:3000/electronics/


echo "Press Ctrl+C to stop the server"
wait $SERVER_PID