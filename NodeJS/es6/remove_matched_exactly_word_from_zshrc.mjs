import fs from "fs";
import path from "path";
import os from "os";

fs.writeFileSync(path.join(os.homedir(), '.zshrc'), fs.readFileSync(path.join(os.homedir(), '.zshrc'), 'utf8').replace("export TOKEN=", ""))
console.log(fs.readFileSync(path.join(os.homedir(), '.zshrc'), 'utf8'))
