USE university_db;

INSERT INTO instructors (id, first_name, last_name, department) VALUES
    (1, 'Alina',   'Popescu',  'Computer Science'),
    (2, 'Mihai',   'Ionescu',  'Mathematics'),
    (3, 'Cristina','Dumitru',  'Physics'),
    (4, 'Radu',    'Stan',     'Computer Science'),
    (5, 'Elena',   'Marin',    'Economics');

INSERT INTO students (id, first_name, last_name, email, year_of_study, enrolled_at) VALUES
    (1,  'Andrei',  'Popa',      'andrei.popa@uni.ro',     1, '2025-10-01'),
    (2,  'Maria',   'Ionescu',   'maria.ionescu@uni.ro',   2, '2024-09-30'),
    (3,  'George',  'Dinu',      'george.dinu@uni.ro',     3, '2023-09-29'),
    (4,  'Ana',     'Stan',      'ana.stan@uni.ro',        1, '2025-10-01'),
    (5,  'Mihai',   'Radu',      'mihai.radu@uni.ro',      2, '2024-10-02'),
    (6,  'Elena',   'Tudor',     'elena.tudor@uni.ro',     3, '2023-09-28'),
    (7,  'Paul',    'Lungu',     'paul.lungu@uni.ro',      1, '2025-10-03'),
    (8,  'Roxana',  'Barbu',     'roxana.barbu@uni.ro',    2, '2024-09-30'),
    (9,  'Cristian','Costea',    'cristian.costea@uni.ro', 4, '2022-10-01'),
    (10, 'Diana',   'Marin',     'diana.marin@uni.ro',     1, '2025-10-04');

INSERT INTO courses (id, name, credits, instructor_id) VALUES
    (1, 'Algorithms',         6, 1),
    (2, 'Databases',          5, 4),
    (3, 'Linear Algebra',     4, 2),
    (4, 'Calculus',           5, 2),
    (5, 'Quantum Mechanics',  6, 3),
    (6, 'Microeconomics',     4, 5),
    (7, 'Operating Systems',  6, 1),
    (8, 'Topology',           4, NULL);

INSERT INTO enrollments (student_id, course_id, grade, enrolled_on) VALUES
    ( 1, 1, 9.5, '2025-10-05'),
    ( 1, 3, 8.0, '2025-10-05'),
    ( 1, 4, 7.5, '2025-10-05'),
    ( 2, 1, 9.0, '2024-10-03'),
    ( 2, 2, 9.5, '2024-10-03'),
    ( 2, 7, 8.5, '2024-10-03'),
    ( 3, 2, 7.0, '2023-10-01'),
    ( 3, 5, 6.5, '2023-10-01'),
    ( 4, 1, 8.0, '2025-10-06'),
    ( 4, 3, NULL,'2025-10-06'),
    ( 5, 2, 9.0, '2024-10-05'),
    ( 5, 6, 8.5, '2024-10-05'),
    ( 6, 7, 7.0, '2023-10-02'),
    ( 7, 1, 6.0, '2025-10-07'),
    ( 7, 4, NULL,'2025-10-07'),
    ( 8, 2, 9.5, '2024-10-04'),
    ( 8, 5, 8.0, '2024-10-04'),
    ( 9, 1,10.0, '2022-10-03'),
    ( 9, 7, 9.5, '2022-10-03'),
    (10, 4, 7.0, '2025-10-08');
