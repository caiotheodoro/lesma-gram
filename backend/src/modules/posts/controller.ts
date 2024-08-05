import express, { Request, Response, Router } from "express";
import { Pool } from "pg";
import { PostRepository } from "./repository/post";
import { CreatePostDTO, UpdatePostDTO } from "./dtos";

export class PostController {
  private router: Router;
  private postRepository: PostRepository;

  constructor(pool: Pool) {
    this.router = express.Router();
    this.postRepository = new PostRepository(pool);
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.get("/", this.getAll);
    this.router.post("/", this.create);
    this.router.get("/:id", this.getById);
    this.router.put("/:id", this.update);
    this.router.delete("/:id", this.delete);
  }

  getAll = async (req: Request, res: Response) => {
    try {
      const posts = await this.postRepository.getPosts();
      res.json(posts);
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  create = async (req: Request, res: Response) => {
    try {
      const { title, description, date } = req.body;
      const createPostDTO: CreatePostDTO = { title, description, date };
      await this.postRepository.createPost(createPostDTO);
      res.status(201).json({ message: "Atividade Criada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  getById = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const post = await this.postRepository.getPostById(id);
      if (!post) {
        res.status(404).json({ message: "Atividade nao encontrada" });
      } else {
        res.json(post);
      }
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  update = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const { title, description, date } = req.body;
      const updatePostDTO: UpdatePostDTO = { id, title, description, date };
      await this.postRepository.updatePost(updatePostDTO);
      res.json({ message: "Atividade Atualizada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  delete = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      await this.postRepository.deletePost(id);
      res.json({ message: "Atividade Deletada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  getRouter() {
    return this.router;
  }
}
