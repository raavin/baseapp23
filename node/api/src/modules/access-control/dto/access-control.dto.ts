import { IsInt, IsNotEmpty, IsPositive, IsString } from 'class-validator';

export class CreateRoleDto {
  @IsString()
  @IsNotEmpty()
  name!: string;
}

export class CreateResourceDto {
  @IsString()
  @IsNotEmpty()
  identifier!: string;
}

export class AttachResourceDto {
  @IsInt()
  @IsPositive()
  roleId!: number;

  @IsInt()
  @IsPositive()
  resourceId!: number;
}
