-- Online Shop — seed pentru exerciții recapitulative
-- 5 clienți, 3 categorii, 3 opțiuni, 10 produse, 5 comenzi, 8 order_details.

USE online_shop_db;

DELETE FROM order_details;
DELETE FROM orders;
DELETE FROM product_options;
DELETE FROM product_categories;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM options;
DELETE FROM customers;
ALTER TABLE order_details      AUTO_INCREMENT = 1;
ALTER TABLE orders             AUTO_INCREMENT = 1;
ALTER TABLE product_options    AUTO_INCREMENT = 1;
ALTER TABLE product_categories AUTO_INCREMENT = 1;
ALTER TABLE products           AUTO_INCREMENT = 1;
ALTER TABLE categories         AUTO_INCREMENT = 1;
ALTER TABLE options            AUTO_INCREMENT = 1;
ALTER TABLE customers          AUTO_INCREMENT = 1;

INSERT INTO customers (email, password, full_name, billing_address, default_shipping_address, country, phone) VALUES
('alex.popescu@example.com',  'pwd-001', 'Alexandru Popescu', 'Str. Lalelelor 1, Bucuresti',  'Str. Lalelelor 1, Bucuresti',  'Romania', '+40 720 111 222'),
('maria.ionescu@example.com', 'pwd-002', 'Maria Ionescu',     'Calea Victoriei 25, Bucuresti', NULL,                           'Romania', '+40 730 333 444'),
('hans.mueller@example.com',  'pwd-003', 'Hans Mueller',      'Berliner Str. 12, Berlin',      'Berliner Str. 12, Berlin',     'Germany', '+49 30 1234567'),
('sophie.dupont@example.com', 'pwd-004', 'Sophie Dupont',     NULL,                            'Rue Lafayette 8, Paris',       'France',  NULL),
('john.smith@example.com',    'pwd-005', 'John Smith',        '10 Baker Street, London',       '10 Baker Street, London',      'UK',      '+44 20 7946 0958');

INSERT INTO categories (name, description, thumbnail) VALUES
('Electronics', 'Gadgeturi si electronice', 'electronics.jpg'),
('Books',       'Carti tiparite si digitale', 'books.jpg'),
('Home',        'Articole pentru casa',     NULL);

INSERT INTO options (option_name) VALUES
('Size'),
('Color'),
('Warranty');

INSERT INTO products (sku, name, price, weight, descriptions, thumbnail, image, category, create_date, stock) VALUES
('SKU-001', 'Wireless Mouse',          89.99, 0.12, 'Mouse fara fir, 1600 DPI',     'mouse_t.jpg',   'mouse.jpg',   'Electronics', '2026-01-10 10:00:00',  50),
('SKU-002', 'Mechanical Keyboard',    349.00, 1.10, 'Tastatura mecanica RGB',       'kb_t.jpg',      'kb.jpg',      'Electronics', '2026-01-15 11:30:00',  20),
('SKU-003', 'USB-C Hub',              159.50, 0.20, NULL,                            'hub_t.jpg',     'hub.jpg',     'Electronics', '2026-02-01 09:15:00',   0),
('SKU-004', 'Bluetooth Speaker',      249.90, 0.80, 'Boxa portabila, 12h baterie',  'speaker_t.jpg', 'speaker.jpg', 'Electronics', '2026-02-10 14:00:00',  15),
('SKU-005', 'Clean Code',              79.00, 0.55, 'Robert C. Martin',              'cc_t.jpg',      'cc.jpg',      'Books',       '2026-01-05 09:00:00',  40),
('SKU-006', 'The Pragmatic Programmer', 95.00, 0.60, 'Hunt & Thomas',                'pp_t.jpg',      'pp.jpg',      'Books',       '2026-01-05 09:00:00',  35),
('SKU-007', 'SQL for Beginners',       55.00, NULL, NULL,                            'sql_t.jpg',     'sql.jpg',     'Books',       '2026-03-01 10:00:00',   0),
('SKU-008', 'Ceramic Mug',             29.90, 0.35, 'Cana ceramica 350ml',          'mug_t.jpg',     'mug.jpg',     'Home',        '2026-03-12 13:45:00', 100),
('SKU-009', 'Desk Lamp',              189.00, 1.50, 'Lampa birou LED',              'lamp_t.jpg',    'lamp.jpg',    'Home',        '2026-03-20 16:00:00',   8),
('SKU-010', 'Cotton Blanket',         219.00, 1.80, NULL,                            'blanket_t.jpg', 'blanket.jpg', 'Home',        '2026-04-01 12:00:00',  12);

INSERT INTO product_categories (product_id, category_id) VALUES
(1, 1), (2, 1), (3, 1), (4, 1),
(5, 2), (6, 2), (7, 2),
(8, 3), (9, 3), (10, 3),
(4, 3);

INSERT INTO product_options (product_id, option_id) VALUES
(1, 2),
(2, 2), (2, 3),
(4, 2), (4, 3),
(8, 1), (8, 2),
(9, 3),
(10, 1), (10, 2);

INSERT INTO orders (customer_id, ammount, shipping_address, order_address, order_email, order_date, order_status) VALUES
(1, 438.99, 'Str. Lalelelor 1, Bucuresti',  'Str. Lalelelor 1, Bucuresti',  'alex.popescu@example.com',  '2026-04-10 10:30:00', 'DELIVERED'),
(2, 174.00, 'Calea Victoriei 25, Bucuresti','Calea Victoriei 25, Bucuresti','maria.ionescu@example.com', '2026-04-15 14:20:00', 'SHIPPED'),
(3, 349.00, 'Berliner Str. 12, Berlin',     'Berliner Str. 12, Berlin',     'hans.mueller@example.com',  '2026-04-20 09:45:00', 'PAID'),
(1,  79.00, 'Str. Lalelelor 1, Bucuresti',  'Str. Lalelelor 1, Bucuresti',  'alex.popescu@example.com',  '2026-04-25 18:00:00', 'CANCELLED'),
(4, 218.00, 'Rue Lafayette 8, Paris',       'Rue Lafayette 8, Paris',       'sophie.dupont@example.com', '2026-05-01 11:10:00', 'NEW');

INSERT INTO order_details (order_id, product_id, price, sku, quantity) VALUES
(1, 1,   89.99, 'SKU-001', 1),
(1, 2,  349.00, 'SKU-002', 1),
(2, 5,   79.00, 'SKU-005', 1),
(2, 6,   95.00, 'SKU-006', 1),
(3, 2,  349.00, 'SKU-002', 1),
(4, 5,   79.00, 'SKU-005', 1),
(5, 8,   29.00, 'SKU-008', 2),
(5, 10, 160.00, 'SKU-010', 1);
