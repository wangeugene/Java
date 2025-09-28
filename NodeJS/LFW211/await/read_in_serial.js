const { readFile } = require("fs").promises;
const print = (contents) => {
    console.log(contents.toString());
};
const [bigFile, mediumFile, smallFile] = Array.from(Array(3)).fill(__filename);

async function run() {
    print(await readFile(bigFile));
    print(await readFile(mediumFile));
    print(await readFile(smallFile));
}

run().catch(console.error);
