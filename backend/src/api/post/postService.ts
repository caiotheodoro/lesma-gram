import { StatusCodes } from 'http-status-codes';

import { Post } from '@/api/post/postModel';
import { postRepository } from '@/api/post/postRepository';
import { ResponseStatus, ServiceResponse } from '@/common/models/serviceResponse';
import { logger } from '@/server';

export const postService = {
  findAll: async (): Promise<ServiceResponse<Post[] | null>> => {
    try {
      const posts = await postRepository.findAllAsync();
      if (!posts) {
        return new ServiceResponse(ResponseStatus.Failed, 'No Posts found', null, StatusCodes.NOT_FOUND);
      }
      return new ServiceResponse<Post[]>(ResponseStatus.Success, 'Posts found', posts, StatusCodes.OK);
    } catch (ex) {
      const errorMessage = `Error finding all posts: $${(ex as Error).message}`;
      logger.error(errorMessage);
      return new ServiceResponse(ResponseStatus.Failed, errorMessage, null, StatusCodes.INTERNAL_SERVER_ERROR);
    }
  },

  findById: async (id: number): Promise<ServiceResponse<Post | null>> => {
    try {
      const post = await postRepository.findByIdAsync(id);
      if (!post) {
        return new ServiceResponse(ResponseStatus.Failed, 'Post not found', null, StatusCodes.NOT_FOUND);
      }
      return new ServiceResponse<Post>(ResponseStatus.Success, 'Post found', post, StatusCodes.OK);
    } catch (ex) {
      const errorMessage = `Error finding post with id ${id}:, ${(ex as Error).message}`;
      logger.error(errorMessage);
      return new ServiceResponse(ResponseStatus.Failed, errorMessage, null, StatusCodes.INTERNAL_SERVER_ERROR);
    }
  },
};
