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

---

## Scenarii frecvente în producție

- [ ] **PR-1.** Audit de acoperire: afișează toate cursurile, numele profesorului și numărul de studenți înscriși la fiecare curs. Include și cursurile fără profesor sau fără studenți.
- [ ] **PR-2.** Identifică profesorii care nu predau niciun curs. *Hint:* `LEFT JOIN instructors ↔ courses`.
- [ ] **PR-3.** Identifică studenții care nu au nicio notă completată încă, deși sunt înscriși la cel puțin un curs.
- [ ] **PR-4.** Afișează pentru fiecare student numărul de credite la care este înscris în total. *Hint:* `SUM(courses.credits)`.
- [ ] **PR-5.** Găsește studenții care au simultan cursuri din `'Computer Science'` și `'Mathematics'`.
- [ ] **PR-6.** Raport de performanță pe profesor: numele profesorului și media tuturor notelor de pe cursurile lui, excluzând notele `NULL`.
- [ ] **PR-7.** Cursurile cu risc operațional: cursurile care au cel puțin 2 studenți și media notelor sub 8.0.
- [ ] **PR-8.** Pentru fiecare catedră afișează numărul de studenți unici înscriși la cursurile profesorilor din acea catedră.
- [ ] **PR-9.** Afișează perechi de studenți care sunt colegi la cel puțin un curs. Nu duplica perechile. *Hint:* self-join pe `enrollments` cu `e1.student_id < e2.student_id`.
- [ ] **PR-10.** Afișează studenții care au note la toate cursurile la care sunt înscriși. *Hint:* compară `COUNT(*)` cu `COUNT(grade)`.
- [ ] **PR-11.** Detectează cursurile unde toți studenții au notă completată și media este peste 8.5.
- [ ] **PR-12.** Pentru fiecare student afișează cursul la care are cea mai mare notă. Dacă are mai multe note egale maxime, toate trebuie să apară.
