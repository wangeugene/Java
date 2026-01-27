//
/* curl -X POST 'http://127.0.0.1:3000/gfw?domainName=eugene.com&fileName=gfw.list'
/* curl -X DELETE 'http://127.0.0.1:3000/gfw?domainName=eugene.com&fileName=gfw.list'
 */
import { deleteDomainName, upsertDomainName, getListFileContent } from "../../infra/listFileRepository.js";

export default async function routes(fastify) {
    fastify.get("/exists", async (req, reply) => {
        let domainName = getDomainNameFromRequest(req);
        let fileName = getFileNameFromRequest(req);
        if (!domainName) {
            reply.code(400).type("text/plain").send("domainName is required");
            return;
        }

        let exists = false;
        try {
            const listFileContent = await getListFileContent(fileName || "gfw.list");
            if (listFileContent !== null) {
                const lines = listFileContent.split("\n").map((line) => line.trim());
                exists = lines.includes(`DOMAIN-SUFFIX,${domainName}`);
            }
        } catch (err) {
            req.log.error({ err }, "Failed to check domainName existence in the list file");
            return reply.code(500).type("text/plain").send("Internal Server Error");
        }

        return reply.code(200).type("application/json").send({ exists });
    });

    fastify.get("/", async (req, reply) => {
        let listFileContent;
        try {
            listFileContent = await getListFileContent("gfw.list");
        } catch (err) {
            req.log.error({ err }, "Failed to get list file content");
            return reply.code(500).type("text/plain").send("Internal Server Error");
        }
        if (listFileContent !== null) {
            return reply.code(200).type("text/plain").send(listFileContent);
        }
    });

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
