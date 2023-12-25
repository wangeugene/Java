// stop the invocation of the interval
setTimeout(() => {
    clearInterval(interval)
    console.log('stop the interval after 10 seconds')
}, 10000)

const interval = setInterval(() => {
    console.log('print every 2 seconds')
}, 2000)
