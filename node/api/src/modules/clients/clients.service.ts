import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { CreateCasenoteDto, CreateClientDto } from './dto/clients.dto';
import { PaginationDto } from '../../common/pagination.dto';

@Injectable()
export class ClientsService {
  constructor(private readonly prisma: PrismaService) {}

  list(pagination: PaginationDto) {
    return this.prisma.client.findMany({
      include: { casenotes: { orderBy: { createdAt: 'desc' }, take: 5 } },
      orderBy: { createdAt: 'desc' },
      skip: pagination.skip,
      take: pagination.take,
    });
  }

  detail(id: number) {
    return this.prisma.client.findUnique({
      where: { id },
      include: { casenotes: { orderBy: { createdAt: 'desc' } } },
    });
  }

  listCasenotes(clientId: number, pagination: PaginationDto) {
    return this.prisma.casenote.findMany({
      where: { clientId },
      orderBy: { createdAt: 'desc' },
      skip: pagination.skip,
      take: pagination.take,
      include: { author: { select: { id: true, email: true } } },
    });
  }

  create(payload: CreateClientDto) {
    return this.prisma.client.create({ data: payload });
  }

  addCasenote(clientId: number, payload: CreateCasenoteDto) {
    return this.prisma.casenote.create({
      data: {
        body: payload.body,
        clientId,
        authorId: payload.authorId,
      },
    });
  }
}
