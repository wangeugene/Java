export function findByDomainSuffix(lines, domainName) {
    const target = `DOMAIN-SUFFIX,${domainName},`;
    return lines.find((line) => line.trimStart().startsWith(target));
}
