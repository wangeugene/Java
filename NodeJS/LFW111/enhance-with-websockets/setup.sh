#! /bin/zsh

echo 'Make sure this setup.sh script run under the `root` dir which contains `static` dir and `mock-srv` dir'
echo 'Setting up the required mock server with fastify'
echo 'Creating a mock-srv dir to install fastify scaffolding'
(
  mkdir -p mock-srv
  cd mock-srv || exit 1
  source ~/.zshrc
  nvm use 20
  echo "Using node version: $(node -v)"
  npm init fastify 
  echo "Initialize fastify scaffolding dependencies"
  npm install
  echo "Installing dependencies for mock server"
  echo "At this point, @autoload & @sensible plugins are already installed by `npm init fastify`"
  npm install @fastify/cors
  npm install @fastify/websocket
  echo "Installing @fastify/cors & @fastify/websocket plugins"
)
