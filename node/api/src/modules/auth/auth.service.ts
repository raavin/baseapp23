import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { ActivateDto, ForgotPasswordDto, LoginDto, RegisterDto, ResetPasswordDto } from './dto/auth.dto';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcryptjs';
import { NotificationsService } from '../notifications/notifications.service';
import { randomBytes } from 'crypto';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
    private readonly notifications: NotificationsService,
  ) {}

  private generatePerishableToken() {
    return randomBytes(24).toString('hex');
  }

  private perishableExpiryDate() {
    const hours = Number(this.config.get('PERISHABLE_TOKEN_TTL_HOURS') ?? 48);
    const expiration = new Date();
    expiration.setHours(expiration.getHours() + hours);
    return expiration;
  }

  async register(payload: RegisterDto) {
    const passwordHash = await bcrypt.hash(payload.password, 12);

    const token = this.generatePerishableToken();

    const user = await this.prisma.user.create({
      data: {
        email: payload.email,
        passwordHash,
        state: 'pending',
        perishableToken: token,
        perishableTokenExpiresAt: this.perishableExpiryDate(),
      },
      select: {
        id: true,
        email: true,
        state: true,
      },
    });

    await this.notifications.sendActivationEmail(payload.email, token);

    return {
      user,
      accessToken: this.jwt.sign({ sub: user.id, email: user.email }),
      activationToken: token,
    };
  }

  async login(payload: LoginDto) {
    const user = await this.prisma.user.findUnique({ where: { email: payload.email } });

    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    const matches = await bcrypt.compare(payload.password, user.passwordHash);

    if (!matches) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (['suspended', 'deleted'].includes(user.state)) {
      throw new UnauthorizedException('Account is not active');
    }

    if (user.state === 'pending') {
      throw new UnauthorizedException('Account is pending activation');
    }

    await this.prisma.user.update({
      where: { id: user.id },
      data: { lastLoginAt: user.currentLoginAt, currentLoginAt: new Date(), loginCount: { increment: 1 } },
    });

    return {
      user: { id: user.id, email: user.email, state: user.state },
      accessToken: this.jwt.sign({ sub: user.id, email: user.email }),
      expiresIn: this.config.get<string>('JWT_TTL', '15m'),
    };
  }

  async activate(payload: ActivateDto) {
    const user = await this.prisma.user.findFirst({
      where: {
        perishableToken: payload.token,
        perishableTokenExpiresAt: { gt: new Date() },
      },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid or expired activation token');
    }

    const updated = await this.prisma.user.update({
      where: { id: user.id },
      data: { state: 'active', perishableToken: null, perishableTokenExpiresAt: null },
      select: { id: true, email: true, state: true },
    });

    return {
      user: updated,
      accessToken: this.jwt.sign({ sub: updated.id, email: updated.email }),
    };
  }

  async forgotPassword(payload: ForgotPasswordDto) {
    const user = await this.prisma.user.findUnique({ where: { email: payload.email } });

    if (!user) {
      return { message: 'If the account exists, a reset email will be sent shortly' };
    }

    const token = this.generatePerishableToken();

    await this.prisma.user.update({
      where: { id: user.id },
      data: { perishableToken: token, perishableTokenExpiresAt: this.perishableExpiryDate() },
    });

    await this.notifications.sendPasswordResetEmail(user.email, token);

    return { message: 'If the account exists, a reset email will be sent shortly' };
  }

  async resetPassword(payload: ResetPasswordDto) {
    const user = await this.prisma.user.findFirst({
      where: {
        perishableToken: payload.token,
        perishableTokenExpiresAt: { gt: new Date() },
      },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid or expired reset token');
    }

    const passwordHash = await bcrypt.hash(payload.password, 12);

    await this.prisma.user.update({
      where: { id: user.id },
      data: {
        passwordHash,
        perishableToken: null,
        perishableTokenExpiresAt: null,
        state: user.state === 'pending' ? 'active' : user.state,
      },
    });

    return { message: 'Password updated successfully' };
  }
}
