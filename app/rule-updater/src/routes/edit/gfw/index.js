//
/* curl -X POST 'http://127.0.0.1:3000/edit/gfw?domainName=eugene.com&fileName=gfw.list'
/* curl -X DELETE 'http://127.0.0.1:3000/edit/gfw?domainName=eugene.com&fileName=gfw.list'
 */
import { deleteDomainName, upsertDomainName } from "../../../infra/listFileRepository.js";

export default async function routes(fastify) {
    fastify.post("/", async (req, reply) => {
        let domainName = getDomainNameFromRequest(req);
        let fileName = getFileNameFromRequest(req);
        if (!domainName) {
            reply.code(400).type("text/plain").send("domainName is required");
            return;
        }

        try {
            upsertDomainName(domainName, (fileName = "gfw.list"));
        } catch (err) {
            req.log.error({ err }, "Failed to add domainName to the list file");
            return reply.code(500).type("text/plain").send("Internal Server Error");
        }
    });

    fastify.delete("/", async (req, reply) => {
        let domainName = getDomainNameFromRequest(req);
        let fileName = getFileNameFromRequest(req);
        if (!domainName) {
            reply.code(400).type("text/plain").send("domainName is required");
            return;
        }

        try {
            deleteDomainName(domainName, (fileName = "gfw.list"));
        } catch (err) {
            req.log.error({ err }, "Failed to delete domainName from the list file");
            return reply.code(500).type("text/plain").send("Internal Server Error");
        }
    });
}

function getDomainNameFromRequest(req) {
    const q = req.query ?? {};
    const b = req.body && typeof req.body === "object" ? req.body : {};
    return (b.domainName ?? q.domainName ?? "").trim();
}

function getFileNameFromRequest(req) {
    const q = req.query ?? {};
    const b = req.body && typeof req.body === "object" ? req.body : {};
    return (b.fileName ?? q.fileName ?? "").trim();
}
