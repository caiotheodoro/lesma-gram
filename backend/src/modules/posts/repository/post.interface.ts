import { PostEntity } from "../../../@types/entities";
import { PostLikeEntity } from "../../../@types/entities/post_like";
import { CreatePostDTO, UpdatePostDTO } from "../dtos";

export interface PostInterface {
  getPosts(idUser: string): Promise<PostLikeEntity[]>;
  getPostById(id: string): Promise<PostEntity>;
  createPost(data: CreatePostDTO): Promise<void>;
  updatePost(data: UpdatePostDTO): Promise<void>;
  deletePost(id: string): Promise<void>;
}
