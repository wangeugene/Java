#!/bin/zsh

source ~/.zshrc
echo "OPAQUE_TOKEN=${OPAQUE_TOKEN}"
response=$(curl -X POST \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "Trace-ID: $(uuidgen)" \
  -d "{ \"opaqueToken\": \"${OPAQUE_TOKEN}\" }" \
  "http://www.example.com")
echo $response

