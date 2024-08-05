import { Pool } from "pg";
import { CreatePostDTO, UpdatePostDTO } from "../dtos";
import { PostEntity } from "../../../@types/entities";
import { PostInterface } from "./post.interface";

export class PostRepository implements PostInterface {
  #pool: Pool;

  constructor(pool: Pool) {
    this.#pool = pool;
  }

  async getPosts(): Promise<PostEntity[]> {
    const response = await this.#pool.query(
      'SELECT * FROM "post" ORDER BY id ASC',
    );
    return response.rows;
  }

  async createPost({ title, description, date }: CreatePostDTO): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "post" (title, description, date) VALUES ($1, $2, $3)',
      [title, description, date],
    );
  }

  async getPostById(id: string): Promise<PostEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "post" WHERE id = $1',
      [id],
    );
    return response.rows[0];
  }

  async updatePost({ id, title, description, date }: UpdatePostDTO) {
    await this.#pool.query(
      `UPDATE "post" SET title = $1, description = $2, date = $3 WHERE id = $4`,
      [title, description, date, id],
    );
  }

  async deletePost(id: string) {
    await this.#pool.query('DELETE FROM "user_post" WHERE postId = $1', [id]);
    await this.#pool.query('DELETE FROM "post" WHERE id = $1', [id]);
  }
}
