import * as dotenv from "dotenv";
dotenv.config();

export default async function addAttendance(Date, ClockInTimeCutOffStart, ClockInTimeCutOffEnd, FinalExceptionHours) {
    const payload = {
        maindata: {
            BreakFrom: `${Date} ${ClockInTimeCutOffStart}`,
            BreakTo: `${Date} ${ClockInTimeCutOffEnd}`,
            Reason: "",
            PINCode: 143404,
            Duration: `${FinalExceptionHours}`,
            DailyDetail: [
                {
                    DayTime: `${Date}T00:00:00`,
                    LeaveHours: `${FinalExceptionHours}`,
                    StartTime: `${Date}T${ClockInTimeCutOffStart}`,
                    EndTime: `${Date}T${ClockInTimeCutOffEnd}`,
                },
            ],
        },
        Details: [
            {
                Table: "BlobAttachment",
                Data: [],
            },
        ],
    };
    console.log("Payload:", JSON.stringify(payload, null, 2));
    const response = await fetch(`${process.env.ADD_URL}`, {
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
        referrer: `${process.env.REFERRER_URL}`,
        referrerPolicy: "strict-origin-when-cross-origin",
        body: JSON.stringify(payload),
        method: "POST",
        mode: "cors",
        credentials: "include",
    });
    const responseBody = await response.json();
    console.log("Added Exception Response:", responseBody);
}

// addAttendance("2025-04-02", "09:00:00", "10:00:00")
//     .then(() => {
//         console.log("Attendance added successfully");
//     })
//     .catch((error) => {
//         console.error("Error adding attendance:", error);
//     });
