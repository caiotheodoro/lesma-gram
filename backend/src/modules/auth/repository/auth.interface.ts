import { UserEntity } from "../../../@types/entities";
import {LoginDTO } from "../dtos";

export interface AuthInterface {
  login(data: LoginDTO): Promise<UserEntity>;
}
