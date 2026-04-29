-- Querying Relational Databases — starter schema (MySQL 8+)
-- Domain: small university with students, courses, enrollments.

CREATE DATABASE IF NOT EXISTS university_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE university_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE instructors (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(80)  NOT NULL,
    last_name   VARCHAR(80)  NOT NULL,
    department  VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE students (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(80) NOT NULL,
    last_name    VARCHAR(80) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    year_of_study TINYINT NOT NULL,
    enrolled_at  DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE courses (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    credits      TINYINT NOT NULL,
    instructor_id INT NULL,
    CONSTRAINT fk_courses_instructor FOREIGN KEY (instructor_id) REFERENCES instructors(id) ON DELETE SET NULL,
    INDEX idx_courses_instructor (instructor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id  INT NOT NULL,
    grade      DECIMAL(3, 1) NULL,
    enrolled_on DATE NOT NULL,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course  FOREIGN KEY (course_id)  REFERENCES courses(id)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
