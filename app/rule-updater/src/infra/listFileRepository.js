import fs from "fs/promises";
import { CONFIG_DIR } from "./paths.js";
import { join } from "node:path";

export async function getListFileContent(fileName) {
    try {
        fileName = join(CONFIG_DIR, fileName);
        const fileContent = await fs.readFile(fileName, "utf-8");
        return fileContent;
    } catch (error) {
        if (error.code === "ENOENT") {
            return ""; // File does not exist, return empty content
        }
        console.error(`Error reading list file: ${error}`);
        throw error;
    }
}

export async function upsertDomainName(domainName, fileName) {
    try {
        let fileContent = "";
        try {
            fileName = join(CONFIG_DIR, fileName);
            fileContent = await fs.readFile(fileName, "utf-8");
        } catch (err) {
            if (err.code !== "ENOENT") {
                throw err;
            }
        }

        const lines = new Set(fileContent.split("\n").filter(Boolean));
        lines.add(`DOMAIN-SUFFIX,${domainName}`);

        await fs.writeFile(fileName, Array.from(lines).join("\n") + "\n", "utf-8");
    } catch (error) {
        console.error(`Error upserting domain name: ${error}`);
        throw error;
    }
}

export async function deleteDomainName(domainName, fileName) {
    try {
        let fileContent = "";
        try {
            fileName = join(CONFIG_DIR, fileName);
            fileContent = await fs.readFile(fileName, "utf-8");
        } catch (err) {
            if (err.code === "ENOENT") {
                return; // File doesn't exist, nothing to delete
            } else {
                throw err;
            }
        }

        const lines = new Set(fileContent.split("\n").filter(Boolean));
        lines.delete(`DOMAIN-SUFFIX,${domainName}`);

        await fs.writeFile(fileName, Array.from(lines).join("\n") + "\n", "utf-8");
    } catch (error) {
        console.error(`Error deleting domain name: ${error}`);
        throw error;
    }
}
