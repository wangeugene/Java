import { createEmailService } from "../src/email";

import * as dotenv from "dotenv"; // import dotenv from "dotenv"; ERROR: has no default
dotenv.config();

describe("EmailService smoke test", () => {
    it("should send an email using real configuration", async () => {
        const emailService = createEmailService(
            process.env.SMTP_HOST!,
            parseInt(process.env.SMTP_PORT!),
            process.env.EMAIL_USER!,
            process.env.EMAIL_PASS!,
            true
        );
        const response = await emailService.sendEmail({
            to: `${process.env.EMAIL_RECIPIENT!}`,
            subject: "163 Email Smoke Test",
            text: "It's sent from my Node.js application!",
        });
        expect(response).toBeDefined();
    });
});
