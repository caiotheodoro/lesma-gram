import { Pool } from "pg";
import { CreatePostDTO, UpdatePostDTO } from "../dtos";
import { PostEntity } from "../../../@types/entities";
import { PostInterface } from "./post.interface";
import { PostLikeEntity } from "../../../@types/entities/post_like";

export class PostRepository implements PostInterface {
  #pool: Pool;

  constructor(pool: Pool) {
    this.#pool = pool;
  }

  async getPosts(idUser: string): Promise<PostLikeEntity[]> {
    const response = await this.#pool.query(
      'SELECT posts.id AS "postId", ' +
      'posts.content, ' +
      'posts.image, ' +
      'posts."createdAt" AS "createdAt", ' +
      'users.id AS "userId", ' +
      'user_settings."isAnonymous" AS "isAnonymous", ' +
      'users.name AS name, ' +
      'CASE WHEN likes.id IS NOT NULL THEN true ELSE false END AS "isLiked" ' +
      'FROM posts ' +
      'JOIN users ON posts."userId" = users.id ' +
      'LEFT JOIN likes ON posts.id = likes."postId" AND likes."userId" = $1 ' +
      'LEFT JOIN "user_settings" ON "user_settings"."userId" = users.id ' +
      'ORDER BY posts."createdAt" DESC',
      [idUser]
    );
    return response.rows;
  }

  async getPostsByUserLiked(idUser: string): Promise<PostLikeEntity[]> {
    const response = await this.#pool.query(
      'SELECT posts.id AS "postId", ' +
      'posts.content, ' +
      'posts.image, ' +
      'posts."createdAt" AS "createdAt", ' +
      'users.id AS "userId", ' +
      'users.name AS name, ' +
      'CASE WHEN likes.id IS NOT NULL THEN true ELSE false END AS "isLiked" ' +
      'FROM posts ' +
      'JOIN users ON posts."userId" = users.id ' +
      'JOIN likes ON posts.id = likes."postId" AND likes."userId" = $1 ' +
      'ORDER BY posts."createdAt" DESC',
      [idUser]
    );
    return response.rows;
  }

  async createPost({ content, image, idUser }: CreatePostDTO): Promise<void> {
    await this.#pool.query(
      'INSERT INTO "posts" (content, image, "userId") VALUES ($1, $2, $3)',
      [content, image, idUser]
    );
  }

  async getPostById(id: string): Promise<PostEntity> {
    const response = await this.#pool.query(
      'SELECT * FROM "posts" WHERE id = $1',
      [id]
    );
    return response.rows[0];
  }

  async getPostsByUsuario(idUser: string): Promise<PostEntity[]> {
    // const response = await this.#pool.query(
    //   'SELECT posts.*, COUNT(likes.id) AS likes_count FROM "posts" LEFT JOIN "likes" ON "posts".id = "likes".post_id WHERE "posts".user_id = $1 GROUP BY posts.id ORDER BY posts.id ASC',
    //   [idUser],
    // );
    const response = await this.#pool.query(
      'SELECT posts.* FROM "posts" WHERE posts."userId" = $1 GROUP BY posts.id ORDER BY posts."createdAt" DESC',
      [idUser]
    );

    return response.rows;
  }

  async updatePost({ id, content, image }: UpdatePostDTO) {
    await this.#pool.query(
      `UPDATE "posts" SET content = $1, image = $2 WHERE id = $3`,
      [content, image, id]
    );
  }

  async deletePost(id: string) {
    await this.#pool.query('DELETE FROM "posts" WHERE id = $1', [id]);
  }
}
