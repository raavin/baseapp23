import { Module } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthModule } from '../auth/auth.module';
import { AccessControlController } from './access-control.controller';
import { AccessControlService } from './access-control.service';
import { AccessGuard } from './access.guard';

@Module({
  imports: [AuthModule],
  controllers: [AccessControlController],
  providers: [AccessControlService, AccessGuard, Reflector],
  exports: [AccessGuard],
})
export class AccessControlModule {}
