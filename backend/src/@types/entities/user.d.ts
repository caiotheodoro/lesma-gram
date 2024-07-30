import { BaseEntity } from ".";


export interface UserEntity  extends BaseEntity {
  name: string;
  email: string;
  password: string;
}
