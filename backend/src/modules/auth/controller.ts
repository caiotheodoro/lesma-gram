import express, { Request, Response, Router } from "express";
import { Pool } from "pg";
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { UserRepository } from "../user/repository/user";



export class AuthController {
  private router: Router;

  private userRepository: UserRepository;

  constructor(pool: Pool) {
    this.router = express.Router();
    this.userRepository = new UserRepository(pool);
    this.initializeRoutes();
  }

  private initializeRoutes() {
    this.router.post("/", this.login);
  }


  login = async (req: Request, res: Response) => {
    try {
      const { email, password } = req.body;

      
      const user = await this.userRepository.getUserByEmail(email);
      
      if(!user || !(await bcrypt.compare(password, user.password))){
        res.status(400).json({ message: "Email ou senha Incorretos." });
      }
   
      
      const access_token = jwt.sign({ id: user.id }, process.env.JWT_SECRET as string, {
        expiresIn: "24h",
      });


      res.status(201).json({ access_token });
    } catch (error) {
      res.status(500).json({ message: "Erro Interno!" });
    }
  };

  

  getRouter() {
    return this.router;
  }
}
