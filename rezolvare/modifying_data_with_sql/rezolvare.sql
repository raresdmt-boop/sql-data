-- - [ ] **EX-1.** Inserează un film nou cu toate coloanele specificate prin poziție:
 `'The Prestige'`, `'Drama'`, 2006, `'Christopher Nolan'`, 8.5, 27.00, 0.

INSERT INTO movies (title, genre, year_released, director, rating, ticket_price, seats_sold)
VALUES ( 'The Prestige', 'Drama', 2006, 'Christopher Nolan', 8.5, 27.00, 0);

- [ ] **EX-2.** Inserează un film nou specificând explicit numele coloanelor (ordinea ta):
 `'Memento'`, `'Thriller'`, 2000, regizor `'Christopher Nolan'`, rating 8.4, 
 lasă `ticket_price` și `seats_sold` să ia valorile default.

INSERT INTO movies (title, genre, year_released, director, rating)
VALUES ('Memento', 'Thriller', 2000, 'Christopher Nolan', 8.4);

- [ ] **EX-3.** Inserează **3 filme** într-un singur `INSERT`:
 `'Joker'` (2019, Drama), `'Parasite'` (2019, Thriller), `'Oppenheimer'` (2023, Drama).

INSERT INTO movies (title, genre, year_released)
VALUES ('Joker', 'Drama', 2019),
       ('Parasite', 'Thriller', 2019),
       ('Oppenheimer', 'Drama', 2023);

- [ ] **EX-4.** Inserează un film fără rating și fără regizor (verifică ce coloane permit `NULL`).
INSERT INTO movies (title, genre, year_released, ticket_price, seats_sold)
VALUES ('Lala Land', 'Musical', 2020, 32.00, 100);
-- rating si regizor permit NULL


-- Update
- [ ] **EX-5.** Mărește prețul biletului cu 10% pentru toate filmele din genul `'Sci-Fi'`.
 *Hint:* `ticket_price = ticket_price * 1.1`.
UPDATE movies
SET ticket_price = ticket_price *1.1
WHERE genre = 'Sci-Fi';

- [ ] **EX-6.** Setează rating-ul la 9.1 pentru filmul `'The Godfather'`.
UPDATE movies
SET rating = 9.1
WHERE title = 'The Godfather';

- [ ] **EX-7.** Pentru filmele lansate înainte de 2000, scade prețul biletului la 18.00 RON.
UPDATE movies
SET ticket_price = 18.00
WHERE year_released < 2000;

- [ ] **EX-8.** Update simultan a două coloane: pentru `'Avatar'`, setează `seats_sold = 700` și `ticket_price = 32.00`.
UPDATE movies
SET seats_sold = 700, ticket_price = 32.00
WHERE title = 'Avatar';

- [ ] **EX-9.** Mărește `seats_sold` cu 50 pentru toate filmele cu rating ≥ 8.5.
UPDATE movies
SET seats_sold =seats_sold + 50
WHERE rating >= 8.5;

-- Delete
- [ ] **EX-10.** Șterge filmul cu `id = 2` (`'The Matrix Reloaded'`).
DELETE FROM movies
WHERE id = 2;

- [ ] **EX-11.** Șterge toate filmele cu `seats_sold < 200`.
DELETE FROM movies
WHERE seats_sold < 200;

- [ ] **EX-12.** Șterge filmele lansate înainte de 1990.
DELETE FROM movies
WHERE year_released < 1990;

- [ ] **CH-1.** Update condițional: dacă rating-ul e peste 8.5 mărește prețul cu 5 RON,
 dacă e între 7 și 8.5 mărește cu 2, altfel scade cu 1. *Hint:* folosește `CASE WHEN ... THEN ... END` în `SET`.
UPDATE movies
SET ticket_price =
    (
        CASE
            WHEN rating > 8.5 THEN ticket_price + 5
            WHEN rating> 7 AND rating <= 8.5 THEN ticket_price + 2
            ELSE ticket_price -1
        END
        );

- [ ] **CH-2.** Șterge într-o singură comandă toate filmele cu rating `NULL`. 
Notează ce condiție folosești (atenție la `= NULL`).
DELETE FROM movies
WHERE rating IS NULL;