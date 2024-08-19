import { BaseEntity } from ".";

export interface PostLikeEntity extends BaseEntity {
  postId: string;
  content: string;
  image: string;
  createdAt: string;
  userId?: string;
  name: string;
  isLiked: boolean;
}
