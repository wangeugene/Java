import { sendRequest } from "./sendRequest.js";
import lookupIP from "./lookupIP.js";

document.addEventListener("DOMContentLoaded", async function () {
    const sendRequestButton = document.getElementById("sendRequest");
    const errorElement = document.getElementById("error");
    const statusElement = document.getElementById("status");
    const responseElement = document.getElementById("response");
    const ipInputElement = document.getElementById("ipInput");

    let userPublicIP = "";

    // Function to get user's public IP and prefill the input field
    async function getUserPublicIP() {
        try {
            errorElement.style.display = "none";
            statusElement.textContent = "Getting your IP...";
            statusElement.style.color = "blue";

            // Get the user's public IP from ifconfig.info
            const ipResponse = await fetch("https://ifconfig.info", { method: "GET" });
            if (!ipResponse.ok) {
                throw new Error(`HTTP error! status: ${ipResponse.status}`);
            }
            userPublicIP = await ipResponse.text();
            userPublicIP = userPublicIP.trim();

            // Pre-fill the input field with the user's public IP
            ipInputElement.value = userPublicIP;

            // Automatically look up the user's IP on initial load
            await lookupIPAddress(userPublicIP);
        } catch (error) {
            errorElement.style.display = "block";
            errorElement.textContent = `Error getting your IP: ${error.message}`;
            statusElement.textContent = "Error";
            statusElement.style.color = "red";
        }
    }

    // Function to handle looking up an IP address
    async function lookupIPAddress(ipAddress) {
        try {
            // Show loading state
            errorElement.style.display = "none";
            responseElement.textContent = "";
            statusElement.textContent = "Looking up IP information...";
            statusElement.style.color = "blue";

            // Use the lookupIP function directly with the provided IP
            const ipData = await lookupIP(ipAddress);

            if (!ipData) {
                throw new Error("Failed to retrieve IP information");
            }

            // Display the IP information
            let ipInfoHTML = `<h3>IP: ${ipData.query}</h3>`;
            ipInfoHTML += `<div class="info-item"><strong>Location:</strong> ${ipData.city}, ${ipData.regionName}, ${ipData.country} (${ipData.countryCode})</div>`;
            ipInfoHTML += `<div class="info-item"><strong>ISP:</strong> ${ipData.isp}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>Organization:</strong> ${ipData.org}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>AS:</strong> ${ipData.as}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>Coordinates:</strong> ${ipData.lat}, ${ipData.lon}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>Timezone:</strong> ${ipData.timezone}</div>`;
            ipInfoHTML += `<div class="info-item"><strong>ZIP:</strong> ${ipData.zip}</div>`;

            // Add a note if this is the user's own IP
            if (ipAddress === userPublicIP) {
                ipInfoHTML += `<div class="info-item" style="color: #27ae60; font-weight: bold;">This is your current public IP address</div>`;
            }

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

    // Get the user's IP and prefill the input on initial load
    await getUserPublicIP();

    // Add event listener for the lookup button
    sendRequestButton.addEventListener("click", async () => {
        const ipToLookup = ipInputElement.value.trim();

        // Validate the IP address (simple validation)
        if (!ipToLookup) {
            errorElement.style.display = "block";
            errorElement.textContent = "Please enter an IP address";
            return;
        }

        await lookupIPAddress(ipToLookup);
    });

    // Add event listener for Enter key in the input field
    ipInputElement.addEventListener("keyup", async (event) => {
        if (event.key === "Enter") {
            const ipToLookup = ipInputElement.value.trim();

            if (!ipToLookup) {
                errorElement.style.display = "block";
                errorElement.textContent = "Please enter an IP address";
                return;
            }

            await lookupIPAddress(ipToLookup);
        }
    });
});
