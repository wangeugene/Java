'use strict'
// A Node passthrough stream sends any writes straight to its readable side with no modifications. We can use the PassThrough constructor to create a passthrough stream to represent the continuous flow of orders sent via POST requests to the /orders/{id} route. For more information on Node streams, see the following resources:
const { PassThrough } = require('stream')
const fp = require('fastify-plugin')

const orders = {
  A1: { total: 3 },
  A2: { total: 7 },
  B1: { total: 101 },
}

const catToPrefix = {
  electronics: 'A',
  confectionery: 'B',
}

const orderStream = new PassThrough({ objectMode: true })

async function* realtimeOrders() {
  for await (const { id, total } of orderStream) {
    yield JSON.stringify({ id, total })
  }
}

function addOrder(id, amount) {
  if (orders.hasOwnProperty(id) === false) {
    const err = new Error(`Order ${id} not found`)
    err.status = 404
    throw err
  }
  if (Number.isInteger(amount) === false) {
    const err = new Error('Supplied amount must be an integer')
    err.status = 400
    throw err
  }
  orders[id].total += amount
  const { total } = orders[id]
  orderStream.write({ id, total })
}

function* currentOrders(category) {
  const idPrefix = catToPrefix[category]
  if (!idPrefix) return
  const ids = Object.keys(orders).filter((id) => id[0] === idPrefix)
  for (const id of ids) {
    yield JSON.stringify({ id, ...orders[id] })
  }
}

const calculateID = (idPrefix, data) => {
  const sorted = [...new Set(data.map(({ id }) => id))]
  const next = Number(sorted.pop().slice(1)) + 1
  return `${idPrefix}${next}`
}

module.exports = fp(async function (fastify, opts) {
  fastify.decorate('currentOrders', currentOrders)
  fastify.decorate('realtimeOrders', realtimeOrders)
  fastify.decorate('addOrder', addOrder)
  fastify.decorateRequest('mockDataInsert', function (category, data) {
    const request = this
    const idPrefix = catToPrefix[category]
    const id = calculateID(idPrefix, data)
    orders[id] = { total: 0 }
    data.push({ id, ...request.body })
  })
})
