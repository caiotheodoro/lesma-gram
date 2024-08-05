import { PostEntity } from "../../../@types/entities";
import { CreatePostDTO, UpdatePostDTO } from "../dtos";

export interface PostInterface {
  getPosts(): Promise<PostEntity[]>;
  getPostById(id: string): Promise<PostEntity>;
  createPost(data: CreatePostDTO): Promise<void>;
  updatePost(data: UpdatePostDTO): Promise<void>;
  deletePost(id: string): Promise<void>;
}
