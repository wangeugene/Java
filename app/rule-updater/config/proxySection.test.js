import { describe, it, expect } from "vitest";

describe("extractProxySection", () => {
    const { extractProxySection } = require("./proxySection");

    it("extracts Proxy section correctly", () => {
        const config = `
[General]
setting1=value1
[Proxy]
proxy1=proxyvalue1
proxy2=proxyvalue2
[OtherSection]
otherSetting=value
        `;

        const expectedProxySection = `[Proxy]
proxy1=proxyvalue1
proxy2=proxyvalue2
`;

        expect(extractProxySection(config)).toBe(expectedProxySection);
    });

    it("throws error if Proxy section is missing", () => {
        const config = `
[General]
setting1=value1

[OtherSection]
otherSetting=value
        `;

        expect(() => extractProxySection(config)).toThrow("Could not find [Proxy] section in config file");
    });

    it("handles Proxy section at the end of the file", () => {
        const config = `
[General]
setting1=value1

[Proxy]
proxy1=proxyvalue1
proxy2=proxyvalue2
        `;

        const expectedProxySection = `[Proxy]
proxy1=proxyvalue1
proxy2=proxyvalue2
`;

        expect(extractProxySection(config)).toBe(expectedProxySection);
    });
});
