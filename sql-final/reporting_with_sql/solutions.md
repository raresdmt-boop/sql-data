# Reporting with SQL — Soluții

Soluțiile pentru exercițiile din `../../sql-start/reporting_with_sql/exercises.md`. Folosește baza `sales_db`.

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < seed.sql
```

---

## ORDER BY & LIMIT

### EX-1. Toate vânzările sortate descrescător după `unit_price`.
```sql
SELECT * FROM sales
ORDER BY unit_price DESC;
```

### EX-2. Top 5 cele mai recente vânzări.
```sql
SELECT * FROM sales
ORDER BY sold_at DESC
LIMIT 5;
```

### EX-3. Sortare după `region` ASC apoi `unit_price` DESC.
```sql
SELECT * FROM sales
ORDER BY region ASC, unit_price DESC;
```

### EX-4. Paginare: rândurile 11–20 ordonate după `id`.
```sql
SELECT * FROM sales
ORDER BY id
LIMIT 10 OFFSET 10;
```

## Funcții agregate (fără GROUP BY)

### EX-5. Numărul total de vânzări.
```sql
SELECT COUNT(*) AS total_sales FROM sales;
```

### EX-6. Suma totală încasată.
```sql
SELECT SUM(quantity * unit_price) AS total_revenue
FROM sales;
```

### EX-7. Prețul mediu unitar, rotunjit la 2 zecimale.
```sql
SELECT ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM sales;
```

### EX-8. Cea mai mare valoare a unei tranzacții.
```sql
SELECT MAX(quantity * unit_price) AS max_transaction_value
FROM sales;
```

### EX-9. Numărul de produse distincte vândute.
```sql
SELECT COUNT(DISTINCT product) AS distinct_products
FROM sales;
```

## GROUP BY

### EX-10. Suma totală vândută pe regiune.
```sql
SELECT region, SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY region;
```

### EX-11. Numărul de tranzacții per `salesperson`.
```sql
SELECT salesperson, COUNT(*) AS transactions
FROM sales
GROUP BY salesperson;
```

### EX-12. Cantitatea totală vândută per produs, descrescător.
```sql
SELECT product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product
ORDER BY total_quantity DESC;
```

### EX-13. Prețul mediu pentru fiecare produs.
```sql
SELECT product, ROUND(AVG(unit_price), 2) AS avg_price
FROM sales
GROUP BY product;
```

## HAVING

### EX-14. Salesperson-i cu peste 5 tranzacții.
```sql
SELECT salesperson, COUNT(*) AS transactions
FROM sales
GROUP BY salesperson
HAVING COUNT(*) > 5;
```

### EX-15. Produse cu vânzări totale > 30000 RON.
```sql
SELECT product, SUM(quantity * unit_price) AS total_revenue
FROM sales
GROUP BY product
HAVING SUM(quantity * unit_price) > 30000;
```

## Funcții de string

### EX-16. `salesperson` UPPER, `region` lower.
```sql
SELECT
    UPPER(salesperson) AS salesperson_upper,
    LOWER(region)      AS region_lower
FROM sales;
```

### EX-17. Prima literă a numelui de familie.
```sql
SELECT
    salesperson,
    SUBSTRING(SUBSTRING_INDEX(salesperson, ' ', -1), 1, 1) AS last_name_initial
FROM sales;
```

### EX-18. Concat salesperson + ' — ' + region.
```sql
SELECT CONCAT(salesperson, ' — ', region) AS label
FROM sales;
```

## Funcții de dată

### EX-19. Vânzările din anul 2025.
```sql
SELECT * FROM sales
WHERE YEAR(sold_at) = 2025;
```

### EX-20. Numărul de vânzări per lună (`YYYY-MM`).
```sql
SELECT
    DATE_FORMAT(sold_at, '%Y-%m') AS month,
    COUNT(*) AS sales_count
FROM sales
GROUP BY month
ORDER BY month;
```

### EX-21. Vânzările din ultimele 60 de zile.
```sql
SELECT * FROM sales
WHERE sold_at >= DATE_SUB(NOW(), INTERVAL 60 DAY);
```

### EX-22. Diferența în zile față de azi.
```sql
SELECT
    id,
    DATEDIFF(NOW(), sold_at) AS days_since_sale
FROM sales;
```

### EX-23. Format `'15 May 2025, 10:30'`.
```sql
SELECT
    id,
    DATE_FORMAT(sold_at, '%d %M %Y, %H:%i') AS sold_at_formatted
FROM sales;
```

## Provocări

### CH-1. Raport lunar.
```sql
SELECT
    DATE_FORMAT(sold_at, '%Y-%m')   AS month,
    COUNT(*)                         AS sales_count,
    SUM(quantity)                    AS total_quantity,
    SUM(quantity * unit_price)       AS total_revenue
FROM sales
GROUP BY month
ORDER BY month DESC;
```

### CH-2. Top 3 salesperson-i cu venit formatat.
```sql
SELECT
    salesperson,
    CONCAT(FORMAT(SUM(quantity * unit_price), 2), ' RON') AS total_revenue
FROM sales
GROUP BY salesperson
ORDER BY SUM(quantity * unit_price) DESC
LIMIT 3;
```

### CH-3. Pentru fiecare regiune produsul cel mai vândut (după cantitate).
```sql
SELECT region, product, total_quantity
FROM (
    SELECT
        region,
        product,
        SUM(quantity) AS total_quantity,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(quantity) DESC) AS rn
    FROM sales
    GROUP BY region, product
) t
WHERE rn = 1;
```

---

## Scenarii frecvente în producție

### PR-1. KPI zilnic.
```sql
SELECT
    DATE(sold_at) AS day,
    COUNT(*) AS transactions,
    SUM(quantity * unit_price) AS revenue
FROM sales
GROUP BY day
ORDER BY day;
```

### PR-2. KPI per produs cu preț mediu ponderat.
```sql
SELECT
    product,
    SUM(quantity * unit_price) AS total_revenue,
    SUM(quantity)              AS total_quantity,
    ROUND(SUM(quantity * unit_price) / SUM(quantity), 2) AS weighted_avg_price
FROM sales
GROUP BY product;
```

### PR-3. Last activity per salesperson.
```sql
SELECT
    salesperson,
    MAX(sold_at) AS last_sale_at
FROM sales
GROUP BY salesperson;
```

### PR-4. Leaderboard regional cu salesperson-ul de top per regiune.
```sql
SELECT region, salesperson, total_revenue
FROM (
    SELECT
        region,
        salesperson,
        SUM(quantity * unit_price) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(quantity * unit_price) DESC) AS rn
    FROM sales
    GROUP BY region, salesperson
) t
WHERE rn = 1;
```

### PR-5. Câte produse distincte s-au vândut în fiecare lună.
```sql
SELECT
    DATE_FORMAT(sold_at, '%Y-%m') AS month,
    COUNT(DISTINCT product) AS distinct_products
FROM sales
GROUP BY month
ORDER BY month;
```

### PR-6. Tranzacții peste 15000 RON.
```sql
SELECT
    id, salesperson, product, quantity, unit_price,
    quantity * unit_price AS transaction_value
FROM sales
WHERE quantity * unit_price > 15000
ORDER BY transaction_value DESC;
```

### PR-7. Forecast simplificat — ultimele 90 zile per produs.
```sql
SELECT
    product,
    SUM(quantity) AS qty_last_90_days
FROM sales
WHERE sold_at >= DATE_SUB(NOW(), INTERVAL 90 DAY)
GROUP BY product;
```

### PR-8. Quality check: același produs la prețuri unitare diferite.
```sql
SELECT
    salesperson,
    product,
    COUNT(DISTINCT unit_price) AS distinct_prices
FROM sales
GROUP BY salesperson, product
HAVING COUNT(DISTINCT unit_price) > 1;
```

### PR-9. Venit mediu per tranzacție per salesperson.
```sql
SELECT
    salesperson,
    ROUND(AVG(quantity * unit_price), 2) AS avg_transaction_value
FROM sales
GROUP BY salesperson;
```

### PR-10. Month-over-month cu LAG().
```sql
WITH monthly AS (
    SELECT
        DATE_FORMAT(sold_at, '%Y-%m') AS month,
        SUM(quantity * unit_price) AS revenue
    FROM sales
    GROUP BY month
)
SELECT
    month,
    revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS delta_vs_prev_month
FROM monthly
ORDER BY month;
```

### PR-11. Pondere regională în venitul total.
```sql
SELECT
    region,
    SUM(quantity * unit_price) AS region_revenue,
    ROUND(
        SUM(quantity * unit_price) * 100.0 /
        (SELECT SUM(quantity * unit_price) FROM sales),
        2
    ) AS pct_of_total
FROM sales
GROUP BY region;
```

### PR-12. Produsul cu cel mai mare venit per trimestru.
```sql
SELECT quarter_label, product, total_revenue
FROM (
    SELECT
        CONCAT(YEAR(sold_at), '-Q', QUARTER(sold_at)) AS quarter_label,
        product,
        SUM(quantity * unit_price) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY CONCAT(YEAR(sold_at), '-Q', QUARTER(sold_at))
            ORDER BY SUM(quantity * unit_price) DESC
        ) AS rn
    FROM sales
    GROUP BY quarter_label, product
) t
WHERE rn = 1
ORDER BY quarter_label;
```
