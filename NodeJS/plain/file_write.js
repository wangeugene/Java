const fs = require('fs');

const file_content = 'This is file content.';
const file_name = 'node_file_write.txt';
// The output file will be in the same dir as the source file¬
fs.writeFile(file_name, file_content, (err) => {
    if (err) throw err;
    fs.appendFile(file_name, '\nThis is appended content.', (err) => {
        if (err) throw err;
    })
    console.log(`Write file ${file_name} successfully!`)
})