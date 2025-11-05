import Fastify from "fastify";
import autoload from "@fastify/autoload";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = Fastify({ logger: false }); // “dead simple”: no logging

// Accept any body as string if needed later
app.addContentTypeParser("*", { parseAs: "string" }, async (_req, payload) => payload);

await app.register(autoload, { dir: join(__dirname, "routes"), forceESM: true });

const PORT = Number(process.env.PORT ?? 3000);
const HOST = process.env.HOST ?? "0.0.0.0";

try {
    await app.listen({ port: PORT, host: HOST });
} catch {
    process.exit(1);
}
