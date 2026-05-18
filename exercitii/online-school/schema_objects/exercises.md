# Schema Objects — Recap pe Online School

Folosește baza `online_school_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Aceste exerciții modifică **schema**, nu doar datele. După ce te-ai jucat, rerulezi `../init.sql` ca să revii la baza curată. Pentru `DELIMITER //` ai nevoie de un client care îl suportă (MySQL CLI, Workbench).

---

## DDL — modificări de schemă

- [ ] **EX-1.** Adaugă coloana `enrollment_year SMALLINT NULL` în `student` (anul în care a fost înrolat — diferit de `enrolment.created_at`).
- [ ] **EX-2.** Adaugă un `CHECK (age BETWEEN 14 AND 100)` pe `student.age`.
- [ ] **EX-3.** Redenumește tabelul `enrolment` în `enrollment` (cu `RENAME TABLE`). *(Atenție: invalidează exercițiile care folosesc numele vechi; pune-l înapoi cu un al doilea `RENAME`.)*
- [ ] **EX-4.** Modifică tipul `course.name` în `VARCHAR(200)`.
- [ ] **EX-5.** Adaugă o coloană generată `full_name VARCHAR(170) GENERATED ALWAYS AS (CONCAT(first_name, ' ', last_name)) STORED` în `student`. Verifică valorile cu un `SELECT`.
- [ ] **EX-6.** Adaugă constraint `ON UPDATE CASCADE` pe FK-urile din `enrolment` (necesită drop + recreate FK).

## Indexes

- [ ] **EX-7.** Index simplu pe `student.age` — folosit la filtre pe interval de vârstă.
- [ ] **EX-8.** Index pe `course.department` — folosit la rapoarte pe departament.
- [ ] **EX-9.** Index compus pe `book (student_id, created_at)` — accelerează „toate cărțile unui student, sortate".
- [ ] **EX-10.** Index `FULLTEXT` pe `book.book_name`. Apoi caută `MATCH(book_name) AGAINST('algorithms')`.
- [ ] **EX-11.** Șterge unul dintre indexurile create mai sus (`DROP INDEX`). Verifică cu `SHOW INDEX FROM ...`.

## Views

- [ ] **EX-12.** View `v_student_overview` cu `id`, `first_name`, `last_name`, `email`, `age`, `card_number` (LEFT JOIN cu `student_id_card`).
- [ ] **EX-13.** View `v_enrolment_details` cu `student.email`, `course.name`, `course.department`, `enrolment.created_at`.
- [ ] **EX-14.** View `v_cs_courses` peste `course WHERE department = 'CS'`. Încearcă să faci `INSERT INTO v_cs_courses (name, department)` — verifică dacă view-ul e actualizabil.
- [ ] **EX-15.** Șterge view-ul `v_cs_courses` cu `DROP VIEW`.

## Stored Procedures

- [ ] **EX-16.** Procedura `sp_enrol_student(IN p_email VARCHAR(150), IN p_course_name VARCHAR(150))`:
  - găsește `student_id` din `student.email`;
  - găsește `course_id` din `course.name`;
  - dacă oricare lipsește, `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student or course not found'`;
  - inserează în `enrolment` cu `created_at = NOW()`;
  - tratează `DUPLICATE KEY` ca pe o eroare semnificativă (mesaj clar în engleză).
- [ ] **EX-17.** Procedura `sp_issue_card(IN p_student_id BIGINT, IN p_card_number VARCHAR(80))` care:
  - validează că studentul există;
  - validează că nu are deja card (UNIQUE pe `student_id`);
  - inserează altfel.
- [ ] **EX-18.** Procedura `sp_transfer_enrolment(IN p_email VARCHAR(150), IN p_from_course VARCHAR(150), IN p_to_course VARCHAR(150))` care mută atomic înrolarea unui student dintr-un curs în altul. Rulează într-o tranzacție.
- [ ] **EX-19.** Șterge una dintre proceduri cu `DROP PROCEDURE`.

## Stored Functions

- [ ] **EX-20.** Funcție `fn_student_has_card(p_student_id BIGINT) RETURNS BOOLEAN` care întoarce `TRUE` dacă studentul are un card emis.
- [ ] **EX-21.** Funcție `fn_age_group(p_age INT) RETURNS VARCHAR(20)` care întoarce `'teen'` (<20), `'young'` (20-29), `'adult'` (≥30).
- [ ] **EX-22.** Funcție `fn_student_full_name(p_id BIGINT) RETURNS VARCHAR(170)` care întoarce `CONCAT(first_name, ' ', last_name)` sau `'unknown'` dacă id-ul nu există.

## Triggers

- [ ] **EX-23.** `BEFORE INSERT ON enrolment`: dacă `NEW.created_at IS NULL`, setează `NEW.created_at = NOW()`.
- [ ] **EX-24.** `BEFORE INSERT ON book`: dacă `NEW.created_at IS NULL`, setează `NEW.created_at = NOW()`.
- [ ] **EX-25.** `BEFORE UPDATE ON student`: dacă `NEW.age < 14`, aruncă `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Student must be at least 14 years old'`.
- [ ] **EX-26.** `AFTER DELETE ON student`: scrie într-o tabelă `audit_log (id, table_name, row_id, action, changed_at)` câmpul `OLD.id`.
- [ ] **EX-27.** Creează tabela `audit_log` (`id` PK, `table_name VARCHAR(80)`, `row_id BIGINT`, `action VARCHAR(20)`, `changed_at DATETIME`) și un trigger `AFTER INSERT ON enrolment` care scrie în ea.

## Provocări

- [ ] **EX-28.** View `v_orphan_students` care arată studenții fără card **și** fără înrolare (atenție: cei fără card sunt 3, fără înrolare e doar 1 — intersecția e... verifică).
- [ ] **EX-29.** Adaugă un `UNIQUE (student_id, book_name)` pe `book` — un student nu poate avea aceeași carte de două ori. Testează cu un `INSERT` care încalcă regula.
- [ ] **EX-30.** Procedură `sp_purge_inactive_students(IN p_days INT)` care șterge studenții fără înrolări și fără cărți de mai mult de `p_days` zile. Atenție la `ON DELETE CASCADE`.

## Scenarii frecvente în producție

- [ ] **EX-31.** Adaugă coloana `deleted_at DATETIME NULL` în `student` și transformă ștergerile în „soft delete" — actualizează `v_student_overview` să exclude rândurile soft-deleted.
- [ ] **EX-32.** Trigger care nu permite ștergerea unui curs dacă există înrolări active la el (`BEFORE DELETE ON course` + `SIGNAL`, înainte de a se aplica `ON DELETE CASCADE`).
