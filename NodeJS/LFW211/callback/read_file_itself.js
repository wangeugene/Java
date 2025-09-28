const { readFile } = require("fs");
readFile(__filename, (err, contents) => {
    if (err) {
        console.error(err);
        return;
    }
    console.log(contents.toString());
});
