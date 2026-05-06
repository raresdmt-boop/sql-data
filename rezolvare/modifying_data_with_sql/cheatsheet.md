# Modifying Data With SQL Cheatsheet (MySQL)

## Adding a Row to a Table

Inserting a single row:

```sql
INSERT INTO <table> VALUES (<value 1>, <value 2>, ...);
```

This will insert values in the order of the columns prescribed in the schema.

Examples:

```sql
INSERT INTO users VALUES (1, 'chalkers', 'Andrew', 'Chalkley');
INSERT INTO users VALUES (2, 'ScRiPtKiDdIe', 'Kenneth', 'Love');

INSERT INTO movies VALUES (3, 'Starman', 'Science Fiction', 1984);
INSERT INTO movies VALUES (4, 'Moulin Rouge!', 'Musical', 2001);
```

Inserting a single row with values in any order:

```sql
INSERT INTO <table> (<column 1>, <column 2>) VALUES (<value 1>, <value 2>);
INSERT INTO <table> (<column 2>, <column 1>) VALUES (<value 2>, <value 1>);
```

Examples:

```sql
INSERT INTO users (username, first_name, last_name) VALUES ('chalkers', 'Andrew', 'Chalkley');
INSERT INTO users (first_name, last_name, username) VALUES ('Kenneth', 'Love', 'ScRiPtKiDdIe');

INSERT INTO movies (title, genre, year_released) VALUES ('Starman', 'Science Fiction', 1984);
INSERT INTO movies (title, year_released, genre) VALUES ('Moulin Rouge!', 2001, 'Musical');
```

## Adding Multiple Rows to a Table

Inserting multiple rows in a single statement:

```sql
INSERT INTO <table> (<column 1>, <column 2>, ...)
             VALUES
                    (<value 1>, <value 2>, ...),
                    (<value 1>, <value 2>, ...),
                    (<value 1>, <value 2>, ...);
```

Examples:

```sql
INSERT INTO users (username, first_name, last_name)
    VALUES
                  ('chalkers', 'Andrew', 'Chalkley'),
                  ('ScRiPtKiDdIe', 'Kenneth', 'Love');

INSERT INTO movies (title, genre, year_released)
     VALUES
                   ('Starman', 'Science Fiction', 1984),
                   ('Moulin Rouge!', 'Musical', 2001);
```

## Updating All Rows in a Table

An update statement for all rows:

```sql
UPDATE <table> SET <column> = <value>;
```

The `=` sign here is different from the equality operator in a `WHERE` condition. It's an _assignment operator_ — you're assigning a new value.

> **MySQL safe-update mode:** by default in MySQL Workbench (and when `sql_safe_updates` is on), an `UPDATE` or `DELETE` without a `WHERE` on a key column is rejected. Disable it for the session with `SET SQL_SAFE_UPDATES = 0;` if you really want to update all rows.

Examples:

```sql
UPDATE users SET password = 'thisisabadidea';
UPDATE products SET price = 2.99;
```

Update multiple columns in all rows:

```sql
UPDATE <table> SET <column 1> = <value 1>, <column 2> = <value 2>;
```

Examples:

```sql
UPDATE users SET first_name = 'Anony', last_name = 'Moose';
UPDATE products SET stock_count = 0, price = 0;
```

## Updating Specific Rows

An update statement for specific rows:

```sql
UPDATE <table> SET <column> = <value> WHERE <condition>;
```

Examples:

```sql
UPDATE users SET password = 'thisisabadidea' WHERE id = 3;
UPDATE blog_posts SET view_count = 1923 WHERE title = 'SQL is Awesome';
```

Update multiple columns for specific rows:

```sql
UPDATE <table> SET <column 1> = <value 1>, <column 2> = <value 2> WHERE <condition>;
```

Examples:

```sql
UPDATE users SET entry_url = '/home', last_login = '2016-01-05' WHERE id = 329;
UPDATE products SET status = 'SOLD OUT', availability = 'In 1 Week' WHERE stock_count = 0;
```

## Removing Data from All Rows in a Table

To delete all rows from a table:

```sql
DELETE FROM <table>;
```

Examples:

```sql
DELETE FROM logs;
DELETE FROM users;
DELETE FROM products;
```

For very large tables, MySQL also supports `TRUNCATE TABLE <table>;` which is faster but cannot be rolled back inside a transaction (it's an implicit commit).

## Removing Specific Rows

To delete specific rows from a table:

```sql
DELETE FROM <table> WHERE <condition>;
```

Examples:

```sql
DELETE FROM users WHERE email = 'andrew@teamtreehouse.com';
DELETE FROM movies WHERE genre = 'Musical';
DELETE FROM products WHERE stock_count = 0;
```

## Transactions

MySQL auto-commits each statement by default. To group statements into a single atomic unit, start a transaction.

Begin a transaction:

```sql
START TRANSACTION;
```

`BEGIN;` is also accepted as an alias in MySQL.

To save all the changes made since the start of the transaction:

```sql
COMMIT;
```

To undo all the changes made since the start of the transaction:

```sql
ROLLBACK;
```

> Transactions in MySQL only work with **transactional storage engines** like `InnoDB` (the default since MySQL 5.5). On `MyISAM` tables, `COMMIT` and `ROLLBACK` have no effect.

Example:

```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```
