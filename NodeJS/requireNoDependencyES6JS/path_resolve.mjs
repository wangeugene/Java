import {fileURLToPath} from 'url';
import {resolve, dirname} from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

console.log(import.meta.url)
console.log(__dirname)
const absolute_path = resolve(__dirname, "justPlainText.txt")
console.log(absolute_path)