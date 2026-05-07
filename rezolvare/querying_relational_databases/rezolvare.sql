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