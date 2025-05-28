#!/bin/zsh
source ~/.zshrc
jenv versions
jenv local 21.0.7
./gradlew ktlintFormat
./gradlew clean build
kp 8080
./gradlew bootRun &
sleep 5
open http://localhost:8080
echo "Server started at http://localhost:8080"
echo "To stop the server, run: ./gradlew --stop"