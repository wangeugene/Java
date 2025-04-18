const sendRequest = async function () {
    try {
        const response = await fetch("https://ifconfig.info", { method: "GET", credentials: "omit" });

        console.log("Response Headers:", response.headers);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.body();
        console.log("Response Data:", data);
        // ipDisplay.textContent = `Your IP address is: ${data.ip}`; // Fixed typo from textContext to textContent
    } catch (error) {
        console.log("Error fetching data:", error); // Added error details to the log
    }
};

sendRequest();
