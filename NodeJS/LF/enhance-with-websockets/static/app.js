const API = 'http://localhost:3000'
const WS_API = 'ws://localhost:3000'

const populateProducts = async (category, method = 'GET', payload) => {
  const products = document.querySelector('#products')
  products.innerHTML = ''
  const send =
    method === 'GET'
      ? {}
      : {
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        }
  const res = await fetch(`${API}/${category}`, { method, ...send })
  const data = await res.json()
  for (const product of data) {
    const item = document.createElement('product-item')
    item.dataset.id = product.id
    for (const key of ['name', 'rrp', 'info']) {
      const span = document.createElement('span')
      span.slot = key
      span.textContent = product[key]
      item.appendChild(span)
    }
    products.appendChild(item)
  }
}
const category = document.querySelector('#category')
const add = document.querySelector('#add')

console.log('static/app.js loaded', { API, WS_API })
window.addEventListener('error', (e) => console.error('Window error', e.error || e.message))
window.addEventListener('unhandledrejection', (e) => console.error('Unhandled rejection', e.reason))

// ...existing code...
let socket = null
// npx wscat -c ws://localhost:3000/orders/electronics
const realtimeOrders = (category) => {
  // close previous socket to avoid multiple handlers
  if (socket && socket.readyState === WebSocket.OPEN) {
    console.log('Closing previous socket')
    socket.close()
  }
  socket = new WebSocket(`${WS_API}/orders/${category}`)
  socket.addEventListener('open', () => console.log('WS open', category))
  socket.addEventListener('close', () => console.log('WS closed', category))
  socket.addEventListener('error', (e) => console.error('WS error', e))

  socket.addEventListener('message', (evt) => {
    console.log('WS raw message', evt.data)
    let payload
    try {
      payload = JSON.parse(evt.data)
    } catch (err) {
      console.error('Invalid JSON from WS', err, evt.data)
      return
    }
    console.log('Received order update', payload)
    const { id, total } = payload
    console.log('Order update', id, total)
    const item = document.querySelector(`[data-id="${id}"]`)
    if (!item) {
      console.warn('No product element for order id', id)
      return
    }
    // update light DOM slot or shadow DOM safely
    try {
      const span = item.querySelector('[slot="orders"]') || document.createElement('span')
      span.slot = 'orders'
      span.textContent = total
      item.appendChild(span)
    } catch (e) {
      console.debug('Failed to update light DOM', e)
    }
    try {
      const root = item.shadowRoot
      if (root) {
        const totalEl = root.querySelector('.order-total') || root.querySelector('[data-order-total]')
        if (totalEl) totalEl.textContent = String(total)
      }
    } catch (e) {
      console.debug('Failed to update shadow DOM', e)
    }
  })
}

category.addEventListener('input', async ({ target }) => {
  add.style.display = 'block'
  await populateProducts(target.value)
  console.log(
    'populated products ids:',
    Array.from(document.querySelectorAll('#products [data-id]')).map((n) => n.dataset.id)
  )
  realtimeOrders(target.value)
})

add.addEventListener('submit', async (e) => {
  e.preventDefault()
  const { target } = e
  const payload = {
    name: target.name.value,
    rrp: target.rrp.value,
    info: target.info.value,
  }
  await populateProducts(category.value, 'POST', payload)
  realtimeOrders(category.value)
  // Reset form
  target.reset()
})

customElements.define(
  'product-item',
  class Item extends HTMLElement {
    constructor() {
      super()
      const itemTmpl = document.querySelector('#item').content
      this.attachShadow({ mode: 'open' }).appendChild(itemTmpl.cloneNode(true))
    }
  }
)
