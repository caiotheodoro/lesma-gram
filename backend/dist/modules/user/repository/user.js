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
var __classPrivateFieldSet = (this && this.__classPrivateFieldSet) || function (receiver, state, value, kind, f) {
    if (kind === "m") throw new TypeError("Private method is not writable");
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
    return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
};
var __classPrivateFieldGet = (this && this.__classPrivateFieldGet) || function (receiver, state, kind, f) {
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
    return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
};
var _UserRepository_pool;
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserRepository = void 0;
class UserRepository {
    constructor(pool) {
        _UserRepository_pool.set(this, void 0);
        __classPrivateFieldSet(this, _UserRepository_pool, pool, "f");
    }
    getUsers() {
        return __awaiter(this, void 0, void 0, function* () {
            const response = yield __classPrivateFieldGet(this, _UserRepository_pool, "f").query('SELECT (id,name,email) FROM "user"  ORDER BY id ASC');
            const formatttedResponse = response.rows.map((row) => {
                const formattedRow = row.row
                    .replace("(", "")
                    .replace(")", "")
                    .replace(/"/g, "")
                    .split(",");
                return {
                    id: formattedRow[0],
                    name: formattedRow[1],
                    email: formattedRow[2],
                };
            });
            return formatttedResponse;
        });
    }
    createUser({ name, email, password }) {
        return __awaiter(this, void 0, void 0, function* () {
            yield __classPrivateFieldGet(this, _UserRepository_pool, "f").query(`INSERT INTO "user" (name, email, password) VALUES ($1, $2, $3)`, [name, email, password]);
        });
    }
    getUserById(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const response = yield __classPrivateFieldGet(this, _UserRepository_pool, "f").query('SELECT * FROM "user" WHERE id = $1', [id]);
            return response.rows[0];
        });
    }
    getUserByEmail(email) {
        return __awaiter(this, void 0, void 0, function* () {
            const response = yield __classPrivateFieldGet(this, _UserRepository_pool, "f").query('SELECT * FROM "user" WHERE email = $1', [email]);
            return response.rows[0];
        });
    }
    updateUser({ id, name, email, password }) {
        return __awaiter(this, void 0, void 0, function* () {
            yield __classPrivateFieldGet(this, _UserRepository_pool, "f").query(`UPDATE "user" SET name = $1, email = $2, password = $3 WHERE id = $4`, [name, email, password, id]);
        });
    }
    deleteUser(id) {
        return __awaiter(this, void 0, void 0, function* () {
            yield __classPrivateFieldGet(this, _UserRepository_pool, "f").query('DELETE FROM "user" WHERE id = $1', [id]);
        });
    }
}
exports.UserRepository = UserRepository;
_UserRepository_pool = new WeakMap();
