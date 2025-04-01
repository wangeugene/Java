import { createEmailService } from "./email";
import dotenv from "dotenv";
import nodemailer from "nodemailer";

dotenv.config();

jest.mock("node-cron", () => ({
    schedule: jest.fn().mockReturnValue({
        start: jest.fn(),
    }),
}));

jest.mock("./zuche", () => ({
    extractHitchList: jest.fn(),
}));

jest.mock("nodemailer", () => ({
    createTransport: jest.fn().mockReturnValue({
        sendMail: jest.fn().mockResolvedValue({ messageId: "test-id" }),
    }),
}));

describe("index.ts", () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    it("should create an email service with correct environment variables", () => {
        process.env.SMTP_HOST = "smtp.example.com";
        process.env.SMTP_PORT = "587";
        process.env.EMAIL_USER = "test@example.com";
        process.env.EMAIL_PASS = "password";

        const emailService = createEmailService(
            process.env.SMTP_HOST!,
            parseInt(process.env.SMTP_PORT!),
            process.env.EMAIL_USER!,
            process.env.EMAIL_PASS!,
            true
        );

        expect(emailService).toBeDefined();
        expect(nodemailer.createTransport).toHaveBeenCalledWith({
            host: process.env.SMTP_HOST,
            port: parseInt(process.env.SMTP_PORT!),
            secure: true,
            auth: {
                user: process.env.EMAIL_USER,
                pass: process.env.EMAIL_PASS,
            },
        });
    });
});
