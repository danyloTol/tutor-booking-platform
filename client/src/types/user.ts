export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: "STUDENT" | "TUTOR" | "ADMIN";
  avatarUrl?: string;
  timezone?: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  role: "STUDENT" | "TUTOR";
}

export interface AuthResponse {
  token: string;
  user: User;
}