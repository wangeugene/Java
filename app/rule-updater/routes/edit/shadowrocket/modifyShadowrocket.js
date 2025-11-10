import * as fs from "node:fs";
import * as path from "node:path";

export function createBackup(configFile, backupFile) {
    fs.copyFileSync(configFile, backupFile);
    console.log(`Backup created at ${path.basename(backupFile)}`);
}

export function removeDuplicateLinesByDomainName(configFile, domainName) {
    const fileContent = fs.readFileSync(configFile, "utf-8");
    const lines = fileContent.split("\n");

    const result = [];
    let seen = false;
    for (const line of lines) {
        if (line.includes(domainName)) {
            if (!seen) {
                result.push(line);
                seen = true;
            }
        } else {
            result.push(line);
        }
    }
    console.log(`Removed duplicate lines containing "${domainName}"`);
    fs.writeFileSync(configFile, result.join("\n"), "utf-8");
}

export function updateConfigWithDomainNameAndRule(configFile, domainName, rule) {
    let fileContent = fs.readFileSync(configFile, "utf-8");
    let lines = fileContent.split("\n");

    for (let i = 0; i < lines.length; i++) {
        if (lines[i].includes(domainName)) {
            lines[i] = `DOMAIN-SUFFIX,${domainName},${rule}`;
            break;
        }
    }
    console.log(`Updated line with domain "${domainName}" to use rule "${rule}"`);
    fs.writeFileSync(configFile, lines.join("\n"), "utf-8");
}

export function isDomainExists(configFile, domainName) {
    const fileContent = fs.readFileSync(configFile, "utf-8");
    const lines = fileContent.split("\n");
    for (const line of lines) {
        if (line.includes(domainName)) {
            return true;
        }
    }
    return false;
}
export function insertAfterLastDomainSuffix(configFile, newLine) {
    const originalText = fs.readFileSync(configFile, "utf-8");
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
    const updatedLines = before + joiner1 + newLine + joiner2 + after;
    fs.writeFileSync(configFile, updatedLines, "utf-8");
}

export function overwriteConfigWithBackup(backupFile, configFile) {
    fs.copyFileSync(backupFile, configFile);
    console.log(`Configuration restored from backup ${path.basename(backupFile)}`);
}
