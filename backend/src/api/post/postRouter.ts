import { OpenAPIRegistry } from '@asteasolutions/zod-to-openapi';
import express, { Request, Response, Router } from 'express';
import { z } from 'zod';

import { GetPostSchema, PostSchema } from '@/api/post/postModel';
import { postService } from '@/api/post/postService';
import { createApiResponse } from '@/api-docs/openAPIResponseBuilders';
import { handleServiceResponse, validateRequest } from '@/common/utils/httpHandlers';

export const postRegistry = new OpenAPIRegistry();

postRegistry.register('User', PostSchema);

export const postRouter: Router = (() => {
  const router = express.Router();

  postRegistry.registerPath({
    method: 'get',
    path: '/posts',
    tags: ['User'],
    responses: createApiResponse(z.array(PostSchema), 'Success'),
  });

  router.get('/', async (_req: Request, res: Response) => {
    const serviceResponse = await postService.findAll();
    handleServiceResponse(serviceResponse, res);
  });

  postRegistry.registerPath({
    method: 'get',
    path: '/posts/{id}',
    tags: ['User'],
    request: { params: GetPostSchema.shape.params },
    responses: createApiResponse(PostSchema, 'Success'),
  });

  router.get('/:id', validateRequest(GetPostSchema), async (req: Request, res: Response) => {
    const id = parseInt(req.params.id, 10);
    const serviceResponse = await postService.findById(id);
    handleServiceResponse(serviceResponse, res);
  });

  return router;
})();
