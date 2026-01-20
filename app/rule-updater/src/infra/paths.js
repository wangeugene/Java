import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// In Docker Compose, set:
//  env  WWW_DIR=/app/www
// Locally, fall back to ../../www from this file. which is ~/Projects/Java/app/www in my setup.
// The www and rule-updater folders are siblings.
// The www shares the config files with Shadowrocket app via mounted volume with Caddy server.
// The fallback www dir and node_modules dir are siblings to each other.
const FALLBACK_WWW_DIR = resolve(__dirname, "../www");

export const WWW_DIR =
    process.env.WWW_DIR && process.env.WWW_DIR.trim() !== "" ? process.env.WWW_DIR : FALLBACK_WWW_DIR;

console.log("[paths.js] __dirname:", __dirname);
console.log("[paths.js] FALLBACK_WWW_DIR:", FALLBACK_WWW_DIR);
console.log("[paths.js] process.env.WWW_DIR:", process.env.WWW_DIR);
console.log("[paths.js] WWW_DIR:", WWW_DIR);

export const CONFIG_DIR = join(WWW_DIR, "config");
export const SHADOWROCKET_CONFIG_FILE = join(CONFIG_DIR, "shadowrocket.conf");
export const SURGE_CONFIG_FILE = join(CONFIG_DIR, "surge.conf");
export const SHADOWROCKET_CONFIG_BACKUP_FILE = join(CONFIG_DIR, "shadowrocket.conf.bak");
