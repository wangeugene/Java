import { sendRequest } from "./sendRequest.js";

document.addEventListener("DOMContentLoaded", async function () {
    const sendRequestButton = document.getElementById("sendRequest");
    const errorElement = document.getElementById("error");
    const statusElement = document.getElementById("status");
    const responseElement = document.getElementById("response");

    async function handleRequest() {
        try {
            // Show loading state
            errorElement.style.display = "none";
            responseElement.textContent = "";
            statusElement.textContent = "Loading...";
            statusElement.style.color = "blue";

            const ipData = await sendRequest();

            // Hide loading and show response
            let ipInfoHTML = `<h3>Your IP: ${ipData.query}</h3>`;
            ipInfoHTML += `<div class="info-item"><strong>Location:</strong> ${ipData.city}, ${ipData.regionName}, ${ipData.country} (${ipData.countryCode})</div>`;
            ipInfoHTML += `<div class="info-item"><strong>ISP:</strong> ${ipData.isp}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>Organization:</strong> ${ipData.org}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>AS:</strong> ${ipData.as}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>Coordinates:</strong> ${ipData.lat}, ${ipData.lon}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>Timezone:</strong> ${ipData.timezone}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>ZIP:</strong> ${ipData.zip}</div>`;

            // Add the full raw JSON data in a collapsible section
            ipInfoHTML += `<div class="raw-data">
                <details>
                    <summary>Raw JSON Data</summary>
                    <pre>${JSON.stringify(ipData, null, 2)}</pre>
                </details>
            </div>`;

            responseElement.innerHTML = ipInfoHTML;
            statusElement.textContent = "Success";
            statusElement.style.color = "green";
        } catch (error) {
            // Handle error state
            errorElement.style.display = "block";
            errorElement.textContent = `Error: ${error.message}`;
            statusElement.textContent = "Error";
            statusElement.style.color = "red";
        }
    }

    // Initial request when popup opens
    handleRequest();

    // Handle refresh button click
    sendRequestButton.addEventListener("click", handleRequest);
});
