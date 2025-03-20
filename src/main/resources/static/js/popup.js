// Get the current tab's URL
chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
    const currentUrl = tabs[0].url;
    console.log('Current URL:', currentUrl);
    
    // Send message to background script
    chrome.runtime.sendMessage({
        action: "getResponse",
        url: currentUrl
    }, function(response) {
        if (response && response.success) {
            // Update the UI with the response
            document.getElementById('response').textContent = response.data;
            document.getElementById('status').textContent = 'Success';
            document.getElementById('status').style.color = 'green';
        } else {
            // Handle error case
            document.getElementById('response').textContent = response?.error || 'Failed to get response';
            document.getElementById('status').textContent = 'Error';
            document.getElementById('status').style.color = 'red';
        }
    });
});

// Add event listener for the refresh button
document.getElementById('refreshButton').addEventListener('click', function() {
    // Get the current tab's URL again
    chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
        const currentUrl = tabs[0].url;
        
        // Update status to show loading
        document.getElementById('status').textContent = 'Loading...';
        document.getElementById('status').style.color = 'blue';
        
        // Send message to background script
        chrome.runtime.sendMessage({
            action: "getResponse",
            url: currentUrl
        }, function(response) {
            if (response && response.success) {
                // Update the UI with the response
                document.getElementById('response').textContent = response.data;
                document.getElementById('status').textContent = 'Success';
                document.getElementById('status').style.color = 'green';
            } else {
                // Handle error case
                document.getElementById('response').textContent = response?.error || 'Failed to get response';
                document.getElementById('status').textContent = 'Error';
                document.getElementById('status').style.color = 'red';
            }
        });
    });
}); 