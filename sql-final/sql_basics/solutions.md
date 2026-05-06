# SQL Basics — Soluții

Soluțiile pentru exercițiile din `../../sql-start/sql_basics/exercises.md`. Folosește baza `library_db`.

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < seed.sql
```

---

## SELECT & coloane

### EX-1. Toate coloanele și rândurile.
```sql
SELECT * FROM books;
```

### EX-2. Doar `title` și `author`.
```sql
SELECT title, author FROM books;
```

### EX-3. Aliasuri pe coloane.
```sql
SELECT title AS "Titlu", author AS "Autor", price AS "Pret"
FROM books;
```

## WHERE — operatori de comparație

### EX-4. Cărțile din genul `'Programming'`.
```sql
SELECT * FROM books
WHERE genre = 'Programming';
```

### EX-5. Cărțile care **nu** sunt din genul `'Fiction'`.
```sql
SELECT * FROM books
WHERE genre <> 'Fiction';
```

### EX-6. Cărțile cu peste 500 de pagini.
```sql
SELECT * FROM books
WHERE pages > 500;
```

### EX-7. Cărțile publicate **înainte** de 1950.
```sql
SELECT * FROM books
WHERE year_published < 1950;
```

### EX-8. Cărțile cu prețul ≥ 100 RON.
```sql
SELECT * FROM books
WHERE price >= 100;
```

## AND / OR

### EX-9. Cărțile din genul `'Fantasy'` cu peste 500 pagini.
```sql
SELECT * FROM books
WHERE genre = 'Fantasy'
  AND pages > 500;
```

### EX-10. Cărțile scrise de `'Yuval Noah Harari'` sau `'Walter Isaacson'`.
```sql
SELECT * FROM books
WHERE author = 'Yuval Noah Harari'
   OR author = 'Walter Isaacson';
```

## IN / NOT IN

### EX-11. Cărțile din genurile `'Science'`, `'History'` sau `'Biography'`.
```sql
SELECT * FROM books
WHERE genre IN ('Science', 'History', 'Biography');
```

### EX-12. Cărțile care nu sunt nici `'Programming'`, nici `'Fiction'`.
```sql
SELECT * FROM books
WHERE genre NOT IN ('Programming', 'Fiction');
```

## BETWEEN

### EX-13. Cărțile cu prețul între 50 și 100 RON inclusiv.
```sql
SELECT * FROM books
WHERE price BETWEEN 50 AND 100;
```

### EX-14. Cărțile publicate între 2000 și 2020.
```sql
SELECT * FROM books
WHERE year_published BETWEEN 2000 AND 2020;
```

## LIKE

### EX-15. Cărțile al căror titlu începe cu `'The '`.
```sql
SELECT * FROM books
WHERE title LIKE 'The %';
```

### EX-16. Cărțile al căror autor conține cuvântul `'Harari'`.
```sql
SELECT * FROM books
WHERE author LIKE '%Harari%';
```

### EX-17. Cărțile al căror titlu se termină cu `'Code'` sau `'JS'`.
```sql
SELECT * FROM books
WHERE title LIKE '%Code'
   OR title LIKE '%JS';
```

## IS NULL / IS NOT NULL

### EX-18. Cărțile fără rating completat.
```sql
SELECT * FROM books
WHERE rating IS NULL;
```

### EX-19. Cărțile fără număr de pagini specificat.
```sql
SELECT * FROM books
WHERE pages IS NULL;
```

### EX-20. Cărțile care **au** rating completat și sunt în stoc.
```sql
SELECT * FROM books
WHERE rating IS NOT NULL
  AND in_stock = TRUE;
```

## Mix — provocări

### CH-1. `'Programming'` cu rating ≥ 4.3, în stoc.
```sql
SELECT * FROM books
WHERE genre = 'Programming'
  AND rating >= 4.3
  AND in_stock = TRUE;
```

### CH-2. Titlu cu `'Java'` sau `'JS'`, publicate după 2010.
```sql
SELECT * FROM books
WHERE (title LIKE '%Java%' OR title LIKE '%JS%')
  AND year_published > 2010;
```

---

## Scenarii frecvente în producție

### PR-1. Catalog pentru homepage.
```sql
SELECT *
FROM books
WHERE in_stock = TRUE
  AND rating IS NOT NULL
ORDER BY rating DESC, price ASC;
```

### PR-2. Data quality cu câmp calculat `missing_field`.
```sql
SELECT
    id,
    title,
    author,
    CASE
        WHEN pages IS NULL AND rating IS NULL THEN 'pages, rating'
        WHEN pages IS NULL                    THEN 'pages'
        WHEN rating IS NULL                   THEN 'rating'
    END AS missing_field
FROM books
WHERE pages IS NULL
   OR rating IS NULL;
```

### PR-3. Cărți foarte scumpe cu rating slab sau lipsă.
```sql
SELECT *
FROM books
WHERE price > 120
  AND (rating < 4.0 OR rating IS NULL);
```

### PR-4. Selecție pentru campanie.
```sql
SELECT *
FROM books
WHERE genre IN ('Programming', 'Science')
  AND year_published > 2000
  AND in_stock = TRUE
  AND price < 150;
```

### PR-5. Outliers: peste 600 pagini cu preț sub 70.
```sql
SELECT *
FROM books
WHERE pages > 600
  AND price < 70;
```

### PR-6. Titluri `'The '` care nu sunt în stoc.
```sql
SELECT *
FROM books
WHERE title LIKE 'The %'
  AND in_stock = FALSE;
```

### PR-7. Backfill prioritization.
```sql
SELECT *
FROM books
WHERE genre IN ('Biography', 'History')
  AND rating IS NULL
ORDER BY year_published DESC;
```

### PR-8. Procurement: indisponibile cu rating ≥ 4.3.
```sql
SELECT *
FROM books
WHERE in_stock = FALSE
  AND rating >= 4.3;
```

### PR-9. Business rule: înainte de 1900 cu preț > 100.
```sql
SELECT *
FROM books
WHERE year_published < 1900
  AND price > 100;
```

### PR-10. Segmentare pe benzi de preț — trei query-uri separate.
```sql
-- band 1: [0, 50]
SELECT * FROM books WHERE price BETWEEN 0 AND 50;

-- band 2: (50, 100]
SELECT * FROM books WHERE price > 50 AND price <= 100;

-- band 3: > 100
SELECT * FROM books WHERE price > 100;
```

### PR-11. Watchlist tehnic.
```sql
SELECT *
FROM books
WHERE genre IN ('Programming', 'Fantasy')
  AND pages > 450
  AND rating > 4.5;
```

### PR-12. Audit pe naming: autor cu punct.
```sql
SELECT *
FROM books
WHERE author LIKE '%.%';
```
