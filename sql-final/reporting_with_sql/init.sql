-- Reporting with SQL — starter schema (MySQL 8+)
-- Domain: sales pipeline with one denormalized sales table.

CREATE DATABASE IF NOT EXISTS sales_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE sales_db;

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    salesperson VARCHAR(100)  NOT NULL,
    region      VARCHAR(50)   NOT NULL,
    product     VARCHAR(100)  NOT NULL,
    quantity    INT           NOT NULL,
    unit_price  DECIMAL(10, 2) NOT NULL,
    sold_at     DATETIME      NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
