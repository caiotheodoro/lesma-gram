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
      'SELECT * FROM "posts" ORDER BY id ASC LEFT JOIN "users" ON "posts".user_id = "users".id',
    );
    return response.rows;
  }

  async createPost({ content, image }: CreatePostDTO): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "posts" (content, image, createdAt) VALUES ($1, $2, $3)',
      [content, image, new Date().toISOString()],
    );
  }

  async getPostById(id: string): Promise<PostEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "posts" WHERE id = $1',
      [id],
    );
    return response.rows[0];
  }

  async updatePost({ id, content, image }: UpdatePostDTO) {
    await this.#pool.query(
      `UPDATE "posts" SET content = $1, image = $2, createdAt = $3 WHERE id = $4`,
      [content, image, new Date().toISOString(), id],
    );
  }

  async deletePost(id: string) {
    await this.#pool.query('DELETE FROM "posts" WHERE id = $1', [id]);
  }
}
