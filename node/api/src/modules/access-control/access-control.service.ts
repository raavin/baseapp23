import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateResourceDto, CreateRoleDto } from './dto/access-control.dto';

@Injectable()
export class AccessControlService {
  constructor(private readonly prisma: PrismaService) {}

  listRoles() {
    return this.prisma.role.findMany({ include: { resources: true }, orderBy: { id: 'asc' } });
  }

  listResources() {
    return this.prisma.resource.findMany({ orderBy: { id: 'asc' } });
  }

  createRole(payload: CreateRoleDto) {
    return this.prisma.role.create({ data: { name: payload.name } });
  }

  createResource(payload: CreateResourceDto) {
    return this.prisma.resource.create({ data: { identifier: payload.identifier } });
  }

  attachResourceToRole(roleId: number, resourceId: number) {
    return this.prisma.roleResource.upsert({
      where: {
        roleId_resourceId: { roleId, resourceId },
      },
      create: { roleId, resourceId },
      update: {},
    });
  }
}
