document.addEventListener("DOMContentLoaded", function () {
    // Get references to DOM elements
    const timestampInput = document.getElementById("timestamp");
    const convertButton = document.getElementById("convert");
    const errorDiv = document.getElementById("error");
    const resultDiv = document.getElementById("result");
    const utc0Div = document.getElementById("utc0");
    const utc8Div = document.getElementById("utc8");
    const localDiv = document.getElementById("local");

    //format the argument date to be like this 2023-10-01T12:00:00
    function formatDate(date) {
        return date.toISOString().slice(0, 19);
    }

    // Auto-fill with current timestamp
    timestampInput.value = Math.floor(Date.now() / 1000);

    // Convert timestamp when button is clicked
    convertButton.addEventListener("click", function () {
        // Get the timestamp value
        const timestampValue = timestampInput.value.trim();

        // Validate input
        if (!timestampValue || isNaN(Number(timestampValue))) {
            errorDiv.style.display = "block";
            resultDiv.style.display = "none";
            return;
        }

        // Hide error message and show results
        errorDiv.style.display = "none";
        resultDiv.style.display = "block";

        // Parse the timestamp
        let timestamp = parseInt(timestampValue);

        // Handle milliseconds if needed (convert to seconds)
        if (timestamp > 100000000000) {
            timestamp = Math.floor(timestamp / 1000);
        }

        // Create date for UTC+0
        const utc0Date = new Date(timestamp * 1000);

        // Create date for UTC+8
        const utc8Date = new Date(utc0Date);
        utc8Date.setTime(utc0Date.getTime() + 8 * 60 * 60 * 1000); // Add 8 hours

        // Display the formatted dates
        utc0Div.textContent = formatDate(utc0Date);
        utc8Div.textContent = formatDate(utc8Date);
    });

    // Trigger conversion on page load
    convertButton.click();

    // Allow Enter key to trigger conversion
    timestampInput.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            convertButton.click();
        }
    });
});
