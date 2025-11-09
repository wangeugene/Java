import * as fs from "node:fs";

// Function 1: Create a backup of the shadowrocket.conf file
export function createBackup(configFile, backupFile) {
    fs.copyFileSync(configFile, backupFile);
    console.log("Backup created: shadowrocket.conf.bak");
}

// Function 2: Remove duplicate lines with "eugene.com"
export function removeDuplicateLines(configFile, domainName) {
    let fileContent = fs.readFileSync(configFile, "utf-8");
    let lines = fileContent.split("\n");
    let uniqueLines = new Set();

    lines.forEach((line) => {
        if (line.includes(domainName)) {
            uniqueLines.add(domainName);
        } else {
            uniqueLines.add(line);
        }
    });

    fs.writeFileSync(configFile, Array.from(uniqueLines).join("\n"), "utf-8");
    console.log('Removed duplicate "eugene.com" entries');
}

// Function 3: Replace line containing "eugene.com" with the specific rule
export function replaceDuplicateLines(configFile, domainName) {
    let fileContent = fs.readFileSync(configFile, "utf-8");
    let lines = fileContent.split("\n");

    for (let i = 0; i < lines.length; i++) {
        if (lines[i].includes(domainName)) {
            lines[i] = "DOMAIN-SUFFIX, eugene.com, PROXY";
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
