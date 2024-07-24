import { StatusCodes } from 'http-status-codes';
import request from 'supertest';

import { Post } from '@/api/post/postModel';
import { posts } from '@/api/post/postRepository';
import { ServiceResponse } from '@/common/models/serviceResponse';
import { app } from '@/server';

describe('Post API Endpoints', () => {
  describe('GET /posts', () => {
    it('should return a list of posts', async () => {
      // Act
      const response = await request(app).get('/posts');
      const responseBody: ServiceResponse<Post[]> = response.body;

      // Assert
      expect(response.statusCode).toEqual(StatusCodes.OK);
      expect(responseBody.success).toBeTruthy();
      expect(responseBody.message).toContain('Posts found');
      expect(responseBody.responseObject.length).toEqual(posts.length);
      responseBody.responseObject.forEach((post, index) => comparePosts(posts[index] as Post, post));
    });
  });

  describe('GET /posts/:id', () => {
    it('should return a post for a valid ID', async () => {
      // Arrange
      const testId = 1;
      const expectedPost = posts.find((post) => post.id === testId) as Post;

      // Act
      const response = await request(app).get(`/posts/${testId}`);
      const responseBody: ServiceResponse<Post> = response.body;

      // Assert
      expect(response.statusCode).toEqual(StatusCodes.OK);
      expect(responseBody.success).toBeTruthy();
      expect(responseBody.message).toContain('Post found');
      if (!expectedPost) throw new Error('Invalid test data: expectedPost is undefined');
      comparePosts(expectedPost, responseBody.responseObject);
    });

    it('should return a not found error for non-existent ID', async () => {
      // Arrange
      const testId = Number.MAX_SAFE_INTEGER;

      // Act
      const response = await request(app).get(`/posts/${testId}`);
      const responseBody: ServiceResponse = response.body;

      // Assert
      expect(response.statusCode).toEqual(StatusCodes.NOT_FOUND);
      expect(responseBody.success).toBeFalsy();
      expect(responseBody.message).toContain('Post not found');
      expect(responseBody.responseObject).toBeNull();
    });

    it('should return a bad request for invalid ID format', async () => {
      // Act
      const invalidInput = 'abc';
      const response = await request(app).get(`/posts/${invalidInput}`);
      const responseBody: ServiceResponse = response.body;

      // Assert
      expect(response.statusCode).toEqual(StatusCodes.BAD_REQUEST);
      expect(responseBody.success).toBeFalsy();
      expect(responseBody.message).toContain('Invalid input');
      expect(responseBody.responseObject).toBeNull();
    });
  });
});

function comparePosts(mockPost: Post, responsePost: Post) {
  if (!mockPost || !responsePost) {
    throw new Error('Invalid test data: mockPost or responsePost is undefined');
  }

  expect(responsePost.id).toEqual(mockPost.id);
  expect(responsePost.content).toEqual(mockPost.content);
  expect(responsePost.image).toEqual(mockPost.image);
  expect(responsePost.user_id).toEqual(mockPost.user_id);
  expect(new Date(responsePost.timestamp)).toEqual(mockPost.timestamp);
}
