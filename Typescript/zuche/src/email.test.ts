import { createEmailService, EmailService } from "./email";
import nodemailer from "nodemailer";

// Mock nodemailer to avoid actual email sending
jest.mock("nodemailer", () => {
    return {
        createTransport: jest.fn().mockReturnValue({
            sendMail: jest.fn().mockResolvedValue({ messageId: "test-id" }),
            verify: jest.fn().mockResolvedValue(true),
        }),
    };
});

describe("createEmailService", () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    it("should create an EmailService instance", () => {
        const emailService = createEmailService("smtp.example.com", 587, "test@example.com", "password");
        expect(emailService).toBeInstanceOf(EmailService);
    });

    it("should configure the transporter with provided parameters", () => {
        const host = "smtp.example.com";
        const port = 587;
        const user = "test@example.com";
        const pass = "password";

        createEmailService(host, port, user, pass);

        expect(nodemailer.createTransport).toHaveBeenCalledWith({
            host,
            port,
            secure: true,
            auth: { user, pass },
        });
    });

    it("should use secure=false when specified", () => {
        const host = "smtp.example.com";
        const port = 587;
        const user = "test@example.com";
        const pass = "password";

        createEmailService(host, port, user, pass, false);

        expect(nodemailer.createTransport).toHaveBeenCalledWith({
            host,
            port,
            secure: false,
            auth: { user, pass },
        });
    });

    it("should use custom defaultFrom when provided", () => {
        const defaultFrom = "custom@example.com";
        const emailService = createEmailService(
            "smtp.example.com",
            587,
            "test@example.com",
            "password",
            true,
            defaultFrom
        );

        // Send an email to test the defaultFrom value
        emailService.sendEmail({ to: "recipient@example.com", subject: "Test" });

        const sendMailMock = nodemailer.createTransport().sendMail as jest.Mock;
        expect(sendMailMock).toHaveBeenCalledWith(
            expect.objectContaining({
                from: defaultFrom,
            })
        );
    });

    it("should use user email as defaultFrom when not provided", () => {
        const user = "test@example.com";
        const emailService = createEmailService("smtp.example.com", 587, user, "password");

        // Send an email to test the defaultFrom value
        emailService.sendEmail({ to: "recipient@example.com", subject: "Test" });

        const sendMailMock = nodemailer.createTransport().sendMail as jest.Mock;
        expect(sendMailMock).toHaveBeenCalledWith(
            expect.objectContaining({
                from: user,
            })
        );
    });
});
