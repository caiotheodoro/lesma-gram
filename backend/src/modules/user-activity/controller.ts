import express, { Request, Response, Router } from "express";
import { Pool } from "pg";
import { UserActivityRepository } from "./repository/user-activity";
import { CreateUserActivityDTO, UpdateUserActivityDTO } from "./dtos";

export class UserActivityController {
  private router: Router;
  private userActivityRepository: UserActivityRepository;

  constructor(pool: Pool) {
    this.router = express.Router();
    this.userActivityRepository = new UserActivityRepository(pool);
    this.routes();
  }

  private routes() {
    this.router.get("/", this.getAll);
    this.router.get("/:id", this.getById);
    this.router.post("/", this.create);
    this.router.put("/:id", this.update);
    this.router.delete("/:id", this.delete);
  }

  getAll = async (req: Request, res: Response) => {
    try {
      const activities = await this.userActivityRepository.getActivities();
      res.json(activities);
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
      console.log(error);
    }
  };

  getById = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const activity =
        await this.userActivityRepository.getUserActivityById(id);
      if (!activity) {
        res
          .status(404)
          .json({ message: "Atividade do usuário não encontrada" });
      } else {
        res.json(activity);
      }
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  create = async (req: Request, res: Response) => {
    try {
      const { userId, activityId, deliver, grade } = req.body;
      const createUserActivityDTO: CreateUserActivityDTO = {
        userId: userId.id as string,
        activityId,
        deliver,
        grade,
      };
      await this.userActivityRepository.createUserActivity(
        createUserActivityDTO,
      );
      res
        .status(201)
        .json({ message: "Atividade do usuário Criada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
      console.log(error);
    }
  };

  update = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const { userId, activityId, deliver, grade } = req.body;
      const updateUserActivityDTO: UpdateUserActivityDTO = {
        id,
        userId,
        activityId,
        deliver,
        grade,
      };
      await this.userActivityRepository.updateUserActivity(
        updateUserActivityDTO,
      );
      res.json({ message: "Atividade do usuário Atualizada com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  delete = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      await this.userActivityRepository.deleteUserActivity(id);
      res.json({ message: "Atividade do usuario deletada!" });
    } catch (error) {
      res.status(500).json({ message: "Erro interno" });
    }
  };

  getRouter() {
    return this.router;
  }
}
