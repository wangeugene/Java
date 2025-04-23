export default async function lookupIP(ip) {
    try {
        let response;
        let retries = 3;
        console.log("IP Address:", ip);
        while (retries > 0) {
            response = await fetch(`http://ip-api.com/json/${ip}`, {
                headers: {
                    accept: "application/json",
                    "cache-control": "no-cache",
                    pragma: "no-cache",
                },
                method: "GET",
                mode: "cors",
                credentials: "omit",
            });
            if (response.ok || response.status !== 429) break;
            retries--;
            console.log("Rate limit hit, retrying...");
            await new Promise((resolve) => setTimeout(resolve, 2000)); // Wait 2 seconds before retrying
        }
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json(); // ← Correct way to parse response body
        console.log("Response Data:", data);
        return data;
    } catch (error) {
        console.log("Error fetching data:", error);
    }
}

lookupIP("117.168.151.122");
