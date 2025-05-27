#!/bin/zsh
source ~/.zshrc
jenv versions
jenv local 21.0.6
./gradlew clean build
kp 8080
./gradlew bootRun &
sleep 5
open http://localhost:8080
echo "Server started at http://localhost:8080"