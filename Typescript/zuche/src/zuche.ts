// Create an HTTP client function for the Zuche API
// pickupCityId: "231" = 惠州 (Huizhou) pickupCityId: "15" = 深圳 (Shenzhen)
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
        console.error("Error fetching hitch list:", error);
        throw error;
    }
}

export async function extractHitchList(pickupCityId: number, returnCityId: number | null) {
    try {
        console.log("Fetching hitch list data...");
        const result = await fetchHitchList(pickupCityId, returnCityId);
        const hitchListInfo: any[] = [];

        if (result.status === "SUCCESS" && result.content && result.content.hitchList) {
            console.log("\nAvailable hitch rides:");
            result.content.hitchList.forEach((ride: any, index: number) => {
                const rideInfo = {
                    index: index + 1,
                    modelName: ride.modelName,
                    pickupCityName: ride.pickupCityName,
                    returnCityName: ride.returnCityName,
                    beginTime: ride.beginTime,
                    endTime: ride.endTime,
                    realTotalPrice: ride.realTotalPrice,
                };
                hitchListInfo.push(rideInfo);
                console.log(`\n[${rideInfo.index}] ${rideInfo.modelName}`);
                console.log(`  From: ${rideInfo.pickupCityName} → To: ${rideInfo.returnCityName}`);
                console.log(`  Date: ${rideInfo.beginTime} - ${rideInfo.endTime}`);
                console.log(`  Price: ${rideInfo.realTotalPrice}`);
                return hitchListInfo;
            });
        }
    } catch (error) {
        console.error("Test failed:", error);
    }
}
