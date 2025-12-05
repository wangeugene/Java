#!/usr/bin/env bash

# Ask for a filename
read -r -p "Please enter the filename you want to paste into the remote machine: " file_name

# Optional: guard against empty input
if [[ -z "$file_name" ]]; then
  echo "Filename cannot be empty."
  exit 1
fi

remote_path="/app/www/config/$file_name"

echo "Pasting clipboard → $remote_path ..."
pbpaste | ssh aws "cat > $remote_path"

echo "Done."
echo "Last 3 lines of the remote file:"
ssh aws "tail -n 3 $remote_path"