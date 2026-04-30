create  database  cars_manager_db;// ?
use cars_manager_db;//?
CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT,
    price_eur DECIMAL(10,2),
    mileage_km INT,
    fuel_type VARCHAR(50),
    transmission VARCHAR(50),
    color VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO cars (
    brand,
    model,
    year,
    price_eur,
    mileage_km,
    fuel_type,
    transmission,
    color
)
VALUES (
    'BMW',
    'Seria 3',
    2020,
    24500.00,
    85000,
    'Diesel',
    'Automatic',
    'Black'
);

CREATE TABLE masini (
    id INT PRIMARY KEY AUTO_INCREMENT,
    marca VARCHAR(30) NOT NULL,
    model VARCHAR(20) NOT NULL,
    an INT,
    motor DECIMAL (2,2),
    transmisie VARCHAR(15)
);
-- am creat tabelul masini  

INSERT INTO cars (
    brand,
    model,
    year,
    price_eur,
    mileage_km,
    fuel_type,
    transmission,
    color
)
VALUES
('BMW', 'Seria 3', 2020, 24500.00, 85000, 'Diesel', 'Automatic', 'Black'),
('Audi', 'A4', 2019, 22000.00, 95000, 'Diesel', 'Automatic', 'White'),
('Volkswagen', 'Golf', 2018, 14500.00, 120000, 'Benzina', 'Manual', 'Blue'),
('Toyota', 'Corolla', 2021, 19000.00, 60000, 'Hybrid', 'Automatic', 'Silver'),
('Dacia', 'Duster', 2022, 17500.00, 40000, 'Benzina', 'Manual', 'Green');

ALTER TABLE masini MODIFY motor DECIMAL (3,1);
-- modificare tabel pentru a putea insera motor values


--
INSERT INTO masini (marca, model, an, motor, transmisie) VALUES
('Dacia','Logan',2018,1.0,'manual'),
etc.
-- am adaugat masinile

SELECT marca AS "aia e", model AS "ce-o fi", motor AS "o fi"
FROM masini
WHERE motor BETWEEN 1.6 AND 2.2 AND transmisie = 'manual';
-- selectam doar marca, modelul si motorul fiecare sub alta denumire din toate masinile
-- unde motorul este intre 1.6 si 2.2 inclusiv si transmisia este manuala

SELECT *
FROM masini
WHERE an BETWEEN 2015 and 2020;
-- selectam toate masinile cu toate columns din anii 2015-2020 inclusiv

UPDATE masini
SET marca = 'Marca'
WHERE marca = 'Dacia';

SELECT *
FROM masini;

UPDATE masini
SET marca = 'Dacia'
WHERE marca = 'Marca';
-- Am schimbat toate marcile Dacia in cuvantul 'Marca' si apoi le-am schimbat inapoi pentru ca am OCD

UPDATE masini
SET marca = 'Marca', model = 'Model'
WHERE model = 'Focus' AND motor = 1.6;

SELECT *
FROM masini
WHERE marca = 'Ford';

UPDATE masini
SET marca = 'Ford', model = 'Focus'
WHERE marca = 'Marca';
-- Am schimbat iar dus intors, am schimbat si denumirea marcii si a modelului dupa 2 parametri

DELETE FROM masini
WHERE id = 269;

SELECT *
FROM masini
WHERE id BETWEEN 265 AND 275;
-- Am sters intrarea cu id-ul 269