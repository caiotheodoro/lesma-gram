import express, { Request, Response, Router } from "express";
import { Pool } from "pg";
import { LikeRepository } from "./repository/like";
import { CreateLikeDTO, UpdateLikeDTO } from "./dtos";

export class LikeController {
  private router: Router;
  private postRepository: LikeRepository;

  constructor(pool: Pool) {
    this.router = express.Router();
    this.postRepository = new LikeRepository(pool);
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.get("/", this.getAll);
    this.router.post("/", this.create);
    this.router.get("/:id", this.getById);
    this.router.put("/:id", this.update);
    this.router.delete("/:postId/:userId", this.delete);
  }

  getAll = async (req: Request, res: Response) => {
    try {
      const posts = await this.postRepository.getLikes();
      res.json(posts);
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  create = async (req: Request, res: Response) => {
    try {
      const { postId, userId } = req.body;
      const createLikeDTO: CreateLikeDTO = { postId, userId };
      await this.postRepository.createLike(createLikeDTO);
      res.status(201).json({ message: "Atividade Criada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  getById = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const post = await this.postRepository.getLikeById(id);
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
      const { postId, userId } = req.body;
      const updateLikeDTO: UpdateLikeDTO = { id, postId, userId };
      await this.postRepository.updateLike(updateLikeDTO);
      res.json({ message: "Atividade Atualizada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  delete = async (req: Request, res: Response) => {
    try {
      const { postId, userId } = req.params;
      await this.postRepository.deleteLike(postId, userId);
      res.json({ message: "Atividade Deletada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  getRouter() {
    return this.router;
  }
}
