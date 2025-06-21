#!/bin/zsh

echo "sensitive environment variables are loaded by .zshrc file's parent file .private.zshrc file e.g. GITHUB_CLIENT_SECRET"
source ~/.zshrc
kp 8080
./mvnw clean install -DskipTests
./mvnw spring-boot:run
open http://localhost:8080