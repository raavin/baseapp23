import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import {
  CreateAnnouncementDto,
  CreatePageDto,
  CreateSettingDto,
  UpdateAnnouncementDto,
  UpdatePageDto,
  UpdateSettingDto,
} from './dto/content.dto';
import { PaginationDto } from '../../common/pagination.dto';

@Injectable()
export class ContentService {
  constructor(private readonly prisma: PrismaService) {}

  listPages(pagination: PaginationDto) {
    return this.prisma.page.findMany({
      orderBy: { createdAt: 'desc' },
      skip: pagination.skip,
      take: pagination.take,
    });
  }

  pageDetail(slug: string) {
    return this.prisma.page.findUnique({ where: { slug } });
  }

  createPage(payload: CreatePageDto) {
    return this.prisma.page.create({ data: payload });
  }

  async updatePage(slug: string, payload: UpdatePageDto) {
    const existing = await this.prisma.page.findUnique({ where: { slug } });

    if (!existing) {
      throw new NotFoundException('Page not found');
    }

    return this.prisma.page.update({ where: { slug }, data: payload });
  }

  deletePage(slug: string) {
    return this.prisma.page.delete({ where: { slug } });
  }

  listAnnouncements(pagination: PaginationDto) {
    return this.prisma.announcement.findMany({
      orderBy: { createdAt: 'desc' },
      skip: pagination.skip,
      take: pagination.take,
    });
  }

  createAnnouncement(payload: CreateAnnouncementDto) {
    return this.prisma.announcement.create({ data: payload });
  }

  async updateAnnouncement(id: number, payload: UpdateAnnouncementDto) {
    const existing = await this.prisma.announcement.findUnique({ where: { id } });

    if (!existing) {
      throw new NotFoundException('Announcement not found');
    }

    return this.prisma.announcement.update({ where: { id }, data: payload });
  }

  deleteAnnouncement(id: number) {
    return this.prisma.announcement.delete({ where: { id } });
  }

  listSettings(pagination: PaginationDto) {
    return this.prisma.setting.findMany({
      orderBy: { key: 'asc' },
      skip: pagination.skip,
      take: pagination.take,
    });
  }

  createSetting(payload: CreateSettingDto) {
    return this.prisma.setting.create({ data: payload });
  }

  async updateSetting(key: string, payload: UpdateSettingDto) {
    const existing = await this.prisma.setting.findUnique({ where: { key } });

    if (!existing) {
      throw new NotFoundException('Setting not found');
    }

    return this.prisma.setting.update({ where: { key }, data: payload });
  }

  deleteSetting(key: string) {
    return this.prisma.setting.delete({ where: { key } });
  }
}
