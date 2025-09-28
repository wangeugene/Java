const { readFile } = require("fs").promises;

readFile(__filename)
    .then((contents) => {
        console.log(contents.toString());
    })
    .catch(console.error);
