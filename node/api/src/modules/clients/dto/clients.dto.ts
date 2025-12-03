import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CreateClientDto {
  @IsString()
  @IsNotEmpty()
  firstName!: string;

  @IsString()
  @IsNotEmpty()
  lastName!: string;
}

export class CreateCasenoteDto {
  @IsString()
  @IsNotEmpty()
  body!: string;

  @IsNumber()
  authorId!: number;
}
