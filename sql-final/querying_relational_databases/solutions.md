# Querying Relational Databases — Soluții

Soluțiile pentru exercițiile din `../../sql-start/querying_relational_databases/exercises.md`. Folosește baza `university_db`.

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < seed.sql
```

---

## INNER JOIN

### EX-1. Înrolări cu notă completată.
```sql
SELECT s.first_name, s.last_name, c.name AS course, e.grade
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses  c ON c.id = e.course_id
WHERE e.grade IS NOT NULL;
```

### EX-2. Curs + profesor pentru cursurile care au profesor.
```sql
SELECT c.name AS course, CONCAT(i.first_name, ' ', i.last_name) AS instructor
FROM courses c
JOIN instructors i ON i.id = c.instructor_id;
```

### EX-3. Studenți și cursurile la care sunt înscriși.
```sql
SELECT s.first_name, s.last_name, c.name AS course
FROM students s
JOIN enrollments e ON e.student_id = s.id
JOIN courses     c ON c.id         = e.course_id
ORDER BY s.last_name, c.name;
```

## Multi-table JOIN

### EX-4. Student + curs + profesor pentru note > 8.0.
```sql
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    c.name AS course,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    e.grade
FROM enrollments e
JOIN students    s ON s.id = e.student_id
JOIN courses     c ON c.id = e.course_id
JOIN instructors i ON i.id = c.instructor_id
WHERE e.grade > 8.0;
```

### EX-5. Studenții de la cursul `'Databases'` cu notele lor.
```sql
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    e.grade
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses  c ON c.id = e.course_id
WHERE c.name = 'Databases';
```

## LEFT JOIN

### EX-6. Toate cursurile, inclusiv cele fără profesor.
```sql
SELECT c.name AS course, CONCAT(i.first_name, ' ', i.last_name) AS instructor
FROM courses c
LEFT JOIN instructors i ON i.id = c.instructor_id;
```

### EX-7. Toți studenții + numărul de cursuri.
```sql
SELECT
    s.id,
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    COUNT(e.course_id) AS courses_count
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.id
GROUP BY s.id, student;
```

### EX-8. Cursurile fără niciun student înscris.
```sql
SELECT c.id, c.name
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
WHERE e.student_id IS NULL;
```

## Self-join

### EX-9. Perechi de profesori din aceeași catedră.
```sql
SELECT
    i1.id AS instructor_a_id,
    CONCAT(i1.first_name, ' ', i1.last_name) AS instructor_a,
    i2.id AS instructor_b_id,
    CONCAT(i2.first_name, ' ', i2.last_name) AS instructor_b,
    i1.department
FROM instructors i1
JOIN instructors i2
  ON i1.department = i2.department
 AND i1.id < i2.id;
```

## Set operations

### EX-10. UNION pe identificatori (instructori + studenți).
```sql
SELECT CONCAT(first_name, '.', last_name) AS person FROM instructors
UNION
SELECT CONCAT(first_name, '.', last_name) FROM students;
```

### EX-11. Aceeași cerință cu UNION ALL.
```sql
SELECT CONCAT(first_name, '.', last_name) AS person FROM instructors
UNION ALL
SELECT CONCAT(first_name, '.', last_name) FROM students;
```

## Subqueries

### EX-12. Studenți care au cel puțin o notă peste 9.0.
```sql
SELECT s.first_name, s.last_name
FROM students s
WHERE s.id IN (
    SELECT e.student_id
    FROM enrollments e
    WHERE e.grade > 9.0
);
```

### EX-13. Cursuri cu mai mult de 1 student înscris.
```sql
SELECT c.id, c.name
FROM courses c
WHERE c.id IN (
    SELECT course_id
    FROM enrollments
    GROUP BY course_id
    HAVING COUNT(*) > 1
);
```

### EX-14. Tabelă derivată: media notelor per student.
```sql
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    avg_grades.avg_grade
FROM students s
JOIN (
    SELECT student_id, AVG(grade) AS avg_grade
    FROM enrollments
    WHERE grade IS NOT NULL
    GROUP BY student_id
) AS avg_grades ON avg_grades.student_id = s.id;
```

### EX-15. Subquery corelat: note peste media propriilor note.
```sql
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    c.name AS course,
    e.grade
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses  c ON c.id = e.course_id
WHERE e.grade > (
    SELECT AVG(e2.grade)
    FROM enrollments e2
    WHERE e2.student_id = e.student_id
      AND e2.grade IS NOT NULL
);
```

## Provocări

### CH-1. Top 3 cele mai populare cursuri.
```sql
SELECT
    c.name AS course,
    COUNT(e.student_id) AS students_count
FROM courses c
LEFT JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id, c.name
ORDER BY students_count DESC
LIMIT 3;
```

### CH-2. Numărul de studenți unici per profesor.
```sql
SELECT
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    COUNT(DISTINCT e.student_id) AS unique_students
FROM instructors i
LEFT JOIN courses     c ON c.instructor_id = i.id
LEFT JOIN enrollments e ON e.course_id     = c.id
GROUP BY i.id, instructor;
```

### CH-3. Studenți cu cursuri din toate catedrele profesorilor existenți.
```sql
SELECT s.id, CONCAT(s.first_name, ' ', s.last_name) AS student
FROM students s
WHERE NOT EXISTS (
    SELECT 1
    FROM instructors i
    WHERE NOT EXISTS (
        SELECT 1
        FROM enrollments e
        JOIN courses c ON c.id = e.course_id
        WHERE e.student_id = s.id
          AND c.instructor_id IN (
              SELECT id FROM instructors WHERE department = i.department
          )
    )
);
```

---

## Scenarii frecvente în producție

### PR-1. Audit de acoperire pe cursuri.
```sql
SELECT
    c.name AS course,
    CONCAT(IFNULL(i.first_name, ''), ' ', IFNULL(i.last_name, '')) AS instructor,
    COUNT(e.student_id) AS students_count
FROM courses c
LEFT JOIN instructors i ON i.id = c.instructor_id
LEFT JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id, c.name, instructor;
```

### PR-2. Profesori care nu predau niciun curs.
```sql
SELECT i.id, CONCAT(i.first_name, ' ', i.last_name) AS instructor
FROM instructors i
LEFT JOIN courses c ON c.instructor_id = i.id
WHERE c.id IS NULL;
```

### PR-3. Studenți înscriși fără nicio notă.
```sql
SELECT s.id, CONCAT(s.first_name, ' ', s.last_name) AS student
FROM students s
JOIN enrollments e ON e.student_id = s.id
GROUP BY s.id, student
HAVING SUM(CASE WHEN e.grade IS NOT NULL THEN 1 ELSE 0 END) = 0;
```

### PR-4. Total credite per student.
```sql
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    SUM(c.credits) AS total_credits
FROM students s
JOIN enrollments e ON e.student_id = s.id
JOIN courses     c ON c.id         = e.course_id
GROUP BY s.id, student;
```

### PR-5. Studenți cu cursuri din `'Computer Science'` ȘI `'Mathematics'`.
```sql
SELECT s.id, CONCAT(s.first_name, ' ', s.last_name) AS student
FROM students s
JOIN enrollments e ON e.student_id = s.id
JOIN courses     c ON c.id         = e.course_id
JOIN instructors i ON i.id         = c.instructor_id
WHERE i.department IN ('Computer Science', 'Mathematics')
GROUP BY s.id, student
HAVING COUNT(DISTINCT i.department) = 2;
```

### PR-6. Media notelor per profesor.
```sql
SELECT
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    ROUND(AVG(e.grade), 2) AS avg_grade
FROM instructors i
JOIN courses     c ON c.instructor_id = i.id
JOIN enrollments e ON e.course_id     = c.id
WHERE e.grade IS NOT NULL
GROUP BY i.id, instructor;
```

### PR-7. Cursuri cu risc operațional (≥ 2 studenți, medie < 8.0).
```sql
SELECT
    c.id,
    c.name,
    COUNT(e.student_id) AS students_count,
    ROUND(AVG(e.grade), 2) AS avg_grade
FROM courses c
JOIN enrollments e ON e.course_id = c.id
WHERE e.grade IS NOT NULL
GROUP BY c.id, c.name
HAVING COUNT(e.student_id) >= 2 AND AVG(e.grade) < 8.0;
```

### PR-8. Studenți unici per catedră.
```sql
SELECT
    i.department,
    COUNT(DISTINCT e.student_id) AS unique_students
FROM instructors i
JOIN courses     c ON c.instructor_id = i.id
JOIN enrollments e ON e.course_id     = c.id
GROUP BY i.department;
```

### PR-9. Perechi de colegi la cel puțin un curs.
```sql
SELECT
    e1.student_id AS student_a,
    e2.student_id AS student_b,
    e1.course_id
FROM enrollments e1
JOIN enrollments e2
  ON e1.course_id  = e2.course_id
 AND e1.student_id < e2.student_id;
```

### PR-10. Studenți cu note la toate cursurile la care sunt înscriși.
```sql
SELECT s.id, CONCAT(s.first_name, ' ', s.last_name) AS student
FROM students s
JOIN enrollments e ON e.student_id = s.id
GROUP BY s.id, student
HAVING COUNT(*) = COUNT(e.grade);
```

### PR-11. Cursuri unde toți studenții au notă și media > 8.5.
```sql
SELECT
    c.id,
    c.name,
    ROUND(AVG(e.grade), 2) AS avg_grade
FROM courses c
JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(*) = COUNT(e.grade)
   AND AVG(e.grade) > 8.5;
```

### PR-12. Pentru fiecare student cursul cu nota maximă (cu ties).
```sql
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    c.name AS course,
    e.grade
FROM enrollments e
JOIN students s ON s.id = e.student_id
JOIN courses  c ON c.id = e.course_id
WHERE e.grade = (
    SELECT MAX(e2.grade)
    FROM enrollments e2
    WHERE e2.student_id = e.student_id
);
```
