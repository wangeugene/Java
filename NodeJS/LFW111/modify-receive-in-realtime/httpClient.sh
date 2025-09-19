node -e "
const http = require('http')
const req = http.request(
  'http://localhost:3000/orders/A1',
  {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
  },
  (res) => res.pipe(process.stdout)
)
req.end(JSON.stringify({ amount: 10 }));"