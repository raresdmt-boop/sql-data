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
