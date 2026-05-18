# Querying Relational Databases — Recap pe Online Shop

Folosește baza `online_shop_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Tabelele cheie pentru `JOIN`: `products`, `categories`, `options` + cele două junction (`product_categories`, `product_options`) + `customers`, `orders`, `order_details`. Reține că un produs poate fi în mai multe categorii (ex.: `Bluetooth Speaker` apare în `Electronics` și `Home`).

---

## INNER JOIN — două tabele

- [ ] **EX-1.** Lista de produse cu numele categoriei asociate (via `product_categories`). Afișează `products.sku`, `products.name`, `categories.name`. *(Așteptat: 11 rânduri — un produs poate apărea de mai multe ori)*
- [ ] **EX-2.** Detaliile fiecărei comenzi împreună cu numele clientului. Afișează `orders.id`, `orders.order_date`, `customers.full_name`, `orders.ammount`. *(Așteptat: 5 rânduri)*
- [ ] **EX-3.** Asocierea produs ↔ opțiune. Afișează `products.name`, `options.option_name`. *(Așteptat: 10 rânduri)*

## Multi-table JOIN

- [ ] **EX-4.** Pentru fiecare linie de comandă, afișează `orders.id`, `customers.full_name`, `products.name`, `order_details.quantity`, `order_details.price`. *(Așteptat: 8 rânduri)*
- [ ] **EX-5.** Pentru fiecare produs, lista de categorii **și** opțiuni asociate. Afișează `products.sku`, `categories.name AS category`, `options.option_name`. *(Atenție: produsele fără opțiuni nu apar la `INNER JOIN`.)*
- [ ] **EX-6.** Clienții care au cumpărat cărți (`category = 'Books'`). Afișează distinct `customers.email` și numele produsului.

## LEFT JOIN & anti-join

- [ ] **EX-7.** Produsele care **nu au nicio opțiune** asociată. Folosește `LEFT JOIN product_options` + `IS NULL`. *(Așteptat: 4 produse — SKU-003, SKU-005, SKU-006, SKU-007)*
- [ ] **EX-8.** Produsele care **nu apar în nicio comandă** (anti-join pe `order_details`). *(Așteptat: produsele 3, 4, 7, 9 — adică 4 rânduri)*
- [ ] **EX-9.** Clienții care **n-au plasat încă nicio comandă**. *(Așteptat: 1 rând — John Smith)*
- [ ] **EX-10.** Pentru fiecare client, afișează `email` și statusul ultimei comenzi (dacă există) sau `NULL`. Folosește `LEFT JOIN`. *(Notă: „ultima" doar dacă fiecare client are exact una; altfel toate.)*

## Self-join

- [ ] **EX-11.** Perechi de produse din **aceeași categorie**. Folosește `product_categories pc1 JOIN product_categories pc2 ON pc1.category_id = pc2.category_id AND pc1.product_id < pc2.product_id`. Afișează `p1.sku`, `p2.sku`, `categories.name`.
- [ ] **EX-12.** Perechi de clienți din **aceeași țară**. Folosește un self-join pe `customers` cu condiția `c1.id < c2.id`. *(Așteptat: 1 pereche — Alex & Maria din Romania)*

## Set operations (MySQL 8.0.31+)

- [ ] **EX-13.** Toate emailurile distincte care apar fie în `customers.email`, fie în `orders.order_email`. Folosește `UNION`.
- [ ] **EX-14.** Produsele care apar **și** în categoria `Electronics`, **și** în `Home`. Folosește `INTERSECT` pe două subquery-uri cu `product_id`. *(Așteptat: 1 produs — Bluetooth Speaker)*
- [ ] **EX-15.** Categoriile care **nu au** niciun produs asociat. Folosește `EXCEPT` între id-urile din `categories` și cele din `product_categories`. *(Așteptat: 0 rânduri pe seed-ul curent — toate categoriile au cel puțin un produs.)*

## Subqueries

- [ ] **EX-16.** Produsele care au fost comandate cel puțin o dată. Folosește `WHERE id IN (SELECT product_id FROM order_details)`. *(Așteptat: 6 produse)*
- [ ] **EX-17.** Clienții care au cel puțin o comandă în status `DELIVERED`. Folosește `EXISTS`. *(Așteptat: 1 rând — Alex)*
- [ ] **EX-18.** Categoriile fără produse — varianta cu `NOT EXISTS` pe `product_categories`. *(Verifică că dă același rezultat ca EX-15.)*
- [ ] **EX-19.** Produsele comandate la un preț **diferit** de prețul lor curent (`order_details.price <> products.price`). Compară pe `product_id`. *(Notă: SKU-008 e comandat la 29.00 față de 29.90.)*
- [ ] **EX-20.** Pentru fiecare comandă, afișează `id`, `ammount` și numărul de linii din `order_details` printr-un **scalar subquery** în `SELECT` (nu `JOIN`).

## Provocări

- [ ] **EX-21.** Produsele care apar în **mai mult de o categorie**. Combină `product_categories` cu el însuși sau folosește `HAVING` (acceptabil aici, nu e reporting).
- [ ] **EX-22.** Clienții care au cumpărat **cel puțin un produs** din categoria `Electronics`. Distinct pe email.
- [ ] **EX-23.** Comenzile care conțin **doar produse din Books**. Indicație: anti-join — comanda nu trebuie să aibă nicio linie cu produs din altă categorie.

## Scenarii frecvente în producție

- [ ] **EX-24.** Catalog admin: pentru fiecare produs, lista categoriilor concatenate (`categories.name`) într-un singur câmp — folosește `GROUP_CONCAT(categories.name)` cu `JOIN`. *(Singura excepție de la „fără agregări" — e doar concat de stringuri.)*
- [ ] **EX-25.** Verificare integritate: există `order_details.sku` care **nu mai există** în `products.sku`? Folosește `LEFT JOIN` + `IS NULL`. *(Așteptat: 0 rânduri pe seed-ul curent.)*
- [ ] **EX-26.** Recommendation simplu: clienții care au cumpărat aceleași produse ca clientul `alex.popescu@example.com`. Self-join pe `order_details` via `product_id`, exclude-l pe Alex din rezultat.
