// Popup script to display authorization token
import { queryAttendance } from "./worker/queryAttendence.js";

document.addEventListener("DOMContentLoaded", function () {
    // Get DOM elements
    const authTokenTextarea = document.getElementById("auth-token");
    const statusMessage = document.getElementById("status-message");
    const timestampElement = document.getElementById("timestamp");
    const copyButton = document.getElementById("copy-button");
    const refreshButton = document.getElementById("refresh-button");
    const fillExceptionsButton = document.getElementById("fill-exceptions-button");
    const actionStatus = document.getElementById("action-status");

    // Function to update the UI with token information
    function updateTokenDisplay() {
        chrome.storage.local.get(["authToken", "timestamp"], function (data) {
            if (data.authToken) {
                // Extract the actual token from the Authorization header
                // Assuming format is "Bearer <token>"
                const tokenMatch = data.authToken.match(/Bearer\s+(.+)/i);
                const token = tokenMatch ? tokenMatch[1] : data.authToken;

                // Update UI elements
                authTokenTextarea.value = token;
                statusMessage.textContent = "Token found!";
                statusMessage.style.color = "#4caf50";

                // Format and display timestamp
                if (data.timestamp) {
                    const timestamp = new Date(data.timestamp);
                    const formattedTime = timestamp.toLocaleString();
                    timestampElement.textContent = `Last updated: ${formattedTime}`;
                }
            } else {
                // No token found
                authTokenTextarea.value = "";
                statusMessage.textContent = "No token found. Please visit attendance.centific.com.cn first.";
                statusMessage.style.color = "#f44336";
                timestampElement.textContent = "";
            }
        });
    }

    // Initial update
    updateTokenDisplay();

    // Copy button functionality
    copyButton.addEventListener("click", function () {
        if (authTokenTextarea.value) {
            authTokenTextarea.select();
            document.execCommand("copy");

            // Visual feedback
            const originalText = copyButton.textContent;
            copyButton.textContent = "Copied!";
            setTimeout(() => {
                copyButton.textContent = originalText;
            }, 1500);
        }
    });

    // Refresh button functionality
    refreshButton.addEventListener("click", function () {
        updateTokenDisplay();

        // Visual feedback
        const originalText = refreshButton.textContent;
        refreshButton.textContent = "Refreshed!";
        setTimeout(() => {
            refreshButton.textContent = originalText;
        }, 1500);
    });

    // Fill Exceptions button functionality
    fillExceptionsButton.addEventListener("click", async function () {
        try {
            // Update UI to show processing state
            actionStatus.textContent = "Processing attendance exceptions...";
            actionStatus.style.color = "#4285f4";
            fillExceptionsButton.disabled = true;

            // Call the queryAttendance function
            await queryAttendance();

            // Update UI to show success
            actionStatus.textContent = "Successfully filled attendance exceptions!";
            actionStatus.style.color = "#34a853";
        } catch (error) {
            // Update UI to show error
            console.error("Error filling exceptions:", error);
            actionStatus.textContent = `Error: ${error.message}`;
            actionStatus.style.color = "#ea4335";
        } finally {
            // Re-enable the button
            fillExceptionsButton.disabled = false;
        }
    });
});
