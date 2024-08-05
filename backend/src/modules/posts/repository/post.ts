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
      'SELECT * FROM "posts" ORDER BY id ASC',
    );
    return response.rows;
  }

  async createPost({ title, description, date }: CreatePostDTO): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "posts" (title, description, date) VALUES ($1, $2, $3)',
      [title, description, date],
    );
  }

  async getPostById(id: string): Promise<PostEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "posts" WHERE id = $1',
      [id],
    );
    return response.rows[0];
  }

  async updatePost({ id, title, description, date }: UpdatePostDTO) {
    await this.#pool.query(
      `UPDATE "posts" SET title = $1, description = $2, date = $3 WHERE id = $4`,
      [title, description, date, id],
    );
  }

  async deletePost(id: string) {
    await this.#pool.query('DELETE FROM "posts" WHERE id = $1', [id]);
  }
}
