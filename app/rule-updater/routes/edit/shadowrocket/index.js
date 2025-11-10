// routes/edit/shadowrocket.js
/* 
curl -X POST 'http://127.0.0.1:3000/edit/shadowrocket?domainName=eugene.com&rule=DIRECT'
*/
import path from "path";
import { fileURLToPath } from "url";
import {
    removeDuplicateLinesByDomainName,
    updateConfigWithDomainNameAndRule,
    overwriteConfigWithBackup,
    isDomainExists,
    insertAfterLastDomainSuffix,
} from "./modifyShadowrocket.js";
import { assertValidRule } from "./ruleEnum.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const BACKUP_FILE = path.join(__dirname, "../../../../www/config/shadowrocket.conf.bak");
const CONFIG_FILE = path.join(__dirname, "../../../../www/config/shadowrocket.conf");

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

        try {
            assertValidRule(rule);
        } catch (err) {
            return reply.code(400).send(`Invalid rule. Allowed: ${Object.values().join(", ")}`);
        }

        removeDuplicateLinesByDomainName(BACKUP_FILE, domainName);
        if (isDomainExists(BACKUP_FILE, domainName)) {
            updateConfigWithDomainNameAndRule(BACKUP_FILE, domainName, rule);
            overwriteConfigWithBackup(BACKUP_FILE, CONFIG_FILE);
        } else {
            insertAfterLastDomainSuffix(BACKUP_FILE, `DOMAIN-SUFFIX,${domainName},${rule}`);
            overwriteConfigWithBackup(BACKUP_FILE, CONFIG_FILE);
        }

        reply.type("text/plain").send("ok");
    });
}
