# Mock HTTP GET & POST services with Fastify as the backend & `serve` static content as the frontend

This LinuxFoundation tutorial demonstrates how to:

- Mock HTTP GET services at the port 3000 under `mock-srv` folder with Fastify scaffolding framework
- Serve HTML static content at the port 5050 with `static` folder using NodeJS built-in package `serve`
- The `setup.sh` script install the required dependencies
- The `start.sh` script run the frontend & backend services in one shot and kill the dangling processes using the port 5050 & 3000

## troubleshooting

The `start.sh` can hide `npm run dev` failure, if it fails to behavior correctly, do it manually.
