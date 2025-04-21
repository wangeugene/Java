import * as dotenv from "dotenv";

dotenv.config();

async function queryAttendance() {
    const payload = {
        page: 1,
        rows: 50,
        wheres: [
            { name: "Status", value: "10,30", DisplayType: "selectlist" },
            { name: "Date", value: "2025-04-01", DisplayType: "thanorequal" },
            { name: "Date", value: "2025-04-30", DisplayType: "lessorequal" },
        ],
        value: 1,
        sort: "Date",
        order: "desc",
    };
    const response = await fetch(`${process.env.GET_URL}`, {
        headers: {
            accept: "application/json, text/plain, */*",
            "accept-language": "en",
            agentemail: "",
            authorization: `Bearer ${process.env.ACCESS_TOKEN}`,
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
        const clockIn = new Date(`2025-04-10 ${item.ClockInTime}`);
        const nineAM = new Date(`2025-04-10 09:00:00`);

        const diffInMilliseconds = clockIn.getTime() - nineAM.getTime();
        const diffInHours = diffInMilliseconds / (1000 * 60 * 60);

        return {
            ...item,
            HoursFromNine: Math.round(diffInHours),
        };
    });

    console.log("Time Difference from 9AM:");
    console.log(JSON.stringify(timeDifference, null, 2));
}

queryAttendance().catch((error) => {
    console.error("Error:", error);
});
