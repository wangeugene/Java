'use strict'

// npx wscat -c ws://localhost:3000/orders/electronics to troubleshoot the WS endpoint
// now tested fine with wscat
module.exports = async function (fastify, opts) {
  fastify.get('/:category', { websocket: true }, async (connection, request) => {
    // Normalize to the actual WebSocket instance (works for both shapes)
    const socket = connection && connection.socket ? connection.socket : connection

    for (const order of fastify.currentOrders(request.params.category)) {
      console.log('Sending current order', order)
      try {
        socket.send(order)
      } catch (err) {
        console.error('Failed to send current order', err, order)
      }
    }

    for await (const order of fastify.realtimeOrders()) {
      if (socket.readyState >= socket.CLOSING) break
      socket.send(order)
    }
  })
}
