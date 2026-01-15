import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { readConfigFromURL } from "./configURLReader.js";

describe("readConfigFromURL", () => {
    const URL = "https://s1.trojanflare.one/surge/01580412-b537-4f92-90d8-b4db69c20d80";
    beforeEach(() => {
        vi.clearAllMocks();
    });

    afterEach(() => {
        vi.restoreAllMocks();
    });

    it("should successfully fetch and return config text", async () => {
        const mockConfigText = "config data here";
        global.fetch = vi.fn().mockResolvedValueOnce({
            ok: true,
            text: vi.fn().mockResolvedValueOnce(mockConfigText),
        });

        const result = await readConfigFromURL(URL);
        expect(result).toBe(mockConfigText);
        expect(global.fetch).toHaveBeenCalledWith(URL);
    });
});
