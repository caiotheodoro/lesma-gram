import express, { Request, Response, Router } from "express";
import { Pool } from "pg";
import { ActivityRepository } from "./repository/activity";
import { CreateActivityDTO, UpdateActivityDTO } from "./dtos";

export class ActivityController {
  private router: Router;
  private activityRepository: ActivityRepository;

  constructor(pool: Pool) {
    this.router = express.Router();
    this.activityRepository = new ActivityRepository(pool);
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
      const activities = await this.activityRepository.getActivities();
      res.json(activities);
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  create = async (req: Request, res: Response) => {
    try {
      const { title, description, date } = req.body;
      const createActivityDTO: CreateActivityDTO = { title, description, date };
      await this.activityRepository.createActivity(createActivityDTO);
      res.status(201).json({ message: "Atividade Criada com sucesso" });
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  getById = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const activity = await this.activityRepository.getActivityById(id);
      if (!activity) {
        res.status(404).json({ message: "Atividade nao encontrada" });
      } else {
        res.json(activity);
      }
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  update = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const { title, description, date } = req.body;
      const updateActivityDTO: UpdateActivityDTO = { id, title, description, date };
      await this.activityRepository.updateActivity(updateActivityDTO);
      res.json({ message: "Atividade Atualizada com sucesso" });
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  delete = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      await this.activityRepository.deleteActivity(id);
      res.json({ message: "Atividade Deletada com sucesso" });
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  getRouter() {
    return this.router;
  }
}
