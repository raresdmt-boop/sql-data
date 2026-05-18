# Online Shop — Exerciții recapitulative

Pachet recapitulativ pe schema unui magazin online (8 tabele). Acoperă patru module din `sql-start/`, **fără** `reporting_with_sql` (agregări, `GROUP BY`, KPI-uri etc.).

## Schema

Diagrama de pornire este în `WhatsApp Image 2026-05-18 at 21.10.01.jpeg`. Tabele:

- `customers` — clienții magazinului
- `products` — catalog de produse (cu o coloană denormalizată `category` pe lângă relația M:N prin `product_categories`)
- `categories`, `options` — taxonomii
- `product_categories`, `product_options` — junction M:N
- `orders`, `order_details` — comenzile și liniile lor

> Coloanele `descriptions` și `ammount` sunt scrise fidel după diagramă (chiar dacă a doua are typo). Nu le „corecta tăcut" — soluțiile presupun numele astea.

## Cum rulezi

Din rădăcina repo-ului:

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < databases/sql/exercitii/online-shop/init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < databases/sql/exercitii/online-shop/seed.sql
```

Sau dintr-un client MySQL conectat:

```sql
SOURCE /path/to/databases/sql/exercitii/online-shop/init.sql;
SOURCE /path/to/databases/sql/exercitii/online-shop/seed.sql;
```

Pentru reset rapid: rerulezi cele două fișiere — `init.sql` face `DROP TABLE` și `seed.sql` face `DELETE` + `AUTO_INCREMENT = 1`.

## Module

| Folder | Temă | Bazat pe modulul |
|---|---|---|
| [sql_basics](sql_basics/exercises.md) | `SELECT`, `WHERE`, `LIKE`, `IN`, `BETWEEN`, `IS NULL` | `sql_basics` |
| [querying_relational_databases](querying_relational_databases/exercises.md) | `JOIN`-uri, anti-join, self-join, set ops, subqueries | `querying_relational_databases` |
| [modifying_data_with_sql](modifying_data_with_sql/exercises.md) | `INSERT`, `UPDATE`, `DELETE`, tranzacții | `modifying_data_with_sql` |
| [schema_objects](schema_objects/exercises.md) | DDL, indexuri, view-uri, proceduri, funcții, trigger-e | `schema_objects` |

Ordinea recomandată e cea din tabel: filtre pe o tabelă, apoi relații, apoi modificări de date, apoi obiecte de schemă.

## Ce **nu** găsești aici

`reporting_with_sql` (agregări, `GROUP BY`, `HAVING`, funcții de dată/string, KPI-uri) — exclus intenționat. Pentru reporting folosește `databases/sql/sql-start/reporting_with_sql/`.

## Observații

- Toate exercițiile sunt scrise pentru MySQL 8.0+.
- Nu există `solutions.md` aici — sunt exerciții libere; verifică-te citind rezultatele și apoi schema.
- Numerele de rânduri din „Așteptat: …" sunt valide pe seed-ul implicit. Dacă inserezi sau ștergi date, nu mai sunt valabile.
- În MySQL Workbench s-ar putea să trebuiască să dezactivezi `safe updates` pentru `UPDATE`/`DELETE` fără cheie.
