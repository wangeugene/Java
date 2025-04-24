// Background script to intercept network requests and store the authorization header
// First, load the base URL from secrets.json
let baseUrl = ""; // Default value

// Load the secrets file when the extension initializes
fetch(chrome.runtime.getURL("secrets.json"))
    .then((response) => response.json())
    .then((secrets) => {
        baseUrl = secrets.BASE_URL;
        console.log("Loaded base URL from secrets.json:", baseUrl);

        // Register the listener after we have the baseUrl from secrets
        setupWebRequestListener(baseUrl);
    })
    .catch((error) => {
        console.error("Error loading secrets.json:", error);
        // Use the default value if secrets.json can't be loaded
        setupWebRequestListener(baseUrl);
    });

function setupWebRequestListener(url) {
    chrome.webRequest.onSendHeaders.addListener(
        function (details) {
            if (details.requestHeaders) {
                const authHeader = details.requestHeaders.find(
                    (header) => header.name.toLowerCase() === "authorization"
                );

                if (authHeader && authHeader.value) {
                    // Store the token in Chrome storage
                    chrome.storage.local.set({
                        authToken: authHeader.value,
                        timestamp: new Date().toISOString(),
                    });
                }
            }
        },
        { urls: [`${url}/*`] },
        ["requestHeaders"]
    );
}
