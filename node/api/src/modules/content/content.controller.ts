import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ContentService } from './content.service';
import {
  CreateAnnouncementDto,
  CreatePageDto,
  CreateSettingDto,
  UpdateAnnouncementDto,
  UpdatePageDto,
  UpdateSettingDto,
} from './dto/content.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AccessGuard } from '../access-control/access.guard';
import { RequireResource } from '../access-control/resource.decorator';
import { PaginationDto } from '../../common/pagination.dto';

@UseGuards(JwtAuthGuard, AccessGuard)
@Controller()
export class ContentController {
  constructor(private readonly content: ContentService) {}

  @Get('pages')
  @RequireResource('pages:list')
  listPages(@Query() pagination: PaginationDto) {
    return this.content.listPages(pagination);
  }

  @Post('pages')
  @RequireResource('pages:create')
  createPage(@Body() payload: CreatePageDto) {
    return this.content.createPage(payload);
  }

  @Get('pages/:slug')
  @RequireResource('pages:detail')
  pageDetail(@Param('slug') slug: string) {
    return this.content.pageDetail(slug);
  }

  @Patch('pages/:slug')
  @RequireResource('pages:update')
  updatePage(@Param('slug') slug: string, @Body() payload: UpdatePageDto) {
    return this.content.updatePage(slug, payload);
  }

  @Delete('pages/:slug')
  @RequireResource('pages:delete')
  deletePage(@Param('slug') slug: string) {
    return this.content.deletePage(slug);
  }

  @Get('announcements')
  @RequireResource('announcements:list')
  listAnnouncements(@Query() pagination: PaginationDto) {
    return this.content.listAnnouncements(pagination);
  }

  @Post('announcements')
  @RequireResource('announcements:create')
  createAnnouncement(@Body() payload: CreateAnnouncementDto) {
    return this.content.createAnnouncement(payload);
  }

  @Patch('announcements/:id')
  @RequireResource('announcements:update')
  updateAnnouncement(@Param('id') id: number, @Body() payload: UpdateAnnouncementDto) {
    return this.content.updateAnnouncement(Number(id), payload);
  }

  @Delete('announcements/:id')
  @RequireResource('announcements:delete')
  deleteAnnouncement(@Param('id') id: number) {
    return this.content.deleteAnnouncement(Number(id));
  }

  @Get('settings')
  @RequireResource('settings:list')
  listSettings(@Query() pagination: PaginationDto) {
    return this.content.listSettings(pagination);
  }

  @Post('settings')
  @RequireResource('settings:create')
  createSetting(@Body() payload: CreateSettingDto) {
    return this.content.createSetting(payload);
  }

  @Patch('settings/:key')
  @RequireResource('settings:update')
  updateSetting(@Param('key') key: string, @Body() payload: UpdateSettingDto) {
    return this.content.updateSetting(key, payload);
  }

  @Delete('settings/:key')
  @RequireResource('settings:delete')
  deleteSetting(@Param('key') key: string) {
    return this.content.deleteSetting(key);
  }
}
