import {
    removeDuplicatesByDomain,
    updateDomainRule,
    hasDomain,
    insertAfterLastDomainSuffix,
} from "../../domain/shadowrocketRuleEditor.js";

import {
    readBackupText,
    writeBackupText,
    syncBackupToConfig,
    ensureBackupExists,
} from "../../infra/configFileService.js";

export async function upsertDomainRule(domainName, rule) {
    await ensureBackupExists();

    const originalText = await readBackupText();
    const hasCRLF = /\r\n/.test(originalText);
    const EOL = hasCRLF ? "\r\n" : "\n";

    let lines = originalText.split(/\r?\n/);

    // 1) Remove duplicates
    lines = removeDuplicatesByDomain(lines, domainName);

    // 2) Update existing or insert new at correct position
    if (hasDomain(lines, domainName)) {
        lines = updateDomainRule(lines, domainName, rule);
        const updatedText = lines.join(EOL);
        await writeBackupText(updatedText);
    } else {
        const newLine = `DOMAIN-SUFFIX,${domainName},${rule}`;
        const updatedText = insertAfterLastDomainSuffix(lines.join(EOL), newLine);
        await writeBackupText(updatedText);
    }

    // 3) Copy backup → main config
    await syncBackupToConfig();
}
