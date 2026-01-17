// routes/delete/shadowrocket/index.js
// curl -X DELETE 'http://localhost:3000/delete/shadowrocket?domainName=eugene1.com'
import { removeDomainRule } from "../../../domain/shadowrocketRuleEditor.js";
import {
    readBackupText,
    writeBackupText,
    syncBackupToConfig,
    ensureBackupExists,
} from "../../../infra/configFileService.js";

export default async function (fastify) {
    fastify.delete("/", async (request, reply) => {
        const { domainName } = request.query;
        await ensureBackupExists();

        console.log("[DELETE /delete/shadowrocket] domainName:", domainName);
        if (!domainName) {
            return reply.code(400).send({ error: "Missing domainName" });
        }

        const originalText = await readBackupText();
        const hasCRLF = /\r\n/.test(originalText);
        const EOL = hasCRLF ? "\r\n" : "\n";
        let lines = originalText.split(/\r?\n/);

        lines = await removeDomainRule(lines, domainName);
        const updatedText = lines.join(EOL);
        await writeBackupText(updatedText);
        await syncBackupToConfig();
        return { ok: true, deleted: domainName };
    });
}
