import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { PrismaModule } from './prisma/prisma.module';
import { appConfig } from './config/app.config';
import { mailConfig } from './config/notifications.config';
import { HealthModule } from './modules/health/health.module';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { AccessControlModule } from './modules/access-control/access-control.module';
import { ContentModule } from './modules/content/content.module';
import { ClientsModule } from './modules/clients/clients.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true, load: [appConfig, mailConfig] }),
    PrismaModule,
    HealthModule,
    AuthModule,
    UsersModule,
    AccessControlModule,
    ContentModule,
    ClientsModule,
  ],
  controllers: [AppController],
})
export class AppModule {}
