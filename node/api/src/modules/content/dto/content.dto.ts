import { IsBoolean, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { Matches } from 'class-validator';

export class CreatePageDto {
  @IsString()
  @IsNotEmpty()
  title!: string;

  @IsString()
  @IsNotEmpty()
  body!: string;

  @IsString()
  @IsNotEmpty()
  @Matches(/^[a-z0-9-]+$/i, { message: 'slug must be URL-friendly (letters, numbers, dashes)' })
  slug!: string;

  @IsOptional()
  @IsBoolean()
  published?: boolean;
}

export class CreateAnnouncementDto {
  @IsString()
  @IsNotEmpty()
  title!: string;

  @IsString()
  @IsNotEmpty()
  body!: string;
}

export class CreateSettingDto {
  @IsString()
  @IsNotEmpty()
  key!: string;

  @IsString()
  @IsNotEmpty()
  value!: string;
}

export class UpdatePageDto extends CreatePageDto {}

export class UpdateAnnouncementDto extends CreateAnnouncementDto {}

export class UpdateSettingDto extends CreateSettingDto {}
