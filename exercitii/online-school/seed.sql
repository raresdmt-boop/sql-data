-- Online School — seed pentru exerciții recapitulative
-- 8 studenți, 5 cursuri, 9 înrolări, 6 cărți, 5 carduri (3 studenți fără card).

USE online_school_db;

DELETE FROM enrolment;
DELETE FROM book;
DELETE FROM student_id_card;
DELETE FROM course;
DELETE FROM student;
ALTER TABLE book            AUTO_INCREMENT = 1;
ALTER TABLE student_id_card AUTO_INCREMENT = 1;
ALTER TABLE course          AUTO_INCREMENT = 1;
ALTER TABLE student         AUTO_INCREMENT = 1;

INSERT INTO student (first_name, last_name, email, age) VALUES
('Ana',       'Popescu',  'ana@school.ro',       22),
('Bogdan',    'Stoica',   'bogdan@school.ro',    24),
('Cristina',  'Marin',    'cristina@school.ro',  21),
('David',     'Iancu',    'david@school.ro',     28),
('Elena',     'Vasile',   'elena@school.ro',     19),
('Florin',    'Mihai',    'florin@school.ro',    35),
('Gabriela',  'Dumitru',  'gabi@school.ro',      26),
('Horia',     'Tudor',    'horia@school.ro',     30);

INSERT INTO course (name, department) VALUES
('Algorithms',       'CS'),
('Database Systems', 'CS'),
('Linear Algebra',   'Math'),
('Calculus',         'Math'),
('World History',    'History');

INSERT INTO student_id_card (student_id, card_number) VALUES
(1, 'CARD-001'),
(2, 'CARD-002'),
(3, 'CARD-003'),
(4, 'CARD-004'),
(5, 'CARD-005');

INSERT INTO book (student_id, book_name, created_at) VALUES
(1, 'Intro to Algorithms',   '2026-01-10 09:00:00'),
(1, 'CLRS Notes',            '2026-02-01 12:30:00'),
(2, 'SQL for All',           '2026-01-15 14:00:00'),
(4, 'History of Rome',       '2026-03-05 10:15:00'),
(7, 'Database Internals',    '2026-02-20 16:45:00'),
(8, 'Algorithms Vol I',      '2026-03-10 11:00:00');

INSERT INTO enrolment (student_id, course_id, created_at) VALUES
(1, 1, '2026-01-20 09:00:00'),
(1, 4, '2026-01-20 09:05:00'),
(2, 2, '2026-01-22 10:00:00'),
(3, 1, '2026-02-01 11:30:00'),
(3, 3, '2026-02-01 11:35:00'),
(4, 5, '2026-02-10 14:00:00'),
(5, 4, '2026-02-15 09:00:00'),
(7, 2, '2026-02-18 13:00:00'),
(7, 5, '2026-02-18 13:05:00'),
(8, 1, '2026-03-01 10:00:00');
