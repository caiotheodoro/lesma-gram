import { BaseEntity } from ".";

export interface PostEntity extends BaseEntity {
  content: string;
  image: string;
  user_id?: string;
}
