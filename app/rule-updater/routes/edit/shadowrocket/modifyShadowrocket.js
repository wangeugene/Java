import * as fs from "node:fs";

export function createBackup(configFile, backupFile) {
    fs.copyFileSync(configFile, backupFile);
    console.log(`Backup created at ${backupFile}`);
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

export function overwriteConfigWithBackup(backupFile, configFile) {
    fs.copyFileSync(backupFile, configFile);
    console.log(`Configuration restored from backup at ${backupFile}`);
}
