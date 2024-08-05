import { BaseEntity } from ".";

export interface PostEntity extends BaseEntity {
  title: string;
  description: string;
  date: Date;
}
