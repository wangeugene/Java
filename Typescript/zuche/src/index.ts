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
const cronJob = schedule("0 */10 9-18 * * *", () => {
    const date = new Date();
    logger.info(`Cron job assigned at: ${date.toLocaleString()}`);
    console.log(`docker log <container_name> to view this log: Email recipient: ${process.env.EMAIL_RECIPIENT!}`);

    // Fetch the hitch list
    extractHitchList(pickupCityId, returnCityId).then((hitchList) => {
        logger.info(`Querying pickup city ID: ${pickupCityId} and returnCityId: ${returnCityId}`);
        if (Array.isArray(hitchList) && hitchList.length > 0) {
            console.log("docker log <container_name> -> Hitch list fetched successfully:", hitchList);
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
            logger.info("No hitch found.");
        }
    });
});

// Start the cron job
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
