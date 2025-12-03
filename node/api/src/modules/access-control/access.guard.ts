import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class AccessGuard implements CanActivate {
  constructor(private readonly reflector: Reflector, private readonly prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const resource = this.reflector.get<string>('resource', context.getHandler());

    if (!resource) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const user = request.user as { userId: number } | undefined;

    if (!user) {
      throw new UnauthorizedException('Missing authenticated user');
    }

    const match = await this.prisma.roleResource.findFirst({
      where: {
        resource: { identifier: resource },
        role: { users: { some: { userId: user.userId } } },
      },
    });

    return Boolean(match);
  }
}
