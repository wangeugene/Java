'use strict'

/* Where {DATA HERE} is whatever mock data we wish to send as a response for that route.

Although we are not using them yet, it's important to note that the route handler function is also passed request and reply objects. These are conceptually the same, but functionally different to the req and res objects passed to the Node core http.createServer request listener function, because they have their own (higher level) APIs. See the Fastify Request and the Fastify Reply documentation for full information on their APIs.
*/

// This function is named: route handler function
module.exports = async function (fastify, opts) {
  fastify.get('/', async function (request, reply) {
    return [
      { id: 'A1', name: 'Vacuum Cleaner', rrp: '99.99', info: 'The worst vacuum in the world.' },
      { id: 'A2', name: 'Leaf Blower', rrp: '303.33', info: 'This product will blow your socks off.' },
    ]
  })
}
