import { writeFile } from 'fs/promises';

// Create an HTTP client function for the Zuche API
// pickupCityId: "231" = 惠州 (Huizhou) pickupCityId: "15" = 深圳 (Shenzhen)
async function fetchHitchList(pageNo = 1, pageSize = 10) {
    const url = 'https://m.zuche.com/api/gw.do?uri=/action/carrctapi/order/hitchList/v1';
    const requestBody = {
        pickupCityId: "231",
        returnCityId: "",
        useCarTime: "",
        pageNo: pageNo,
        pageSize: pageSize,
        source: 2
    };

    const encodedData = `data=${encodeURIComponent(JSON.stringify(requestBody))}`;

    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Accept': 'application/json, text/plain, */*',
                'Accept-Language': 'en',
                'Content-Type': 'application/x-www-form-urlencoded',
                'Referer': 'https://m.zuche.com/',
                'Cookie': 'lctuid=4509213c792233e1c4917b22539515fa; CAR_UID=7ff48ce4-6a13-4bf5-ac0f-62ba846d784e1742208766650; intranet-sessionid=677ccee5-50ab-4696-8f71-58974b7076c8'
            },
            body: encodedData
        });

        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching hitch list:', error);
        throw error;
    }
}

// Test function to trigger the request and save results
async function testHitchListApi() {
    try {
        console.log('Fetching hitch list data...');
        const result = await fetchHitchList();

        // Format the JSON with proper Unicode character representation
        // const formattedResult = JSON.stringify(result, null, 2);
        // console.log('Response received:');
        // console.log(formattedResult);

        // Save the response to a file for analysis
        // await writeFile('hitchlist_response.json', formattedResult, 'utf8');
        // console.log('Response saved to hitchlist_response.json');

        // Extract and display specific data if the response was successful
        if (result.status === 'SUCCESS' && result.content && result.content.hitchList) {
            console.log('\nAvailable hitch rides:');
            result.content.hitchList.forEach((ride, index) => {
                console.log(`\n[${index + 1}] ${ride.modelName}`);
                console.log(`  From: ${ride.pickupCityName} → To: ${ride.returnCityName}`);
                console.log(`  Date: ${ride.beginTime} - ${ride.endTime}`);
                console.log(`  Price: ${ride.realTotalPrice}`);
            });
        }
    } catch (error) {
        console.error('Test failed:', error);
    }
}

// Run the test
testHitchListApi();