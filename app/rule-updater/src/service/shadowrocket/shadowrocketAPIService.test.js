// config/shadowrocketService.test.js
import { describe, it, expect, vi, beforeEach } from "vitest";

// Mock store.js BEFORE importing the service
vi.mock("../../infra/configFileService.js", () => {
    return {
        ensureBackupExists: vi.fn(),
        readBackupText: vi.fn(),
        writeBackupText: vi.fn(),
        syncBackupToConfig: vi.fn(),
    };
});

import {
    ensureBackupExists,
    readBackupText,
    writeBackupText,
    syncBackupToConfig,
} from "../../infra/shadowrocketConfigFileBackupService.js";

import { upsertDomainRule } from "../../service/shadowrocket/shadowrocketAPIService.js";

beforeEach(() => {
    vi.clearAllMocks();
});

describe("upsertDomainRule", () => {
    it("updates existing domain line with new rule", async () => {
        // Arrange
        const original = ["DOMAIN-SUFFIX,example.com,DIRECT", "DOMAIN-SUFFIX,other.com,PROXY"].join("\n");

        readBackupText.mockResolvedValue(original);

        // Act
        await upsertDomainRule("example.com", "PROXY");

        // Assert flow
        expect(ensureBackupExists).toHaveBeenCalledTimes(1);
        expect(readBackupText).toHaveBeenCalledTimes(1);
        expect(writeBackupText).toHaveBeenCalledTimes(1);
        expect(syncBackupToConfig).toHaveBeenCalledTimes(1);

        // Assert content written
        const written = writeBackupText.mock.calls[0][0];
        expect(written).toBe(
            [
                "DOMAIN-SUFFIX,example.com,PROXY", // updated
                "DOMAIN-SUFFIX,other.com,PROXY",
            ].join("\n"),
        );
    });

    it("inserts new domain line when not present", async () => {
        const original = [
            "DOMAIN-SUFFIX,aaa.com,DIRECT",
            "DOMAIN-SUFFIX,bbb.com,PROXY",
            "IP-CIDR,1.2.3.4/32,REJECT",
        ].join("\n");

        readBackupText.mockResolvedValue(original);

        await upsertDomainRule("ccc.com", "DIRECT");

        expect(writeBackupText).toHaveBeenCalledTimes(1);
        const written = writeBackupText.mock.calls[0][0];

        // New line should appear after last DOMAIN-SUFFIX line
        const lines = written.split("\n");
        expect(lines).toEqual([
            "DOMAIN-SUFFIX,aaa.com,DIRECT",
            "DOMAIN-SUFFIX,bbb.com,PROXY",
            "DOMAIN-SUFFIX,ccc.com,DIRECT",
            "IP-CIDR,1.2.3.4/32,REJECT",
        ]);
    });

    it("preserves CRLF when original backup uses CRLF", async () => {
        const original = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,DIRECT"].join("\r\n");

        readBackupText.mockResolvedValue(original);

        await upsertDomainRule("bbb.com", "PROXY");

        const written = writeBackupText.mock.calls[0][0];

        // Must still contain CRLF, not just \n
        expect(written).toContain("\r\n");
        expect(written).toBe("DOMAIN-SUFFIX,aaa.com,DIRECT\r\nDOMAIN-SUFFIX,bbb.com,PROXY");
    });
});
