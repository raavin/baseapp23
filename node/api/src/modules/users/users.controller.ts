import { Body, Controller, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AccessGuard } from '../access-control/access.guard';
import { RequireResource } from '../access-control/resource.decorator';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserStateDto } from './dto/update-user-state.dto';
import { AttachRoleDto } from './dto/attach-role.dto';
import { UsersService } from './users.service';

@UseGuards(JwtAuthGuard, AccessGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  @RequireResource('users:list')
  list() {
    return this.usersService.list();
  }

  @Get(':id')
  @RequireResource('users:detail')
  detail(@Param('id') id: number) {
    return this.usersService.detail(Number(id));
  }

  @Post()
  @RequireResource('users:create')
  create(@Body() payload: CreateUserDto) {
    return this.usersService.create(payload);
  }

  @Patch(':id/state')
  @RequireResource('users:update-state')
  updateState(@Param('id') id: number, @Body() payload: UpdateUserStateDto) {
    return this.usersService.updateState(Number(id), payload.state);
  }

  @Post(':id/roles')
  @RequireResource('users:assign-role')
  attachRole(@Param('id') id: number, @Body() payload: AttachRoleDto) {
    return this.usersService.addRole(Number(id), payload.roleId);
  }
}
