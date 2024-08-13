import { BaseEntity } from ".";


export interface LikeEntity  extends BaseEntity {
  postId: string;
  userId: string;
}
