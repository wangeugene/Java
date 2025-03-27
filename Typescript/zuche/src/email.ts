import nodemailer from "nodemailer";

// Email configuration interface
interface EmailConfig {
    host: string;
    port: number;
    secure: boolean;
    auth: {
        user: string;
        pass: string;
    };
}

// Email data interface
export interface EmailData {
    from?: string;
    to: string | string[];
    cc?: string | string[];
    bcc?: string | string[];
    subject: string;
    text?: string;
    html?: string;
    attachments?: Array<{
        filename: string;
        path: string;
        contentType?: string;
    }>;
}

// Email service class
export class EmailService {
    private transporter: nodemailer.Transporter;
    private defaultFrom: string;

    constructor(config: EmailConfig, defaultFrom: string) {
        this.transporter = nodemailer.createTransport(config);
        this.defaultFrom = defaultFrom;
    }

    /**
     * Send an email
     * @param emailData The email data
     * @returns Promise with the info about the sent email
     */
    async sendEmail(emailData: EmailData): Promise<nodemailer.SentMessageInfo> {
        try {
            const mailOptions = {
                from: emailData.from || this.defaultFrom,
                to: emailData.to,
                cc: emailData.cc,
                bcc: emailData.bcc,
                subject: emailData.subject,
                text: emailData.text,
                html: emailData.html,
                attachments: emailData.attachments,
            };

            const info = await this.transporter.sendMail(mailOptions);
            return info;
        } catch (error) {
            console.error("Failed to send email:", error);
            throw error;
        }
    }

    /**
     * Verify connection configuration
     * @returns Promise with verification result
     */
    async verifyConnection(): Promise<boolean> {
        try {
            await this.transporter.verify();
            return true;
        } catch (error) {
            console.error("Email connection verification failed:", error);
            return false;
        }
    }
}

// Helper function to create an email service instance with default configuration
export function createEmailService(
    host: string,
    port: number,
    user: string,
    pass: string,
    secure = true,
    defaultFrom = user
): EmailService {
    const config: EmailConfig = {
        host,
        port,
        secure,
        auth: { user, pass },
    };

    return new EmailService(config, defaultFrom);
}
