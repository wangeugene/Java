const fs = require("fs");
const path = require("path");
const os = require("os");

const npmrcPath = path.join(os.homedir(), ".npmrc");
fs.appendFileSync(npmrcPath, "\npackage-lock=false\n");

// Read and print the ~/.npmrc contents (or report if not present)
if (fs.existsSync(npmrcPath)) {
    const content = fs.readFileSync(npmrcPath, "utf8");
    console.log(`~/.npmrc path: ${npmrcPath}`);
    console.log("--- ~/.npmrc content ---");
    console.log(content);
} else {
    console.log(`No ~/.npmrc found at ${npmrcPath}`);
}

// The following one-liner does the same thing:
// node -e "fs.appendFileSync(path.join(os.homedir(), '.npmrc'), '\npackage-lock=false\n')"
