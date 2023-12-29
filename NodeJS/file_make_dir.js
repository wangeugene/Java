const fs = require('fs');

fs.existsSync('node_dir', (exists) => {
    if (exists) console.log('Directory already exists!');
    else {
        fs.mkdir('node_dir', (err) => {
            if (err) throw err;
            console.log('Directory created successfully!');
        })
    }
})