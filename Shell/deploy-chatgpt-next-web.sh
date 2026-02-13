
#!/usr/bin/env bash
set -euo pipefail

# Load .env (export variables so curl can see them)
set -a
source .env
set +a

: "${OPENAI_API_KEY:?OPENAI_API_KEY is missing. Put it in .env}"
: "${CHATGPT_WEB_PASS:?CHATGPT_WEB_PASS is missing. Put it in .env}"

docker pull yidadaa/chatgpt-next-web

docker run -d -p 3000:3000 \
	-e "OPENAI_API_KEY=$OPENAI_API_KEY" \
	-e "CODE=$CHATGPT_WEB_PASS" \
	yidadaa/chatgpt-next-web
