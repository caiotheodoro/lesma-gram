import { Pool } from "pg";
import { CreateLikeDTO, UpdateLikeDTO } from "../dtos";
import { LikeEntity } from "../../../@types/entities";
import { LikeInterface } from "./like.interface";

export class LikeRepository implements LikeInterface {
  #pool: Pool;

  constructor(pool: Pool) {
    this.#pool = pool;
  }

  async getLikes(): Promise<LikeEntity[]> {
    const response = await this.#pool.query(
      'SELECT * FROM "likes" ORDER BY id ASC LEFT JOIN "users" ON "likes".user_id = "users".id',
    );
    return response.rows;
  }

  async createLike({ postId,userId }: CreateLikeDTO): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "likes" (postId, userId) VALUES ($1, $2)',
      [postId, userId],
    );
  }

  async getLikeById(id: string): Promise<LikeEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "likes" WHERE id = $1',
      [id],
    );
    return response.rows[0];
  }

  async updateLike({ id, postId,userId }: UpdateLikeDTO) {
    await this.#pool.query(
      `UPDATE "likes" SET postId = $1, userId = $2 WHERE id = $4`,
      [postId, userId, id],
    );
  }

  async deleteLike(id: string) {
    await this.#pool.query('DELETE FROM "likes" WHERE id = $1', [id]);
  }
}
