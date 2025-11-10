import * as fs from "node:fs";

// Function 1: Create a backup of the shadowrocket.conf file
export function createBackup(configFile, backupFile) {
    fs.copyFileSync(configFile, backupFile);
    console.log("Backup created: shadowrocket.conf.bak");
}

// Function 2: Remove duplicate lines with "eugene.com"
export function removeDuplicateLines(configFile, domainName) {
    const fileContent = fs.readFileSync(configFile, "utf-8");
    const lines = fileContent.split("\n");

    const result = [];
    let seen = false;
    for (const line of lines) {
        if (line.includes(domainName)) {
            if (!seen) {
                result.push(line); // keep the first occurrence as-is
                seen = true;
            }
            // skip subsequent occurrences
        } else {
            result.push(line);
        }
    }

    fs.writeFileSync(configFile, result.join("\n"), "utf-8");
}

// Function 3: Replace line containing "eugene.com" with the specific rule
export function replaceDuplicateLines(configFile, domainName) {
    let fileContent = fs.readFileSync(configFile, "utf-8");
    let lines = fileContent.split("\n");

    for (let i = 0; i < lines.length; i++) {
        if (lines[i].includes(domainName)) {
            lines[i] = `DOMAIN-SUFFIX, ${domainName}, PROXY`;
            break; // Ensure we only replace the first occurrence
        }
    }

    fs.writeFileSync(configFile, lines.join("\n"), "utf-8");
    console.log('Replaced "eugene.com" line with the new rule');
}

// Function 4: Overwrite the original config with the backup
export function overwriteConfigWithBackup(configFile, backupFile) {
    fs.copyFileSync(backupFile, configFile);
    console.log("Configuration file restored from backup");
}
