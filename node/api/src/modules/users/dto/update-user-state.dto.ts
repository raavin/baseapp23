import { IsIn } from 'class-validator';

export class UpdateUserStateDto {
  @IsIn(['pending', 'active', 'suspended', 'deleted'])
  state!: 'pending' | 'active' | 'suspended' | 'deleted';
}
