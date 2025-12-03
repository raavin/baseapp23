import { IsInt, IsPositive } from 'class-validator';

export class AttachRoleDto {
  @IsInt()
  @IsPositive()
  roleId!: number;
}
