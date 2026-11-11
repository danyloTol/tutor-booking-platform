import { Router } from "express";
import authRoutes from "./authRoutes";

const router = Router();

router.use("/auth", authRoutes);

// TODO: Add more route groups later
// router.use("/tutors", tutorRoutes);
// router.use("/bookings", bookingRoutes);

export default router;