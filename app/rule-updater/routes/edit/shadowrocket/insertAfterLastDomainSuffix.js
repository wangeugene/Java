export function insertAfterLastDomainSuffix(originalText, newLine) {
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
