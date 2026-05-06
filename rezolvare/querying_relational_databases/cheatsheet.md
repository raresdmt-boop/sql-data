# Querying Relational Databases Cheatsheet (MySQL)

## SQL JOINs

JOINs merge related data from multiple tables into a single result set.

The two most common types of joins are:

* INNER JOIN
* OUTER JOIN

### INNER JOINs

INNER JOINs return rows that match in both tables.

```sql
SELECT <columns> FROM <table 1>
    INNER JOIN <table 2> ON <table 1>.<column> = <table 2>.<column>;


SELECT <columns> FROM <table 1> AS <table 1 alias>
    INNER JOIN <table 2> AS <table 2 alias> ON <table 1 alias>.<column> = <table 2 alias>.<column>;
```

Examples:

```sql
SELECT product_name, category FROM products
    INNER JOIN product_categories ON products.category_id = product_categories.id;

SELECT products.product_name, product_categories.category FROM products
    INNER JOIN product_categories ON products.category_id = product_categories.id;

SELECT p.product_name, c.category FROM products AS p
    INNER JOIN product_categories AS c ON p.category_id = c.id;
```

In MySQL, `JOIN`, `INNER JOIN`, and `CROSS JOIN` are all syntactic equivalents — but it's clearer to write `INNER JOIN` when you mean an inner join.

INNER JOINing multiple tables:

```sql
SELECT <columns> FROM <table 1>
    INNER JOIN <table 2> ON <table 1>.<column> = <table 2>.<column>
    INNER JOIN <table 3> ON <table 1>.<column> = <table 3>.<column>;
```

Examples:

```sql
SELECT users.full_name, sales.amount, products.name FROM sales
        INNER JOIN users ON sales.user_id = users.id
        INNER JOIN products ON sales.product_id = products.id;
```

### OUTER JOINs

MySQL supports two types of OUTER JOINs:

* `LEFT OUTER JOIN` (or just `LEFT JOIN`) — returns all matching rows plus all non-matching rows from the *left* table
* `RIGHT OUTER JOIN` (or just `RIGHT JOIN`) — returns all matching rows plus all non-matching rows from the *right* table

> **MySQL does not support `FULL OUTER JOIN`** directly. To emulate one, combine a `LEFT JOIN` and a `RIGHT JOIN` with `UNION` (see below).

```sql
SELECT <columns> FROM <left table>
    LEFT OUTER JOIN <right table> ON <left table>.<column> = <right table>.<column>;


SELECT <columns> FROM <left table> AS <left alias>
    LEFT OUTER JOIN <right table> AS <right alias>
        ON <left alias>.<column> = <right alias>.<column>;
```

#### Example

If you wanted to get the product count for every category — even categories without products — an `OUTER JOIN` is the right tool. The two queries below produce the same result, one using `LEFT JOIN`, the other `RIGHT JOIN`:

```sql
SELECT categories.name, COUNT(products.id) AS `Product Count` FROM categories
    LEFT OUTER JOIN products ON categories.id = products.category_id
    GROUP BY categories.name;

SELECT categories.name, COUNT(products.id) AS `Product Count` FROM products
    RIGHT OUTER JOIN categories ON categories.id = products.category_id
    GROUP BY categories.name;
```

#### Emulating FULL OUTER JOIN in MySQL

```sql
SELECT * FROM table_a
    LEFT JOIN table_b ON table_a.id = table_b.a_id
UNION
SELECT * FROM table_a
    RIGHT JOIN table_b ON table_a.id = table_b.a_id;
```

## Set Operations

Set operations merge results from two or more queries into a single result set, based on column position and type.

The number and types of columns must match across queries, otherwise MySQL returns an error.

MySQL supports the following set operations:

* `UNION` — available in all MySQL versions
* `UNION ALL` — available in all MySQL versions
* `INTERSECT` — available from **MySQL 8.0.31+**
* `EXCEPT` — available from **MySQL 8.0.31+**

```sql
<query 1> <set operation> <query 2>;
SELECT <column> FROM <table 1> <set operation> SELECT <column> FROM <table 2>;
SELECT <column>, <column> FROM <table 1> <set operation> SELECT <column>, <column> FROM <table 2>;
```

### UNION Examples

`UNION` returns all distinct values from both data sets — duplicates are removed.

Get a list of unique restaurants from both north and south malls:

```sql
SELECT store FROM mall_south WHERE type = 'restaurant'
    UNION
SELECT store FROM mall_north WHERE type = 'restaurant';
```

Get a list of unique classes taught in two schools, ordered by class name:

```sql
SELECT evening_class FROM school_1
    UNION
SELECT evening_class FROM school_2
    ORDER BY evening_class ASC;
```

### UNION ALL

`UNION ALL` returns all values from both data sets — duplicates are kept.

Get a list of all names for boys and girls and order them by name:

```sql
SELECT boy_name AS name FROM boy_baby_names
    UNION ALL
SELECT girl_name AS name FROM girl_baby_names
    ORDER BY name;
```

### INTERSECT (MySQL 8.0.31+)

Returns only values present in both data sets.

Get list of classes offered in both schools:

```sql
SELECT evening_class FROM school_1
    INTERSECT
SELECT evening_class FROM school_2
    ORDER BY evening_class ASC;
```

### EXCEPT (MySQL 8.0.31+)

Returns rows from the first query that are *not* present in the second query.

Get a list of local stores in a mall (stores that are not part of a national chain):

```sql
SELECT store FROM mall
    EXCEPT
SELECT store FROM all_stores WHERE type = 'national';
```

> If you're on an older MySQL version, you can emulate `INTERSECT` and `EXCEPT` with `INNER JOIN` / `LEFT JOIN ... WHERE ... IS NULL` or with `IN` / `NOT IN` subqueries.

## Subqueries

Subqueries are queries within queries. The subquery is the _inner_ query, and the wrapping query is the _outer_ query.

There are two main ways to use a subquery:

1. Inside an `IN` condition
2. As a derived (temporary) table in the `FROM` clause

A subquery used in an `IN` condition must return only one column.

```sql
SELECT <columns> FROM <table 1> WHERE <table 1>.<column> IN (<subquery>);

SELECT <columns> FROM <table 1>
    WHERE <table 1>.<column> IN (SELECT <a single column> FROM <table 2> WHERE <condition>);
```

### Examples

Get a list of users' names and emails for users who have spent over 100 dollars in a single transaction:

```sql
-- using a subquery in IN
SELECT name, email FROM users
    WHERE id IN (SELECT DISTINCT user_id FROM sales WHERE sale_amount > 100);

-- using a derived table
SELECT name, email FROM users
    INNER JOIN (SELECT DISTINCT user_id FROM sales WHERE sale_amount > 100) AS best_customers
    ON users.id = best_customers.user_id;
```

Get a list of users' names and emails for users who have spent over 1000 dollars in total:

```sql
-- using a subquery in IN (note: HAVING, not WHERE, because we filter on an aggregate)
SELECT name, email FROM users
    WHERE id IN (
        SELECT user_id FROM sales
        GROUP BY user_id
        HAVING SUM(sale_amount) > 1000
    );

-- using a derived table
SELECT name, email, total FROM users
    INNER JOIN (
        SELECT user_id, SUM(sale_amount) AS total
        FROM sales
        GROUP BY user_id
        HAVING SUM(sale_amount) > 1000
    ) AS ultimate_customers
    ON users.id = ultimate_customers.user_id;
```

> Aggregate functions like `SUM()`, `COUNT()`, `AVG()` cannot appear in a `WHERE` clause. Use `HAVING` after `GROUP BY` instead.
