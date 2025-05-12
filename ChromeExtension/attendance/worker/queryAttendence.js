import addAttendance from "./addAttendance.js";

// Export the queryAttendance function so it can be imported in popup.js
export async function queryAttendance() {
    // Get access token from Chrome storage
    const tokenData = await new Promise((resolve) => {
        chrome.storage.local.get(["authToken"], (result) => {
            resolve(result);
        });
    });

    // Extract the token from the Authorization header value (assuming "Bearer" format)
    let accessToken = "";
    if (tokenData.authToken) {
        const tokenMatch = tokenData.authToken.match(/Bearer\s+(.+)/i);
        accessToken = tokenMatch ? tokenMatch[1] : tokenData.authToken;
    }

    if (!accessToken) {
        throw new Error("No access token found. Please visit attendance.centific.com.cn first.");
    }

    // Get the extension's root URL for secrets.json
    const extensionURL = chrome.runtime.getURL("secrets.json");

    // Fetch the secrets.json file
    const secretsResponse = await fetch(extensionURL);
    const secrets = await secretsResponse.json();

    const startOfMonth = new Date(new Date().getFullYear(), new Date().getMonth(), 1).toLocaleDateString('en-CA')
    const endOfMonth = new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0).toLocaleDateString('en-CA');

    const payload = {
        page: 1,
        rows: 50,
        wheres: [
            { name: "Status", value: "10,30", DisplayType: "selectlist" },
            { name: "Date", value: startOfMonth, DisplayType: "thanorequal" },
            { name: "Date", value: endOfMonth, DisplayType: "lessorequal" },
        ],
        value: 1,
        sort: "Date",
        order: "desc",
    };
    const response = await fetch(`${secrets.GET_URL}`, {
        headers: {
            accept: "application/json, text/plain, */*",
            "accept-language": "en",
            agentemail: "",
            authorization: `Bearer ${accessToken}`,
            "cache-control": "no-cache",
            "content-type": "application/json",
            lang: "en",
            pragma: "no-cache",
            "sec-ch-ua": '"Google Chrome";v="135", "Not-A.Brand";v="8", "Chromium";v="135"',
            "sec-ch-ua-mobile": "?1",
            "sec-ch-ua-platform": '"Android"',
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin",
            serviceid: "null",
            testemail: "",
            testemailpassword: "",
            timezoneoffset: "8",
        },
        referrerPolicy: "strict-origin-when-cross-origin",
        body: '{"page":1,"rows":50,"wheres":"[{\\"name\\":\\"Status\\",\\"value\\":\\"10,30\\",\\"DisplayType\\":\\"selectlist\\"},{\\"name\\":\\"Date\\",\\"value\\":\\"2025-04-01\\",\\"DisplayType\\":\\"thanorequal\\"},{\\"name\\":\\"Date\\",\\"value\\":\\"2025-04-30\\",\\"DisplayType\\":\\"lessorequal\\"}]","value":1,"sort":"Date","order":"desc"}',
        // body: JSON.stringify(payload), //TODO fix this
        method: "POST",
        mode: "cors",
        credentials: "include",
    });

    console.log("Payload:", JSON.stringify(payload, null, 2));
    if (response.status !== 200) {
        console.error("Non-200 response:", response.status);
        const errorText = await response.text(); // To inspect the response body
        console.error("Response body:", errorText);
        throw new Error(`HTTP error! status: ${response.status}`);
    }
    const responseObj = await response.json();
    const data = responseObj.data;
    const filteredData = data.rows
        .filter((item) => item.Status < 30)
        .map((item) => {
            return {
                ID: item.ID,
                Date: item.Date,
                ClockInTime: item.ClockInTime,
                ClockOutTime: item.ClockOutTime,
                FinalExceptionHours: item.FinalExceptionHours,
                Status: item.Status,
            };
        });

    const timeDifference = filteredData.map((item) => {
        if (item.ClockInTime === item.ClockOutTime) {
            return {
                ...item,
                ClockInTimeCutOffStart: "09:00",
                ClockInTimeCutOffEnd: "18:00",
            };
        } else {
            const [hours, minutes] = item.ClockInTime.split(":").map(Number);
            const totalMinutes = hours * 60 + minutes;
            const roundedMinutes = Math.ceil(totalMinutes / 30) * 30;
            const roundedHours = Math.floor(roundedMinutes / 60) % 24;
            const roundedMinute = roundedMinutes % 60;

            const roundedClockInTime = `${String(roundedHours).padStart(2, "0")}:${String(roundedMinute).padStart(
                2,
                "0"
            )}`;
            return {
                ...item,
                ClockInTimeCutOffStart: "09:00",
                ClockInTimeCutOffEnd: roundedClockInTime,
            };
        }
    });

    console.log(JSON.stringify(timeDifference, null, 2));
    for (const item of timeDifference) {
        const { Date, ClockInTimeCutOffStart, ClockInTimeCutOffEnd, FinalExceptionHours } = item;
        console.log(Date, ClockInTimeCutOffStart, ClockInTimeCutOffEnd);
        await addAttendance(Date, ClockInTimeCutOffStart, ClockInTimeCutOffEnd, FinalExceptionHours, accessToken);
    }
}

// Keep the direct execution for testing, but now the function can also be imported
queryAttendance().catch((error) => {
    console.error("Error:", error);
});
