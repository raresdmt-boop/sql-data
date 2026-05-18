# Modifying Data — Recap pe Online Shop

Folosește baza `online_shop_db` (vezi `../init.sql` + `../seed.sql`).

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < ../seed.sql
```

> 💡 Aceste exerciții **modifică** datele. Pentru reset rapid rerulezi `../init.sql` și `../seed.sql`. În MySQL Workbench poate fi nevoie să dezactivezi `safe updates`: `SET SQL_SAFE_UPDATES = 0;`.

---

## INSERT

- [ ] **EX-1.** Inserează un client nou: email `irina.toma@example.com`, parola `pwd-006`, nume `Irina Toma`, adresa `Str. Mihai Viteazu 7, Cluj`, țara `Romania`, telefon `+40 740 555 666`.
- [ ] **EX-2.** Inserează un produs nou: `sku = 'SKU-011'`, `name = 'Wireless Charger'`, `price = 129.00`, `weight = 0.25`, `descriptions = 'Incarcator wireless 15W'`, `category = 'Electronics'`, `create_date = NOW()`, `stock = 30`.
- [ ] **EX-3.** Inserează **într-un singur `INSERT`** trei opțiuni noi: `'Material'`, `'Brand'`, `'Country of Origin'`.
- [ ] **EX-4.** Asociază produsul nou inserat la EX-2 cu categoria `Electronics` (în `product_categories`).
- [ ] **EX-5.** Inserează o comandă nouă pentru clientul cu emailul `john.smith@example.com`, status `NEW`, cu o singură linie pe produsul `SKU-008`, `quantity = 3`. Calculează corect `ammount` și `order_details.price`.

## UPDATE

- [ ] **EX-6.** Schimbă statusul comenzii cu `id = 3` în `'DELIVERED'`.
- [ ] **EX-7.** Mărește cu 10% prețul tuturor produselor din categoria `'Electronics'`. (Folosește coloana denormalizată `products.category`.)
- [ ] **EX-8.** Pune `stock = 0` pentru produsele din `'Books'` cu prețul sub 60 RON.
- [ ] **EX-9.** Actualizează `default_shipping_address` pentru `Sophie Dupont` la `'Rue de Rivoli 200, Paris'`.
- [ ] **EX-10.** **UPDATE cu JOIN:** sincronizează `products.category` cu numele primei categorii din `product_categories` (folosește `UPDATE ... JOIN ...`). Indicație: pentru produsele cu mai multe categorii, alege cea cu cel mai mic `categories.id`.
- [ ] **EX-11.** Setează `phone = 'unknown'` pentru toți clienții la care `phone IS NULL`.

## DELETE

- [ ] **EX-12.** Șterge toate `order_details` cu `quantity = 0`. *(Așteptat: 0 rânduri afectate pe seed-ul curent — exercițiu de „safe delete".)*
- [ ] **EX-13.** Șterge produsele care **nu au nicio categorie** asociată în `product_categories` (anti-join via `NOT EXISTS`). *(Așteptat: 0 rânduri pe seed-ul curent.)*
- [ ] **EX-14.** Șterge clienții care **nu au plasat nicio comandă**. Folosește `NOT EXISTS`. *(Așteptat: 1 rând — John Smith. Dacă ai inserat la EX-5 comanda lui, nu mai are efect.)*
- [ ] **EX-15.** Șterge opțiunea `'Warranty'` și — datorită lui `ON DELETE CASCADE` — verifică ce s-a întâmplat cu `product_options`.

## Tranzacții

- [ ] **EX-16.** Începe o tranzacție în care:
  1. Inserezi o comandă nouă pentru `maria.ionescu@example.com`.
  2. Inserezi 2 linii în `order_details` (alege produse cu stock > 0).
  3. Decrementezi `stock` în `products` pentru produsele respective.
  4. Faci `ROLLBACK` și verifici că **nimic nu s-a schimbat**.
- [ ] **EX-17.** Repetă pașii de la EX-16, dar termină cu `COMMIT`. Verifică `products.stock` după.
- [ ] **EX-18.** „Transferă" stoc între două produse: scade 5 din `SKU-001` și adaugă 5 la `SKU-002` într-o tranzacție. Dacă valoarea finală a `SKU-001` ar fi negativă, `ROLLBACK`.

## Provocări

- [ ] **EX-19.** **Anulare comandă:** într-o singură tranzacție, pentru comanda `id = 5`:
  - schimbă `order_status` în `'CANCELLED'`;
  - restituie stocul pentru fiecare produs din `order_details` (adaugă `quantity` la `products.stock`).
- [ ] **EX-20.** **Mutare comandă între clienți:** schimbă atomic `customer_id` și `order_email` pentru comanda `id = 2` astfel încât să aparțină lui `hans.mueller@example.com`. Verifică integritatea înainte de `COMMIT`.

## Scenarii frecvente în producție

- [ ] **EX-21.** **Backfill:** pentru toate comenzile la care `order_email` diferă de `customers.email`, suprascrie `order_email` cu emailul curent al clientului. Folosește `UPDATE ... JOIN ...`. *(Așteptat: 0 rânduri pe seed-ul curent — toate sunt deja sincronizate.)*
- [ ] **EX-22.** **Bulk correction:** rotunjește prețul la întreg pentru toate produsele cu `price < 50` (folosește `ROUND(price)`).
- [ ] **EX-23.** **Soft cleanup:** pentru toți clienții fără `billing_address`, copiază valoarea din `default_shipping_address` (doar acolo unde aceasta nu e `NULL`).
