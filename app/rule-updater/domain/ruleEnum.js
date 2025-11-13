export const RuleEnum = Object.freeze({
    DIRECT: "DIRECT",
    PROXY: "PROXY",
    REJECT: "REJECT",
});

export function assertValidRule(rule) {
    if (!isValidRule(rule)) {
        throw new Error(`Invalid rule: ${rule}`);
    }
}

export function isValidRule(rule) {
    return Object.values(RuleEnum).includes(rule);
}
