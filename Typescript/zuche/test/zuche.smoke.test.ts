import {fetchHitchList} from "../src/zuche";
import * as dotenv from "dotenv";// import * as dotenv from "dotenv"; // import dotenv from "dotenv"; ERROR: has no default
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
