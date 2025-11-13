# !/bin/zsh

# Bind the parent directory's www folder to /app/www in the container
docker run --rm -it \
  -p 3000:3000 \
  -e WWW_DIR="/app/www" \
  -v "$(pwd)/../www:/app/www" \
  rule-updater:local