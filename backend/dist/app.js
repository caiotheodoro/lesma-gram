"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const body_parser_1 = __importDefault(require("body-parser"));
const database_1 = require("./database");
const modules_1 = require("./modules");
const controller_1 = require("./modules/auth/controller");
const auth_1 = require("./middlewares/auth");
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(body_parser_1.default.json());
const userController = new modules_1.UserController(database_1.pool);
const postsController = new modules_1.PostController(database_1.pool);
const authController = new controller_1.AuthController(database_1.pool);
app.use("/users", auth_1.authMiddleware, userController.getRouter());
app.use("/posts", /*authMiddleware,*/ postsController.getRouter());
app.use("/auth", authController.getRouter());
app.listen(3025, () => {
    console.log("Listening to 3025");
});
