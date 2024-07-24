import { extendZodWithOpenApi } from '@asteasolutions/zod-to-openapi';
import { z } from 'zod';

extendZodWithOpenApi(z);

export type Post = z.infer<typeof PostSchema>;
export const PostSchema = z.object({
  id: z.number(),
  content: z.string(),
  image: z.string(),
  timestamp: z.date(),
  user_id: z.string().uuid(),
});

export const GetPostSchema = z.object({
  params: z.object({ id: z.string().uuid() }),
});
