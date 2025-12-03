import { SetMetadata } from '@nestjs/common';

export const RequireResource = (identifier: string) => SetMetadata('resource', identifier);
