import { Body, Controller, Get, Param, Post, Query, UseGuards } from '@nestjs/common';
import { ClientsService } from './clients.service';
import { CreateCasenoteDto, CreateClientDto } from './dto/clients.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AccessGuard } from '../access-control/access.guard';
import { RequireResource } from '../access-control/resource.decorator';
import { PaginationDto } from '../../common/pagination.dto';

@UseGuards(JwtAuthGuard, AccessGuard)
@Controller('clients')
export class ClientsController {
  constructor(private readonly clients: ClientsService) {}

  @Get()
  @RequireResource('clients:list')
  list(@Query() pagination: PaginationDto) {
    return this.clients.list(pagination);
  }

  @Get(':id')
  @RequireResource('clients:detail')
  detail(@Param('id') id: number) {
    return this.clients.detail(Number(id));
  }

  @Get(':id/casenotes')
  @RequireResource('casenotes:list')
  listCasenotes(@Param('id') id: number, @Query() pagination: PaginationDto) {
    return this.clients.listCasenotes(Number(id), pagination);
  }

  @Post()
  @RequireResource('clients:create')
  create(@Body() payload: CreateClientDto) {
    return this.clients.create(payload);
  }

  @Post(':id/casenotes')
  @RequireResource('casenotes:create')
  addCasenote(@Param('id') id: number, @Body() payload: CreateCasenoteDto) {
    return this.clients.addCasenote(Number(id), payload);
  }
}
