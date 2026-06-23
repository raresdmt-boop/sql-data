# Schema Objects Cheatsheet (MySQL)

Cheat sheet for **DDL** (creating tables and constraints), **indexes**, **views**, **stored procedures**, **functions**, **triggers** and **users/permissions** in MySQL 8+.

---

## DDL — Creating, Altering, Dropping Tables

### CREATE TABLE

```sql
CREATE TABLE <table name> (
    <column name> <type> [<column constraints>],
    ...
    [<table constraints>]
);
```

Example:

```sql
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(150) NOT NULL UNIQUE,
    first_name    VARCHAR(80)  NOT NULL,
    last_name     VARCHAR(80)  NOT NULL,
    date_of_birth DATE         NULL,
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

Use `CREATE TABLE IF NOT EXISTS ...` to avoid errors when the table already exists.

### ALTER TABLE

Add a column:

```sql
ALTER TABLE <table> ADD COLUMN <column> <type> [<constraints>];
ALTER TABLE products ADD COLUMN sku VARCHAR(50) NULL;
```

Modify a column type:

```sql
ALTER TABLE <table> MODIFY COLUMN <column> <new type> [<constraints>];
ALTER TABLE products MODIFY COLUMN price DECIMAL(12, 2) NOT NULL;
```

Rename a column:

```sql
ALTER TABLE <table> RENAME COLUMN <old name> TO <new name>;
ALTER TABLE products RENAME COLUMN slug TO url_slug;
```

Drop a column:

```sql
ALTER TABLE <table> DROP COLUMN <column>;
ALTER TABLE products DROP COLUMN sku;
```

Add / drop a constraint or index:

```sql
ALTER TABLE products ADD CONSTRAINT uq_products_slug UNIQUE (slug);
ALTER TABLE products DROP INDEX uq_products_slug;
```

Rename a table:

```sql
RENAME TABLE <old name> TO <new name>;
```

### DROP TABLE

```sql
DROP TABLE <table>;
DROP TABLE IF EXISTS <table>;
```

> `DROP TABLE` removes the table **and all its data**. There's no rollback.

---

## Constraints

A *constraint* is a rule the database enforces on a column or table.

### NOT NULL & DEFAULT

```sql
email      VARCHAR(150) NOT NULL,
country    VARCHAR(80)  NOT NULL DEFAULT 'Romania',
created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
```

### PRIMARY KEY

Uniquely identifies each row. Implies `NOT NULL` and creates a clustered (in InnoDB) index.

```sql
-- inline
id INT AUTO_INCREMENT PRIMARY KEY,

-- table-level (multi-column)
PRIMARY KEY (order_id, product_id)
```

### UNIQUE

Ensures all values in a column (or set of columns) are distinct.

```sql
email VARCHAR(150) NOT NULL UNIQUE,

-- table-level
CONSTRAINT uq_users_email UNIQUE (email)
```

### FOREIGN KEY

Enforces a relationship to another table.

```sql
CREATE TABLE orders (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    CONSTRAINT fk_orders_user FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

Referential actions for `ON DELETE` / `ON UPDATE`:

| Action | Meaning |
|---|---|
| `RESTRICT` (default) | Block the parent operation if any child rows reference it |
| `CASCADE` | Apply the same operation to child rows |
| `SET NULL` | Set the FK to `NULL` in children (column must be nullable) |
| `NO ACTION` | Same as `RESTRICT` in MySQL |

### CHECK (MySQL 8.0.16+)

```sql
CREATE TABLE reviews (
    id     INT AUTO_INCREMENT PRIMARY KEY,
    rating TINYINT NOT NULL,
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5)
);
```

> In MySQL versions before 8.0.16, `CHECK` was parsed but **not enforced**.

---

## Indexes

Indexes speed up `SELECT` / `WHERE` / `JOIN` lookups but slow down `INSERT` / `UPDATE` / `DELETE` (the index also has to be updated). Don't add an index unless you know it'll be used.

### Create an index

Standard (B-Tree) index on one column:

```sql
CREATE INDEX idx_products_price ON products(price);
```

Composite (multi-column) index — order matters: it helps queries that filter on the leftmost columns:

```sql
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at);
```

Unique index (same as `UNIQUE` constraint):

```sql
CREATE UNIQUE INDEX uq_products_slug ON products(slug);
```

Full-text index (for natural-language `MATCH() AGAINST()` searches on text):

```sql
CREATE FULLTEXT INDEX ft_products_description ON products(description);

-- usage
SELECT * FROM products
    WHERE MATCH(description) AGAINST('wireless' IN NATURAL LANGUAGE MODE);
```

Index inside `CREATE TABLE`:

```sql
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    INDEX idx_orders_user (user_id),
    INDEX idx_orders_created (created_at)
);
```

### Drop an index

```sql
DROP INDEX <index name> ON <table>;
ALTER TABLE <table> DROP INDEX <index name>;
```

### See indexes on a table

```sql
SHOW INDEX FROM <table>;
SHOW INDEX FROM products;
```

### Use `EXPLAIN` to check if an index is used

```sql
EXPLAIN SELECT * FROM products WHERE price > 1000;
```

The `key` column shows which index MySQL chose (or `NULL` if it's doing a full table scan).

---

## Views

A view is a stored `SELECT` query that you can query like a table. Useful for hiding complexity, exposing safer columns, or naming common reports.

### Create a view

```sql
CREATE VIEW <view name> AS
    <select statement>;
```

Example:

```sql
CREATE VIEW v_active_products AS
    SELECT id, name, price, stock
    FROM products
    WHERE stock > 0;
```

Now you can query it like a table:

```sql
SELECT * FROM v_active_products WHERE price < 200;
```

### Replace or drop

```sql
CREATE OR REPLACE VIEW v_active_products AS
    SELECT id, name, price, stock, category_id FROM products WHERE stock > 0;

DROP VIEW IF EXISTS v_active_products;
```

### Updatable views

A view is **updatable** (you can `INSERT` / `UPDATE` / `DELETE` through it) only if it satisfies several conditions, including:

- The underlying `SELECT` references one table only.
- It contains no aggregate functions, `DISTINCT`, `GROUP BY`, `HAVING`, `UNION`.
- No subqueries that reference the same base table.

Use `WITH CHECK OPTION` to prevent rows that wouldn't pass the view's `WHERE` clause from being inserted/updated through it:

```sql
CREATE VIEW v_in_stock_products AS
    SELECT id, name, price, stock FROM products WHERE stock > 0
    WITH CHECK OPTION;
```

---

## Stored Procedures

A stored procedure is a saved block of SQL you can call by name.

### Create a procedure

Use `DELIMITER` to allow `;` inside the body without ending the `CREATE` statement.

```sql
DELIMITER $$

CREATE PROCEDURE <procedure name>(<parameters>)
BEGIN
    <statements>;
END $$

DELIMITER ;
```

Parameter modes:

- `IN` — input (default)
- `OUT` — output
- `INOUT` — both

Example — give a discount to all products in a category:

```sql
DELIMITER $$

CREATE PROCEDURE discount_category(IN p_category_id INT, IN p_percent DECIMAL(5, 2))
BEGIN
    UPDATE products
    SET price = price * (1 - p_percent / 100)
    WHERE category_id = p_category_id;
END $$

DELIMITER ;
```

### Call a procedure

```sql
CALL discount_category(2, 10);   -- 10% off all books
```

### Drop / list

```sql
DROP PROCEDURE IF EXISTS discount_category;

SHOW PROCEDURE STATUS WHERE Db = 'online_shop';
```

---

## Stored Functions

A stored function returns a single value and can be used inside `SELECT` like a built-in function.

```sql
DELIMITER $$

CREATE FUNCTION full_name(p_user_id INT) RETURNS VARCHAR(170)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_full VARCHAR(170);
    SELECT CONCAT(first_name, ' ', last_name) INTO v_full
    FROM users
    WHERE id = p_user_id;
    RETURN v_full;
END $$

DELIMITER ;
```

Use it:

```sql
SELECT id, full_name(user_id) AS customer FROM orders;
```

Drop:

```sql
DROP FUNCTION IF EXISTS full_name;
```

---

## Triggers

A trigger fires automatically when an `INSERT`, `UPDATE`, or `DELETE` happens on a table.

```sql
CREATE TRIGGER <trigger name>
    {BEFORE | AFTER} {INSERT | UPDATE | DELETE}
    ON <table>
    FOR EACH ROW
BEGIN
    <statements>;
END;
```

Inside the body, use `NEW.<column>` (the row being inserted/updated) and `OLD.<column>` (the row being updated/deleted).

Example — log every change to product prices:

```sql
CREATE TABLE product_price_log (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT      NOT NULL,
    old_price  DECIMAL(10, 2),
    new_price  DECIMAL(10, 2),
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER trg_products_price_log
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO product_price_log (product_id, old_price, new_price)
        VALUES (NEW.id, OLD.price, NEW.price);
    END IF;
END $$

DELIMITER ;
```

Drop / list:

```sql
DROP TRIGGER IF EXISTS trg_products_price_log;

SHOW TRIGGERS FROM online_shop;
```

> Triggers can make debugging hard because they run "behind the scenes". Use them sparingly and document them well.

---

## Users & Permissions

> You usually need the root account (or an admin) to manage users.

### Create a user

```sql
CREATE USER '<username>'@'<host>' IDENTIFIED BY '<password>';

CREATE USER 'app_user'@'%' IDENTIFIED BY 'StrongPass!23';
```

The host part:
- `'localhost'` — only from the same machine
- `'%'` — from any host
- `'192.168.1.10'` — only from a specific IP

### Grant privileges

```sql
-- read-only on one database
GRANT SELECT ON online_shop.* TO 'reporter'@'%';

-- full CRUD on one database
GRANT SELECT, INSERT, UPDATE, DELETE ON online_shop.* TO 'app_user'@'%';

-- everything (DBA)
GRANT ALL PRIVILEGES ON *.* TO 'admin_user'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```

### Revoke / drop

```sql
REVOKE INSERT, UPDATE ON online_shop.* FROM 'reporter'@'%';

DROP USER 'old_user'@'%';
```

### Inspect

```sql
SHOW GRANTS FOR 'app_user'@'%';
SELECT user, host FROM mysql.user;
```

---

## Quick Diagnostic Queries

```sql
-- list all databases
SHOW DATABASES;

-- list all tables in the current database
SHOW TABLES;

-- describe a table
DESCRIBE <table>;
SHOW COLUMNS FROM <table>;
SHOW CREATE TABLE <table>;

-- size of a table (approximate, in MB)
SELECT
    table_name,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS size_mb
FROM information_schema.tables
WHERE table_schema = DATABASE()
ORDER BY size_mb DESC;

-- which queries are running right now
SHOW PROCESSLIST;
```
