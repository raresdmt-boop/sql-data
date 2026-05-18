# Schema Objects — Recap pe Online Shop

Folosește baza `online_shop_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Aceste exerciții modifică **schema**, nu doar datele. După ce te-ai jucat, rerulezi `../init.sql` ca să revii la baza curată. Pentru `DELIMITER //` ai nevoie de un client care îl suportă (MySQL CLI, Workbench).

---

## DDL — modificări de schemă

- [ ] **EX-1.** Adaugă coloana `slug VARCHAR(150) NOT NULL UNIQUE` în `categories`. (Va trebui întâi să completezi valorile pentru rândurile existente — folosește un `UPDATE` cu `LOWER(name)`.)
- [ ] **EX-2.** Adaugă constraint `NOT NULL` + `DEFAULT 'Romania'` pe `customers.country`.
- [ ] **EX-3.** Redenumește coloana `products.descriptions` în `products.description` (`ALTER TABLE ... RENAME COLUMN ...`). *(Atenție: invalidează toate exercițiile care folosesc numele vechi; pune înapoi cu un al doilea `ALTER` după ce ai verificat.)*
- [ ] **EX-4.** Modifică tipul `orders.ammount` din `DECIMAL(10,2)` în `DECIMAL(12,2)`.
- [ ] **EX-5.** Adaugă o coloană generată `line_total DECIMAL(12,2) GENERATED ALWAYS AS (price * quantity) STORED` în `order_details`. Verifică valorile generate cu un `SELECT`.
- [ ] **EX-6.** Adaugă un `CHECK (price >= 0)` pe `products.price` și un `CHECK (quantity > 0)` pe `order_details.quantity`.

## Indexes

- [ ] **EX-7.** Index simplu pe `orders.order_date` — folosit la filtre pe interval de timp.
- [ ] **EX-8.** Index pe `customers.country` — folosit la rapoarte geografice.
- [ ] **EX-9.** Index compus pe `order_details (order_id, product_id)` — accelerează căutarea „toate liniile unei comenzi pentru un produs".
- [ ] **EX-10.** Index `FULLTEXT` pe `products (name, descriptions)`. Apoi caută `MATCH(name, descriptions) AGAINST('mouse')`.
- [ ] **EX-11.** Șterge unul dintre indexurile create mai sus (`DROP INDEX`). Verifică cu `SHOW INDEX FROM ...`.

## Views

- [ ] **EX-12.** View `v_catalog` cu `sku`, `name`, `price`, `stock`, `category` și un câmp calculat `availability` care e `'IN_STOCK'` dacă `stock > 0`, altfel `'OUT_OF_STOCK'`.
- [ ] **EX-13.** View `v_customer_orders` cu `customer_email`, `order_id`, `order_date`, `order_status`, `ammount`. Sursa: `customers JOIN orders`.
- [ ] **EX-14.** View `v_books` peste `products WHERE category = 'Books'`. Încearcă să faci `INSERT INTO v_books (sku, name, price, create_date)` cu o nouă carte — observă dacă view-ul e actualizabil (Hint: trebuie să furnizezi și `category`).
- [ ] **EX-15.** Șterge view-ul `v_books` cu `DROP VIEW`.

## Stored Procedures

- [ ] **EX-16.** Procedura `sp_place_order(IN p_customer_id INT, IN p_sku VARCHAR(40), IN p_quantity INT)`:
  - găsește `product_id` și `price` din `products` după `sku`;
  - verifică `stock >= p_quantity` — altfel `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock'`;
  - creează un `orders` cu `ammount = price * p_quantity`, `order_email` luat din `customers`, status `NEW`;
  - inserează `order_details` cu prețul curent;
  - decrementează `stock` în `products`;
  - rulează totul într-o tranzacție.
- [ ] **EX-17.** Procedura `sp_change_order_status(IN p_order_id INT, IN p_new_status VARCHAR(20))` care:
  - validează că `p_new_status` e în `ENUM`-ul comenzilor;
  - aruncă `SIGNAL` cu mesaj english dacă statusul nu există;
  - actualizează altfel.
- [ ] **EX-18.** Procedura `sp_cancel_order(IN p_order_id INT)` care schimbă statusul în `CANCELLED` **și** restituie stocul (foloseste fie cursor pe `order_details`, fie un singur `UPDATE ... JOIN ...`).
- [ ] **EX-19.** Șterge una dintre proceduri cu `DROP PROCEDURE`.

## Stored Functions

- [ ] **EX-20.** Funcție `fn_product_in_stock(p_sku VARCHAR(40)) RETURNS BOOLEAN` care întoarce `TRUE` dacă produsul există și are `stock > 0`, altfel `FALSE`.
- [ ] **EX-21.** Funcție `fn_customer_country(p_email VARCHAR(150)) RETURNS VARCHAR(80)` care întoarce țara clientului sau `'unknown'` dacă emailul nu există.
- [ ] **EX-22.** Funcție `fn_format_price(p_amount DECIMAL(10,2), p_currency VARCHAR(3)) RETURNS VARCHAR(40)` care întoarce stringul `'1299.00 RON'`. Folosește `CONCAT`.

## Triggers

- [ ] **EX-23.** `BEFORE INSERT ON orders`: dacă `NEW.order_email` e gol sau `NULL`, copiază valoarea din `customers.email` corespunzător lui `NEW.customer_id`.
- [ ] **EX-24.** `AFTER INSERT ON order_details`: decrementează `products.stock` cu `NEW.quantity` pentru `NEW.product_id`.
- [ ] **EX-25.** `BEFORE UPDATE ON products`: dacă `NEW.price < 0`, aruncă `SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Price cannot be negative'`.
- [ ] **EX-26.** `AFTER UPDATE ON orders`: când statusul trece în `CANCELLED` (verifică `OLD.order_status <> 'CANCELLED' AND NEW.order_status = 'CANCELLED'`), restituie stocul pentru toate liniile comenzii (`UPDATE products ... WHERE id IN (SELECT ... FROM order_details ...)`).
- [ ] **EX-27.** Creează tabela `audit_log (id, table_name, row_id, action, changed_at)` și un trigger `AFTER UPDATE ON orders` care scrie în ea ori de câte ori se schimbă `order_status`.

## Provocări

- [ ] **EX-28.** View `v_low_stock` care arată produsele cu `stock < 10` împreună cu numele categoriei principale (folosește `JOIN` cu `product_categories` + `categories`).
- [ ] **EX-29.** Adaugă un `INDEX (sku)` pe `order_details` — argumentează când e util.
- [ ] **EX-30.** Scrie o procedură `sp_purge_old_carts(IN p_days INT)` care șterge comenzile cu status `NEW` mai vechi de `p_days` zile. Atenție la `ON DELETE CASCADE` din `order_details`.

## Scenarii frecvente în producție

- [ ] **EX-31.** Adaugă coloana `deleted_at DATETIME NULL` în `products` și convertește toate ștergerile la „soft delete" — modifică view-ul `v_catalog` să exclude produsele soft-deleted.
- [ ] **EX-32.** Trigger care nu permite `DELETE` direct pe `customers` dacă există comenzi active (status `NEW`, `PAID`, `SHIPPED`). Folosește `BEFORE DELETE` + `SIGNAL`.
