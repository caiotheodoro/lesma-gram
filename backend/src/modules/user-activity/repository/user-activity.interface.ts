import { UserActivityEntity } from "../../../@types/entities";
import { CreateUserActivityDTO, UpdateUserActivityDTO } from "../dtos";
import { GetActivitiesDTO } from "../dtos/get-user-activity.dto";

export interface UserActivityInterface {
  getActivities(): Promise<GetActivitiesDTO[]>;
  getUserActivityById(id: string): Promise<UserActivityEntity>;
  createUserActivity(data: CreateUserActivityDTO): Promise<void>;
  updateUserActivity(data: UpdateUserActivityDTO): Promise<void>;
  deleteUserActivity(id: string): Promise<void>;
}
