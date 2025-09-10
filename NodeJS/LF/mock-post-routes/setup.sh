#!/bin/zsh  

source ~/.zshrc
if [ -f .nvmrc ]; then
  nvm install
  nvm use
else
  nvm install 18.20.0
  nvm use 18.20.0
fi
npm install