import { schedule } from "node-cron";
import { extractHitchList} from "./zuche";
import dotenv from "dotenv";
dotenv.config();
import { createEmailService } from "./email";

const emailService =createEmailService(
    process.env.SMTP_HOST!,
    parseInt(process.env.SMTP_PORT!),
    process.env.EMAIL_USER!,
    process.env.EMAIL_PASS!,
    true
);

// Schedule the cron job
const cronJob = schedule("0 */20 9-18 * * *", () => {
    const date = new Date();
    console.log("cron job assigned at", date.toLocaleString());
    // Fetch the hitch list
    extractHitchList(231, null).then((hitchList) => {
        if (Array.isArray(hitchList) && hitchList.length > 0) {
            console.log("Hitch list fetched successfully:", hitchList);
            emailService
                .sendEmail({
                    to: process.env.EMAIL_RECIPIENT!,
                    subject: "Hitch List Notification",
                    text: `Hitch list: ${JSON.stringify(hitchList)}`,
                })
                .then((emailResponse) => {
                    console.log("Email sent successfully:", emailResponse);
                })
                .catch((error) => {
                    console.error("Failed to send email:", error);
                });
        } else {
            console.log("No hitchs found.");
        }
    });

});

// Start the cron job
cronJob.start();

setInterval(() => {}, 1000); // Keep process alive
