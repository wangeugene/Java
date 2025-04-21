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

            const response = await sendRequest();

            // Hide loading and show response
            responseElement.textContent = `Your IP address is: ${response}`;
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
