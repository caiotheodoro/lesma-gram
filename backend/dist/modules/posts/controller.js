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
exports.PostController = void 0;
const express_1 = __importDefault(require("express"));
const post_1 = require("./repository/post");
class PostController {
    constructor(pool) {
        this.getAll = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const posts = yield this.postRepository.getPosts();
                res.json(posts);
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.create = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { title, description, date } = req.body;
                const createPostDTO = { title, description, date };
                yield this.postRepository.createPost(createPostDTO);
                res.status(201).json({ message: "Atividade Criada com sucesso" });
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.getById = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                const post = yield this.postRepository.getPostById(id);
                if (!post) {
                    res.status(404).json({ message: "Atividade nao encontrada" });
                }
                else {
                    res.json(post);
                }
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.update = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                const { title, description, date } = req.body;
                const updatePostDTO = { id, title, description, date };
                yield this.postRepository.updatePost(updatePostDTO);
                res.json({ message: "Atividade Atualizada com sucesso" });
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.delete = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { id } = req.params;
                yield this.postRepository.deletePost(id);
                res.json({ message: "Atividade Deletada com sucesso" });
            }
            catch (error) {
                res.status(500).json({ message: "Erro Interno!" });
            }
        });
        this.router = express_1.default.Router();
        this.postRepository = new post_1.PostRepository(pool);
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
exports.PostController = PostController;
