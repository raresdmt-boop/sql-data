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
