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
      'SELECT posts.*, COUNT(likes.id) AS likes_count FROM "posts" LEFT JOIN "likes" ON "posts".id = "likes".post_id GROUP BY posts.id ORDER BY posts.id ASC',
    );
    return response.rows;
  }

  async createPost({ content, image }: CreatePostDTO): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "posts" (content, image) VALUES ($1, $2)',
      [content, image],
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
      `UPDATE "posts" SET content = $1, image = $2 WHERE id = $3`,
      [content, image, id],
    );
  }

  async deletePost(id: string) {
    await this.#pool.query('DELETE FROM "posts" WHERE id = $1', [id]);
  }
}
