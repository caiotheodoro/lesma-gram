import { Pool } from "pg";
import { LoginDTO } from "../dtos";
import { AuthInterface } from "./auth.interface";
import { UserEntity } from "../../../@types/entities";


export class AuthRepository implements AuthInterface {
  #pool: Pool;

  constructor(pool: Pool) {
    this.#pool = pool;
  }


  async login({ email, password }: LoginDTO): Promise<UserEntity> {
    const user: UserEntity = await this.#pool.query(
      `SELECT * FROM users WHERE email = $1 AND password = $2`,
      [email, password]
    ) as unknown as UserEntity;

    return user;
  }

}