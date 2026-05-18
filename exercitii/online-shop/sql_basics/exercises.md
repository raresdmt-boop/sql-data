# SQL Basics — Recap pe Online Shop

Folosește baza `online_shop_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Numerele de rânduri din „Așteptat" sunt verificate pe seed-ul implicit (10 produse, 5 clienți). Toate exercițiile lucrează pe o singură tabelă — `products` sau `customers`. Pentru `JOIN`-uri vezi modulul `querying_relational_databases/`.

---

## SELECT & coloane

- [ ] **EX-1.** Afișează toate coloanele și rândurile din `products`. *(Așteptat: 10 rânduri)*
- [ ] **EX-2.** Afișează doar `sku`, `name` și `price` din `products`.
- [ ] **EX-3.** Afișează `sku AS "Cod"`, `name AS "Denumire"`, `price AS "Pret RON"`.
- [ ] **EX-4.** Afișează `email`, `full_name` și `country` din `customers`.

## WHERE — operatori de comparație

- [ ] **EX-5.** Produsele cu prețul ≥ 200 RON. *(Așteptat: 3 rânduri)*
- [ ] **EX-6.** Produsele cu stocul exact 0. *(Așteptat: 2 rânduri)*
- [ ] **EX-7.** Produsele cu greutatea strict sub 1 kg. (Atenție: produsele cu `weight IS NULL` nu trebuie să apară.)
- [ ] **EX-8.** Produsele adăugate strict după `2026-02-01` (folosește `create_date`).
- [ ] **EX-9.** Clienții care **nu** sunt din `'Romania'`. Folosește `!=` sau `<>`. *(Așteptat: 3 rânduri)*

## AND / OR

- [ ] **EX-10.** Produsele din categoria `'Electronics'` cu stocul > 10.
- [ ] **EX-11.** Produsele din `'Books'` **sau** `'Home'`. *(Așteptat: 6 rânduri)*
- [ ] **EX-12.** Clienții din `'Romania'` care **au** și telefon completat.

## IN / NOT IN

- [ ] **EX-13.** Produsele din categoriile `'Electronics'` sau `'Home'`. Folosește `IN`. *(Așteptat: 7 rânduri)*
- [ ] **EX-14.** Produsele care **nu** sunt din `'Electronics'` și nici din `'Books'`. Folosește `NOT IN`. *(Așteptat: 3 rânduri)*
- [ ] **EX-15.** Clienții din `'Germany'`, `'France'` sau `'UK'`. *(Așteptat: 3 rânduri)*

## BETWEEN

- [ ] **EX-16.** Produsele cu prețul între 50 și 100 RON inclusiv. *(Așteptat: 4 rânduri)*
- [ ] **EX-17.** Produsele cu stocul între 10 și 50 inclusiv.
- [ ] **EX-18.** Produsele adăugate între `2026-01-01` și `2026-02-28` inclusiv.

## LIKE

- [ ] **EX-19.** Produsele al căror nume începe cu litera `C`. *(Așteptat: 3 rânduri)*
- [ ] **EX-20.** Produsele care au cuvântul `'Code'` în nume.
- [ ] **EX-21.** Produsele cu `sku` între `SKU-001` și `SKU-009` — folosește `LIKE 'SKU-00%'`. *(Așteptat: 9 rânduri)*
- [ ] **EX-22.** Clienții cu email pe domeniul `example.com`.

## IS NULL / IS NOT NULL

- [ ] **EX-23.** Produsele fără descriere (`descriptions IS NULL`). *(Așteptat: 3 rânduri)*
- [ ] **EX-24.** Produsele cu greutatea necunoscută. *(Așteptat: 1 rând)*
- [ ] **EX-25.** Clienții fără telefon. *(Așteptat: 1 rând)*
- [ ] **EX-26.** Clienții cu `billing_address` completat. *(Așteptat: 4 rânduri)*

## Mix — provocări

- [ ] **EX-27.** Produsele din `'Electronics'` cu prețul sub 200 RON și stocul > 0. *(Așteptat: 1 rând)*
- [ ] **EX-28.** Produsele cu numele care conțin litera `a` și au prețul peste 100 RON.
- [ ] **EX-29.** Clienții care **nu** au `default_shipping_address` setat sau nu au `phone`. *(Așteptat: 2 rânduri — Maria și Sophie)*

## Scenarii frecvente în producție

- [ ] **EX-30.** Catalog homepage: produsele în stoc (`stock > 0`) cu prețul ≥ 50 RON din categoria `'Electronics'`. Afișează `sku`, `name`, `price`, `stock`.
- [ ] **EX-31.** Audit data quality: produsele care au `descriptions IS NULL` **sau** `weight IS NULL`. Afișează `id`, `sku`, `name`.
- [ ] **EX-32.** Marketing: clienții care pot fi contactați și prin email și prin telefon (ambele not null) și sunt din afara României.
- [ ] **EX-33.** Out-of-stock alert: toate produsele cu `stock = 0`, indiferent de categorie. Afișează `sku`, `name`, `category`, `create_date`.
