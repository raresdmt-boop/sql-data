-- Schema Objects — starter schema (MySQL 8+)
-- Domain: HR with employees and departments. Minimal — student adds indexes, views, procedures, triggers.

CREATE DATABASE IF NOT EXISTS hr_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE hr_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS salary_log;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE departments (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE employees (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(80)  NOT NULL,
    last_name     VARCHAR(80)  NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    department_id INT          NULL,
    salary        DECIMAL(10, 2) NOT NULL,
    hired_at      DATE         NOT NULL,
    CONSTRAINT fk_employees_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
