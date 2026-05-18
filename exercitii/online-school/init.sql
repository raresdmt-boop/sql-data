-- Online School — schema recapitulativă (MySQL 8+)
-- Domeniu: studenți, carduri de identificare, cărți personale, cursuri, înrolări.
-- Diagrama sursă folosește tipuri PostgreSQL (BIGSERIAL, TIMESTAMP WITHOUT TIME ZONE).
-- Aici sunt traduse la echivalentele MySQL (BIGINT AUTO_INCREMENT, DATETIME).
-- Numele tabelului `enrolment` păstrat ca în diagramă (varianta britanică).

CREATE DATABASE IF NOT EXISTS online_school_db
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE online_school_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS enrolment;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS student_id_card;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS student;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE student (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(80)  NOT NULL,
    last_name  VARCHAR(80)  NOT NULL,
    email      VARCHAR(150) NOT NULL UNIQUE,
    age        INT          NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE course (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    department VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_id_card (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id  BIGINT       NOT NULL UNIQUE,
    card_number VARCHAR(80)  NOT NULL UNIQUE,
    CONSTRAINT fk_card_student FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE book (
    id         BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT       NOT NULL,
    book_name  VARCHAR(200) NOT NULL,
    created_at DATETIME     NOT NULL,
    CONSTRAINT fk_book_student FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE enrolment (
    student_id BIGINT   NOT NULL,
    course_id  BIGINT   NOT NULL,
    created_at DATETIME NOT NULL,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enrolment_student FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
    CONSTRAINT fk_enrolment_course  FOREIGN KEY (course_id)  REFERENCES course(id)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
