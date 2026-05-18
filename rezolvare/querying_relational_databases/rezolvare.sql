-- ONLINE SCHOOL
CREATE TABLE student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    age INT NOT NULL
);

CREATE TABLE book(
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    book_name VARCHAR(50) NOT NULL,
    created_at DATE NOT NULL,
    CONSTRAINT FOREIGN KEY (student_id) REFERENCES student(id)
)

CREATE TABLE course(
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(30) NOT NULL,
        department VARCHAR(30) NOT NULL
)

CREATE TABLE enrollment(
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    created_at DATE,
    CONSTRAINT FOREIGN KEY (student_id) REFERENCES student(id),
    CONSTRAINT FOREIGN KEY (course_id) REFERENCES course(id)
)
-- =========================================================================================
-- online shop
CREATE TABLE products(
    id INT PRIMARY KEY AUTO_INCREMENT,
    sku INT NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    price DECIMAL (10,2),
    weight DECIMAL (5,2),
    descriptions VARCHAR(1000) NULL,
    category VARCHAR(30) NOT NULL,
    create_date DATE NOT NULL,
    stock INT NOT NULL
)

CREATE TABLE customers(
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(35) NOT NULL UNIQUE,
    password VARCHAR(35) NOT NULL,
    full_name VARCHAR(35) NOT NULL,
    billing_address VARCHAR(50) NULL,
    default_shipping_address VARCHAR(50) NULL,
    country VARCHAR(35) NULL,
    phone VARCHAR(15) NULL UNIQUE
);

CREATE TABLE orders(
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    amount INT NOT NULL,
    shipping_address VARCHAR(50) NOT NULL,
    order_address VARCHAR(50) NOT NULL,
    order_email VARCHAR(35) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(15) NOT NULL,
    CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_details(
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    price INT NOT NULL,
    sku INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT FOREIGN KEY (product_id) REFERENCES products(id)
)

CREATE TABLE options(
    id INT PRIMARY KEY AUTO_INCREMENT,
    option_name VARCHAR(20) NOT NULL
);

CREATE TABLE product_options(
    id INT PRIMARY KEY AUTO_INCREMENT,
    option_id INT NOT NULL ,
    product_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (option_id) REFERENCES options(id),
    CONSTRAINT FOREIGN KEY (product_id) REFERENCES products(id)
)

CREATE TABLE categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(250) NULL
);
CREATE TABLE product_categories(
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL ,
    category_id INT NOT NULL,
    CONSTRAINT FOREIGN KEY (product_id) REFERENCES products(id),
    CONSTRAINT FOREIGN KEY (category_id) REFERENCES categories(id)
)

------ EX 1
SELECT students.first_name, students.last_name, courses.name, enrollments.grade
FROM students
INNER JOIN enrollments ON students.id = enrollments.student_id
INNER JOIN courses ON enrollments.course_id = courses.id
WHERE grade IS NOT NULL;
-- MI-AU APARUT 18 THO

------- EX 2
SELECT courses.name, instructors.first_name, instructors.last_name
FROM courses
INNER JOIN instructors ON courses.instructor_id = instructors.id;


------- EX 3
SELECT students.first_name, courses.name
FROM students
INNER JOIN enrollments ON students.id = enrollments.student_id
INNER JOIN courses ON enrollments.course_id = courses.id

------- EX 4
SELECT students.first_name, courses.name, instructors.last_name
FROM students
INNER JOIN enrollments ON students.id = enrollments.student_id
INNER JOIN courses ON enrollments.course_id = courses.id
INNER JOIN instructors ON courses.instructor_id = instructors.id
WHERE grade > 8.0 ;

------ EX 5
SELECT students.first_name, students.last_name, enrollments.grade
FROM students
INNER JOIN enrollments ON students.id = enrollments.student_id
INNER JOIN courses ON enrollments.course_id = courses.id
where name = 'Databases'

------ EX 6
SELECT courses.name, instructors.first_name, last_name
FROM courses
LEFT JOIN instructors ON courses.instructor_id = instructors.id;

------ EX 7
SELECT students.first_name, students.last_name, COUNT(enrollments.course_id) AS number_of_classes
FROM students
JOIN enrollments ON students.id = enrollments.student_id
GROUP BY students.id;

-- SAU
SELECT students.first_name, students.last_name, COUNT(enrollments.ORICE) AS number_of_classes
FROM students
JOIN enrollments ON students.id = enrollments.student_id
GROUP BY students.id; <-- AICI E SCHEMA

------ EX 8
SELECT courses.name, enrollments.student_id
FROM courses
LEFT JOIN enrollments ON courses.id = enrollments.course_id
WHERE student_id IS NULL;

------ EX 9
???????

------ EX 10
SELECT email FROM students
UNION
SELECT CONCAT(first_name,' ',last_name) AS email
FROM instructors;

------ EX 11
-- nu am observat nicio diferenta

------ EX 12
SELECT students.first_name, students.last_name
FROM students
WHERE students.id IN (
    SELECT student_id FROM enrollments WHERE grade>9.0
    )

------ EX 13
SELECT courses.name
FROM courses
JOIN enrollments ON courses.id = enrollments.course_id
GROUP BY course_id HAVING COUNT(enrollments.student_id) > 1;

------ EX 14



--- PROVOCARE 1
SELECT
    c.name,
    COUNT(e.course_id) AS numarul_de_studenti
FROM courses c
JOIN enrollments e ON e.course_id = c.id
GROUP BY c.id
ORDER BY numarul_de_studenti DESC
LIMIT 3

---- PROVOCARE 2
SELECT
    CONCAT(i.first_name,' ',i.last_name) AS nume_profesor,
    COUNT(DISTINCT e.student_id) AS numarul_de_studenti
FROM instructors i
JOIN courses c ON c.instructor_id = i.id
JOIN enrollments e ON e.course_id = c.id
GROUP BY i.id
ORDER BY numarul_de_studenti DESC;

---- PROVOCARE 3
SELECT
    DISTINCT CONCAT (s.first_name,' ',s.last_name) AS full_name, COUNT(e.course_id) AS numarul_de_enroll
FROM
    enrollments e
join
    students s ON s.id = e.student_id
GROUP BY s.id HAVING numarul_de_enroll =7
ORDER BY numarul_de_enroll DESC;

----- SCENARII
-- 1
SELECT
    c.name AS numele_cursului, CONCAT(i.first_name,' ',i.last_name) AS nume_profesor, COUNT(e.course_id)
FROM
    courses c
LEFT JOIN
    enrollments e ON c.id = e.course_id
left join
    instructors i ON c.instructor_id = i.id
GROUP BY c.id;

-- 2
SELECT
    CONCAT(i.first_name,' ',i.last_name) AS nume_profesor, c.name AS course_name
FROM
    instructors i
LEFT JOIN
    courses c ON i.id = c.instructor_id
WHERE
    c.id IS NULL;

-- 3
SELECT
    CONCAT(s.first_name,' ',s.last_name) AS nume_student
FROM
    students s
LEFT JOIN
    enrollments e ON s.id = e.student_id
GROUP BY
    s.id
HAVING
    SUM(CASE 
        WHEN e.grade IS NOT NULL THEN 1 
        ELSE 0 
        END) = 0;

-- 4
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    SUM(c.credits) AS total_credits
FROM students s
JOIN enrollments e ON e.student_id = s.id
JOIN courses     c ON c.id         = e.course_id
GROUP BY s.id, student;

--5
SELECT
    CONCAT(s.first_name, ' ', s.last_name) AS student
FROM
    students s
JOIN
    enrollments e ON e.student_id = s.id
JOIN
    courses c ON c.id = e.course_id
JOIN
    instructors i ON i.id = c.instructor_id
WHERE
    i.department IN ('Mathematics', 'Computer Science')
GROUP BY
    s.id
HAVING COUNT(DISTINCT i.department) = 2;






-- =============== PRODUCTS APP =================
CREATE TABLE users (
id INT AUTO_INCREMENT PRIMARY KEY,
email VARCHAR(35) UNIQUE NOT NULL,
password VARCHAR(35) NOT NULL,
full_name VARCHAR(50) NOT NULL,
type VARCHAR(10) NOT NULL,
billing_address VARCHAR(50),
shipping_address VARCHAR(50),
phone VARCHAR(15)
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    amount DECIMAL (10,2),
    shipping_address VARCHAR(50) NOT NULL,
    order_address VARCHAR(50) NOT NULL,
    order_email VARCHAR(35) NOT NULL,
    order_date DATE NOT NULL,
    order_status VARCHAR(10),
    CONSTRAINT foreign key (customer_id) REFERENCES users(id)
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sku INT UNIQUE NOT NULL,
    name VARCHAR(50) NOT NULL,
    price DECIMAL (10,2) NOT NULL,
    weight DECIMAL (6,2) NOT NULL,
    description VARCHAR(200),
    stock INT
);



CREATE TABLE order_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    price DECIMAL (10,2) NOT NULL,
    sku INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT foreign key (order_id) REFERENCES orders(id),
    CONSTRAINT foreign key (product_id) REFERENCES products(id)
)


-- USERS (10)
INSERT INTO users (email, password, full_name, type, billing_address, shipping_address, phone) VALUES
('alex.popescu@gmail.com', 'pass123', 'Alex Popescu', 'client', 'Str. Libertatii 10', 'Str. Libertatii 10', '0711111111'),
('maria.ionescu@yahoo.com', 'maria321', 'Maria Ionescu', 'client', 'Bd. Unirii 21', 'Bd. Unirii 21', '0722222222'),
('dan.vasilescu@gmail.com', 'danpass', 'Dan Vasilescu', 'admin', 'Str. Republicii 7', 'Str. Republicii 7', '0733333333'),
('elena.georgescu@gmail.com', 'elena123', 'Elena Georgescu', 'client', 'Str. Florilor 15', 'Str. Florilor 15', '0744444444'),
('mihai.stan@yahoo.com', 'mihai987', 'Mihai Stan', 'client', 'Str. Lalelelor 9', 'Str. Lalelelor 9', '0755555555'),
('ioana.dumitru@gmail.com', 'ioana777', 'Ioana Dumitru', 'client', 'Bd. Independentei 44', 'Bd. Independentei 44', '0766666666'),
('andrei.rusu@yahoo.com', 'rusu111', 'Andrei Rusu', 'client', 'Str. Muncii 12', 'Str. Muncii 12', '0777777777'),
('cristina.ilie@gmail.com', 'cristi555', 'Cristina Ilie', 'client', 'Str. Victoriei 30', 'Str. Victoriei 30', '0788888888'),
('bogdan.enache@gmail.com', 'bogdan999', 'Bogdan Enache', 'admin', 'Str. Primaverii 18', 'Str. Primaverii 18', '0799999999'),
('raluca.marinescu@yahoo.com', 'raluca222', 'Raluca Marinescu', 'client', 'Str. Stadionului 3', 'Str. Stadionului 3', '0700000000');


-- PRODUCTS (20)
INSERT INTO products (sku, name, price, weight, description, stock) VALUES
(1001, 'Burger Classic', 25.50, 0.45, 'Burger vita clasic', 120),
(1002, 'Cheese Burger', 28.00, 0.50, 'Burger cu cheddar', 90),
(1003, 'Chicken Burger', 24.00, 0.40, 'Burger de pui', 100),
(1004, 'Hot Dog Simplu', 15.00, 0.25, 'Hot dog clasic', 150),
(1005, 'Hot Dog Cheese', 18.50, 0.30, 'Hot dog cu branza', 130),
(1006, 'Cartofi Prajiti', 10.00, 0.20, 'Portie cartofi', 200),
(1007, 'Cartofi Wedges', 12.50, 0.25, 'Cartofi wedges', 180),
(1008, 'Coca Cola', 8.00, 0.50, 'Bautura racoritoare', 300),
(1009, 'Fanta', 8.00, 0.50, 'Bautura portocale', 250),
(1010, 'Sprite', 8.00, 0.50, 'Bautura lamaie', 220),
(1011, 'Apa Plata', 5.00, 0.50, 'Apa minerala plata', 400),
(1012, 'Apa Minerala', 5.00, 0.50, 'Apa carbogazoasa', 350),
(1013, 'Milkshake Vanilie', 14.00, 0.40, 'Milkshake vanilie', 80),
(1014, 'Milkshake Capsuni', 14.00, 0.40, 'Milkshake capsuni', 70),
(1015, 'Milkshake Ciocolata', 14.00, 0.40, 'Milkshake ciocolata', 75),
(1016, 'Burger BBQ', 32.00, 0.55, 'Burger cu sos BBQ', 60),
(1017, 'Burger Picant', 30.00, 0.50, 'Burger picant', 65),
(1018, 'Nuggets Pui', 20.00, 0.35, 'Nuggets crocanti', 110),
(1019, 'Onion Rings', 13.50, 0.25, 'Inele de ceapa', 140),
(1020, 'Salata Caesar', 22.00, 0.30, 'Salata Caesar cu pui', 50);


-- ORDERS (20)
INSERT INTO orders (customer_id, amount, shipping_address, order_address, order_email, order_date, order_status) VALUES
(1, 58.00, 'Str. Libertatii 10', 'Str. Libertatii 10', 'alex.popescu@gmail.com', '2026-05-01', 'pending'),
(2, 42.50, 'Bd. Unirii 21', 'Bd. Unirii 21', 'maria.ionescu@yahoo.com', '2026-05-01', 'done'),
(3, 75.00, 'Str. Republicii 7', 'Str. Republicii 7', 'dan.vasilescu@gmail.com', '2026-05-02', 'done'),
(4, 36.00, 'Str. Florilor 15', 'Str. Florilor 15', 'elena.georgescu@gmail.com', '2026-05-02', 'pending'),
(5, 90.00, 'Str. Lalelelor 9', 'Str. Lalelelor 9', 'mihai.stan@yahoo.com', '2026-05-03', 'done'),
(6, 44.00, 'Bd. Independentei 44', 'Bd. Independentei 44', 'ioana.dumitru@gmail.com', '2026-05-03', 'pending'),
(7, 61.50, 'Str. Muncii 12', 'Str. Muncii 12', 'andrei.rusu@yahoo.com', '2026-05-04', 'done'),
(8, 29.00, 'Str. Victoriei 30', 'Str. Victoriei 30', 'cristina.ilie@gmail.com', '2026-05-04', 'pending'),
(9, 120.00, 'Str. Primaverii 18', 'Str. Primaverii 18', 'bogdan.enache@gmail.com', '2026-05-05', 'done'),
(10, 55.00, 'Str. Stadionului 3', 'Str. Stadionului 3', 'raluca.marinescu@yahoo.com', '2026-05-05', 'pending'),
(1, 48.00, 'Str. Libertatii 10', 'Str. Libertatii 10', 'alex.popescu@gmail.com', '2026-05-06', 'done'),
(2, 67.00, 'Bd. Unirii 21', 'Bd. Unirii 21', 'maria.ionescu@yahoo.com', '2026-05-06', 'pending'),
(3, 88.50, 'Str. Republicii 7', 'Str. Republicii 7', 'dan.vasilescu@gmail.com', '2026-05-07', 'done'),
(4, 33.00, 'Str. Florilor 15', 'Str. Florilor 15', 'elena.georgescu@gmail.com', '2026-05-07', 'pending'),
(5, 74.00, 'Str. Lalelelor 9', 'Str. Lalelelor 9', 'mihai.stan@yahoo.com', '2026-05-08', 'done'),
(6, 25.00, 'Bd. Independentei 44', 'Bd. Independentei 44', 'ioana.dumitru@gmail.com', '2026-05-08', 'pending'),
(7, 98.00, 'Str. Muncii 12', 'Str. Muncii 12', 'andrei.rusu@yahoo.com', '2026-05-09', 'done'),
(8, 41.50, 'Str. Victoriei 30', 'Str. Victoriei 30', 'cristina.ilie@gmail.com', '2026-05-09', 'pending'),
(9, 63.00, 'Str. Primaverii 18', 'Str. Primaverii 18', 'bogdan.enache@gmail.com', '2026-05-10', 'done'),
(10, 52.00, 'Str. Stadionului 3', 'Str. Stadionului 3', 'raluca.marinescu@yahoo.com', '2026-05-10', 'pending');


-- ORDER DETAILS (20+)
INSERT INTO order_details (order_id, product_id, price, sku, quantity) VALUES
(1, 1, 25.50, 1001, 2),
(1, 6, 10.00, 1006, 1),

(2, 2, 28.00, 1002, 1),
(2, 8, 8.00, 1008, 1),

(3, 16, 32.00, 1016, 2),
(3, 7, 12.50, 1007, 1),

(4, 4, 15.00, 1004, 2),

(5, 1, 25.50, 1001, 2),
(5, 13, 14.00, 1013, 1),

(6, 3, 24.00, 1003, 1),
(6, 11, 5.00, 1011, 2),

(7, 17, 30.00, 1017, 1),
(7, 18, 20.00, 1018, 1),

(8, 5, 18.50, 1005, 1),
(8, 9, 8.00, 1009, 1),

(9, 16, 32.00, 1016, 3),
(9, 19, 13.50, 1019, 1),

(10, 20, 22.00, 1020, 2),

(11, 2, 28.00, 1002, 1),
(11, 6, 10.00, 1006, 2),

(12, 17, 30.00, 1017, 2),
(12, 8, 8.00, 1008, 1),

(13, 1, 25.50, 1001, 3),

(14, 4, 15.00, 1004, 2),
(14, 10, 8.00, 1010, 1),

(15, 3, 24.00, 1003, 2),
(15, 15, 14.00, 1015, 1),

(16, 11, 5.00, 1011, 5),

(17, 16, 32.00, 1016, 2),
(17, 13, 14.00, 1013, 1),

(18, 19, 13.50, 1019, 2),
(18, 9, 8.00, 1009, 1),

(19, 20, 22.00, 1020, 2),
(19, 12, 5.00, 1012, 1),

(20, 2, 28.00, 1002, 1),
(20, 14, 14.00, 1014, 1);

UPDATE orders SET amount = 61.00 WHERE id = 1;
UPDATE orders SET amount = 36.00 WHERE id = 2;
UPDATE orders SET amount = 76.50 WHERE id = 3;
UPDATE orders SET amount = 30.00 WHERE id = 4;
UPDATE orders SET amount = 65.00 WHERE id = 5;
UPDATE orders SET amount = 34.00 WHERE id = 6;
UPDATE orders SET amount = 50.00 WHERE id = 7;
UPDATE orders SET amount = 26.50 WHERE id = 8;
UPDATE orders SET amount = 109.50 WHERE id = 9;
UPDATE orders SET amount = 44.00 WHERE id = 10;
UPDATE orders SET amount = 48.00 WHERE id = 11;
UPDATE orders SET amount = 68.00 WHERE id = 12;
UPDATE orders SET amount = 76.50 WHERE id = 13;
UPDATE orders SET amount = 38.00 WHERE id = 14;
UPDATE orders SET amount = 62.00 WHERE id = 15;
UPDATE orders SET amount = 25.00 WHERE id = 16;
UPDATE orders SET amount = 78.00 WHERE id = 17;
UPDATE orders SET amount = 35.00 WHERE id = 18;
UPDATE orders SET amount = 49.00 WHERE id = 19;
UPDATE orders SET amount = 42.00 WHERE id = 20;

-- cat a cheltuit fiecare client in parte in ordine desc
SELECT
    u.full_name, SUM(o.amount) AS total_spent
FROM
    users u
LEFT JOIN
    orders o ON u.id = o.customer_id
GROUP BY u.id
ORDER BY total_spent DESC;


----- online shop -----
------------------------------------------------------------------------------

create table categories
(
    id          int auto_increment
        primary key,
    name        varchar(30)  not null,
    description varchar(250) null,
    constraint name
        unique (name)
);

create table customers
(
    id                       int auto_increment
        primary key,
    email                    varchar(35) not null,
    password                 varchar(35) not null,
    full_name                varchar(35) not null,
    billing_address          varchar(50) null,
    default_shipping_address varchar(50) null,
    country                  varchar(35) null,
    phone                    varchar(15) null,
    constraint email
        unique (email),
    constraint phone
        unique (phone)
);

create table options
(
    id          int auto_increment
        primary key,
    option_name varchar(20) not null
);

create table orders
(
    id               int auto_increment
        primary key,
    customer_id      int         not null,
    amount           int         not null,
    shipping_address varchar(50) not null,
    order_address    varchar(50) not null,
    order_email      varchar(35) not null,
    order_date       date        not null,
    order_status     varchar(15) not null,
    constraint orders_ibfk_1
        foreign key (customer_id) references customers (id)
);

create index customer_id
    on orders (customer_id);

create table products
(
    id           int auto_increment
        primary key,
    sku          int            not null,
    name         varchar(50)    not null,
    price        decimal(10, 2) null,
    weight       decimal(5, 2)  null,
    descriptions varchar(1000)  null,
    category     varchar(30)    not null,
    create_date  date           not null,
    stock        int            not null,
    constraint sku
        unique (sku)
);

create table order_details
(
    id         int auto_increment
        primary key,
    order_id   int not null,
    product_id int not null,
    price      int not null,
    sku        int not null,
    quantity   int not null,
    constraint order_details_ibfk_1
        foreign key (order_id) references orders (id),
    constraint order_details_ibfk_2
        foreign key (product_id) references products (id)
);

create index order_id
    on order_details (order_id);

create index product_id
    on order_details (product_id);

create table product_categories
(
    id          int auto_increment
        primary key,
    product_id  int not null,
    category_id int not null,
    constraint product_categories_ibfk_1
        foreign key (product_id) references products (id),
    constraint product_categories_ibfk_2
        foreign key (category_id) references categories (id)
);

create index category_id
    on product_categories (category_id);

create index product_id
    on product_categories (product_id);

create table product_options
(
    id         int auto_increment
        primary key,
    option_id  int not null,
    product_id int not null,
    constraint product_options_ibfk_1
        foreign key (option_id) references options (id),
    constraint product_options_ibfk_2
        foreign key (product_id) references products (id)
);

create index option_id
    on product_options (option_id);

create index product_id
    on product_options (product_id);



-- =========================
-- CATEGORIES
-- =========================

INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices'),
('Gaming', 'Gaming accessories'),
('Books', 'Programming and tech books'),
('Clothing', 'Fashion products'),
('Home', 'Home accessories');

-- =========================
-- OPTIONS
-- =========================

INSERT INTO options (option_name) VALUES
('Red'),
('Blue'),
('Black'),
('White'),
('Large');

-- =========================
-- CUSTOMERS
-- =========================

INSERT INTO customers (
email,
password,
full_name,
billing_address,
default_shipping_address,
country,
phone
) VALUES
('john@example.com', 'pass123', 'John Smith', 'Street 1', 'Street 1', 'USA', '111111111'),
('anna@example.com', 'pass123', 'Anna Brown', 'Street 2', 'Street 2', 'UK', '222222222'),
('mike@example.com', 'pass123', 'Mike Johnson', 'Street 3', 'Street 3', 'Germany', '333333333'),
('sarah@example.com', 'pass123', 'Sarah Lee', 'Street 4', 'Street 4', 'France', '444444444'),
('alex@example.com', 'pass123', 'Alex White', 'Street 5', 'Street 5', 'Spain', '555555555');

-- =========================
-- PRODUCTS
-- =========================

INSERT INTO products (
sku,
name,
price,
weight,
descriptions,
category,
create_date,
stock
) VALUES
(1001, 'Laptop Pro', 1200.00, 2.50, 'Gaming laptop', 'Electronics', CURDATE(), 15),
(1002, 'Wireless Mouse', 35.00, 0.20, 'Bluetooth mouse', 'Electronics', CURDATE(), 50),
(1003, 'Mechanical Keyboard', 90.00, 0.80, 'RGB keyboard', 'Gaming', CURDATE(), 30),
(1004, 'Gaming Chair', 250.00, 12.00, 'Comfortable gaming chair', 'Gaming', CURDATE(), 10),
(1005, 'Java Programming', 40.00, 0.50, 'Learn Java book', 'Books', CURDATE(), 100),
(1006, 'Black T-Shirt', 20.00, 0.30, 'Cotton t-shirt', 'Clothing', CURDATE(), 60),
(1007, 'Coffee Maker', 80.00, 3.00, 'Kitchen coffee maker', 'Home', CURDATE(), 25),
(1008, '4K Monitor', 300.00, 5.00, '27 inch monitor', 'Electronics', CURDATE(), 18),
(1009, 'Headphones', 120.00, 0.60, 'Noise cancelling headphones', 'Gaming', CURDATE(), 35),
(1010, 'Desk Lamp', 45.00, 1.00, 'LED desk lamp', 'Home', CURDATE(), 40);

-- =========================
-- PRODUCT_CATEGORIES
-- =========================

INSERT INTO product_categories (product_id, category_id) VALUES
(1,1),
(2,1),
(3,2),
(4,2),
(5,3),
(6,4),
(7,5),
(8,1),
(9,2),
(10,5);

-- =========================
-- PRODUCT_OPTIONS
-- =========================

INSERT INTO product_options (option_id, product_id) VALUES
(3,1),
(2,2),
(3,3),
(1,4),
(5,6),
(4,7),
(3,8),
(2,9),
(4,10),
(1,2);

-- =========================
-- ORDERS
-- =========================

INSERT INTO orders (
customer_id,
amount,
shipping_address,
order_address,
order_email,
order_date,
order_status
) VALUES
(1, 1235, 'Street 1', 'Street 1', 'john@example.com', CURDATE(), 'Processing'),
(2, 90, 'Street 2', 'Street 2', 'anna@example.com', CURDATE(), 'Delivered'),
(3, 340, 'Street 3', 'Street 3', 'mike@example.com', CURDATE(), 'Pending'),
(4, 120, 'Street 4', 'Street 4', 'sarah@example.com', CURDATE(), 'Shipped'),
(5, 65, 'Street 5', 'Street 5', 'alex@example.com', CURDATE(), 'Delivered');

-- =========================
-- ORDER_DETAILS
-- =========================

INSERT INTO order_details (
order_id,
product_id,
price,
sku,
quantity
) VALUES
(1,1,1200,1001,1),
(1,2,35,1002,1),
(2,3,90,1003,1),
(3,8,300,1008,1),
(3,6,20,1006,2),
(4,9,120,1009,1),
(5,10,45,1010,1),
(5,6,20,1006,1),
(4,5,40,1005,1),
(2,2,35,1002,1);

--- 6. Afișează numărul total de comenzi pentru fiecare client
SELECT c.id, c.email, COUNT(o.customer_id) AS numar_comenzi
FROM customers c
JOIN orders o
ON o.customer_id = c.id
GROUP BY c.id;