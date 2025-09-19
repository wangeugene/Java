'use strict'
module.exports = async function (fastify, opts) {
  function monitorMessages(socket) {
    socket.on('message', (data) => {
      try {
        const { cmd, payload } = JSON.parse(data)
        console.log('WebSocket Orders Message received from the frontend:', { cmd, payload })
        if (cmd === 'update-category') {
          sendCurrentOrders(payload.category, socket)
        }
      } catch (err) {
        fastify.log.warn('WebSocket Message (data: %o) Error: %s', data, err.message)
      }
    })
  }

  function sendCurrentOrders(category, socket) {
    for (const order of fastify.currentOrders(category)) {
      socket.send(order)
    }
  }

  fastify.get('/:category', { websocket: true }, async (connection, request) => {
    const socket = connection
    monitorMessages(socket)
    sendCurrentOrders(request.params.category, socket)
    for await (const order of fastify.realtimeOrders()) {
      if (socket.readyState >= socket.CLOSING) break
      socket.send(order)
    }
  })
}
