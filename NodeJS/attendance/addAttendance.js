import * as dotenv from "dotenv";
dotenv.config();

(async () => {
    const body = {
        maindata: {
            BreakFrom: "2025-04-07 09:00",
            BreakTo: "2025-04-07 10:00",
            Reason: "",
            PINCode: 143404,
            Duration: 1,
            DailyDetail: [
                {
                    DayTime: "2025-04-07T00:00:00",
                    LeaveHours: 1.0,
                    StartTime: "2025-04-07T09:00:00",
                    EndTime: "2025-04-07T10:00:00",
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
        body: JSON.stringify(body),
        method: "POST",
        mode: "cors",
        credentials: "include",
    });
    const responseBody = await response.json();
    console.log("Response:", responseBody);
})();
