import { NextFunction, Request, Response } from "express";
import jwt, { Secret } from "jsonwebtoken";

export const authMiddleware = async (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  let token = req.headers.authorization;
  if (!token) {
    return res.status(401).json({ message: "Token is required" });
  }

  try {
    const userId = jwt.verify(token.replace("Bearer ", ""), process.env.JWT_SECRET as Secret);
    req.body.userId = userId;
    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid token", error });
  }
};
