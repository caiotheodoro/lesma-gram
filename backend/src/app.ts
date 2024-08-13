import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import swaggerUi  from 'swagger-ui-express';
import YAML from 'yamljs';
import { pool } from "./database";
import { PostController, UserController } from "./modules";
import { AuthController } from "./modules/auth/controller";
import { authMiddleware } from "./middlewares/auth";
const app = express();
app.use(cors());
app.use(bodyParser.json());

const swaggerDocument = YAML.load('swagger.yaml');

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));


const userController = new UserController(pool);
const postsController = new PostController(pool);
const authController = new AuthController(pool);

app.use("/users",  userController.getRouter());
app.use("/posts", authMiddleware, postsController.getRouter());
app.use("/auth", authController.getRouter());

app.listen(3025, () => {
  console.log("Listening to 3025");
});
