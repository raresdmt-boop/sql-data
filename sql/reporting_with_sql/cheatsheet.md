# Reporting with SQL Cheatsheet (MySQL)

## Ordering Columns

Ordering by a single column:

```sql
SELECT * FROM <table name> ORDER BY <column> [ASC|DESC];
```

`ASC` orders results in ascending order (default).
`DESC` orders results in descending order.

Examples:

```sql
SELECT * FROM books ORDER BY title ASC;
SELECT * FROM products WHERE name = 'Sonic T-Shirt' ORDER BY stock_count DESC;
SELECT * FROM users ORDER BY signed_up_on DESC;
SELECT * FROM countries ORDER BY population DESC;
```

Ordering by multiple columns:

```sql
SELECT * FROM <table name> ORDER BY <column> [ASC|DESC],
                                    <column 2> [ASC|DESC],
                                    ...,
                                    <column n> [ASC|DESC];
```

Ordering is prioritized left to right.

Examples:

```sql
SELECT * FROM books ORDER BY    genre ASC,
                                title ASC;

SELECT * FROM books ORDER BY    genre ASC,
                                year_published DESC;

SELECT * FROM users WHERE email LIKE '%@gmail.com'
                    ORDER BY    last_name ASC,
                                first_name ASC;
```

## Limiting Results

To limit the number of results returned, use the `LIMIT` keyword:

```sql
SELECT <columns> FROM <table> LIMIT <# of rows>;
```

Examples:

```sql
SELECT * FROM products LIMIT 10;
SELECT title FROM movies ORDER BY release_year DESC LIMIT 5;
```

## Paging Through Results

To page through results, use `LIMIT` together with `OFFSET`. MySQL supports two equivalent forms:

```sql
SELECT <columns> FROM <table> LIMIT <# of rows> OFFSET <skipped rows>;
SELECT <columns> FROM <table> LIMIT <skipped rows>, <# of rows>;
```

Examples:

```sql
-- skip the first 20 rows, return the next 10
SELECT * FROM products ORDER BY id LIMIT 10 OFFSET 20;

-- same query, shorter MySQL-only syntax
SELECT * FROM products ORDER BY id LIMIT 20, 10;
```

> Always pair `LIMIT` with `ORDER BY` — without an explicit ordering, MySQL is free to return rows in any order, so paging results may be inconsistent across queries.

## Syntax Definitions

* **Keywords**: commands issued to the database. The data presented in queries is unaltered.
* **Operators**: perform comparisons and simple manipulation.
* **Functions**: present data differently through more complex manipulation.
* **Arguments** or **Parameters**: values passed in to functions.

A function call looks like:

```sql
<function name>(<value or column>)
```

Examples:

```sql
SELECT UPPER('Andrew Chalkley');
SELECT UPPER(name) FROM passport_holders;
```

## Concatenating Strings

In MySQL, `||` is **not** a string concatenation operator by default — it's a logical OR. Use the `CONCAT()` function instead:

```sql
SELECT CONCAT(<value or column>, <value or column>, <value or column>) FROM <table>;
```

Examples:

```sql
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM users;
SELECT CONCAT('Hello, ', name, '!') AS greeting FROM customers;
```

There's also `CONCAT_WS()` ("with separator") for joining many fields with the same separator:

```sql
SELECT CONCAT_WS(', ', street, city, state, zip_code) AS address FROM addresses;
```

## Finding Length of Strings

Use the `CHAR_LENGTH()` function to get the number of characters, or `LENGTH()` to get the number of bytes (relevant for multi-byte UTF-8 strings):

```sql
SELECT CHAR_LENGTH(<value or column>) FROM <table>;
SELECT LENGTH(<value or column>) FROM <table>;
```

Example:

```sql
SELECT CHAR_LENGTH('héllo'); -- returns 5
SELECT LENGTH('héllo');      -- returns 6 (because é takes 2 bytes in UTF-8)
```

## Changing the Case of Strings

Use `UPPER()` to uppercase text:

```sql
SELECT UPPER(<value or column>) FROM <table>;
```

Use `LOWER()` to lowercase text:

```sql
SELECT LOWER(<value or column>) FROM <table>;
```

## Creating Excerpts with Substring

In MySQL use `SUBSTRING()` (or its alias `SUBSTR()` / `MID()`):

```sql
SELECT SUBSTRING(<value or column>, <start>, <length>) FROM <table>;
```

* **\<start\>** — starting position (1-based, **not** 0-based).
  * If `<start>` is 0, MySQL returns an empty string.
  * If `<start>` is positive, counting starts from the beginning of the string.
  * If `<start>` is negative, counting starts from the end of the string.
* **\<length\>** — length of the desired substring.

Examples:

```sql
SELECT SUBSTRING('abcdefg', 3, 4); -- output: 'cdef'
SELECT SUBSTRING('abcdefg', -5, 4); -- output: 'cdef'
```

## Replacing Portions of Text

Use the `REPLACE()` function:

```sql
SELECT REPLACE(<original value or column>, <target string>, <replacement string>) FROM <table>;
```

Example:

```sql
SELECT REPLACE('Hello, World!', 'World', 'MySQL'); -- output: 'Hello, MySQL!'
```

## Counting Results

Count rows with `COUNT()`:

```sql
SELECT COUNT(*) FROM <table>;
```

Count unique entries with `DISTINCT`:

```sql
SELECT COUNT(DISTINCT <column>) FROM <table>;
```

Count grouped rows with `GROUP BY`:

```sql
SELECT <column with common value>, COUNT(*) FROM <table> GROUP BY <column with common value>;
```

Example:

```sql
SELECT category, COUNT(*) FROM products GROUP BY category;
```

## Obtaining Totals

Use `SUM()` to total numeric columns:

```sql
SELECT SUM(<numeric column>) FROM <table>;

SELECT <group column>, SUM(<numeric column>) AS <alias>
    FROM <table>
    GROUP BY <group column>
    HAVING <alias> <operator> <value>;
```

Example:

```sql
SELECT user_id, SUM(sale_amount) AS total
    FROM sales
    GROUP BY user_id
    HAVING total > 1000;
```

## Calculating Averages

Use `AVG()` for the average of a numeric column:

```sql
SELECT AVG(<numeric column>) FROM <table>;
SELECT <group column>, AVG(<numeric column>) FROM <table> GROUP BY <group column>;
```

## Finding the Maximum and Minimum Values

Use `MAX()` and `MIN()`:

```sql
SELECT MAX(<numeric column>) FROM <table>;
SELECT MIN(<numeric column>) FROM <table>;

SELECT <group column>, MAX(<numeric column>) FROM <table> GROUP BY <group column>;
SELECT <group column>, MIN(<numeric column>) FROM <table> GROUP BY <group column>;
```

## Mathematical Operators

* `*` Multiply
* `/` Divide
* `+` Add
* `-` Subtract
* `%` or `MOD` — modulo (remainder)
* `DIV` — integer division

```sql
SELECT <numeric column> <mathematical operator> <numeric value> FROM <table>;
```

Example:

```sql
SELECT price, price * 1.19 AS price_with_tax FROM products;
SELECT 17 DIV 5;  -- output: 3
SELECT 17 % 5;    -- output: 2
```

## Up-to-the-Minute Dates and Times

To get the current date use: `CURDATE()` (alias `CURRENT_DATE`)
To get the current time use: `CURTIME()` (alias `CURRENT_TIME`)
To get the current date and time use: `NOW()` (alias `CURRENT_TIMESTAMP`)

Example:

```sql
SELECT CURDATE(), CURTIME(), NOW();
```

## Calculating Dates

Use `DATE_ADD()` and `DATE_SUB()` for arithmetic on date/time values:

```sql
SELECT DATE_ADD(NOW(), INTERVAL 7 DAY);
SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH);
SELECT DATE_ADD('2026-01-15', INTERVAL 3 HOUR);
```

Use `DATEDIFF()` to get the number of days between two dates:

```sql
SELECT DATEDIFF('2026-12-31', '2026-01-01'); -- output: 364
```

Use `TIMESTAMPDIFF()` for differences in other units:

```sql
SELECT TIMESTAMPDIFF(YEAR, '1990-05-20', CURDATE()); -- age in years
SELECT TIMESTAMPDIFF(MINUTE, start_time, end_time) FROM events;
```

Full reference: <https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html>

## Formatting Dates

Use `DATE_FORMAT()` with format specifiers:

```sql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d');         -- 2026-04-29
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y');         -- 29/04/2026
SELECT DATE_FORMAT(NOW(), '%W, %M %e, %Y');    -- Wednesday, April 29, 2026
SELECT DATE_FORMAT(NOW(), '%H:%i:%s');         -- 14:30:00
```

Common specifiers:

| Specifier | Meaning                       |
|-----------|-------------------------------|
| `%Y`      | Year, 4 digits (2026)         |
| `%y`      | Year, 2 digits (26)           |
| `%m`      | Month, zero-padded (01–12)    |
| `%M`      | Month name (January)          |
| `%d`      | Day of month, zero-padded     |
| `%e`      | Day of month, no padding      |
| `%W`      | Weekday name (Monday)         |
| `%H`      | Hour, 24-hour (00–23)         |
| `%h`      | Hour, 12-hour (01–12)         |
| `%i`      | Minutes (00–59)               |
| `%s`      | Seconds (00–59)               |
| `%p`      | AM or PM                      |

Full reference: <https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format>
