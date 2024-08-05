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
var _PostRepository_pool;
Object.defineProperty(exports, "__esModule", { value: true });
exports.PostRepository = void 0;
class PostRepository {
    constructor(pool) {
        _PostRepository_pool.set(this, void 0);
        __classPrivateFieldSet(this, _PostRepository_pool, pool, "f");
    }
    getPosts() {
        return __awaiter(this, void 0, void 0, function* () {
            const response = yield __classPrivateFieldGet(this, _PostRepository_pool, "f").query('SELECT * FROM "post" ORDER BY id ASC');
            return response.rows;
        });
    }
    createPost({ title, description, date }) {
        return __awaiter(this, void 0, void 0, function* () {
            yield __classPrivateFieldGet(this, _PostRepository_pool, "f").query('INSERT INTO "post" (title, description, date) VALUES ($1, $2, $3)', [title, description, date]);
        });
    }
    getPostById(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const response = yield __classPrivateFieldGet(this, _PostRepository_pool, "f").query('SELECT * FROM "post" WHERE id = $1', [id]);
            return response.rows[0];
        });
    }
    updatePost({ id, title, description, date }) {
        return __awaiter(this, void 0, void 0, function* () {
            yield __classPrivateFieldGet(this, _PostRepository_pool, "f").query(`UPDATE "post" SET title = $1, description = $2, date = $3 WHERE id = $4`, [title, description, date, id]);
        });
    }
    deletePost(id) {
        return __awaiter(this, void 0, void 0, function* () {
            yield __classPrivateFieldGet(this, _PostRepository_pool, "f").query('DELETE FROM "user_post" WHERE postId = $1', [id]);
            yield __classPrivateFieldGet(this, _PostRepository_pool, "f").query('DELETE FROM "post" WHERE id = $1', [id]);
        });
    }
}
exports.PostRepository = PostRepository;
_PostRepository_pool = new WeakMap();
