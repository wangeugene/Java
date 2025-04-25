document.addEventListener("DOMContentLoaded", function () {
    // Get references to DOM elements
    const timestampInput = document.getElementById("timestamp");
    const convertButton = document.getElementById("convert");
    const timezoneInput = document.getElementById("custom-timezone");
    const saveTimezoneButton = document.getElementById("save-timezone");
    const errorDiv = document.getElementById("error");
    const resultDiv = document.getElementById("result");
    const utc0Div = document.getElementById("utc0");
    const utc8Div = document.getElementById("utc8");
    const customTimeDiv = document.getElementById("custom-time");

    let userTimezone = "+8"; // Default timezone

    // Load saved timezone from Chrome storage
    chrome.storage.sync.get(["userTimezone"], function (result) {
        if (result.userTimezone) {
            userTimezone = result.userTimezone;
            timezoneInput.value = userTimezone;
        } else {
            timezoneInput.value = userTimezone;
        }
        // Initial conversion with loaded timezone
        convertButton.click();
    });

    // Save timezone to Chrome storage
    saveTimezoneButton.addEventListener("click", function () {
        const newTimezone = timezoneInput.value.trim();

        // Validate timezone format
        if (!/^[+-]\d{1,2}(.\d{1,2})?$/.test(newTimezone)) {
            alert("Please enter a valid timezone in format +8 or -7.5");
            return;
        }

        userTimezone = newTimezone;
        chrome.storage.sync.set({ userTimezone: newTimezone }, function () {
            // Show visual confirmation
            saveTimezoneButton.textContent = "Saved!";
            setTimeout(() => {
                saveTimezoneButton.textContent = "Save";
            }, 1500);

            // Update conversion with new timezone
            convertButton.click();
        });
    });

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

        // Create date for custom timezone
        const customDate = new Date(utc0Date);
        const offsetHours = parseFloat(userTimezone);
        customDate.setTime(utc0Date.getTime() + offsetHours * 60 * 60 * 1000);

        // Update timezone display text
        const timezoneLabel = document.querySelector(".custom-timezone");
        timezoneLabel.textContent = `Your Timezone (UTC${userTimezone}):`;

        // Display the formatted dates
        utc0Div.textContent = formatDate(utc0Date);
        customTimeDiv.textContent = formatDate(customDate);
    });

    // Trigger conversion on page load
    // This is now handled after loading the timezone preference

    // Allow Enter key to trigger conversion
    timestampInput.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            convertButton.click();
        }
    });

    // Allow Enter key to save timezone
    timezoneInput.addEventListener("keypress", function (e) {
        if (e.key === "Enter") {
            saveTimezoneButton.click();
        }
    });
});
