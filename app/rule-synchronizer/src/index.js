import "dotenv/config";
import { readConfigFromURL } from "./configURLReader.js";
import { extractProxySection } from "./proxySection.js";
import { SURGE_CONFIG_FILE } from "./paths.js";
import fs from "fs/promises";

const URL = process.env.SURGE_CONFIG_URL;
if (!URL || URL.trim() === "") {
    throw new Error(
        "Missing SURGE_CONFIG_URL. Set it in your environment or a local .env file (do not commit secrets)."
    );
}

const INTERVAL_MINUTES = Number.parseInt(process.env.INTERVAL_MINUTES ?? "5", 10);
const RUN_MODE = (process.env.RUN_MODE ?? "schedule").toLowerCase();

// Avoid overlapping runs if one execution takes longer than the interval.
let isRunning = false;

async function runOnce() {
    if (isRunning) {
        console.log("Previous run still in progress; skipping this tick.");
        return;
    }
    isRunning = true;
    try {
        const response = await readConfigFromURL(URL);

        const proxySection = extractProxySection(response);

        // remove the second line of the proxy section
        const proxyLines = proxySection.split("\n");
        if (proxyLines.length > 2) {
            proxyLines.splice(1, 1); // remove the second line
        }
        const modifiedProxySection = proxyLines.join("\n");

        const fileContent = await fs.readFile(SURGE_CONFIG_FILE, "utf-8");

        const currentProxySection = extractProxySection(fileContent);

        // replace the current proxy section with the modified one
        const updatedConfig = fileContent.replace(currentProxySection, modifiedProxySection);

        // write back to the SURGE_CONFIG_FILE
        await fs.writeFile(SURGE_CONFIG_FILE, updatedConfig, "utf-8");
        console.log("SURGE_CONFIG_FILE has been updated.");
    } catch (err) {
        console.error("Run failed:", err);
        process.exitCode = 1;
    } finally {
        isRunning = false;
    }
}

function startScheduler() {
    const ms = Math.max(1, INTERVAL_MINUTES) * 60_000;
    console.log(`Scheduler started: every ${INTERVAL_MINUTES} minute(s).`);

    // Run immediately on startup, then on the interval.
    void runOnce();
    const timer = setInterval(() => void runOnce(), ms);

    // Allow the process to exit cleanly on SIGINT/SIGTERM.
    const shutdown = () => {
        console.log("Shutting down scheduler...");
        clearInterval(timer);
    };
    process.on("SIGINT", shutdown);
    process.on("SIGTERM", shutdown);
}

if (RUN_MODE === "once") {
    await runOnce();
} else {
    startScheduler();
}
