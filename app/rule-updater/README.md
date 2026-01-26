pnpm init -y
pnpm add fastify @fastify/autoload
pnpm add fastify @fastify/cors

# Description

This is a Fastify project scaffolded with pnpm. It includes the Fastify framework along with the @fastify/autoload and @fastify/cors plugins for automatic route loading and CORS support, respectively.
It offers API endpoints for managing rule configurations for Shadowrocket and Surge client.

## code-server configuration

```bash
# to stop the code-server service
sudo systemctl stop code-server@$USER
sudo systemctl disable code-server@$USER
# to configure code-server to listen on all IP addresses (foreground)
code-server --bind-addr 0.0.0.0:8080

#(as a daemon)
vim ~/.config/code-server/config.yaml
sudo systemctl enable code-server@$USER
sudo systemctl start code-server@$USER
```
