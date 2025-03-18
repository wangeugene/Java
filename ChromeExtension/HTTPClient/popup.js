import { sendRequest } from './send_request.js';

document.addEventListener('DOMContentLoaded', async function () {
    const sendRequestButton = document.getElementById('sendRequest');
    const responseElement = document.getElementById('response');
    const loadingElement = document.getElementById('loading');
    const errorElement = document.getElementById('error');
    const statusElement = document.getElementById('status');

    async function handleRequest() {
        try {
            // Show loading state
            loadingElement.style.display = 'block';
            errorElement.style.display = 'none';
            responseElement.textContent = '';
            statusElement.textContent = 'Loading...';
            statusElement.style.color = 'blue';

            const response = await sendRequest();
            
            // Hide loading and show response
            loadingElement.style.display = 'none';
            responseElement.textContent = JSON.stringify(response, null, 2);
            statusElement.textContent = 'Success';
            statusElement.style.color = 'green';
        } catch (error) {
            // Handle error state
            loadingElement.style.display = 'none';
            errorElement.style.display = 'block';
            errorElement.textContent = `Error: ${error.message}`;
            statusElement.textContent = 'Error';
            statusElement.style.color = 'red';
        }
    }

    // Initial request when popup opens
    handleRequest();

    // Handle refresh button click
    sendRequestButton.addEventListener('click', handleRequest);
});

