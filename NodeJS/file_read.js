const fs = require('fs');
const options = 'UTF-8';

let for_loop = fs.readFileSync('./for_loop.js', options);
console.log(for_loop);

// read file async
fs.readFile('./for_loop.js', options, (err, file) => {
    if (err) console.log(err);
    else console.log(file);
});