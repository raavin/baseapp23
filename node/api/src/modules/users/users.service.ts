import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  list() {
    return this.prisma.user.findMany({
      select: { id: true, email: true, state: true, roles: { include: { role: true } } },
      orderBy: { id: 'asc' },
    });
  }

  detail(id: number) {
    return this.prisma.user.findUnique({
      where: { id },
      select: { id: true, email: true, state: true, profile: true, roles: { include: { role: true } } },
    });
  }

  async create(payload: CreateUserDto) {
    const passwordHash = await bcrypt.hash(payload.password, 12);

    const user = await this.prisma.user.create({
      data: {
        email: payload.email,
        passwordHash,
        profile: payload.profile
          ? {
              create: {
                firstName: payload.profile.firstName,
                lastName: payload.profile.lastName,
              },
            }
          : undefined,
      },
      include: { profile: true },
    });

    return { id: user.id, email: user.email, profile: user.profile };
  }

  updateState(id: number, state: 'pending' | 'active' | 'suspended' | 'deleted') {
    return this.prisma.user.update({ where: { id }, data: { state } });
  }

  addRole(userId: number, roleId: number) {
    return this.prisma.userRole.upsert({
      where: { userId_roleId: { userId, roleId } },
      update: {},
      create: { userId, roleId },
    });
  }
}
