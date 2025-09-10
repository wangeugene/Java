#!/bin/zsh

echo "Setting up Prettier for code formatting with npm"
npm install --save-dev --save-exact prettier

echo "Formatting all files recursively in the current directory using npm prettier"
npx prettier . --write

URL="https://prettier.io/docs/install"
echo "For more information, visit: $URL"