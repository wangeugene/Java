// routes/edit/shadowrocket.js
/* 
curl -X POST 'http://127.0.0.1:3000/edit/shadowrocket?domainName=eugene.com&rule=DIRECT'
*/
import { promises as fs } from "fs";
import path from "path";

const FILE_PATH = "../../../www/config/shadowrocket.conf";

function insertAfterLastDomainSuffix(originalText, newLine) {
    const hasCRLF = /\r\n/.test(originalText);
    const EOL = hasCRLF ? "\r\n" : "\n";
    const lines = originalText.split(/\r?\n/);

    let lastIdx = -1;
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].trimStart().startsWith("DOMAIN-SUFFIX")) lastIdx = i;
    }

    if (lastIdx === -1) {
        const needsNL = originalText.length > 0 && !/\r?\n$/.test(originalText);
        const prefix = needsNL ? originalText + EOL : originalText;
        return prefix + newLine + EOL;
    }

    const before = lines.slice(0, lastIdx + 1).join(EOL);
    const after = lines.slice(lastIdx + 1).join(EOL);
    const joiner1 = before.length ? EOL : "";
    const joiner2 = EOL + (after.length ? "" : "");
    return before + joiner1 + newLine + joiner2 + after;
}

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

        const newLine = `DOMAIN-SUFFIX,${domainName},${rule}`;

        let original = "";
        try {
            original = await fs.readFile(FILE_PATH, "utf-8");
        } catch {}

        const updated = insertAfterLastDomainSuffix(original, newLine);

        await fs.mkdir(path.dirname(FILE_PATH), { recursive: true });
        await fs.writeFile(FILE_PATH, updated, "utf-8");

        reply.type("text/plain").send("ok");
    });
}
