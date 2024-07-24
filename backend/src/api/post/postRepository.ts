import pool from '@/database/db';

import { Post } from './postModel';

export const posts: Post[] = [{ id: 1, content: 'Alice', image: 'alice.jpg', timestamp: new Date(), user_id: '1' }];
export const postRepository = {
  findAllAsync: async (): Promise<Post[]> => {
    const response = await pool.query('SELECT * FROM posts'); //TODO: left join with users table and likes, count likes

    return response.rows;
  },

  findByIdAsync: async (id: number): Promise<Post | null> => {
    const response = await pool.query('SELECT * FROM posts WHERE id = $1', [id]);

    return response.rows[0] || null;
  },
};
