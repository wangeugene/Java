const fs = require("fs");
const path = require("path");

// To fix Error: unable to get local issuer certificate
// Node.js 18+
// Error: unable to get local issuer certificate
// To see above error, run the following command:
// node skip_ca_check_http_request.js
// To run this code, copy & paste the following line in your terminal:
// NODE_TLS_REJECT_UNAUTHORIZED=0 node skip_ca_check_http_request_with_cli_arg.js

// Read secrets.json file from the same directory
const secretsPath = path.join(__dirname, "secrets.json");
const secrets = JSON.parse(fs.readFileSync(secretsPath, "utf8"));
const URL = secrets.URL;
async function getSiteJwt() {
    const resp = await fetch(`${URL}`);
    if (resp.status != 200) {
        throw new Error(`Failed to get site jwt: ${resp.status}`);
    }
    const json = await resp.json();
    console.log(json);
}

getSiteJwt();
