import * as dotenv from "dotenv";
import addAttendance from "./addAttendance.js";

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
    // for (const item of timeDifference) {
    //     const { Date, ClockInTimeCutOffStart, ClockInTimeCutOffEnd } = item;
    //     console.log(Date, ClockInTimeCutOffStart, ClockInTimeCutOffEnd);
    //     await addAttendance(Date, ClockInTimeCutOffStart, ClockInTimeCutOffEnd);
    // }
}

queryAttendance().catch((error) => {
    console.error("Error:", error);
});
