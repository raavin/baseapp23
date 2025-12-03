import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AccessControlService } from './access-control.service';
import { AttachResourceDto, CreateResourceDto, CreateRoleDto } from './dto/access-control.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AccessGuard } from './access.guard';
import { RequireResource } from './resource.decorator';

@UseGuards(JwtAuthGuard, AccessGuard)
@Controller('access-control')
export class AccessControlController {
  constructor(private readonly accessControl: AccessControlService) {}

  @Get('roles')
  @RequireResource('access-control:roles:list')
  listRoles() {
    return this.accessControl.listRoles();
  }

  @Get('resources')
  @RequireResource('access-control:resources:list')
  listResources() {
    return this.accessControl.listResources();
  }

  @Post('roles')
  @RequireResource('access-control:roles:create')
  createRole(@Body() payload: CreateRoleDto) {
    return this.accessControl.createRole(payload);
  }

  @Post('resources')
  @RequireResource('access-control:resources:create')
  createResource(@Body() payload: CreateResourceDto) {
    return this.accessControl.createResource(payload);
  }

  @Post('roles/attach-resource')
  @RequireResource('access-control:roles:attach')
  attachResource(@Body() payload: AttachResourceDto) {
    return this.accessControl.attachResourceToRole(payload.roleId, payload.resourceId);
  }
}
