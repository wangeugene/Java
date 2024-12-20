// cd the folder contains this file and node fileName to execute
// this file uses just Plain NodeJS, no dependencies required
const { execSync } = require('child_process'); // Import child_process for executing system commands

const value = "test_value";
const authToken = {
    "Authorization": `Principal-JWT=${value}`
}
// Convert the object to a JSON string
const clipboardContent = JSON.stringify(authToken);

// Use pbcopy to copy the content to the system clipboard
execSync(`echo '${clipboardContent}' | pbcopy`);

console.log("Authorization token copied to clipboard!");