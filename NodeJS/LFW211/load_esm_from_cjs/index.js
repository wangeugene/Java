"use strict";

if (require.main === module) {
    const pino = require("pino");
    const logger = pino();
    import("./format.mjs")
        .then((format) => {
            logger.info(format.upper("my-package started"));
            process.stdin.resume();
        })
        .catch((err) => {
            console.error(err);
            process.exit(1);
        });
} else {
    let format = null;
    const reverseAndUpper = async (str) => {
        format = format || (await import("./format.mjs"));
        return format.upper(str).split("").reverse().join("");
    };
    module.exports = reverseAndUpper;
}

// run as a main module: node index.js
// run as a library: node -e "require('./index')('hello').then(console.log)"
// run as a library: node -p 'require("./index")("hello")'
