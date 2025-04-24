const getDetails = async (hitchIdArg: { hitchId: string }) => {
    const bodyURLEncoded = `data=${encodeURIComponent(JSON.stringify(hitchIdArg))}`;
    try {
        await new Promise((resolve) => setTimeout(resolve, 1000)); // wait for 1 second
        const response = await fetch("https://m.zuche.com/api/gw.do?uri=/action/carrctapi/order/hitchDetail/v1", {
            headers: {
                accept: "application/json, text/plain, */*",
                "accept-language": "en",
                "cache-control": "no-cache",
                "content-type": "application/x-www-form-urlencoded",
                pragma: "no-cache",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-origin",
            },
            referrer: "https://m.zuche.com/",
            referrerPolicy: "strict-origin-when-cross-origin",
            body: bodyURLEncoded,
            method: "POST",
            mode: "cors",
            credentials: "include",
        });
        const data = await response.json();
        if (!data) {
            throw new Error("No data received");
        }
        const content = data.content;
        if (!content) {
            throw new Error("No content in response data");
        }

        if (!content.pickupDept?.deptName) {
            throw new Error("No pickup deptName found");
        }

        // Transform the data into the desired return format
        const transformedData = {
            pickupDeptName: content.pickupDept.deptName,
            pickupWorkTime: content.pickupDept.workTime,
            pickupCityName: content.pickupCityName,
            estTotalPrice: content.estTotalPrice,
            modelName: content.modelName,
            modelDesc: content.modelDesc,
            returnCityName: content.returnCityName,
            returnDeptName: content.returnDept?.deptName,
        };
        // console.log("Transformed Data:", transformedData);
        return transformedData;
    } catch (error) {
        console.error("Error fetching or parsing data:", error);
    }
};

// pnpm run getDetails
// getDetails({ hitchId: "8069767" });
export default getDetails;
