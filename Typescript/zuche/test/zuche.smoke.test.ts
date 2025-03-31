import {extractHitchList, fetchHitchList} from "../src/zuche";
import dotenv from "dotenv";

dotenv.config();

describe("zuche hitch list smoke test", () => {
    it("should return huizhou -> anywhere list,if there are hitchs", async () => {
        const response = await fetchHitchList(231, null);
        expect(response.status).toEqual("SUCCESS");
        expect(response.content).toBeDefined();
        expect(response.content.hitchList).toBeDefined();
        expect(response.content.hitchList.length).toBeGreaterThan(0);
        console.log(response.content.hitchList);
    });
});
