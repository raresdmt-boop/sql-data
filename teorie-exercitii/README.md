# MySQL Cheat Sheets

A collection of cheat sheets for learning MySQL.

All examples use MySQL syntax (tested on MySQL 8.0+).

## Topics

* [SQL Basics](sql_basics/cheatsheet.md) — `SELECT`, `WHERE`, operators, `LIKE`, `IS NULL`
* [Modifying Data With SQL](modifying_data_with_sql/cheatsheet.md) — `INSERT`, `UPDATE`, `DELETE`, transactions
* [Reporting with SQL](reporting_with_sql/cheatsheet.md) — `ORDER BY`, `LIMIT`, aggregate functions, dates
* [Querying Relational Databases](querying_relational_databases/cheatsheet.md) — `JOIN`s, set operations, subqueries
* [Schema Objects](schema_objects/cheatsheet.md) — DDL, constraints, indexes, views, stored procedures, functions, triggers, users
* [Markdown Basics](markdown_basics/cheatsheet.md)

## String literals

In MySQL, string literals are wrapped in **single quotes** (`'...'`). Double quotes work too by default, but single quotes are the SQL standard and are safer when `ANSI_QUOTES` mode is enabled (in which case `"..."` is treated as an identifier).
