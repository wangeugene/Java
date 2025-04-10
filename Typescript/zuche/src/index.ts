import { schedule } from "node-cron";
import { extractHitchList } from "./zuche.js";
import logger from "./logger.js";
import dotenv from "dotenv";
dotenv.config();
import { createEmailService } from "./email.js";

const emailService = createEmailService(
    process.env.SMTP_HOST!,
    parseInt(process.env.SMTP_PORT!),
    process.env.EMAIL_USER!,
    process.env.EMAIL_PASS!,
    true
);

const pickupCityId = parseInt(process.argv[2] || "231");
const returnCityId = parseInt(process.argv[3] || "15");

// Schedule the cron job
const cronJob = schedule("0 */10 8-22 * * *", () => {
    const date = new Date();
    logger.info(`Cron job assigned at: ${date.toLocaleString()}`);

    // Fetch the hitch list
    extractHitchList(pickupCityId, returnCityId).then((hitchList) => {
        logger.info(`Querying pickup city ID: ${pickupCityId} and returnCityId: ${returnCityId}`);
        logger.info(`Array.isArray(hitchList): ${Array.isArray(hitchList)}, hitchList: ${hitchList}`);
        if (Array.isArray(hitchList)) {
            console.log(`hitchList.length: ${hitchList.length}`);
            emailService
                .sendEmail({
                    to: process.env.EMAIL_RECIPIENT!,
                    subject: "Hitch List Notification",
                    text: `Hitch list: ${JSON.stringify(hitchList)}`,
                })
                .then((emailResponse) => {
                    logger.info(`Email sent successfully: ${JSON.stringify(emailResponse)}`);
                })
                .catch((error) => {
                    logger.error(`Failed to send email: ${error.message}`, error);
                });
        } else {
            logger.error("No hitch found.");
        }
    });
});

// Immediately run the cron job once when the app starts
cronJob.start();

// Function to gracefully stop the cron job
function stopCronJob() {
    console.log("Stopping cron job...");
    cronJob.stop();
    console.log("Cron job stopped.");
}

// Handle shutdown signals
process.on("SIGINT", () => {
    stopCronJob();
    process.exit(0);
});

process.on("SIGTERM", () => {
    stopCronJob();
    process.exit(0);
});

setInterval(() => {}, 1000); // Keep process alive
