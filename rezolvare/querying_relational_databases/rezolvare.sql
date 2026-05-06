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