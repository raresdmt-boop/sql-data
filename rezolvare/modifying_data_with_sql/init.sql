-- Modifying Data — starter schema (MySQL 8+)
-- Domain: cinema with one movies table.

CREATE DATABASE IF NOT EXISTS cinema_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE cinema_db;

DROP TABLE IF EXISTS movies;

CREATE TABLE movies (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(200)  NOT NULL,
    genre         VARCHAR(50)   NOT NULL,
    year_released INT           NOT NULL,
    director      VARCHAR(150)  NULL,
    rating        DECIMAL(3, 1) NULL,
    ticket_price  DECIMAL(6, 2) NOT NULL DEFAULT 25.00,
    seats_sold    INT           NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
