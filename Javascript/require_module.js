const {increase, decrease, getCount, author} = require('./export_module.js')

increase()
increase()
increase()
increase()
decrease()

console.log(getCount())
increase()
increase()
console.log(`the count now is ${getCount()}`)

console.log(author)
