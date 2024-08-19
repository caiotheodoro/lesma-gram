import { UserEntity } from "../../../@types/entities";
import { UserSettingsEntity } from "../../../@types/entities/user_settings";
import { CreateUserDTO, UpdateUserDTO } from "../dtos";

export interface UserInterface {
  getUsers(): Promise<UserEntity[]>;
  getUserById(id: string): Promise<UserEntity>;
  createUser(data: CreateUserDTO): Promise<string>;
  createUserSettings(id: string): Promise<void>;
  updateUser(data: UpdateUserDTO): Promise<void>;
  updateUserSettings(id: string, isAnonymous: string): Promise<void>;
  deleteUser(id: string): Promise<void>;
  getUserSettings(id: string): Promise<UserSettingsEntity>;
}
