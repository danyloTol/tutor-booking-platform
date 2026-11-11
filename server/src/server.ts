import routes from "./routes";
import express from "express";
import cors from "cors";
import { env } from "./config/env";
import { errorHandler } from "./middlewares/errorHandler";

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Health check
app.get("/", (req, res) => {
  res.json({ status: "ok", message: "Tutor Booking API is running" });
});

app.use("/api", routes);

// Error handler (must be last)
app.use(errorHandler);

app.listen(env.PORT, () => {
  console.log(`Server running on http://localhost:${env.PORT}`);
});