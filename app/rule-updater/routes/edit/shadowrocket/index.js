// routes/edit/shadowrocket.js
/* 
curl -X POST 'http://127.0.0.1:3000/edit/shadowrocket?domainName=eugene.com&rule=DIRECT'
*/
import { promises as fs } from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { removeDuplicateLines } from "./modifyShadowrocket.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const FILE_PATH = path.join(__dirname, "../../../../www/config/shadowrocket.conf");

export default async function routes(fastify) {
    fastify.post("/", async (req, reply) => {
        const q = req.query ?? {};
        const b = req.body && typeof req.body === "object" ? req.body : {};

        const domainName = (b.domainName ?? q.domainName ?? "").trim();
        const rule = (b.rule ?? q.rule ?? "").trim();

        if (!domainName || !rule) {
            reply.code(400).type("text/plain").send("domainName and rule are required");
            return;
        }

        let original = "";
        try {
            original = await fs.readFile(FILE_PATH, "utf-8");
            console.log(`Read existing file1: ${original}`);
        } catch {}

        const withoutDuplicates = removeDuplicateLines(original, domainName);
        await fs.writeFile(FILE_PATH, withoutDuplicates, "utf-8");

        reply.type("text/plain").send("ok");
    });
}
