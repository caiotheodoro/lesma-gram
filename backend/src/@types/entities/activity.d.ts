import { BaseEntity } from ".";

export interface ActivityEntity  extends BaseEntity {
  title: string;
  description: string;
  date: Date;
}
