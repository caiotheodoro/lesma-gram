import { ActivityEntity } from "../../../@types/entities";
import { CreateActivityDTO, UpdateActivityDTO } from "../dtos";

export interface ActivityInterface {
  getActivities(): Promise<ActivityEntity[]>;
  getActivityById(id: string): Promise<ActivityEntity>;
  createActivity(data: CreateActivityDTO): Promise<void>;
  updateActivity(data: UpdateActivityDTO): Promise<void>;
  deleteActivity(id: string): Promise<void>;
}
