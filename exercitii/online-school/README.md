# Online School — Exerciții recapitulative

Pachet recapitulativ pe schema unei școli online (5 tabele: `student`, `student_id_card`, `book`, `course`, `enrolment`). Acoperă patru module din `sql-start/`, **fără** `reporting_with_sql`.

## Schema

Diagrama de pornire este în `WhatsApp Image 2026-02-05 at 21.45.22.jpeg`. Tabele:

- `student` — studenții (un email unic per student)
- `student_id_card` — 1:1 cu `student` (un student are cel mult un card; unii nu au)
- `book` — 1:N de la `student` la cărțile lui personale
- `course` — cursuri (cu departament)
- `enrolment` — junction M:N între `student` și `course`; PK compus `(student_id, course_id)`

> Diagrama folosește tipuri PostgreSQL (`BIGSERIAL`, `TIMESTAMP WITHOUT TIME ZONE`). În `init.sql` sunt traduse la `BIGINT AUTO_INCREMENT` / `DATETIME` ca să fie consistent cu restul modulelor MySQL 8. Numele `enrolment` (varianta britanică) e păstrat ca în diagramă.

## Cum rulezi

Din rădăcina repo-ului:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < databases/sql/exercitii/online-school/init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < databases/sql/exercitii/online-school/seed.sql
```

Sau dintr-un client MySQL conectat:

```sql
SOURCE /path/to/databases/sql/exercitii/online-school/init.sql;
SOURCE /path/to/databases/sql/exercitii/online-school/seed.sql;
```

Pentru reset rapid: rerulezi cele două fișiere.

## Module

| Folder | Temă | Bazat pe modulul |
|---|---|---|
| [sql_basics](sql_basics/exercises.md) | `SELECT`, `WHERE`, `LIKE`, `IN`, `BETWEEN`, `IS NULL` | `sql_basics` |
| [querying_relational_databases](querying_relational_databases/exercises.md) | `JOIN`-uri, anti-join, self-join, set ops, subqueries | `querying_relational_databases` |
| [modifying_data_with_sql](modifying_data_with_sql/exercises.md) | `INSERT`, `UPDATE`, `DELETE`, tranzacții | `modifying_data_with_sql` |
| [schema_objects](schema_objects/exercises.md) | DDL, indexuri, view-uri, proceduri, funcții, trigger-e | `schema_objects` |

## Ce **nu** găsești aici

`reporting_with_sql` (agregări, `GROUP BY`, `HAVING`, KPI-uri) — exclus intenționat.

## Observații

- Toate exercițiile sunt scrise pentru MySQL 8.0+.
- Nu există `solutions.md` — sunt exerciții libere.
- Numerele de rânduri din „Așteptat: …" sunt valide pe seed-ul implicit (8 studenți, 5 cursuri, 10 înrolări, 6 cărți, 5 carduri).
- În MySQL Workbench s-ar putea să trebuiască să dezactivezi `safe updates` pentru `UPDATE`/`DELETE` fără cheie.
