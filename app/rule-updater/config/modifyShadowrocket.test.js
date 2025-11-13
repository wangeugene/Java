import { describe, test, beforeEach, expect, vi } from "vitest";
import * as fs from "node:fs";
const { createBackup, removeDuplicateLinesByDomainName, updateConfigWithDomainNameAndRule, overwriteConfigWithBackup } =
    await import("./modifyShadowrocket.js");

vi.mock("node:fs", () => ({
    copyFileSync: vi.fn(),
    readFileSync: vi.fn(),
    writeFileSync: vi.fn(),
}));

beforeEach(() => {
    vi.clearAllMocks();
});

describe("modifyShadowrocket helpers", () => {
    test("create a backup copy of the config file", () => {
        createBackup("shadowrocket.conf", "shadowrocket.conf.bak");
        expect(fs.copyFileSync).toHaveBeenCalledWith("shadowrocket.conf", "shadowrocket.conf.bak");
    });

    test("remove duplicate lines by a domain name", () => {
        const input = ["foo", "something eugene.com other", "another eugene.com entry", "foo", "bar"].join("\n");
        fs.readFileSync.mockReturnValue(input);
        removeDuplicateLinesByDomainName("shadowrocket.conf", "eugene.com");
        const expected = ["foo", "something eugene.com other", "foo", "bar"].join("\n");
        expect(fs.writeFileSync).toHaveBeenCalledWith("shadowrocket.conf", expected, "utf-8");
    });

    test("update config with domain name and rule", () => {
        const input = ["alpha", "DOMAIN-SUFFIX,eugene.com,PROXY", "omega"].join("\n");
        fs.readFileSync.mockReturnValue(input);
        updateConfigWithDomainNameAndRule("shadowrocket.conf.bak", "eugene.com", "DIRECT");
        const expected = ["alpha", "DOMAIN-SUFFIX,eugene.com,DIRECT", "omega"].join("\n");
        expect(fs.writeFileSync).toHaveBeenCalledWith("shadowrocket.conf.bak", expected, "utf-8");
    });

    test("overwrite the config with its backup", () => {
        overwriteConfigWithBackup("shadowrocket.conf.bak", "shadowrocket.conf");
        expect(fs.copyFileSync).toHaveBeenCalledWith("shadowrocket.conf.bak", "shadowrocket.conf");
    });
});
