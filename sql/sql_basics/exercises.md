# SQL Basics — Exerciții propuse

Folosește baza `library_db` (vezi `init.sql` + `seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < seed.sql
```

> 💡 Numerele de rânduri din „Așteptat" sunt verificate pe seed-ul implicit (20 cărți). Nu există soluții — le scrii tu.

---

## SELECT & coloane

- [ ] **EX-1.** Afișează toate coloanele și rândurile din `books`. *(Așteptat: 20 rânduri)*
- [ ] **EX-2.** Afișează doar `title` și `author` pentru toate cărțile.
- [ ] **EX-3.** Afișează `title AS "Titlu"`, `author AS "Autor"`, `price AS "Pret"`.

## WHERE — operatori de comparație

- [ ] **EX-4.** Cărțile din genul `'Programming'`. *(Așteptat: 5 rânduri)*
- [ ] **EX-5.** Cărțile care **nu** sunt din genul `'Fiction'`. Folosește `!=` sau `<>`.
- [ ] **EX-6.** Cărțile cu peste 500 de pagini.
- [ ] **EX-7.** Cărțile publicate **înainte** de 1950.
- [ ] **EX-8.** Cărțile cu prețul ≥ 100 RON.

## AND / OR

- [ ] **EX-9.** Cărțile din genul `'Fantasy'` cu peste 500 pagini.
- [ ] **EX-10.** Cărțile scrise de `'Yuval Noah Harari'` **sau** `'Walter Isaacson'`.

## IN / NOT IN

- [ ] **EX-11.** Cărțile din genurile `'Science'`, `'History'` sau `'Biography'`. Folosește `IN`. *(Așteptat: 7 rânduri)*
- [ ] **EX-12.** Cărțile care nu sunt nici `'Programming'`, nici `'Fiction'`. Folosește `NOT IN`.

## BETWEEN

- [ ] **EX-13.** Cărțile cu prețul între 50 și 100 RON inclusiv.
- [ ] **EX-14.** Cărțile publicate între 2000 și 2020.

## LIKE

- [ ] **EX-15.** Cărțile al căror titlu începe cu `'The '`.
- [ ] **EX-16.** Cărțile al căror autor conține cuvântul `'Harari'`.
- [ ] **EX-17.** Cărțile al căror titlu se termină cu `'Code'` sau `'JS'`.

## IS NULL / IS NOT NULL

- [ ] **EX-18.** Cărțile fără rating completat (rating IS NULL). *(Așteptat: 2 rânduri)*
- [ ] **EX-19.** Cărțile fără număr de pagini specificat.
- [ ] **EX-20.** Cărțile care **au** rating completat și sunt în stoc.

## Mix — provocări

- [ ] **CH-1.** Cărțile din genul `'Programming'` cu rating ≥ 4.3, în stoc.
- [ ] **CH-2.** Cărțile cu titlul ce conține `'Java'` sau `'JS'`, publicate după 2010.

---

## Scenarii frecvente în producție

- [ ] **PR-1.** Catalog pentru homepage: afișează doar cărțile `in_stock = TRUE`, cu `rating IS NOT NULL`, ordonate după `rating` descrescător și apoi după `price` crescător.
- [ ] **PR-2.** Data quality: găsește cărțile care au `pages IS NULL` sau `rating IS NULL`. Afișează și un câmp calculat `missing_field` care spune ce lipsește.
- [ ] **PR-3.** Review operațional: afișează cărțile foarte scumpe (`price > 120`) care au rating sub 4.0 sau lipsă. Acestea sunt candidate pentru verificare manuală.
- [ ] **PR-4.** Selecție pentru campanie: cărțile din `'Programming'` sau `'Science'` publicate după 2000, aflate în stoc și cu preț sub 150 RON.
- [ ] **PR-5.** Detectare de outliers: cărțile cu peste 600 pagini și preț sub 70 RON.
- [ ] **PR-6.** Curățare de catalog: titlurile care încep cu `'The '` și nu sunt în stoc.
- [ ] **PR-7.** Backfill prioritization: cărțile din `'Biography'` sau `'History'` fără rating, ordonate după `year_published` descrescător.
- [ ] **PR-8.** Raport pentru procurement: cărțile care nu sunt în stoc, dar au rating de cel puțin 4.3.
- [ ] **PR-9.** Verificare de business rule: cărțile publicate înainte de anul 1900 cu preț peste 100 RON.
- [ ] **PR-10.** Segmentare pe benzi de preț: afișează toate cărțile din intervalul `[0, 50]`, `(50, 100]` și `> 100`, folosind condiții în `WHERE` pentru fiecare interogare separat.
- [ ] **PR-11.** Watchlist pentru bestseller-e tehnice: cărțile de `'Programming'` sau `'Fantasy'` cu peste 450 pagini și rating peste 4.5.
- [ ] **PR-12.** Audit simplu pe naming: cărțile al căror autor conține un punct (`.`) în nume. *Hint:* `LIKE '%.%'`
