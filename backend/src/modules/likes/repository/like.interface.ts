import { LikeEntity } from "../../../@types/entities";
import { CreateLikeDTO, UpdateLikeDTO } from "../dtos";

export interface LikeInterface {
  getLikes(): Promise<LikeEntity[]>;
  getLikeById(id: string): Promise<LikeEntity>;
  createLike(data: CreateLikeDTO): Promise<void>;
  updateLike(data: UpdateLikeDTO): Promise<void>;
  deleteLike(postId: string, userId: string): Promise<void>;
}
