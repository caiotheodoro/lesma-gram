import { Pool } from "pg";
import { CreateActivityDTO, UpdateActivityDTO } from "../dtos";
import { ActivityEntity } from "../../../@types/entities";
import { ActivityInterface } from "./activity.interface";


export class ActivityRepository implements ActivityInterface {
  #pool: Pool;

  constructor(pool: Pool) {
    this.#pool = pool;
  }

  async getActivities(): Promise<ActivityEntity[]> {
    const response = await this.#pool.query('SELECT * FROM "activity" ORDER BY id ASC');
    return response.rows;
  }

  async createActivity({ title, description, date }: CreateActivityDTO): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "activity" (title, description, date) VALUES ($1, $2, $3)',
      [title, description, date],
    );
  }

  async getActivityById(id:string): Promise<ActivityEntity> {
    const response = await this.#pool.query('SELECT * FROM "activity" WHERE id = $1', [
      id,
    ]);
    return response.rows[0];
  }

  async updateActivity({ id, title, description, date }: UpdateActivityDTO) {
    await this.#pool.query(
      `UPDATE "activity" SET title = $1, description = $2, date = $3 WHERE id = $4`,
      [title, description, date, id],
    );
  }

  async deleteActivity(id:string) {
    await this.#pool.query('DELETE FROM "user_activity" WHERE activityId = $1', [
      id,
    ]);
    await this.#pool.query('DELETE FROM "activity" WHERE id = $1', [id]);
  }
}