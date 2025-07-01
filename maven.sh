#!/bin/zsh

source ~/.zshrc
./mvnw clean package
kp 8080 9001
./mvnw spring-boot:run &
APP_PID=$!

# Wait for application to start
echo "Waiting for application to start..."
for i in {1..30}; do
  if curl -s http://localhost:8080 &> /dev/null; then
    echo "Application started successfully at APP_PID: $APP_PID"
    open http://localhost:8080
    break
  fi

  if ! ps -p $APP_PID > /dev/null; then
    echo "Application failed to start. Check logs at /tmp/app.log"
    exit 1
  fi

  echo "Still waiting... ($i/30)"
  sleep 1
done

