-- SQL Basics — starter schema (MySQL 8+)
-- Domain: small library with one books table.

CREATE DATABASE IF NOT EXISTS library_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE library_db;

DROP TABLE IF EXISTS books;

CREATE TABLE books (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(200)  NOT NULL,
    author         VARCHAR(150)  NOT NULL,
    genre          VARCHAR(50)   NOT NULL,
    year_published INT           NOT NULL,
    pages          INT           NULL,
    price          DECIMAL(8, 2) NOT NULL,
    in_stock       BOOLEAN       NOT NULL DEFAULT TRUE,
    rating         DECIMAL(3, 2) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
