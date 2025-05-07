import { schedule } from "node-cron";
import { extractHitchList } from "./zuche.js";
import logger from "./logger.js";
import dotenv from "dotenv";
dotenv.config();
import { createEmailService } from "./email.js";
import getDetails from "./getDetails.js";

const emailService = createEmailService(
    process.env.SMTP_HOST!,
    parseInt(process.env.SMTP_PORT!),
    process.env.EMAIL_USER!,
    process.env.EMAIL_PASS!,
    true
);

const pickupCityId = parseInt(process.argv[2] || "15");
const returnCityId = parseInt(process.argv[3] || "231");
console.log(`Starting with pickupCityId: ${pickupCityId}, returnCityId: ${returnCityId || "not specified"}`);

// Schedule the cron job
const cronJob = schedule("0 */10 8-22 * * *", async () => {
    try {
        const date = new Date();
        logger.info(`Cron job started at: ${date.toLocaleString()}`);
        logger.info(
            `Fetching hitch list with pickupCityId: ${pickupCityId}, returnCityId: ${returnCityId || "not specified"}`
        );

        const hitchList = await extractHitchList(pickupCityId, returnCityId);
        console.log("Hitch List:", hitchList);
        logger.info(`Received hitchList with ${hitchList.length} items`);

        if (hitchList.length === 0) {
            logger.warn("No hitch rides found");
            return;
        }

        // The problem is that forEach does not wait for async operations to complete. This means that the hitchList array is not guaranteed to have all hitchDetails populated when you use it later (for example, when sending an email or logging).
        for (const hitch of hitchList) {
            const hitchIdArg = {
                hitchId: hitch.hitchId,
            };
            logger.info(`Fetching details for hitchId: ${hitch.hitchId}`);
            const hitchDetails = await getDetails(hitchIdArg);
            hitch.hitchDetails = hitchDetails;
            logger.info(`Hitch: ${JSON.stringify(hitch)}`);
        }

        if (hitchList.length > 0) {
            logger.info(`Sending email with hitch list`);
            emailService
                .sendEmail({
                    to: process.env.EMAIL_RECIPIENT!,
                    subject: "Hitch List Notification",
                    text: `Hitch list: \n ${JSON.stringify(hitchList, null, 2)}`,
                })
                .then((emailResponse) => {
                    logger.info(`Email sent successfully}`);
                })
                .catch((error) => {
                    logger.error(`Failed to send email: ${error.message}`, error);
                });
        }
    } catch (error) {
        logger.error(`Error in cron job: ${error}`);
    }
});

// Run the job immediately when the app starts (regardless of the schedule)
console.log("Starting immediate job execution...");
cronJob.start();
(async () => {
    try {
        const date = new Date();
        logger.info(`Manual job execution at: ${date.toLocaleString()}`);
        logger.info(
            `Fetching hitch list with pickupCityId: ${pickupCityId}, returnCityId: ${returnCityId || "not specified"}`
        );

        const hitchList = await extractHitchList(pickupCityId, returnCityId);
        console.log("Hitch List from immediate execution:", hitchList);
        logger.info(`Received hitchList with ${hitchList.length} items`);

        if (hitchList.length === 0) {
            logger.warn("No hitch rides found in immediate execution");
            return;
        }

        for (const hitch of hitchList) {
            const hitchIdArg = {
                hitchId: hitch.hitchId,
            };
            logger.info(`Fetching details for hitchId: ${hitch.hitchId}`);
            const hitchDetails = await getDetails(hitchIdArg);
            hitch.hitchDetails = hitchDetails;
            logger.info(`Hitch details: ${JSON.stringify(hitch)}`);
        }
    } catch (error) {
        logger.error(`Error in immediate execution: ${error}`);
    }
})();

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
