export const sendRequest = async function() {
    const requestBody = {
        pickupCityId: "15",
        returnCityId: "",
        useCarTime: "",
        pageNo: 1,
        pageSize: 10,
        source: 2
    };

    const encodedData = `data=${encodeURIComponent(JSON.stringify(requestBody))}`;

    try {
        const response = await fetch("https://m.zuche.com/api/gw.do?uri=/action/carrctapi/order/hitchList/v1", {
            method: "POST",
            headers: {
                'Accept': 'application/json, text/plain, */*',
                'Accept-Language': 'en',
                'Content-Type': 'application/x-www-form-urlencoded',
                'Referer': 'https://m.zuche.com/',
                'Cookie': 'lctuid=4509213c792233e1c4917b22539515fa; CAR_UID=7ff48ce4-6a13-4bf5-ac0f-62ba846d784e1742208766650; intranet-sessionid=677ccee5-50ab-4696-8f71-58974b7076c8'
            },
            body: encodedData,
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        //How to print the data in a readable format?
        console.log(JSON.stringify(data, null, 2));
        return data;
    } catch (error) {
        console.error('Error:', error);
        throw error;
    }
}

// How do I run this file via nodeJS?
// 1. Remove the export keyword from the function declaration
// 2. Run: node send_request.js , it can fetch the data from the API correctly
// sendRequest();
// but when I run it in the browser, it can't fetch the data from the API, showed request origin is not allowed
// How to fix this?
// I need to run it in the browser, and it can fetch the data from the API correctly
// Please help me to fix this, thank you!