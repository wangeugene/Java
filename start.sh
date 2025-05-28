#!/bin/zsh

# shellcheck disable=SC1090
source ~/.zshrc
jenv versions
jenv local 21.0.7
./gradlew spotlessApply
./gradlew clean build
kp 8080
(./gradlew bootRun)
sleep 5
echo "running the open operation using sub shell failed, trying to fix it later"
(open http://localhost:8079)
echo "Server started at http://localhost:8080"
echo "To stop the server, run: ./gradlew --stop"