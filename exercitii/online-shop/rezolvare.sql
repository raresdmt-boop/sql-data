==============================
--      1. Afișează primele 5 produse ordonate descrescător după venitul
-- total generat (price × quantity din order_details). Include și totalul unităților vândute.
SELECT p.name, p.price, SUM(od.price * od.quantity) AS amount, SUM(od.quantity) AS numar_unitati
FROM products p
left JOIN order_details od
ON od.product_id = p.id
GROUP BY p.id
ORDER BY amount DESC
LIMIT 5;

--      2. Listează clienții (full_name, email) cu mai mult de 3 comenzi
--     plasate, împreună cu suma totală cheltuită și data ultimei comenzi.
SELECT c.full_name, c.email, COUNT(o.customer_id) AS nr_com, SUM(o.ammount) AS suma_totala, MAX(o.order_date) AS ultima_com
FROM customers c
JOIN orders o
ON c.id = o.customer_id
GROUP BY c.id
HAVING nr_com > 3;

--      3.Calculează venitul total per categorie per lună (an + număr lună), 
--      ordonat cronologic. Afișează: category name, an, lună, venit.
