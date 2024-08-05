import { BaseEntity } from ".";

export interface UserActivityEntity extends BaseEntity {
  userId: string;
  activityId: string;

  deliver: Date;
  grade: number;
}
