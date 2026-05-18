# SQL Basics — Recap pe Online School

Folosește baza `online_school_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Numerele de rânduri din „Așteptat" sunt verificate pe seed-ul implicit (8 studenți, 5 cursuri, 6 cărți). Toate exercițiile lucrează pe o singură tabelă — `student`, `course` sau `book`.

---

## SELECT & coloane

- [ ] **EX-1.** Afișează toate coloanele și rândurile din `student`. *(Așteptat: 8 rânduri)*
- [ ] **EX-2.** Afișează doar `first_name`, `last_name` și `email` din `student`.
- [ ] **EX-3.** Afișează `first_name AS "Prenume"`, `last_name AS "Nume"`, `age AS "Varsta"`.
- [ ] **EX-4.** Afișează `name` și `department` din `course`.

## WHERE — operatori de comparație

- [ ] **EX-5.** Studenții cu vârsta strict peste 25 ani. *(Așteptat: 4 rânduri)*
- [ ] **EX-6.** Studenții cu vârsta exact 19. *(Așteptat: 1 rând — Elena)*
- [ ] **EX-7.** Studenții care **nu** au 28 de ani. Folosește `!=` sau `<>`. *(Așteptat: 7 rânduri)*
- [ ] **EX-8.** Cărțile adăugate strict după `2026-02-01`. *(Așteptat: 3 rânduri)*
- [ ] **EX-9.** Cursurile care **nu** sunt din departamentul `'CS'`. *(Așteptat: 3 rânduri)*

## AND / OR

- [ ] **EX-10.** Studenții cu vârsta între 20 și 25 ani (strict). Folosește `AND`. *(Așteptat: 3 rânduri)*
- [ ] **EX-11.** Studenții cu prenumele `'Ana'` **sau** `'Bogdan'`. *(Așteptat: 2 rânduri)*
- [ ] **EX-12.** Cursurile din departamentele `'CS'` sau `'Math'`. *(Așteptat: 4 rânduri)*

## IN / NOT IN

- [ ] **EX-13.** Cursurile din departamentele `'CS'` sau `'History'`. Folosește `IN`. *(Așteptat: 3 rânduri)*
- [ ] **EX-14.** Studenții cu vârsta `IN (19, 22, 28)`. *(Așteptat: 3 rânduri)*
- [ ] **EX-15.** Cursurile care **nu** sunt din `'Math'` și nici din `'History'`. Folosește `NOT IN`. *(Așteptat: 2 rânduri)*

## BETWEEN

- [ ] **EX-16.** Studenții cu vârsta între 20 și 30 inclusiv. *(Așteptat: 6 rânduri)*
- [ ] **EX-17.** Cărțile adăugate între `2026-01-01` și `2026-02-28` inclusiv. *(Așteptat: 4 rânduri)*
- [ ] **EX-18.** Înrolările (`enrolment`) făcute în luna ianuarie 2026.

## LIKE

- [ ] **EX-19.** Studenții al căror prenume începe cu litera `'A'`. *(Așteptat: 1 rând — Ana)*
- [ ] **EX-20.** Studenții al căror prenume conține litera `'a'` (case insensitive cu collation-ul implicit).
- [ ] **EX-21.** Studenții cu emailul pe domeniul `school.ro`. *(Așteptat: 8 rânduri — toți)*
- [ ] **EX-22.** Cărțile cu titlul care conține `'Algorithms'`. *(Așteptat: 2 rânduri)*
- [ ] **EX-23.** Numerele de card care încep cu `CARD-00`. *(Așteptat: 5 rânduri — toate)*

## IS NULL / IS NOT NULL

> 💡 Schema actuală e foarte strictă: aproape toate coloanele sunt `NOT NULL`. Exercițiile de mai jos te pun să verifici că într-adevăr nu există date lipsă (audit).

- [ ] **EX-24.** Caută studenți care au `email IS NULL`. *(Așteptat: 0 rânduri — schema garantează asta.)*
- [ ] **EX-25.** Caută cărți cu `book_name IS NULL` și cu `created_at IS NULL`. *(Așteptat: 0 + 0.)*
- [ ] **EX-26.** Cursurile cu `department IS NOT NULL`. *(Așteptat: 5 rânduri — toate.)*

## Mix — provocări

- [ ] **EX-27.** Studenții care au între 20 și 30 ani și prenumele începe cu o literă din mulțimea `A`, `B`, `C` (`LEFT(first_name, 1) IN ('A','B','C')`).
- [ ] **EX-28.** Cărțile cu titlul care conține `Algorithms` sau `History`, adăugate după `2026-01-15`.
- [ ] **EX-29.** Cursurile care nu au departamentul `'Math'` și al căror nume conține `'a'`.

## Scenarii frecvente în producție

- [ ] **EX-30.** Newsletter eligibility: studenții cu vârsta ≥ 20 și emailul pe `school.ro`. Afișează `first_name`, `last_name`, `email`.
- [ ] **EX-31.** Catalog cursuri pe homepage: cursurile din `'CS'` și `'Math'`, sortate alfabetic. (Dacă ai voie `ORDER BY` — e ok aici, nu e agregare.)
- [ ] **EX-32.** Audit cititori activi: cărțile adăugate în ultimele 60 de zile față de `2026-04-01` (folosește `DATE_SUB`). *(Notă: data e fixă în seed.)*
