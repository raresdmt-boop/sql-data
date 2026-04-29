# SQL Practice Pack for MySQL 8

Colecție de materiale practice pentru învățarea SQL în MySQL 8, organizată pe module scurte, fiecare cu schemă proprie, date seed și exerciții fără soluții.

Scopul repo-ului este dublu:

- să fixeze sintaxa SQL de bază și intermediară;
- să exerseze scenarii apropiate de ce apare des în proiecte reale: reporting, audit, data quality, bulk updates, backfill și obiecte de schemă folosite în producție.

## Structura repo-ului

Fiecare folder conține:

- `cheatsheet.md` pentru sintaxă și exemple rapide;
- `init.sql` pentru schema bazei de date;
- `seed.sql` pentru date de test;
- `exercises.md` pentru exerciții propuse, fără soluții.

## Module

| Folder | Temă | Baza de date | Ce exersezi |
|---|---|---|---|
| [sql_basics](sql_basics/cheatsheet.md) | SQL fundamentals | `library_db` | `SELECT`, `WHERE`, `LIKE`, `IN`, `BETWEEN`, `IS NULL`, filtre uzuale de catalog |
| [reporting_with_sql](reporting_with_sql/cheatsheet.md) | Reporting și agregări | `sales_db` | `ORDER BY`, `LIMIT`, agregări, `GROUP BY`, `HAVING`, date, KPI-uri și rapoarte operaționale |
| [querying_relational_databases](querying_relational_databases/cheatsheet.md) | Relații și interogări pe mai multe tabele | `university_db` | `JOIN`, subquery, set operations, audit pe relații și coverage reporting |
| [modifying_data_with_sql](modifying_data_with_sql/cheatsheet.md) | Modificarea datelor | `cinema_db` | `INSERT`, `UPDATE`, `DELETE`, tranzacții, bulk corrections, backfill-uri |
| [schema_objects](schema_objects/cheatsheet.md) | Obiecte de schemă | `hr_db` | DDL, constrângeri, indexuri, view-uri, proceduri, funcții, trigger-e, audit |

## Cum folosești materialele

1. Alege un modul.
2. Rulează `init.sql`.
3. Rulează `seed.sql`.
4. Deschide `exercises.md` și scrie singur query-urile.
5. Dacă vrei să reiei exercițiile de la zero, rulează din nou `init.sql` și `seed.sql`.

Exemplu:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < sql_basics/init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < sql_basics/seed.sql
```

Sau dintr-un client MySQL conectat:

```sql
SOURCE /path/to/sql_basics/init.sql;
SOURCE /path/to/sql_basics/seed.sql;
```

## Ordine recomandată

Dacă parcurgi repo-ul ca learning path:

1. `sql_basics`
2. `reporting_with_sql`
3. `querying_relational_databases`
4. `modifying_data_with_sql`
5. `schema_objects`

Ordinea e gândită să mergi de la filtre simple și selecții, la agregări, apoi la join-uri, modificări de date și în final obiecte de schemă.

## Ce s-a adăugat în plus

Pe lângă exercițiile clasice de sintaxă, fiecare modul conține acum și o secțiune de tip:

- `Scenarii frecvente în producție`

Acolo vei găsi exerciții inspirate din situații reale:

- selecții pentru homepage sau campanii;
- verificări de data quality și anomalii;
- KPI-uri și leaderboard-uri;
- backfill și bulk corrections;
- audit logs, view-uri publice și controale de integritate.

## Observații MySQL

- Toate exemplele sunt scrise pentru MySQL 8.0+.
- Pentru string-uri folosește preferabil ghilimele simple: `'text'`.
- Unele exerciții din zona de tranzacții sau DDL modifică datele; pentru reset rapid rerulezi `init.sql` și `seed.sql`.
- În unele GUI-uri MySQL poate fi nevoie să dezactivezi `safe updates` pentru anumite exerciții de `UPDATE` sau `DELETE`.

## Obiectivul repo-ului

Repo-ul nu încearcă să fie doar o listă de comenzi SQL. Ideea este să te antreneze pe:

- scriere corectă de query-uri;
- citirea schemelor relaționale;
- gândire de reporting;
- modificări sigure de date;
- modelare de bază pentru nevoi reale din aplicații.
