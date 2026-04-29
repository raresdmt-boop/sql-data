# Querying Relational Databases — Exerciții propuse

Folosește baza `university_db` (vezi `init.sql` + `seed.sql`). 4 tabele: `students`, `courses`, `enrollments` (pivot N-N), `instructors`.

---

## INNER JOIN

- [ ] **EX-1.** Afișează `student.first_name`, `student.last_name`, `course.name` și `grade` pentru toate înrolările care au notă (rating != NULL). *(Așteptat: 17 rânduri)*
- [ ] **EX-2.** Afișează `course.name` și `instructor.first_name + ' ' + instructor.last_name` pentru fiecare curs care are profesor.
- [ ] **EX-3.** Pentru fiecare student afișează numele lui și numele cursurilor la care e înscris (poate apărea de mai multe ori dacă e înscris la mai multe cursuri).

## Multi-table JOIN

- [ ] **EX-4.** Afișează numele studentului, numele cursului și numele profesorului — pentru toate înrolările cu notă peste 8.0.
- [ ] **EX-5.** Pentru cursul `'Databases'` afișează lista studenților înscriși cu nota lor.

## LEFT JOIN

- [ ] **EX-6.** Afișează **toate** cursurile, inclusiv cele care nu au profesor asignat. *(Hint: LEFT JOIN courses ↔ instructors. Așteptat: 8 rânduri)*
- [ ] **EX-7.** Afișează **toți** studenții, plus numărul de cursuri la care sunt înscriși. Inclusiv studenții care nu sunt înscriși la niciun curs (dacă există).
- [ ] **EX-8.** Cursurile la care **nu e înscris niciun student**. *(Hint: LEFT JOIN courses ↔ enrollments + WHERE enrollment.student_id IS NULL)*

## Self-join

- [ ] **EX-9.** Afișează perechi de profesori care lucrează în aceeași catedră. Nu duplica perechile (un cuplu apare o singură dată). *(Hint: `i1.id < i2.id`)*

## Set operations

- [ ] **EX-10.** Lista email-urilor profesorilor și studenților, fără duplicate. *Hint:* atenție — `instructors` nu are email; folosește `CONCAT(first_name, '.', last_name)` ca identificator. Rulează `UNION` între cele două.
- [ ] **EX-11.** Folosește `UNION ALL` în loc de `UNION` pentru exercițiul anterior și observă diferența.

## Subqueries

- [ ] **EX-12.** Afișează numele studenților care au cel puțin o notă peste 9.0. Folosește `WHERE id IN (SELECT ...)`.
- [ ] **EX-13.** Afișează cursurile la care s-a înscris **mai mult de 1 student**. *Hint:* subquery cu `GROUP BY course_id HAVING COUNT(*) > 1`.
- [ ] **EX-14.** Folosind o tabelă derivată, afișează numele studentului și media notelor lui (doar pentru studenții cu media calculabilă).
- [ ] **EX-15.** Subquery corelat: afișează studenții care au o notă mai mare decât **media propriilor note**.

## Provocări

- [ ] **CH-1.** Top 3 cele mai populare cursuri (cele mai multe înscrieri) cu numele cursului și numărul de studenți.
- [ ] **CH-2.** Pentru fiecare profesor afișează numărul total de studenți unici care învață la cursurile lui.
- [ ] **CH-3.** Studenții care învață la cursuri din **toate** catedrele profesorilor existenți (nu există în seed, dar query-ul trebuie să fie corect).
