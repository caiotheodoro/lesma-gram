import { BaseEntity } from ".";

export interface PostEntity extends BaseEntity {
  content: string;
  image: string;
  userId?: string;
}
