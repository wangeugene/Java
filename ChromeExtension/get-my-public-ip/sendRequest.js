export const sendRequest = async function () {
    try {
        const response = await fetch("https://ifconfig.info", { method: "GET" });
        const headers = {};
        for (const [key, value] of response.headers.entries()) {
            headers[key] = value;
        }
        console.log("Response Headers (as object):", headers);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.text(); // ← Correct way to parse response body
        console.log("Response Data:", data);
        return data;
    } catch (error) {
        console.log("Error fetching data:", error);
    }
};
