import * as fs from "node:fs";

import { describe, test, beforeEach, expect, vi } from "vitest";

// 1) Mock fs BEFORE importing the module under test (ESM rule)
vi.mock("node:fs", () => ({
    copyFileSync: vi.fn(),
    readFileSync: vi.fn(),
    writeFileSync: vi.fn(),
}));

// 2) Import the mocked module namespace for assertions
import * as fs from "node:fs";

// 3) Import the module under test AFTER the mock
const { createBackup, removeDuplicateLines, replaceDuplicateLines, overwriteConfigWithBackup } = await import(
    "./modifyShadowrocket.js"
);

beforeEach(() => {
    vi.clearAllMocks();
});

describe("modifyShadowrocket helpers", () => {
    test("createBackup calls fs.copyFileSync correctly", () => {
        createBackup("shadowrocket.conf", "shadowrocket.conf.bak");
        expect(fs.copyFileSync).toHaveBeenCalledWith("shadowrocket.conf", "shadowrocket.conf.bak");
    });

    test("removeDuplicateLines collapses domain lines to a single 'eugene.com' and removes duplicate plain lines", () => {
        const input = ["foo", "something eugene.com other", "another eugene.com entry", "foo", "bar"].join("\n");
        fs.readFileSync.mockReturnValue(input);

        removeDuplicateLines("shadowrocket.conf", "eugene.com");

        const expected = ["foo", "eugene.com", "bar"].join("\n");
        expect(fs.writeFileSync).toHaveBeenCalledWith("shadowrocket.conf", expected, "utf-8");
    });

    test("replaceDuplicateLines replaces only the first domain occurrence with fixed rule", () => {
        const input = ["alpha", "mid eugene.com here", "tail eugene.com again", "omega"].join("\n");
        fs.readFileSync.mockReturnValue(input);

        replaceDuplicateLines("shadowrocket.conf", "eugene.com");

        const expected = ["alpha", "DOMAIN-SUFFIX, eugene.com, PROXY", "tail eugene.com again", "omega"].join("\n");

        expect(fs.writeFileSync).toHaveBeenCalledWith("shadowrocket.conf", expected, "utf-8");
    });

    test("overwriteConfigWithBackup copies backup to config", () => {
        overwriteConfigWithBackup("shadowrocket.conf", "shadowrocket.conf.bak");
        expect(fs.copyFileSync).toHaveBeenCalledWith("shadowrocket.conf.bak", "shadowrocket.conf");
    });
});
