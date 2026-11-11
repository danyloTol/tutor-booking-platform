import { createContext, useState, useEffect, type ReactNode } from "react";
import type { User, AuthResponse, LoginRequest, RegisterRequest } from "../types/user";
import { api } from "../lib/api";

interface AuthContextType {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  login: (data: LoginRequest) => Promise<void>;
  register: (data: RegisterRequest) => Promise<void>;
  logout: () => void;
}

export const AuthContext = createContext<AuthContextType | null>(null);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(() => localStorage.getItem("token"));
  const [isLoading, setIsLoading] = useState(true);

  // Run once on initial app load to restore user from existing token
  useEffect(() => {
    const initializeAuth = async () => {
      const savedToken = localStorage.getItem("token");

      if (!savedToken || savedToken === "undefined" || savedToken === "null") {
        localStorage.removeItem("token");
        setIsLoading(false);
        return;
      }
      if (!savedToken) {
        setIsLoading(false);
        return;
      }

      try {
        const data = await api.get<{ user: User }>("/auth/me");
        setUser(data.user);
        setToken(savedToken);
      } catch {
        // Token is invalid or expired
        localStorage.removeItem("token");
        setToken(null);
        setUser(null);
      } finally {
        setIsLoading(false);
      }
    };

    initializeAuth();
  }, []);

  const login = async (credentials: LoginRequest) => {
    const data = await api.post<AuthResponse>("/auth/login", credentials);
    localStorage.setItem("token", data.token);
    setToken(data.token);
    setUser(data.user);
  };

  const register = async (credentials: RegisterRequest) => {
    const data = await api.post<AuthResponse>("/auth/register", credentials);
    localStorage.setItem("token", data.token);
    setToken(data.token);
    setUser(data.user);
  };

  const logout = () => {
    localStorage.removeItem("token");
    setToken(null);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, token, isLoading, login, register, logout }}>
      {children}
    </AuthContext.Provider>
  );
};