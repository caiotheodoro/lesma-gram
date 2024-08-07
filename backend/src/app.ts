import express from "express";
import cors from "cors";
import bodyParser from "body-parser";
import { pool } from "./database";
import { LikeController, PostController, UserController } from "./modules";
import { AuthController } from "./modules/auth/controller";
import { authMiddleware } from "./middlewares/auth";
const app = express();
app.use(cors());
app.use(bodyParser.json());

const userController = new UserController(pool);
const postsController = new PostController(pool);
const likesController = new LikeController(pool);
const authController = new AuthController(pool);

app.use("/users", authMiddleware, userController.getRouter());
app.use("/posts", /*authMiddleware,*/ postsController.getRouter());
app.use("/likes", /*authMiddleware,*/ likesController.getRouter());
app.use("/auth", authController.getRouter());

app.listen(3025, () => {
  console.log("Listening to 3025");
});
