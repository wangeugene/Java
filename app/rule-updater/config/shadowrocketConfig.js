// config/shadowrocketConfig.js

/**
 * Remove duplicate lines containing the domainName,
 * keeping only the first occurrence.
 */
export function removeDuplicatesByDomain(lines, domainName) {
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
    return result;
}

/**
 * Update the rule for an existing domain line:
 * DOMAIN-SUFFIX,domainName,RULE
 */
export function updateDomainRule(lines, domainName, rule) {
    return lines.map((line) => (line.includes(domainName) ? `DOMAIN-SUFFIX,${domainName},${rule}` : line));
}

/**
 * Does at least one line contain this domain?
 */
export function hasDomain(lines, domainName) {
    return lines.some((line) => line.includes(domainName));
}

/**
 * Insert a new DOMAIN-SUFFIX line after the last DOMAIN-SUFFIX line.
 * Preserves line endings.
 */
export function insertAfterLastDomainSuffix(text, newLine) {
    const hasCRLF = /\r\n/.test(text);
    const EOL = hasCRLF ? "\r\n" : "\n";
    const lines = text.split(/\r?\n/);

    let lastIdx = -1;
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].trimStart().startsWith("DOMAIN-SUFFIX")) lastIdx = i;
    }

    if (lastIdx === -1) {
        const needsNL = text.length > 0 && !/\r?\n$/.test(text);
        const prefix = needsNL ? text + EOL : text;
        return prefix + newLine + EOL;
    }

    const before = lines.slice(0, lastIdx + 1).join(EOL);
    const after = lines.slice(lastIdx + 1).join(EOL);
    const joiner1 = before.length ? EOL : "";
    const joiner2 = after.length ? EOL : "";
    return before + joiner1 + newLine + EOL + after;
}
