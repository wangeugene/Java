export function extractProxySection(fullConfig) {
    const match = fullConfig.match(/\[Proxy\]([\s\S]*?)(?=\[[^\]]+\]|$)/);

    if (!match) {
        throw new Error("Could not find [Proxy] section in config file");
    }

    const body = match[1].trim();
    return `[Proxy]\n${body}\n`;
}
