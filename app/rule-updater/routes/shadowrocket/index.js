import { promises as fs } from "fs";
import { fileURLToPath } from "url";
import { dirname, resolve } from "path";
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const CONFIG_FILE = resolve(__dirname, "../../../www/config/shadowrocket.conf");

export default async function (fastify, opts) {
    fastify.get("/", async function (request, reply) {
        try {
            const content = await fs.readFile(CONFIG_FILE, "utf-8");
            reply.type("text/plain").send(content);
        } catch {
            reply.code(404).type("text/plain").send("not found");
        }
    });
}
