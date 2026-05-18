# Modifying Data — Recap pe Online School

Folosește baza `online_school_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Aceste exerciții **modifică** datele. Pentru reset rapid rerulezi `../init.sql` și `../seed.sql`. În MySQL Workbench: `SET SQL_SAFE_UPDATES = 0;`.

---

## INSERT

- [ ] **EX-1.** Inserează un student nou: `first_name = 'Irina'`, `last_name = 'Toma'`, `email = 'irina@school.ro'`, `age = 23`.
- [ ] **EX-2.** Inserează un curs nou: `name = 'Operating Systems'`, `department = 'CS'`.
- [ ] **EX-3.** Inserează **într-un singur `INSERT`** trei cursuri noi pentru departamentul `'Physics'`: `'Mechanics'`, `'Thermodynamics'`, `'Optics'`.
- [ ] **EX-4.** Emite un card pentru Florin (`email = 'florin@school.ro'`): găsește-i `id`-ul cu subquery, apoi inserează `card_number = 'CARD-006'`.
- [ ] **EX-5.** Înrolează studenta nou-creată Irina la cursul `'Operating Systems'` și la `'Algorithms'`. Folosește subquery-uri pentru a obține id-urile.
- [ ] **EX-6.** Adaugă o carte pentru Cristina (`'Discrete Math Notes'`, `created_at = NOW()`).

## UPDATE

- [ ] **EX-7.** Schimbă departamentul cursului `'World History'` în `'Humanities'`.
- [ ] **EX-8.** Mărește cu 1 vârsta tuturor studenților născuți (sic — modelat ca vârstă) sub 25 ani. Folosește `WHERE age < 25`.
- [ ] **EX-9.** Actualizează emailul lui Bogdan din `'bogdan@school.ro'` în `'bogdan.stoica@school.ro'`.
- [ ] **EX-10.** **UPDATE cu JOIN:** schimbă `card_number` în `'EXPIRED-<id>'` (folosește `CONCAT('EXPIRED-', id)`) pentru cardurile studenților cu vârsta > 27. Indicație: `UPDATE student_id_card JOIN student ON ... SET ... WHERE student.age > 27`.
- [ ] **EX-11.** Setează `book.created_at = NOW()` pentru toate cărțile lui Ana.

## DELETE

- [ ] **EX-12.** Șterge cărțile lui Ana (`student_id = 1`). *(Așteptat: 2 rânduri afectate)*
- [ ] **EX-13.** Șterge înrolările vechi de peste 60 de zile față de `'2026-04-01'` (folosește `DATEDIFF`). *(Așteptat: toate, dacă referința e `2026-04-01`.)*
- [ ] **EX-14.** Șterge studenții care **nu au nicio carte și nicio înrolare**. Folosește `NOT EXISTS`. *(Așteptat: 1 rând — Florin.)*
- [ ] **EX-15.** Șterge cursul `'Calculus'` și — datorită lui `ON DELETE CASCADE` — verifică ce s-a întâmplat cu înrolările aferente.

## Tranzacții

- [ ] **EX-16.** Într-o tranzacție:
  1. Inserezi un student nou.
  2. Îi emiți un card.
  3. Îl înrolezi la 2 cursuri.
  4. Faci `ROLLBACK` și verifici că nimic nu s-a schimbat.
- [ ] **EX-17.** Repetă pașii de la EX-16, dar termină cu `COMMIT`. Verifică rezultatul cu `SELECT`-uri.
- [ ] **EX-18.** „Transfer" de card: ștergi cardul vechi al lui Ana și creezi unul nou (`CARD-100`) — totul într-o tranzacție. Dacă unicitatea pe `card_number` ar fi încălcată, `ROLLBACK`.

## Provocări

- [ ] **EX-19.** **Dezînrolare în masă:** într-o tranzacție, șterge toate înrolările studenților cu vârsta > 30 și loghează (cu `SELECT`) câte rânduri urmează să fie afectate înainte de `DELETE`.
- [ ] **EX-20.** **Mutare înrolare:** schimbă atomic `course_id` pentru o înrolare existentă, dintr-un curs în altul. Atenție la PK compus `(student_id, course_id)` — dacă deja există, va da eroare; tratează cazul.

## Scenarii frecvente în producție

- [ ] **EX-21.** **Backfill:** pentru toți studenții care au card și emailul **nu** se potrivește cu `'<first_name_lowercase>@school.ro'`, suprascrie emailul cu varianta canonică. Folosește `UPDATE ... JOIN ...` cu `LOWER(first_name)`.
- [ ] **EX-22.** **Bulk correction:** schimbă `course.department` din `'CS'` în `'Computer Science'` (versiune lungă). Apoi inversează schimbarea.
- [ ] **EX-23.** **Soft cleanup:** șterge toate cărțile cu `book_name` egal cu un string gol sau cu doar spații (`book_name = '' OR TRIM(book_name) = ''`). *(Așteptat: 0 pe seed-ul curent — exercițiu de protecție.)*
