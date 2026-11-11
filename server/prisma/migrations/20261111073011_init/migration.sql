-- CreateEnum
CREATE TYPE "Role" AS ENUM ('STUDENT', 'TUTOR', 'ADMIN');

-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password_hash" TEXT NOT NULL,
    "role" "Role" NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "avatar_url" TEXT,
    "timezone" TEXT NOT NULL DEFAULT 'UTC',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tutor_profiles" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "bio" TEXT,
    "hourly_rate" DOUBLE PRECISION NOT NULL,
    "meeting_link" TEXT,
    "is_verified" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "tutor_profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subjects" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tutor_subjects" (
    "tutor_id" TEXT NOT NULL,
    "subject_id" TEXT NOT NULL,

    CONSTRAINT "tutor_subjects_pkey" PRIMARY KEY ("tutor_id","subject_id")
);

-- CreateTable
CREATE TABLE "tutor_weekly_availability" (
    "id" TEXT NOT NULL,
    "tutor_id" TEXT NOT NULL,
    "day_of_week" INTEGER NOT NULL,
    "start_time" TEXT NOT NULL,
    "end_time" TEXT NOT NULL,

    CONSTRAINT "tutor_weekly_availability_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tutor_availability_overrides" (
    "id" TEXT NOT NULL,
    "tutor_id" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "is_available" BOOLEAN NOT NULL,
    "start_time" TEXT,
    "end_time" TEXT,

    CONSTRAINT "tutor_availability_overrides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bookings" (
    "id" TEXT NOT NULL,
    "tutor_id" TEXT NOT NULL,
    "student_id" TEXT NOT NULL,
    "subject_id" TEXT NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "status" "BookingStatus" NOT NULL DEFAULT 'PENDING',
    "meeting_url" TEXT,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bookings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "tutor_id" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "tutor_profiles_user_id_key" ON "tutor_profiles"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "subjects_name_key" ON "subjects"("name");

-- CreateIndex
CREATE UNIQUE INDEX "tutor_weekly_availability_tutor_id_day_of_week_start_time_key" ON "tutor_weekly_availability"("tutor_id", "day_of_week", "start_time");

-- CreateIndex
CREATE UNIQUE INDEX "tutor_availability_overrides_tutor_id_date_key" ON "tutor_availability_overrides"("tutor_id", "date");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_booking_id_key" ON "reviews"("booking_id");

-- AddForeignKey
ALTER TABLE "tutor_profiles" ADD CONSTRAINT "tutor_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tutor_subjects" ADD CONSTRAINT "tutor_subjects_tutor_id_fkey" FOREIGN KEY ("tutor_id") REFERENCES "tutor_profiles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tutor_subjects" ADD CONSTRAINT "tutor_subjects_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "subjects"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tutor_weekly_availability" ADD CONSTRAINT "tutor_weekly_availability_tutor_id_fkey" FOREIGN KEY ("tutor_id") REFERENCES "tutor_profiles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tutor_availability_overrides" ADD CONSTRAINT "tutor_availability_overrides_tutor_id_fkey" FOREIGN KEY ("tutor_id") REFERENCES "tutor_profiles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_tutor_id_fkey" FOREIGN KEY ("tutor_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_subject_id_fkey" FOREIGN KEY ("subject_id") REFERENCES "subjects"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "bookings"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_tutor_id_fkey" FOREIGN KEY ("tutor_id") REFERENCES "tutor_profiles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
