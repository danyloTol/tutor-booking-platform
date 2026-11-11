import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { env } from "../config/env";
import { JwtPayload } from "../types";

export const authMiddleware = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const header = req.headers.authorization;

  if (!header || !header.startsWith("Bearer ")) {
    res.status(401).json({ error: "No token provided" });
    return;
  }

  const token = header.split(" ")[1];

  try {
    const decoded = jwt.verify(token, env.JWT_SECRET) as JwtPayload;
    req.user = decoded;
    next();
  } catch {
    res.status(401).json({ error: "Invalid or expired token" });
  }
};