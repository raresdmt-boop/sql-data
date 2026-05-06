# Modifying Data — Soluții

Soluțiile pentru exercițiile din `../../sql-start/modifying_data_with_sql/exercises.md`. Folosește baza `cinema_db`.

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < seed.sql
```

> ⚠️ Pentru UPDATE/DELETE fără cheie: `SET SQL_SAFE_UPDATES = 0;`
> 🔁 Resetare rapidă între exerciții: rerulează `init.sql` + `seed.sql`.

---

## INSERT

### EX-1. INSERT cu coloane prin poziție.
```sql
INSERT INTO movies VALUES
    (NULL, 'The Prestige', 'Drama', 2006, 'Christopher Nolan', 8.5, 27.00, 0);
```

### EX-2. INSERT cu coloane explicite, default pe `ticket_price` și `seats_sold`.
```sql
INSERT INTO movies (title, genre, year_released, director, rating)
VALUES ('Memento', 'Thriller', 2000, 'Christopher Nolan', 8.4);
```

### EX-3. INSERT multi-row.
```sql
INSERT INTO movies (title, genre, year_released) VALUES
    ('Joker',       'Drama',    2019),
    ('Parasite',    'Thriller', 2019),
    ('Oppenheimer', 'Drama',    2023);
```

### EX-4. INSERT fără rating și fără regizor.
```sql
INSERT INTO movies (title, genre, year_released)
VALUES ('Untitled Project', 'Drama', 2024);
```

## UPDATE

### EX-5. +10% la preț pentru `'Sci-Fi'`.
```sql
UPDATE movies
SET ticket_price = ticket_price * 1.1
WHERE genre = 'Sci-Fi';
```

### EX-6. Rating 9.1 pentru `'The Godfather'`.
```sql
UPDATE movies
SET rating = 9.1
WHERE title = 'The Godfather';
```

### EX-7. Preț 18.00 pentru filme dinainte de 2000.
```sql
UPDATE movies
SET ticket_price = 18.00
WHERE year_released < 2000;
```

### EX-8. Pentru `'Avatar'`, două coloane simultan.
```sql
UPDATE movies
SET seats_sold   = 700,
    ticket_price = 32.00
WHERE title = 'Avatar';
```

### EX-9. +50 seats_sold pentru rating ≥ 8.5.
```sql
UPDATE movies
SET seats_sold = seats_sold + 50
WHERE rating >= 8.5;
```

## DELETE

### EX-10. Șterge filmul cu `id = 2`.
```sql
DELETE FROM movies WHERE id = 2;
```

### EX-11. Șterge filmele cu `seats_sold < 200`.
```sql
DELETE FROM movies WHERE seats_sold < 200;
```

### EX-12. Șterge filmele lansate înainte de 1990.
```sql
DELETE FROM movies WHERE year_released < 1990;
```

## Tranzacții

### EX-13. Tranzacție cu ROLLBACK.
```sql
START TRANSACTION;

DELETE FROM movies;
SELECT COUNT(*) FROM movies;   -- 0

ROLLBACK;
SELECT COUNT(*) FROM movies;   -- 10 din nou
```

### EX-14. Tranzacție cu COMMIT pentru două update-uri.
```sql
START TRANSACTION;

UPDATE movies SET ticket_price = ticket_price - 5  WHERE genre = 'Drama';
UPDATE movies SET seats_sold   = seats_sold   - 10 WHERE genre = 'Drama';

COMMIT;

SELECT * FROM movies WHERE genre = 'Drama';
```

### EX-15. INSERT urmat de ROLLBACK.
```sql
START TRANSACTION;

INSERT INTO movies (title, genre, year_released, director, rating)
VALUES ('Dune', 'Sci-Fi', 2021, 'Denis Villeneuve', 8.0);

SELECT * FROM movies WHERE title = 'Dune';   -- vizibil în acest client

ROLLBACK;

SELECT * FROM movies WHERE title = 'Dune';   -- nu mai există
```

## Provocări

### CH-1. UPDATE condițional cu CASE.
```sql
UPDATE movies
SET ticket_price = ticket_price + CASE
    WHEN rating > 8.5                THEN  5
    WHEN rating BETWEEN 7 AND 8.5    THEN  2
    ELSE                                  -1
END;
```

### CH-2. Șterge filmele cu rating NULL.
```sql
DELETE FROM movies WHERE rating IS NULL;
```

---

## Scenarii frecvente în producție

### PR-1. Backfill: `'Dune: Part Two'` cu valori complete.
```sql
INSERT INTO movies (title, genre, year_released, director, rating, ticket_price, seats_sold)
VALUES ('Dune: Part Two', 'Sci-Fi', 2024, 'Denis Villeneuve', 8.6, 35.00, 0);
```

### PR-2. +3 RON la prețul filmelor lansate după 2010.
```sql
UPDATE movies
SET ticket_price = ticket_price + 3
WHERE year_released > 2010;
```

### PR-3. `director = 'Unknown'` pentru NULL-uri.
```sql
UPDATE movies
SET director = 'Unknown'
WHERE director IS NULL;
```

### PR-4. Backfill rating la 7.0 pentru NULL.
```sql
UPDATE movies
SET rating = 7.0
WHERE rating IS NULL;
```

### PR-5. +25 seats_sold pentru Christopher Nolan.
```sql
UPDATE movies
SET seats_sold = seats_sold + 25
WHERE director = 'Christopher Nolan';
```

### PR-6. Ajustare diferențiată într-un singur UPDATE.
```sql
UPDATE movies
SET ticket_price = CASE
    WHEN seats_sold > 450 THEN ticket_price + 2
    WHEN seats_sold < 250 THEN ticket_price - 2
    ELSE ticket_price
END;
```

### PR-7. Campaign rollback drill.
```sql
START TRANSACTION;

UPDATE movies
SET ticket_price = ticket_price * 0.85
WHERE genre = 'Sci-Fi';

SELECT title, ticket_price FROM movies WHERE genre = 'Sci-Fi';

ROLLBACK;
```

### PR-8. Cleanup catalog: `< 1980` și `seats_sold < 200`.
```sql
DELETE FROM movies
WHERE year_released < 1980
  AND seats_sold < 200;
```

### PR-9. +4 RON pentru rating > 9.0.
```sql
UPDATE movies
SET ticket_price = ticket_price + 4
WHERE rating > 9.0;
```

### PR-10. INSERT idempotent cu NOT EXISTS.
```sql
INSERT INTO movies (title, genre, year_released, director, rating, ticket_price, seats_sold)
SELECT 'The Prestige', 'Drama', 2006, 'Christopher Nolan', 8.5, 27.00, 0
FROM dual
WHERE NOT EXISTS (
    SELECT 1 FROM movies
    WHERE title = 'The Prestige' AND year_released = 2006
);
```

### PR-11. Simulare de vânzare cu COMMIT.
```sql
START TRANSACTION;

UPDATE movies SET seats_sold = seats_sold + 1 WHERE title = 'Inception';
SELECT title, seats_sold FROM movies WHERE title = 'Inception';

COMMIT;
```

### PR-12. Hotfix `'The Godfather'` cu ROLLBACK opțional.
```sql
START TRANSACTION;

UPDATE movies
SET genre = 'Crime Drama'
WHERE title = 'The Godfather';

SELECT title, genre FROM movies WHERE title = 'The Godfather';

-- decide:
-- COMMIT;   -- păstrează modificarea
-- ROLLBACK; -- anulează
```
