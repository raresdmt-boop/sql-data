# Querying Relational Databases — Recap pe Online School

Folosește baza `online_school_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Relațiile cheie:
> - `student` 1:1 `student_id_card` (unii studenți nu au card)
> - `student` 1:N `book` (unii studenți nu au cărți)
> - `student` M:N `course` prin `enrolment`

---

## INNER JOIN — două tabele

- [ ] **EX-1.** Lista (`first_name`, `last_name`, `card_number`) pentru studenții care **au** card. *(Așteptat: 5 rânduri)*
- [ ] **EX-2.** Lista cărților cu numele studentului care le deține: `book.book_name`, `student.first_name`, `student.last_name`. *(Așteptat: 6 rânduri)*
- [ ] **EX-3.** Pentru fiecare înrolare: `student.email`, `course.name`, `enrolment.created_at`. *(Așteptat: 10 rânduri)*

## Multi-table JOIN

- [ ] **EX-4.** Lista (`student.first_name`, `student.last_name`, `course.name`, `course.department`) pentru toate înrolările. *(Așteptat: 10 rânduri)*
- [ ] **EX-5.** Pentru fiecare carte: titlul cărții, numele studentului și departamentul cursurilor la care e înrolat (poate fi mai multe rânduri per carte dacă studentul e înrolat la mai multe cursuri).
- [ ] **EX-6.** Studenții care **au și** card **și** cel puțin o înrolare: `first_name`, `last_name`, `card_number`, `course.name`.

## LEFT JOIN & anti-join

- [ ] **EX-7.** Studenții **fără card** (anti-join pe `student_id_card`). *(Așteptat: 3 rânduri — Florin, Gabriela, Horia)*
- [ ] **EX-8.** Studenții **fără nicio carte**. *(Așteptat: 3 rânduri — Cristina, Elena, Florin)*
- [ ] **EX-9.** Studenții **fără nicio înrolare**. *(Așteptat: 1 rând — Florin)*
- [ ] **EX-10.** Cursurile **fără niciun înrolat**. *(Așteptat: 0 rânduri pe seed-ul curent — toate au cel puțin un student.)*
- [ ] **EX-11.** Pentru fiecare student afișează numele și `card_number` dacă există, altfel `NULL`. Folosește `LEFT JOIN`. *(Așteptat: 8 rânduri)*

## Self-join

- [ ] **EX-12.** Perechi de studenți de **aceeași vârstă**. Folosește `student s1 JOIN student s2 ON s1.age = s2.age AND s1.id < s2.id`. *(Așteptat: 0 rânduri pe seed-ul curent — toate vârstele sunt distincte. Inserează un student de 22 ca să vezi diferența.)*
- [ ] **EX-13.** Perechi de studenți cu **același prenume**. Folosește self-join cu `s1.id < s2.id`. *(Așteptat: 0 — toate prenumele sunt unice.)*
- [ ] **EX-14.** Perechi de cursuri din **același departament**. Folosește self-join pe `course`. *(Așteptat: 2 perechi — în CS și în Math.)*

## Set operations (MySQL 8.0.31+)

- [ ] **EX-15.** Toate id-urile distincte de student care apar fie în `book.student_id`, fie în `enrolment.student_id`. Folosește `UNION`.
- [ ] **EX-16.** Studenții care apar **și** în `book`, **și** în `enrolment`. Folosește `INTERSECT` pe două subquery-uri. *(Așteptat: 4 studenți — Ana, Bogdan, David, Gabriela și Horia... verifică.)*
- [ ] **EX-17.** Studenții care apar în `student` dar **nu** în `student_id_card`. Folosește `EXCEPT` între `SELECT id FROM student` și `SELECT student_id FROM student_id_card`. *(Așteptat: 3 rânduri — același set ca EX-7.)*

## Subqueries

- [ ] **EX-18.** Studenții înrolați cel puțin la un curs din departamentul `'CS'`. Folosește `IN` cu subquery. *(Așteptat: 4 studenți — Ana, Bogdan, Cristina, Gabriela, Horia.)*
- [ ] **EX-19.** Cursurile la care **niciun student nu e înrolat**. Folosește `NOT IN` sau `NOT EXISTS` (verifică EX-10).
- [ ] **EX-20.** Studenții care au **mai mulți de un** card asociat. *(Așteptat: 0 — UNIQUE garantează asta. Exercițiu pentru a înțelege query-ul.)*
- [ ] **EX-21.** Pentru fiecare student afișează `email` și numărul de cărți printr-un **scalar subquery** în `SELECT` (nu `JOIN`/`GROUP BY`).
- [ ] **EX-22.** Studenții care au **toate** înrolările în același departament (folosește `NOT EXISTS` cu o subcerere care găsește o înrolare a studentului într-un alt departament).

## Provocări

- [ ] **EX-23.** Studenții înrolați la `Algorithms` **dar nu** la `Calculus`. Folosește `IN` + `NOT IN`. *(Așteptat: 2 studenți — Cristina, Horia.)*
- [ ] **EX-24.** Cursurile la care e înrolată Ana (`email = 'ana@school.ro'`).
- [ ] **EX-25.** Studenții care au în comun cel puțin un curs cu Ana. Self-join pe `enrolment`, exclude-o pe Ana din rezultat.

## Scenarii frecvente în producție

- [ ] **EX-26.** Catalog admin: pentru fiecare student, lista cursurilor concatenate într-un singur câmp (`GROUP_CONCAT(course.name)`). *(Singura excepție de la „fără agregări" — e concat de stringuri, nu KPI.)*
- [ ] **EX-27.** Audit integritate: există vreo carte (`book.student_id`) care **nu** mai există în `student`? Folosește `LEFT JOIN` + `IS NULL`. *(Așteptat: 0 — FK garantează asta, dar exercițiul rămâne util.)*
- [ ] **EX-28.** Recommendation simplu: studenții care sunt înrolați la **toate** cursurile din `'CS'`. Indicație: `NOT EXISTS` pe cursurile CS la care studentul nu e înrolat.
