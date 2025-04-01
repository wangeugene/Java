import pino from "pino"; // "allowSyntheticDefaultImports": true in tsconfig.json is a must
import { join } from "path";
import { fileURLToPath } from "url";
import { dirname } from "path";
// Determine the current directory
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Define the log file path
const logFilePath = join(__dirname, "app.log");

const transport = pino.transport({
    targets: [
        {
            target: "pino/file",
            options: { destination: logFilePath },
        },
    ],
});

// Create the logger instance
const logger = pino(
    {
        level: process.env.LOG_LEVEL || "info",
    },
    transport
);

export default logger;
