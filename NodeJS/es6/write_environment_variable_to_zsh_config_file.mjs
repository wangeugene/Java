import fs from "fs";
import path from "path";
import os from "os";

fs.appendFileSync(path.join(os.homedir(), '.zshrc'), "export TOKEN='exampleToken'\n");
console.log(fs.readFileSync(path.join(os.homedir(), '.zshrc'), 'utf8'))