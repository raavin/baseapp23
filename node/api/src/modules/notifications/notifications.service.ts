import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';
import type { Transporter } from 'nodemailer';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);
  private transporter?: Transporter;
  private readonly fromAddress: string;
  private readonly webBaseUrl?: string;

  constructor(private readonly config: ConfigService) {
    this.fromAddress = this.config.get<string>('MAIL_FROM', 'no-reply@example.com');
    this.webBaseUrl = this.config.get<string>('PUBLIC_WEB_URL');

    const host = this.config.get<string>('SMTP_HOST');
    const port = this.config.get<number>('SMTP_PORT') ?? 587;
    const user = this.config.get<string>('SMTP_USER');
    const pass = this.config.get<string>('SMTP_PASSWORD');
    const secure = this.config.get<boolean>('SMTP_SECURE', false);

    if (host && port) {
      this.transporter = nodemailer.createTransport({
        host,
        port,
        secure,
        auth: user && pass ? { user, pass } : undefined,
      });

      this.logger.log(`Email transport configured for ${host}:${port}`);
    } else {
      this.logger.warn('Email transport not configured; falling back to log-only notifications');
    }
  }

  private buildActionUrl(path: string, token: string) {
    if (!this.webBaseUrl) return undefined;

    const trimmed = this.webBaseUrl.replace(/\/$/, '');
    return `${trimmed}/${path}?token=${token}`;
  }

  private async deliverMail(to: string, subject: string, text: string) {
    if (!this.transporter) {
      this.logger.log(`[DEV-ONLY] Would send email to ${to}: ${subject}\n${text}`);
      return;
    }

    try {
      await this.transporter.sendMail({ from: this.fromAddress, to, subject, text });
    } catch (error) {
      const message = (error as Error).message || 'Unknown error';
      this.logger.error(`Failed to send email to ${to}: ${message}`);
    }
  }

  async sendActivationEmail(email: string, token: string) {
    const activationLink = this.buildActionUrl('activate', token);
    const body = activationLink
      ? `Welcome! Activate your account: ${activationLink}`
      : `Welcome! Use this token to activate your account: ${token}`;

    await this.deliverMail(email, 'Activate your account', body);
  }

  async sendPasswordResetEmail(email: string, token: string) {
    const resetLink = this.buildActionUrl('reset-password', token);
    const body = resetLink
      ? `You requested a password reset. Reset here: ${resetLink}`
      : `You requested a password reset. Use this token: ${token}`;

    await this.deliverMail(email, 'Reset your password', body);
  }
}
