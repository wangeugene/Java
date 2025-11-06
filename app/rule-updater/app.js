import Fastify from "fastify";
import autoload from "@fastify/autoload";
import { fileURLToPath } from "url";
import { dirname, join } from "path";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const app = Fastify({ logger: true });

// Accept any body as string if needed later
app.addContentTypeParser("*", { parseAs: "string" }, async (_req, payload) => payload);

await app.register(autoload, { dir: join(__dirname, "routes"), forceESM: true });

const PORT = Number(process.env.PORT ?? 3000);
const HOST = process.env.HOST ?? "0.0.0.0";

try {
    await app.listen({ port: PORT, host: HOST });
    console.log(`Server listening on http://127.0.0.1:${PORT}`);
} catch (err) {
    app.log.error(err);
    process.exit(1);
}

const signals = ["SIGINT", "SIGTERM", "SIGHUP"];
for (const sig of signals) {
    process.on(sig, async () => {
        try {
            await app.close(); // closes the listener & releases port 3000
            process.exit(0);
        } catch (e) {
            app.log.error(e);
            process.exit(1);
        }
    });
}
