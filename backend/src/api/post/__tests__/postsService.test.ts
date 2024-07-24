import { StatusCodes } from 'http-status-codes';
import { Mock, vi } from 'vitest';

import { Post } from '@/api/post/postModel';
import { postRepository } from '@/api/post/postRepository';
import { postService } from '@/api/post/postService';

vi.mock('@/api/post/postRepository');
vi.mock('@/server', () => ({
  ...vi.importActual('@/server'),
  logger: {
    error: vi.fn(),
  },
}));

describe('postService', () => {
  const mockPosts: Post[] = [
    { id: 1, content: 'Alice', image: 'a.png', timestamp: new Date(), user_id: '1' },
    { id: 2, content: 'Bob', image: 'a.png', timestamp: new Date(), user_id: '1' },
  ];

  describe('findAll', () => {
    it('return all posts', async () => {
      // Arrange
      (postRepository.findAllAsync as Mock).mockReturnValue(mockPosts);

      // Act
      const result = await postService.findAll();

      // Assert
      expect(result.statusCode).toEqual(StatusCodes.OK);
      expect(result.success).toBeTruthy();
      expect(result.message).toContain('Posts found');
      expect(result.responseObject).toEqual(mockPosts);
    });

    it('returns a not found error for no posts found', async () => {
      // Arrange
      (postRepository.findAllAsync as Mock).mockReturnValue(null);

      // Act
      const result = await postService.findAll();

      // Assert
      expect(result.statusCode).toEqual(StatusCodes.NOT_FOUND);
      expect(result.success).toBeFalsy();
      expect(result.message).toContain('No Posts found');
      expect(result.responseObject).toBeNull();
    });

    it('handles errors for findAllAsync', async () => {
      // Arrange
      (postRepository.findAllAsync as Mock).mockRejectedValue(new Error('Database error'));

      // Act
      const result = await postService.findAll();

      // Assert
      expect(result.statusCode).toEqual(StatusCodes.INTERNAL_SERVER_ERROR);
      expect(result.success).toBeFalsy();
      expect(result.message).toContain('Error finding all posts');
      expect(result.responseObject).toBeNull();
    });
  });

  describe('findById', () => {
    it('returns a post for a valid ID', async () => {
      // Arrange
      const testId = 1;
      const mockPost = mockPosts.find((post) => post.id === testId);
      (postRepository.findByIdAsync as Mock).mockReturnValue(mockPost);

      // Act
      const result = await postService.findById(testId);

      // Assert
      expect(result.statusCode).toEqual(StatusCodes.OK);
      expect(result.success).toBeTruthy();
      expect(result.message).toContain('Post found');
      expect(result.responseObject).toEqual(mockPost);
    });

    it('handles errors for findByIdAsync', async () => {
      // Arrange
      const testId = 1;
      (postRepository.findByIdAsync as Mock).mockRejectedValue(new Error('Database error'));

      // Act
      const result = await postService.findById(testId);

      // Assert
      expect(result.statusCode).toEqual(StatusCodes.INTERNAL_SERVER_ERROR);
      expect(result.success).toBeFalsy();
      expect(result.message).toContain(`Error finding post with id ${testId}`);
      expect(result.responseObject).toBeNull();
    });

    it('returns a not found error for non-existent ID', async () => {
      // Arrange
      const testId = 1;
      (postRepository.findByIdAsync as Mock).mockReturnValue(null);

      // Act
      const result = await postService.findById(testId);

      // Assert
      expect(result.statusCode).toEqual(StatusCodes.NOT_FOUND);
      expect(result.success).toBeFalsy();
      expect(result.message).toContain('Post not found');
      expect(result.responseObject).toBeNull();
    });
  });
});
