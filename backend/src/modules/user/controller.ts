import express, { Request, Response, Router } from "express";
import { Pool } from "pg";
import { UserRepository } from "./repository/user";
import { CreateUserDTO, UpdateUserDTO } from "./dtos";
import bcrypt from "bcrypt";
import dotenv from "dotenv";
import { authMiddleware } from "../../middlewares/auth";
import jwt from "jsonwebtoken";

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
    this.router.get("/", authMiddleware, this.getAll);
    this.router.post("/", this.create);
    this.router.get("/:id", authMiddleware, this.getById);
    this.router.get("/search/:name", authMiddleware, this.getByName);
    this.router.put("/:id", authMiddleware, this.update);
    this.router.delete("/:id", authMiddleware, this.delete);
    this.router.get("/profile/me", authMiddleware, this.getUserByIdFromToken);
    this.router.get("/settings/:userId", authMiddleware, this.getUserSettings);
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

      const existingUser = await this.userRepository.getUserByEmail(email);
      if (existingUser) {
        return res.status(400).json({ message: "Email already exists" });
      }

      const hash = await bcrypt.hash(password, 10);
      const createUserDTO: CreateUserDTO = { name, email, password: hash };

      const userId = await this.userRepository.createUser(createUserDTO);
      await this.userRepository.createUserSettings(userId);
      res.status(201).json({ message: "Usuario Criado com sucesso" });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
      console.log(error);
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

  getByName = async (req: Request, res: Response) => {
    try {
      const { name } = req.params;
      const users = await this.userRepository.getUsersByName(name);
      if (!users) {
        res.status(404).json({ message: "Users not found" });
      } else {
        res.json(users);
      }
    } catch (error) {
      res.status(500).json({ message: "Internal Server Error!" });
    }
  };

  update = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const { name, email, currentPassword, password, isAnonymous } = req.body;

      const user = await this.userRepository.getUserById(id);

      if (await bcrypt.compare(currentPassword, user.password)) {
        const hash = await bcrypt.hash(password, 10);
        const updateUserDTO: UpdateUserDTO = {
          id,
          name,
          email,
          password: hash,
        };
        await this.userRepository.updateUser(updateUserDTO);
        await this.userRepository.updateUserSettings(id, isAnonymous);
        res.json({ message: "User Atualizada com sucesso" });
      } else {
        res.status(400).json({ message: "Senha atual incorreta" });
      }
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

  getUserByIdFromToken = async (req: Request, res: Response) => {
    try {
      const token = req.headers.authorization?.split(" ")[1];
      const decodedToken = jwt.verify(
        token?.replace("Bearer ", "") as string,
        process.env.JWT_SECRET as string
      ) as { id: string };
      const userId = decodedToken.id;
      const user = await this.userRepository.getUserById(userId);
      if (!user) {
        res.status(404).json({ message: "User not foundb" });
      } else {
        res.json(user);
      }
    } catch (error) {
      res.status(500).json({ message: "Internal Server Error!" });
    }
  };

  getUserSettings = async (req: Request, res: Response) => {
    try {
      const { userId } = req.params;
      const userSettings = await this.userRepository.getUserSettings(userId);
      if (!userSettings) {
        res.status(404).json({ message: "User settings not found" });
      } else {
        res.json(userSettings);
      }
    } catch (error) {
      res.status(500).json({ message: "Internal Server Error!" });
    }
  };

  getRouter() {
    return this.router;
  }
}
