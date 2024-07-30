import { UserEntity } from "../../../@types/entities";
import { CreateUserDTO, UpdateUserDTO } from "../dtos";

export interface UserInterface {
  getUsers(): Promise<UserEntity[]>;
  getUserById(id: string): Promise<UserEntity>;
  createUser(data: CreateUserDTO): Promise<void>;
  updateUser(data: UpdateUserDTO): Promise<void>;
  deleteUser(id: string): Promise<void>;
}
