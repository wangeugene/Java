// Create an HTTP client function for the Zuche API
// pickupCityId: "231" = 惠州 (Huizhou) pickupCityId: "15" = 深圳 (Shenzhen)
import getDetails from "./getDetails.js";
import logger from "./logger.js";
export interface RideInfo {
    hitchDetails?:
        | {
              pickupDeptName: any;
              pickupWorkTime: any;
              pickupCityName: any;
              estTotalPrice: any;
              modelName: any;
              modelDesc: any;
              returnCityName: any;
              returnDeptName: any;
          }
        | undefined;
    hitchId: any;
    index: number;
    modelName: string;
    pickupCityName: string;
    returnCityName: string;
    beginTime: string;
    endTime: string;
    realTotalPrice: number;
}

export async function fetchHitchList(pickupCityId: number, returnCityId: number | null) {
    const url = "https://m.zuche.com/api/gw.do?uri=/action/carrctapi/order/hitchList/v1";
    const requestBody = {
        pickupCityId: pickupCityId,
        returnCityId: returnCityId,
        useCarTime: "",
        pageNo: 1,
        pageSize: 10,
        source: 2,
    };

    const encodedData = `data=${encodeURIComponent(JSON.stringify(requestBody))}`;
    console.log(`Sending request to ${url} with data:`, requestBody);

    try {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                Accept: "application/json, text/plain, */*",
                "Accept-Language": "en",
                "Content-Type": "application/x-www-form-urlencoded",
                Referer: "https://m.zuche.com/",
                Cookie: "lctuid=4509213c792233e1c4917b22539515fa; CAR_UID=7ff48ce4-6a13-4bf5-ac0f-62ba846d784e1742208766650; intranet-sessionid=677ccee5-50ab-4696-8f71-58974b7076c8",
            },
            body: encodedData,
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status} - ${response.statusText}`);
        }

        const data = await response.json();
        return data;
    } catch (error) {
        logger.error("Error fetching hitch list:", error);
        throw error;
    }
}

export async function extractHitchList(pickupCityId: number, returnCityId: number | null) {
    try {
        console.log(
            `extractHitchList called with pickupCityId: ${pickupCityId}, returnCityId: ${returnCityId || "null"}`
        );
        const result = await fetchHitchList(pickupCityId, returnCityId);
        const hitchList: RideInfo[] = [];

        if (result.status === "SUCCESS" && result.content && result.content.hitchList) {
            logger.info(`Available hitch rides: ${result.content.hitchList.length}`);
            console.log(`Processing ${result.content.hitchList.length} hitch rides...`);

            result.content.hitchList.forEach((ride: any, index: number) => {
                const rideInfo = {
                    index: index + 1,
                    hitchId: ride.hitchId,
                    modelName: ride.modelName,
                    pickupCityName: ride.pickupCityName,
                    returnCityName: ride.returnCityName,
                    beginTime: ride.beginTime,
                    endTime: ride.endTime,
                    realTotalPrice: ride.realTotalPrice,
                };
                hitchList.push(rideInfo);
            });
        } else {
            console.log("No hitch list available in the API response or status not SUCCESS:", result);
            logger.warn("No hitch list available in the API response or status not SUCCESS");
        }

        // The problem is that forEach does not wait for async operations to complete. This means that the hitchList array is not guaranteed to have all hitchDetails populated when you use it later (for example, when sending an email or logging).
        for (const hitch of hitchList) {
            const hitchIdArg = {
                hitchId: hitch.hitchId,
            };
            logger.info(`Fetching details for hitchId: ${hitch.hitchId}`);
            const hitchDetails = await getDetails(hitchIdArg);
            hitch.hitchDetails = hitchDetails;
        }

        logger.info(`HitchList: ${JSON.stringify(hitchList, null, 2)}`);
        return hitchList;
    } catch (error) {
        console.error("Error in extractHitchList:", error);
        logger.error("Fetching hitch list failed:", error);
        return [];
    }
}

// Check if this file is being run directly (ES modules version)
// In ES modules, import.meta.url gives the URL of the current module
const isMainModule = import.meta.url === `file://${process.argv[1]}`;

if (isMainModule) {
    const pickupCityId = parseInt(process.argv[2] || "15");
    const returnCityId = parseInt(process.argv[3] || "231");

    console.log(
        `Running zuche.ts directly with pickupCityId: ${pickupCityId}, returnCityId: ${returnCityId || "not specified"}`
    );

    extractHitchList(pickupCityId, returnCityId);
}
