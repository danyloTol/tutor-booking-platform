import { Role } from "@prisma/client";

export interface JwtPayload {
  userId: string;
  role: Role;
}

// Extend Express Request to include our user
declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}