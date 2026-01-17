import { describe, it, expect } from "vitest";
import {
    removeDuplicatesByDomain,
    updateDomainRule,
    hasDomain,
    insertAfterLastDomainSuffix,
    removeDomainRule,
} from "./shadowrocketRuleEditor.js";

describe("removeDuplicatesByDomain", () => {
    it("removes duplicate lines for the same domain", () => {
        const lines = [
            "DOMAIN-SUFFIX,example.com,DIRECT",
            "DOMAIN-SUFFIX,example.com,PROXY",
            "DOMAIN-SUFFIX,other.com,DIRECT",
        ];
        const result = removeDuplicatesByDomain(lines, "example.com");
        expect(result).toEqual(["DOMAIN-SUFFIX,example.com,DIRECT", "DOMAIN-SUFFIX,other.com,DIRECT"]);
    });

    it("returns identical list when domain is not present", () => {
        const lines = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,PROXY"];
        const result = removeDuplicatesByDomain(lines, "ccc.com");
        expect(result).toEqual(lines);
    });

    it("returns empty list when given an empty list", () => {
        expect(removeDuplicatesByDomain([], "example.com")).toEqual([]);
    });
});

describe("updateDomainRule", () => {
    it("updates the rule for an existing domain line", () => {
        const lines = ["DOMAIN-SUFFIX,example.com,DIRECT", "DOMAIN-SUFFIX,other.com,PROXY"];
        const result = updateDomainRule(lines, "example.com", "REJECT");
        expect(result).toEqual(["DOMAIN-SUFFIX,example.com,REJECT", "DOMAIN-SUFFIX,other.com,PROXY"]);
    });

    it("updates only the first matching domain line when there are duplicates", () => {
        const lines = [
            "DOMAIN-SUFFIX,example.com,DIRECT",
            "DOMAIN-SUFFIX,example.com,PROXY",
            "DOMAIN-SUFFIX,other.com,DIRECT",
        ];
        const result = updateDomainRule(lines, "example.com", "REJECT");
        expect(result).toEqual([
            "DOMAIN-SUFFIX,example.com,REJECT",
            "DOMAIN-SUFFIX,example.com,REJECT",
            "DOMAIN-SUFFIX,other.com,DIRECT",
        ]);
    });

    it("returns the original lines when domain does not exist", () => {
        const lines = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,PROXY"];
        const result = updateDomainRule(lines, "ccc.com", "REJECT");
        expect(result).toEqual(lines);
    });
});

describe("hasDomain", () => {
    it("returns true when at least one line contains the domain", () => {
        const lines = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,PROXY"];
        expect(hasDomain(lines, "aaa.com")).toBe(true);
        expect(hasDomain(lines, "bbb.com")).toBe(true);
    });

    it("returns false when no line contains the domain", () => {
        const lines = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,PROXY"];
        expect(hasDomain(lines, "ccc.com")).toBe(false);
    });

    it("returns false for an empty list", () => {
        expect(hasDomain([], "example.com")).toBe(false);
    });
});

describe("insertAfterLastDomainSuffix", () => {
    it("inserts after the last DOMAIN-SUFFIX line when there are multiple", () => {
        const original = [
            "DOMAIN-SUFFIX,aaa.com,DIRECT",
            "DOMAIN-SUFFIX,bbb.com,PROXY",
            "IP-CIDR,1.2.3.4/32,REJECT",
        ].join("\n");

        const newLine = "DOMAIN-SUFFIX,ccc.com,DIRECT";
        const updated = insertAfterLastDomainSuffix(original, newLine);

        expect(updated).toBe(
            [
                "DOMAIN-SUFFIX,aaa.com,DIRECT",
                "DOMAIN-SUFFIX,bbb.com,PROXY",
                "DOMAIN-SUFFIX,ccc.com,DIRECT",
                "IP-CIDR,1.2.3.4/32,REJECT",
            ].join("\n"),
        );
    });

    it("appends a newline before inserting when text does not end with EOL", () => {
        const original = "DOMAIN-SUFFIX,aaa.com,DIRECT";
        const newLine = "DOMAIN-SUFFIX,bbb.com,PROXY";

        const updated = insertAfterLastDomainSuffix(original, newLine);

        expect(updated).toBe(["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,PROXY"].join("\n") + "\n");
    });

    it("inserts at the end when there is no DOMAIN-SUFFIX line but text is non-empty", () => {
        const original = "IP-CIDR,1.2.3.4/32,REJECT";
        const newLine = "DOMAIN-SUFFIX,aaa.com,DIRECT";

        const updated = insertAfterLastDomainSuffix(original, newLine);

        expect(updated).toBe(["IP-CIDR,1.2.3.4/32,REJECT", "DOMAIN-SUFFIX,aaa.com,DIRECT"].join("\n") + "\n");
    });

    it("returns just the new line plus EOL when original text is empty", () => {
        const original = "";
        const newLine = "DOMAIN-SUFFIX,aaa.com,DIRECT";

        const updated = insertAfterLastDomainSuffix(original, newLine);

        expect(updated).toBe("DOMAIN-SUFFIX,aaa.com,DIRECT\n");
    });

    it("preserves CRLF endings when original text uses CRLF", () => {
        const original = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,PROXY"].join("\r\n");

        const newLine = "DOMAIN-SUFFIX,ccc.com,DIRECT";

        const updated = insertAfterLastDomainSuffix(original, newLine);

        expect(updated).toBe(
            ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,bbb.com,PROXY", "DOMAIN-SUFFIX,ccc.com,DIRECT"].join(
                "\r\n",
            ) + "\r\n",
        );
    });
    it("removes all lines containing the domain", () => {
        const lines = [
            "DOMAIN-SUFFIX,example.com,DIRECT",
            "DOMAIN-SUFFIX,example.com,PROXY",
            "DOMAIN-SUFFIX,other.com,DIRECT",
            "IP-CIDR,1.2.3.4/32,REJECT",
        ];
        const result = removeDomainRule(lines, "example.com");
        expect(result).toEqual(["DOMAIN-SUFFIX,other.com,DIRECT", "IP-CIDR,1.2.3.4/32,REJECT"]);
    });

    it("returns original list when domain is not present", () => {
        const lines = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "IP-CIDR,1.2.3.4/32,REJECT"];
        const result = removeDomainRule(lines, "bbb.com");
        expect(result).toEqual(lines);
    });

    it("returns empty list when all lines contain the domain", () => {
        const lines = ["DOMAIN-SUFFIX,aaa.com,DIRECT", "DOMAIN-SUFFIX,aaa.com,PROXY"];
        const result = removeDomainRule(lines, "aaa.com");
        expect(result).toEqual([]);
    });
});
