"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserController = void 0;
const express_1 = __importDefault(require("express"));
const user_1 = require("./repository/user");
const bcrypt_1 = __importDefault(require("bcrypt"));
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config();
class UserController {
    constructor(pool) {
        this.getAll = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const users = yield this.userRepository.getUsers();
                res.json(users);
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.create = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { name, email, password } = req.body;
                const hash = yield bcrypt_1.default.hash(password, 10);
                const createUserDTO = { name, email, password: hash };
                yield this.userRepository.createUser(createUserDTO);
                res.status(201).json({ message: "Usuario Criado com sucesso" });
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
                console.log(error);
            }
        });
        this.getById = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                const user = yield this.userRepository.getUserById(id);
                if (!user) {
                    res.status(404).json({ message: "User not found" });
                }
                else {
                    res.json(user);
                }
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.update = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                const { name, email, password } = req.body;
                const updateUserDTO = { id, name, email, password };
                yield this.userRepository.updateUser(updateUserDTO);
                res.json({ message: "User Atualizada com sucesso" });
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.delete = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                yield this.userRepository.deleteUser(id);
                res.json({ message: "User Deletada com sucesso" });
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.router = express_1.default.Router();
        this.userRepository = new user_1.UserRepository(pool);
        this.initializeRoutes();
    }
    initializeRoutes() {
        this.router.get("/", this.getAll);
        this.router.post("/", this.create);
        this.router.get("/:id", this.getById);
        this.router.put("/:id", this.update);
        this.router.delete("/:id", this.delete);
    }
    getRouter() {
        return this.router;
    }
}
exports.UserController = UserController;
