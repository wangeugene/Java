import lookupIP from "./lookupIP.js";

export const sendRequest = async function () {
    try {
        // First get the user's IP address
        const ipResponse = await fetch("https://ifconfig.info", { method: "GET" });
        if (!ipResponse.ok) {
            throw new Error(`HTTP error! status: ${ipResponse.status}`);
        }
        const ipAddress = await ipResponse.text();

        // Then look up detailed information about that IP
        const ipData = await lookupIP(ipAddress.trim());

        if (!ipData) {
            throw new Error("Failed to retrieve IP information");
        }

        return ipData;
    } catch (error) {
        console.log("Error fetching data:", error);
        throw error;
    }
};
