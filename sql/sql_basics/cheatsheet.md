# SQL Basics Cheatsheet (MySQL)

## Find All Columns and Rows in a Table

```sql
SELECT * FROM <table name>;
```

The asterisk or star symbol (`*`) means all columns.

The semi-colon (`;`) terminates the statement like a period in a sentence or question mark in a question.

Examples:

```sql
SELECT * FROM books;
SELECT * FROM products;
SELECT * FROM users;
SELECT * FROM countries;
```

## Retrieving Specific Columns of Information

Retrieving a single column:

```sql
SELECT <column name> FROM <table name>;
```

Examples:

```sql
SELECT email FROM users;
SELECT first_name FROM users;
SELECT name FROM products;
SELECT zip_code FROM addresses;
```

Retrieving multiple columns:

```sql
SELECT <column name 1>, <column name 2>, ... FROM <table name>;
```

Examples:

```sql
SELECT first_name, last_name FROM customers;
SELECT name, description, price FROM products;
SELECT title, author, isbn, year_released FROM books;
SELECT name, species, legs FROM pets;
```

## Aliasing Column Names

```sql
SELECT <column name> AS <alias> FROM <table name>;
SELECT <column name> <alias> FROM <table name>;
```

In MySQL, aliases that contain spaces or special characters must be wrapped in double quotes (when `ANSI_QUOTES` is on) or backticks (default mode):

Examples:

```sql
SELECT username AS Username, first_name AS `First Name` FROM users;
SELECT title AS Title, year AS `Year Released` FROM movies;
SELECT name AS Name, description AS Description, price AS `Current Price` FROM products;
SELECT name Name, description Description, price `Current Price` FROM products;
```

## Finding the Data You Want

```sql
SELECT <columns> FROM <table> WHERE <condition>;
```

### Equality Operator

Find all rows where a given value matches a column's value.

```sql
SELECT <columns> FROM <table> WHERE <column name> = <value>;
```

Examples:

```sql
SELECT * FROM contacts WHERE first_name = 'Andrew';
SELECT first_name, email FROM users WHERE last_name = 'Chalkley';
SELECT name AS `Product Name` FROM products WHERE stock_count = 0;
SELECT title `Book Title` FROM books WHERE year_published = 1999;
```

### Inequality Operator

Find all rows where a given value doesn't match a column's value.

```sql
SELECT <columns> FROM <table> WHERE <column name> != <value>;
SELECT <columns> FROM <table> WHERE <column name> <> <value>;
```

The not-equal operator can be written in two ways: `!=` and `<>`. Both are valid in MySQL.

Examples:

```sql
SELECT * FROM contacts WHERE first_name != 'Kenneth';
SELECT first_name, email FROM users WHERE last_name != 'Lone';
SELECT name AS `Product Name` FROM products WHERE stock_count != 0;
SELECT title `Book Title` FROM books WHERE year_published != 2015;
```

### Relational Operators

There are several relational operators you can use:

* `<` less than
* `<=` less than or equal to
* `>` greater than
* `>=` greater than or equal to

These are primarily used to compare *numeric* and *date/time* types.

```sql
SELECT <columns> FROM <table> WHERE <column name> < <value>;
SELECT <columns> FROM <table> WHERE <column name> <= <value>;
SELECT <columns> FROM <table> WHERE <column name> > <value>;
SELECT <columns> FROM <table> WHERE <column name> >= <value>;
```

Examples:

```sql
SELECT first_name, last_name FROM users WHERE date_of_birth < '1998-12-01';
SELECT title AS `Book Title`, author AS Author FROM books WHERE year_released <= 2015;
SELECT name, description FROM products WHERE price > 9.99;
SELECT title FROM movies WHERE release_year >= 2000;
```

### More Than One Condition

You can combine multiple conditions in a `WHERE` clause. Use `AND` when *both* conditions must be true, or `OR` when *either* condition must be true.

```sql
SELECT <columns> FROM <table> WHERE <condition 1> AND <condition 2> ...;
SELECT <columns> FROM <table> WHERE <condition 1> OR <condition 2> ...;
```

Examples:

```sql
SELECT username FROM users WHERE last_name = 'Chalkley' AND first_name = 'Andrew';
SELECT * FROM products WHERE category = 'Games Consoles' AND price < 400;
SELECT * FROM movies WHERE title = 'The Matrix' OR title = 'The Matrix Reloaded' OR title = 'The Matrix Revolutions';
SELECT country FROM countries WHERE population < 1000000 OR population > 100000000;
```

### Searching in a Set of Values

```sql
SELECT <columns> FROM <table> WHERE <column> IN (<value 1>, <value 2>, ...);
```

Examples:

```sql
SELECT name FROM islands WHERE id IN (4, 8, 15, 16, 23, 42);
SELECT * FROM products WHERE category IN ('eBooks', 'Books', 'Comics');
SELECT title FROM courses WHERE topic IN ('JavaScript', 'Databases', 'CSS');
SELECT * FROM campaigns WHERE medium IN ('email', 'blog', 'ppc');
```

To find all rows that are not in the set of values use `NOT IN`:

```sql
SELECT <columns> FROM <table> WHERE <column> NOT IN (<value 1>, <value 2>, ...);
```

Examples:

```sql
SELECT answer FROM answers WHERE id NOT IN (7, 42);
SELECT * FROM products WHERE category NOT IN ('Electronics');
SELECT title FROM courses WHERE topic NOT IN ('SQL', 'NoSQL');
```

### Searching within a Range of Values

```sql
SELECT <columns> FROM <table> WHERE <column> BETWEEN <lesser value> AND <greater value>;
```

`BETWEEN` is inclusive on both ends.

Examples:

```sql
SELECT * FROM movies WHERE release_year BETWEEN 2000 AND 2010;
SELECT name, description FROM products WHERE price BETWEEN 9.99 AND 19.99;
SELECT name, appointment_date FROM appointments WHERE appointment_date BETWEEN '2015-01-01' AND '2015-01-07';
```

### Pattern Matching

The percent symbol (`%`) used with the `LIKE` keyword acts as a wildcard — it matches any number of characters, including zero. The underscore (`_`) matches exactly one character.

```sql
SELECT <columns> FROM <table> WHERE <column> LIKE <pattern>;
```

Examples:

```sql
SELECT title FROM books WHERE title LIKE 'Harry Potter%Fire';
SELECT title FROM movies WHERE title LIKE 'Alien%';
SELECT * FROM contacts WHERE first_name LIKE '%drew';
SELECT * FROM books WHERE title LIKE '%Brief History%';
```

In MySQL, `LIKE` is **case-insensitive by default** for non-binary string columns (this depends on the column's collation, e.g. `utf8mb4_general_ci`). To force case-sensitive matching, use the `BINARY` keyword:

```sql
SELECT * FROM contacts WHERE first_name LIKE BINARY '%Drew';
```

### Missing Values

```sql
SELECT * FROM <table> WHERE <column> IS NULL;
```

Note: you cannot use `= NULL` — comparisons with `NULL` always return unknown. Always use `IS NULL` or `IS NOT NULL`.

Examples:

```sql
SELECT * FROM people WHERE last_name IS NULL;
SELECT * FROM vhs_rentals WHERE returned_on IS NULL;
SELECT * FROM car_rentals WHERE returned_on IS NULL AND location = 'PDX';
```

To filter out missing values use `IS NOT NULL`:

```sql
SELECT * FROM <table> WHERE <column> IS NOT NULL;
```

Examples:

```sql
SELECT * FROM people WHERE email IS NOT NULL;
SELECT * FROM addresses WHERE zip_code IS NOT NULL;
```
