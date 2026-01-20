import { SHADOWROCKET_CONFIG_FILE } from "../../infra/paths.js";
import { promises as fs } from "node:fs";

export default async function (fastify, opts) {
    fastify.get("/", async function (request, reply) {
        try {
            console.log("Reading shadowrocket config file:", SHADOWROCKET_CONFIG_FILE);
            const content = await fs.readFile(SHADOWROCKET_CONFIG_FILE, "utf-8");
            console.log(`content length: ${content.length}`);
            reply.type("text/plain").send(content);
        } catch (err) {
            console.error("Failed to read config:", err);
            reply.code(404).type("text/plain").send("not found");
        }
    });
}
