# Mock HTTP GET & POST services & WebSocket services with Fastify as the backend & `serve` static content as the frontend

- This `bidirectional-realtime-communication` project features the pretty much the same as the `enhance-with-websockets` project
  except optimized client code `app.js` from the `static` folder to reduce WebSocket connection generation during the flow.

This LinuxFoundation tutorial demonstrates how to:

- Mock HTTP GET services at the port 3000 under `mock-srv` folder with Fastify scaffolding framework
- Serve HTML static content at the port 5050 with `static` folder using NodeJS built-in package `serve`
- The `setup.sh` script install the required dependencies
- The `start.sh` script run the frontend & backend services in one shot and kill the dangling processes using the port 5050 & 3000
- Backend WebSocket service periodically send random generated order counts to the client code, this demonstrates the live updating feature of the DOM object (order counts) here without the need to refreshing the webpage,like a stock dashboard flicker! ## Troubleshooting
  The `start.sh` can hide `npm run dev` failure, if it fails to behavior correctly, do it manually.

```html
Chocolate Bar - 22.40 [Orders: 108]
```

- The `Orders` can increment every 1500 ms, artificially generated order counts

## Bug Fix history

- Fix POST not supported: 404 when I checked the Google Chrome Network panel for the POST requests
- Fix WebSocket connection not updated to the client side code: Backend WebSocket randomly generated some order data sent back to the front end code
  1. Because {} spread operator can't correctly parse the object which is stringified here: `socket.send(JSON.stringify(object))`,removed the `JSON.stringify` call fix this issue.
