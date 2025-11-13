// routes/edit/shadowrocket.js
/* 
curl -X POST 'http://127.0.0.1:3000/edit/shadowrocket?domainName=eugene.com&rule=DIRECT'
*/
import { assertValidRule } from "../../../domain/ruleEnum.js";
import { upsertDomainRule } from "../../../config/shadowrocketService.js";

export default async function routes(fastify) {
    fastify.post("/", async (req, reply) => {
        const q = req.query ?? {};
        const b = req.body && typeof req.body === "object" ? req.body : {};

        const domainName = (b.domainName ?? q.domainName ?? "").trim();
        const rule = (b.rule ?? q.rule ?? "").trim().toUpperCase();

        if (!domainName || !rule) {
            reply.code(400).type("text/plain").send("domainName and rule are required");
            return;
        }

        try {
            assertValidRule(rule);
        } catch (err) {
            return reply.code(400).send(`Invalid rule. Allowed: ${Object.values().join(", ")}`);
        }

        try {
            console.log(`Updating shadowrocket config: ${domainName} → ${rule}`);
            await upsertDomainRule(domainName, rule);
            return reply.type("text/plain").send("ok");
        } catch (err) {
            req.log.error({ err }, "Failed to update shadowrocket config");
            return reply.code(500).type("text/plain").send("Internal Server Error");
        }
    });
}
