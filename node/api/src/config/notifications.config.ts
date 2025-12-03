export interface MailConfig {
  from: string;
  webBaseUrl?: string;
  smtpHost?: string;
  smtpPort?: number;
  smtpUser?: string;
  smtpPassword?: string;
  smtpSecure: boolean;
}

export const mailConfig = (): MailConfig => ({
  from: process.env.MAIL_FROM || 'no-reply@example.com',
  webBaseUrl: process.env.PUBLIC_WEB_URL,
  smtpHost: process.env.SMTP_HOST,
  smtpPort: process.env.SMTP_PORT ? parseInt(process.env.SMTP_PORT, 10) : undefined,
  smtpUser: process.env.SMTP_USER,
  smtpPassword: process.env.SMTP_PASSWORD,
  smtpSecure: process.env.SMTP_SECURE === 'true',
});
