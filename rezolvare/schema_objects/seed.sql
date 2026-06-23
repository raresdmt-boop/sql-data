USE hr_db;

INSERT INTO departments (id, name) VALUES
    (1, 'Engineering'),
    (2, 'Sales'),
    (3, 'Marketing'),
    (4, 'Human Resources'),
    (5, 'Finance');

INSERT INTO employees (first_name, last_name, email, department_id, salary, hired_at) VALUES
    ('Andrei',   'Popescu',  'andrei.popescu@hr.ro',   1, 12000.00, '2022-03-15'),
    ('Maria',    'Ionescu',  'maria.ionescu@hr.ro',    1, 14500.00, '2021-07-01'),
    ('George',   'Dinu',     'george.dinu@hr.ro',      1,  9000.00, '2024-01-20'),
    ('Ana',      'Stan',     'ana.stan@hr.ro',         2,  8500.00, '2023-05-10'),
    ('Mihai',    'Radu',     'mihai.radu@hr.ro',       2,  9800.00, '2022-11-05'),
    ('Elena',    'Tudor',    'elena.tudor@hr.ro',      3,  7500.00, '2024-02-18'),
    ('Paul',     'Lungu',    'paul.lungu@hr.ro',       3,  8200.00, '2023-09-01'),
    ('Roxana',   'Barbu',    'roxana.barbu@hr.ro',     4,  7000.00, '2024-04-15'),
    ('Cristian', 'Costea',   'cristian.costea@hr.ro',  5, 11000.00, '2021-12-10'),
    ('Diana',    'Marin',    'diana.marin@hr.ro',      5, 10500.00, '2023-06-22'),
    ('Bogdan',   'Vasile',   'bogdan.vasile@hr.ro',    NULL, 6500.00, '2025-09-01');
