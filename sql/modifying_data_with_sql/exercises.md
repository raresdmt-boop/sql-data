# Modifying Data — Exerciții propuse

Folosește baza `cinema_db` (vezi `init.sql` + `seed.sql`).

> 💡 Resetare rapidă: rulează din nou `init.sql` urmat de `seed.sql` ca să revii la starea inițială.
> ⚠️ În MySQL Workbench dezactivează safe-update-mode pentru câteva exerciții: `SET SQL_SAFE_UPDATES = 0;`

---

## INSERT

- [ ] **EX-1.** Inserează un film nou cu toate coloanele specificate prin poziție: `'The Prestige'`, `'Drama'`, 2006, `'Christopher Nolan'`, 8.5, 27.00, 0.
- [ ] **EX-2.** Inserează un film nou specificând explicit numele coloanelor (ordinea ta): `'Memento'`, `'Thriller'`, 2000, regizor `'Christopher Nolan'`, rating 8.4, lasă `ticket_price` și `seats_sold` să ia valorile default.
- [ ] **EX-3.** Inserează **3 filme** într-un singur `INSERT`: `'Joker'` (2019, Drama), `'Parasite'` (2019, Thriller), `'Oppenheimer'` (2023, Drama).
- [ ] **EX-4.** Inserează un film fără rating și fără regizor (verifică ce coloane permit `NULL`).

## UPDATE

- [ ] **EX-5.** Mărește prețul biletului cu 10% pentru toate filmele din genul `'Sci-Fi'`. *Hint:* `ticket_price = ticket_price * 1.1`.
- [ ] **EX-6.** Setează rating-ul la 9.1 pentru filmul `'The Godfather'`.
- [ ] **EX-7.** Pentru filmele lansate înainte de 2000, scade prețul biletului la 18.00 RON.
- [ ] **EX-8.** Update simultan a două coloane: pentru `'Avatar'`, setează `seats_sold = 700` și `ticket_price = 32.00`.
- [ ] **EX-9.** Mărește `seats_sold` cu 50 pentru toate filmele cu rating ≥ 8.5.

## DELETE

- [ ] **EX-10.** Șterge filmul cu `id = 2` (`'The Matrix Reloaded'`).
- [ ] **EX-11.** Șterge toate filmele cu `seats_sold < 200`.
- [ ] **EX-12.** Șterge filmele lansate înainte de 1990.

## Tranzacții

- [ ] **EX-13.** Pornește o tranzacție, șterge **toate** rândurile din `movies` cu `DELETE FROM movies;`, verifică numărul cu `SELECT COUNT(*)`, apoi `ROLLBACK;`. Confirmă că datele s-au întors.
- [ ] **EX-14.** Tranzacție **comitată**: scade prețul cu 5 RON la toate filmele de gen `'Drama'`, apoi scade `seats_sold` cu 10 la aceleași filme. Dacă ambele update-uri reușesc, fă `COMMIT;`. Verifică modificările cu un `SELECT`.
- [ ] **EX-15.** Tranzacție eșuată **simulată**: pornește tranzacția, fă un `INSERT` valid pentru `'Dune'`, apoi observă efectul în alt client. Fă `ROLLBACK;` și confirmă că `'Dune'` nu mai există în tabel.

## Provocări

- [ ] **CH-1.** Update condițional: dacă rating-ul e peste 8.5 mărește prețul cu 5 RON, dacă e între 7 și 8.5 mărește cu 2, altfel scade cu 1. *Hint:* folosește `CASE WHEN ... THEN ... END` în `SET`.
- [ ] **CH-2.** Șterge într-o singură comandă toate filmele cu rating `NULL`. Notează ce condiție folosești (atenție la `= NULL`).

---

## Scenarii frecvente în producție

- [ ] **PR-1.** Backfill de date: inserează filmul `'Dune: Part Two'` cu toate coloanele relevante și verifică faptul că nu ai lăsat `ticket_price` sau `seats_sold` pe valori greșite implicit.
- [ ] **PR-2.** Corecție de preț: mărește `ticket_price` cu 3 RON pentru toate filmele lansate după 2010.
- [ ] **PR-3.** Curățare operațională: setează `director = 'Unknown'` pentru toate filmele unde directorul este `NULL`.
- [ ] **PR-4.** Backfill de rating: pentru filmele cu `rating IS NULL`, setează temporar `rating = 7.0`.
- [ ] **PR-5.** Bulk correction: pentru toate filmele regizate de `'Christopher Nolan'`, mărește `seats_sold` cu 25.
- [ ] **PR-6.** Ajustare diferențiată: pentru filmele cu `seats_sold > 450` mărește prețul cu 2 RON, iar pentru cele cu `seats_sold < 250` scade-l cu 2 RON. Folosește un singur `UPDATE`.
- [ ] **PR-7.** Campaign rollback drill: într-o tranzacție, scade prețul cu 15% pentru toate filmele din `'Sci-Fi'`, verifică rezultatul, apoi fă `ROLLBACK`.
- [ ] **PR-8.** Cleanup de catalog: șterge toate filmele cu `year_released < 1980` și `seats_sold < 200`.
- [ ] **PR-9.** Data repair: pentru toate filmele cu rating peste 9.0 setează `ticket_price = ticket_price + 4`.
- [ ] **PR-10.** Insert idempotent: inserează filmul `'The Prestige'` doar dacă nu există deja un film cu același `title` și `year_released`. *Hint:* `INSERT INTO ... SELECT ... WHERE NOT EXISTS (...)`.
- [ ] **PR-11.** Simulare de vânzare: într-o tranzacție, crește `seats_sold` cu 1 pentru `'Inception'`, verifică valoarea nouă, apoi fă `COMMIT`.
- [ ] **PR-12.** Hotfix pe catalog: schimbă genul filmului `'The Godfather'` în `'Crime Drama'`, verifică rezultatul, apoi decide dacă păstrezi sau anulezi modificarea prin tranzacție.
