#! /bin/zsh

echo 'Make sure this setup.sh script run under the `mock-get-routes` dir'
echo 'Setting up the required mock server with fastify'
echo 'Creating a mock-srv dir to install fastify scaffolding'
(
  mkdir -p mock-srv
  cd mock-srv || exit 1
  source ~/.zshrc
  nvm use 20
  npm install
  npm install @fastify/cors --save
  npm install @fastify/autoload
)
