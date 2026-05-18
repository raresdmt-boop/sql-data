-- Online Shop — schema recapitulativă (MySQL 8+)
-- Domeniu: e-commerce cu produse, categorii, opțiuni, comenzi, clienți.
-- Numele coloanelor sunt preluate fidel din diagrama originală
-- (de aceea apar `descriptions` și `ammount` — ca în sursă).

CREATE DATABASE IF NOT EXISTS online_shop_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE online_shop_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_options;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS options;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
    id                       INT AUTO_INCREMENT PRIMARY KEY,
    email                    VARCHAR(150) NOT NULL UNIQUE,
    password                 VARCHAR(200) NOT NULL,
    full_name                VARCHAR(150) NOT NULL,
    billing_address          VARCHAR(255) NULL,
    default_shipping_address VARCHAR(255) NULL,
    country                  VARCHAR(80)  NULL,
    phone                    VARCHAR(40)  NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE options (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    option_name VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    thumbnail   VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    sku          VARCHAR(40)    NOT NULL UNIQUE,
    name         VARCHAR(150)   NOT NULL,
    price        DECIMAL(10, 2) NOT NULL,
    weight       DECIMAL(8, 2)  NULL,
    descriptions TEXT           NULL,
    thumbnail    VARCHAR(255)   NULL,
    image        VARCHAR(255)   NULL,
    category     VARCHAR(100)   NULL,
    create_date  DATETIME       NOT NULL,
    stock        INT            NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    product_id  INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_pc_product  FOREIGN KEY (product_id)  REFERENCES products(id)   ON DELETE CASCADE,
    CONSTRAINT fk_pc_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    UNIQUE KEY uq_pc (product_id, category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_options (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    option_id  INT NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT fk_po_option  FOREIGN KEY (option_id)  REFERENCES options(id)  ON DELETE CASCADE,
    CONSTRAINT fk_po_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY uq_po (option_id, product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    customer_id      INT            NOT NULL,
    ammount          DECIMAL(10, 2) NOT NULL,
    shipping_address VARCHAR(255)   NOT NULL,
    order_address    VARCHAR(255)   NOT NULL,
    order_email      VARCHAR(150)   NOT NULL,
    order_date       DATETIME       NOT NULL,
    order_status     ENUM('NEW','PAID','SHIPPED','DELIVERED','CANCELLED') NOT NULL DEFAULT 'NEW',
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_details (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    order_id   INT            NOT NULL,
    product_id INT            NOT NULL,
    price      DECIMAL(10, 2) NOT NULL,
    sku        VARCHAR(40)    NOT NULL,
    quantity   INT            NOT NULL,
    CONSTRAINT fk_od_order   FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE CASCADE,
    CONSTRAINT fk_od_product FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
