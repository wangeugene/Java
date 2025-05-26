#!/bin/zsh
echo "Setting up mock server environment with Fastify and Node.js 20..."

# Source zshrc to ensure nvm is available
source ~/.zshrc

echo "Switching to the Node.js version 20..."
nvm use 20
echo "Installing Fastify CLI and Fastify..."
npm add fastify fastify-cli
echo "Generating Fastify server with ESM support..."
npx fastify generate . --esm
npm install

echo "Installing Fastify CORS for handling CORS..."
npm install @fastify/cors