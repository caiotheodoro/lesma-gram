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
exports.AuthController = void 0;
const express_1 = __importDefault(require("express"));
const bcrypt_1 = __importDefault(require("bcrypt"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const user_1 = require("../user/repository/user");
class AuthController {
    constructor(pool) {
        this.login = (req, res) => __awaiter(this, void 0, void 0, function* () {
            try {
                const { email, password } = req.body;
                const user = yield this.userRepository.getUserByEmail(email);
                if (!user || !(yield bcrypt_1.default.compare(password, user.password))) {
                    res.status(400).json({ message: "Email ou senha Incorretos." });
                }
                const access_token = jsonwebtoken_1.default.sign({ id: user.id }, process.env.JWT_SECRET, {
                    expiresIn: "24h",
                });
                res.status(201).json({ access_token });
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
        this.router.post("/", this.login);
    }
    getRouter() {
        return this.router;
    }
}
exports.AuthController = AuthController;
