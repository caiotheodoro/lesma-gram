import { Pool } from "pg";
import { CreateUserDTO, UpdateUserDTO } from "../dtos";
import { UserEntity } from "../../../@types/entities";
import { UserInterface } from "./user.interface";
import { UserSettingsEntity } from "../../../@types/entities/user_settings";

export class UserRepository implements UserInterface {
  #pool: Pool;

  constructor(pool: Pool) {
    this.#pool = pool;
  }

  async getUsers(): Promise<UserEntity[]> {
    const response = await this.#pool.query(
      'SELECT (id,name,email) FROM "users"  ORDER BY id ASC'
    );

    const formatttedResponse = response.rows.map((row) => {
      const formattedRow = row.row
        .replace("(", "")
        .replace(")", "")
        .replace(/"/g, "")
        .split(",");
      return {
        id: formattedRow[0],
        name: formattedRow[1],
        email: formattedRow[2],
      };
    });

    return formatttedResponse as UserEntity[];
  }

  async createUser({ name, email, password }: CreateUserDTO): Promise<string> {
    const result = await this.#pool.query(
      `INSERT INTO "users" (name, email, password) VALUES ($1, $2, $3) RETURNING id`,
      [name, email, password]
    );
    return result.rows[0].id;
  }

  async createUserSettings(userId: string): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "user_settings" ("userId", "isAnonymous", "showPicture", "storyPosts") VALUES ($1, $2, $3, $4)',
      [userId, false, false, false]
    );
  }

  async getUserById(id: string): Promise<UserEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "users" WHERE id = $1',
      [id]
    );
    return response.rows[0];
  }

  async getUsersByName(name: string): Promise<UserEntity[]> {
    const response = await this.#pool.query(
      'SELECT * FROM "users" WHERE "users"."name" LIKE $1',
      [`%${name}%`]
    );
    return response.rows;
  }

  async getUserByEmail(email: string): Promise<UserEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "users" WHERE email = $1',
      [email]
    );
    return response.rows[0];
  }

  async updateUser({ id, name, email, password }: UpdateUserDTO) {
    await this.#pool.query(
      `UPDATE "users" SET name = $1, email = $2, password = $3 WHERE id = $4`,
      [name, email, password, id]
    );
  }

  async updateUserSettings(id: string, isAnonymous: string): Promise<void> {
    await this.#pool.query(
      'UPDATE "user_settings" SET "isAnonymous" = $1 WHERE "userId" = $2',
      [isAnonymous, id]
    );
  }

  async deleteUser(id: string) {
    await this.#pool.query('DELETE FROM "users" WHERE id = $1', [id]);
  }

  async getUserSettings(userId: string): Promise<UserSettingsEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "user_settings" WHERE "userId" = $1',
      [userId]
    );
    return response.rows[0];
  }
}
