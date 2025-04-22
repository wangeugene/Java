const fs = require("fs");
const path = require("path");

// To resolve above error, run the following command:
//  node skip_ca_check_http_request_with_env_var.js
// (it works too)

// Read secrets.json file from the same directory
const secretsPath = path.join(__dirname, "secrets.json");
const secrets = JSON.parse(fs.readFileSync(secretsPath, "utf8"));
const URL = secrets.URL;
async function getSiteJwt() {
    // Set environment variable to disable certificate validation
    process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

    const resp = await fetch(`${URL}`);

    if (resp.status != 200) {
        throw new Error(`Failed to get site jwt: ${resp.status}`);
    }
    const json = await resp.json();
    console.log(json);
}

getSiteJwt();
