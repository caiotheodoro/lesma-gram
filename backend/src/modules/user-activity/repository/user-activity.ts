import { Pool } from "pg";
import { CreateUserActivityDTO, UpdateUserActivityDTO } from "../dtos";
import { UserActivityEntity } from "../../../@types/entities";
import { UserActivityInterface } from "./user-activity.interface";
import { GetActivitiesDTO } from "../dtos/get-user-activity.dto";

export class UserActivityRepository implements UserActivityInterface {
  #pool: Pool;

  constructor(pool: Pool) {
    this.#pool = pool;
  }

  async getActivities(): Promise<GetActivitiesDTO[]> {
    const response = await this.#pool.query(
      'SELECT ( \
      u.name , \
      ac.title, \
      "user_activity".deliver, \
      "user_activity".grade \
      ) \
      FROM user_activity \
      LEFT JOIN "user" u ON "user_activity".userId = u.id \
      LEFT JOIN "activity" ac ON "user_activity".activityId = ac.id',
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
        title: formattedRow[2],
        deliver: formattedRow[3],
        grade: formattedRow[4],
      };
    });

    return formatttedResponse;
  }

  async createUserActivity({
    userId,
    activityId,
    deliver,
    grade,
  }: CreateUserActivityDTO): Promise<void> {
    console.log(userId, activityId, deliver, grade);
    await this.#pool.query(
      `INSERT INTO "user_activity" (userId, activityId, deliver,grade) VALUES ($1, $2, $3, $4)`,
      [userId, activityId, deliver, grade],
    );
  }

  async getUserActivityById(id: string): Promise<UserActivityEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "user_activity" WHERE id = $1',
      [id],
    );

    console.log(response.rows[0]);
    return response.rows[0];
  }

  async updateUserActivity({
    id,
    userId,
    activityId,
    deliver,
    grade,
  }: UpdateUserActivityDTO) {
    await this.#pool.query(
      `UPDATE "user_activity" SET userId = $1, activityId = $2, deliver = $3, grade = $4 WHERE id = $5`,
      [userId, activityId, deliver, grade, id],
    );
  }

  async deleteUserActivity(id: string) {
    await this.#pool.query('DELETE FROM "user_activity" WHERE id = $1', [id]);
  }
}
