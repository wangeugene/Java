const path = require('path')
console.log(__dirname)
console.log(__filename)
console.log(path.basename(__filename))
console.log(path.dirname(__filename))

const dirUploads = path.join(__dirname, 'www', 'files', 'uploads')
console.log(dirUploads)
