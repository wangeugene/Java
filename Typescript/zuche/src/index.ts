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

// Schedule the cron job
const cronJob = schedule("0 */20 9-18 * * *", () => {
    const date = new Date();
    logger.info(`Cron job assigned at: ${date.toLocaleString()}`);
    logger.info(`Email recipient: ${process.env.EMAIL_RECIPIENT!}`);
    console.log(`docker log <container_name> to view this log: Email recipient: ${process.env.EMAIL_RECIPIENT!}`);

    // Fetch the hitch list
    extractHitchList(231, null).then((hitchList) => {
        if (Array.isArray(hitchList) && hitchList.length > 0) {
            logger.info("Hitch list fetched successfully:", hitchList);
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

setInterval(() => {}, 1000); // Keep process alive
