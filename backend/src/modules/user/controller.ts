import express, { Request, Response, Router } from "express";
import { Pool } from "pg";
import { UserRepository } from "./repository/user";
import { CreateUserDTO, UpdateUserDTO } from "./dtos";
import bcrypt from 'bcrypt';
import dotenv from 'dotenv';
import { authMiddleware } from "../../middlewares/auth";

dotenv.config();

export class UserController {
  private router: Router;
  private userRepository: UserRepository;

  constructor(pool: Pool) {
    this.router = express.Router();
    this.userRepository = new UserRepository(pool);
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.get("/",authMiddleware, this.getAll);
    this.router.post("/", this.create);
    this.router.get("/:id",authMiddleware, this.getById);
    this.router.put("/:id",authMiddleware, this.update);
    this.router.delete("/:id",authMiddleware, this.delete);
  }

  getAll = async (req: Request, res: Response) => {
    try {
      const users = await this.userRepository.getUsers();
      res.json(users);
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  create = async (req: Request, res: Response) => {
    try {
      const { name, email, password } = req.body;

      const hash = await bcrypt.hash(password, 10);
      const createUserDTO: CreateUserDTO = { name, email, password: hash };

      await this.userRepository.createUser(createUserDTO);
      res.status(201).json({ message: "Usuario Criado com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
      console.log(error)
    }
  };

  getById = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const user = await this.userRepository.getUserById(id);
      if (!user) {
        res.status(404).json({ message: "User not found" });
      } else {
        res.json(user);
      }
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  update = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const { name, email, password } = req.body;
      const updateUserDTO: UpdateUserDTO = { id, name, email, password };
      await this.userRepository.updateUser(updateUserDTO);
      res.json({ message: "User Atualizada com sucesso" });
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  delete = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      await this.userRepository.deleteUser(id);
      res.json({ message: "User Deletada com sucesso" });
    } catch (error) {
      
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  getRouter() {
    return this.router;
  }
}
