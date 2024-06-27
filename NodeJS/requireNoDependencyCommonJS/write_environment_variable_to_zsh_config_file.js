// export TOKEN='exampleToken' >> ~/.zshrc
// write code to write environment variable to ~/.zshrc file
const fs = require('fs')
const path = require('NodeJS/requireNoDependencyCommonJS/path')
const os = require('os')
// write string: export Token='exampleTokne' to ~/.zshrc file
fs.appendFileSync(path.join(os.homedir(), '.zshrc'), "export TOKEN='exampleToken'\n");

// print out the content of ~/.zshrc file
console.log(fs.readFileSync(path.join(os.homedir(), '.zshrc'), 'utf8'))