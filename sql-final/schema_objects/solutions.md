# Schema Objects — Soluții

Soluțiile pentru exercițiile din `../../sql-start/schema_objects/exercises.md`. Folosește baza `hr_db`.

```bash
mysql -h 127.0.0.1 -P 3306 -u root -proot < init.sql
mysql -h 127.0.0.1 -P 3306 -u root -proot < seed.sql
```

> 🔁 Pentru reset complet (după triggers / proceduri create), rerulează `init.sql` + `seed.sql`.

---

## DDL — modificări de schemă

### EX-1. Adaugă coloana `phone`.
```sql
ALTER TABLE employees
ADD COLUMN phone VARCHAR(20) NULL;

DESCRIBE employees;
```

### EX-2. Modifică tipul `salary` în `DECIMAL(12, 2)`.
```sql
ALTER TABLE employees
MODIFY COLUMN salary DECIMAL(12, 2) NOT NULL;
```

### EX-3. Adaugă constrângerea `CHECK (salary > 0)`.
```sql
ALTER TABLE employees
ADD CONSTRAINT chk_employees_salary_positive CHECK (salary > 0);
```

### EX-4. Redenumește `phone` → `phone_number`.
```sql
ALTER TABLE employees
RENAME COLUMN phone TO phone_number;
```

### EX-5. Șterge coloana `phone_number`.
```sql
ALTER TABLE employees
DROP COLUMN phone_number;
```

## Indexes

### EX-6. Index simplu pe `last_name`.
```sql
CREATE INDEX idx_employees_last_name ON employees(last_name);

SHOW INDEX FROM employees;
```

### EX-7. Index compus pe `(department_id, salary)`.
```sql
CREATE INDEX idx_employees_dept_salary ON employees(department_id, salary);
```

### EX-8. EXPLAIN pentru `last_name`.
```sql
EXPLAIN SELECT * FROM employees WHERE last_name = 'Popescu';
-- coloana `key` ar trebui să arate `idx_employees_last_name`
```

### EX-9. Șterge `idx_employees_last_name`.
```sql
DROP INDEX idx_employees_last_name ON employees;
```

### EX-10. UNIQUE pe email (fail), apoi pe `(first_name, last_name)`.
```sql
-- email are deja un index implicit numit `email` (din UNIQUE inline);
-- dacă reutilizezi exact acel nume, MySQL aruncă: ERROR 1061 'Duplicate key name'
CREATE UNIQUE INDEX email ON employees(email);

-- pe alt nume merge, dar e redundant — același index logic, doar dublat;
-- verifici cu `SHOW INDEX FROM employees;`
CREATE UNIQUE INDEX idx_employees_email_unique ON employees(email);

-- pe `(first_name, last_name)` se creează fără probleme:
CREATE UNIQUE INDEX idx_employees_first_last ON employees(first_name, last_name);
```

## Views

### EX-11. View `v_active_employees`.
```sql
CREATE VIEW v_active_employees AS
SELECT id, first_name, last_name, salary
FROM employees
WHERE salary >= 8000;
```

### EX-12. SELECT pe view.
```sql
SELECT * FROM v_active_employees ORDER BY salary DESC;
```

### EX-13. View cu JOIN.
```sql
CREATE VIEW v_employees_with_department AS
SELECT
    e.id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.name AS department
FROM employees e
LEFT JOIN departments d ON d.id = e.department_id;
```

### EX-14. Modifică prima view ca să includă `hired_at`.
```sql
CREATE OR REPLACE VIEW v_active_employees AS
SELECT id, first_name, last_name, salary, hired_at
FROM employees
WHERE salary >= 8000;
```

### EX-15. Șterge ambele view-uri.
```sql
DROP VIEW IF EXISTS v_active_employees;
DROP VIEW IF EXISTS v_employees_with_department;
```

## Stored Procedures

### EX-16. Procedura `give_raise`.
```sql
DELIMITER //

CREATE PROCEDURE give_raise(
    IN p_dept_id INT,
    IN p_percent DECIMAL(5, 2)
)
BEGIN
    UPDATE employees
    SET salary = salary * (1 + p_percent / 100)
    WHERE department_id = p_dept_id;
END //

DELIMITER ;
```

### EX-17. Apelează procedura.
```sql
CALL give_raise(1, 5);

SELECT id, first_name, last_name, salary
FROM employees
WHERE department_id = 1;
```

### EX-18. Procedura `count_employees_by_department`.
```sql
DELIMITER //

CREATE PROCEDURE count_employees_by_department()
BEGIN
    SELECT
        d.name AS department,
        COUNT(e.id) AS employees_count
    FROM departments d
    LEFT JOIN employees e ON e.department_id = d.id
    GROUP BY d.id, d.name;
END //

DELIMITER ;

CALL count_employees_by_department();
```

## Stored Functions

### EX-19. Funcția `full_name`.
```sql
DELIMITER //

CREATE FUNCTION full_name(p_id INT)
RETURNS VARCHAR(170)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result VARCHAR(170);
    SELECT CONCAT(first_name, ' ', last_name) INTO result
    FROM employees WHERE id = p_id;
    RETURN result;
END //

DELIMITER ;

SELECT id, full_name(id) AS name FROM employees;
```

### EX-20. Funcția `years_of_service`.
```sql
DELIMITER //

CREATE FUNCTION years_of_service(p_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result INT;
    SELECT TIMESTAMPDIFF(YEAR, hired_at, CURDATE()) INTO result
    FROM employees WHERE id = p_id;
    RETURN result;
END //

DELIMITER ;

SELECT id, full_name(id) AS name, years_of_service(id) AS years
FROM employees;
```

## Triggers

### EX-21. Tabela `salary_log`.
```sql
CREATE TABLE salary_log (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    old_salary  DECIMAL(12, 2) NOT NULL,
    new_salary  DECIMAL(12, 2) NOT NULL,
    changed_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### EX-22. Trigger `trg_employees_salary_log`.
```sql
DELIMITER //

CREATE TRIGGER trg_employees_salary_log
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_log (employee_id, old_salary, new_salary)
        VALUES (NEW.id, OLD.salary, NEW.salary);
    END IF;
END //

DELIMITER ;
```

### EX-23. Test trigger.
```sql
UPDATE employees SET salary = 13500 WHERE id = 1;

SELECT * FROM salary_log;
```

### EX-24. Listă trigger-uri.
```sql
SHOW TRIGGERS;
```

## Provocări

### CH-1. Procedura `transfer_employee` cu tranzacție și log.
```sql
CREATE TABLE IF NOT EXISTS transfer_log (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    employee_id     INT NOT NULL,
    old_department  INT NULL,
    new_department  INT NOT NULL,
    transferred_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELIMITER //

CREATE PROCEDURE transfer_employee(
    IN p_employee_id INT,
    IN p_new_department INT
)
BEGIN
    DECLARE v_old_department INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT department_id INTO v_old_department
    FROM employees WHERE id = p_employee_id;

    UPDATE employees
    SET department_id = p_new_department
    WHERE id = p_employee_id;

    INSERT INTO transfer_log (employee_id, old_department, new_department)
    VALUES (p_employee_id, v_old_department, p_new_department);

    COMMIT;
END //

DELIMITER ;
```

### CH-2. View `v_department_stats`.
```sql
CREATE VIEW v_department_stats AS
SELECT
    d.name AS department,
    COUNT(e.id)        AS employees_count,
    AVG(e.salary)      AS avg_salary,
    MAX(e.salary)      AS max_salary,
    MIN(e.salary)      AS min_salary
FROM departments d
LEFT JOIN employees e ON e.department_id = d.id
GROUP BY d.id, d.name;
```

### CH-3. User `app_reader` doar pe view fără salary.
```sql
CREATE VIEW v_employees_no_salary AS
SELECT id, first_name, last_name, email, department_id, hired_at
FROM employees;

CREATE USER 'app_reader'@'%' IDENTIFIED BY 'StrongPass!23';

GRANT SELECT ON hr_db.v_employees_no_salary TO 'app_reader'@'%';
GRANT SELECT ON hr_db.departments           TO 'app_reader'@'%';

FLUSH PRIVILEGES;
```

---

## Scenarii frecvente în producție

### PR-1. Coloana `status` cu default `'active'`.
```sql
ALTER TABLE employees
ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'active';
```

### PR-2. Index pe `hired_at`.
```sql
CREATE INDEX idx_employees_hired_at ON employees(hired_at);
```

### PR-3. Index compus + EXPLAIN.
```sql
CREATE INDEX idx_employees_dept_hired ON employees(department_id, hired_at);

EXPLAIN
SELECT *
FROM employees
WHERE department_id = 1
  AND hired_at >= '2023-01-01';
```

### PR-4. View `v_public_employees`.
```sql
CREATE VIEW v_public_employees AS
SELECT
    e.id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.name AS department,
    e.hired_at
FROM employees e
LEFT JOIN departments d ON d.id = e.department_id;
```

### PR-5. View `v_unassigned_employees`.
```sql
CREATE VIEW v_unassigned_employees AS
SELECT id, first_name, last_name, email, hired_at
FROM employees
WHERE department_id IS NULL;
```

### PR-6. Procedura `hire_employee` cu validare.
```sql
DELIMITER //

CREATE PROCEDURE hire_employee(
    IN p_first_name    VARCHAR(80),
    IN p_last_name     VARCHAR(80),
    IN p_email         VARCHAR(150),
    IN p_department_id INT,
    IN p_salary        DECIMAL(12, 2),
    IN p_hired_at      DATE
)
BEGIN
    IF p_salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be positive';
    END IF;

    INSERT INTO employees (first_name, last_name, email, department_id, salary, hired_at)
    VALUES (p_first_name, p_last_name, p_email, p_department_id, p_salary, p_hired_at);
END //

DELIMITER ;
```

### PR-7. Funcția `department_name`.
```sql
DELIMITER //

CREATE FUNCTION department_name(p_employee_id INT)
RETURNS VARCHAR(100)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result VARCHAR(100);
    SELECT d.name INTO result
    FROM employees e
    LEFT JOIN departments d ON d.id = e.department_id
    WHERE e.id = p_employee_id;
    RETURN result;
END //

DELIMITER ;
```

### PR-8. Audit log + trigger pe INSERT.
```sql
CREATE TABLE employee_audit_log (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    action_name VARCHAR(20) NOT NULL,
    changed_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes       VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELIMITER //

CREATE TRIGGER trg_employees_after_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit_log (employee_id, action_name, notes)
    VALUES (NEW.id, 'HIRED', CONCAT('Hired on ', NEW.hired_at));
END //

DELIMITER ;
```

### PR-9. Trigger BEFORE UPDATE care blochează salariul ≤ 0.
```sql
DELIMITER //

CREATE TRIGGER trg_employees_block_invalid_salary
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary must be positive';
    END IF;
END //

DELIMITER ;
```

### PR-10. Procedura `deactivate_employee`.
```sql
DELIMITER //

CREATE PROCEDURE deactivate_employee(IN p_employee_id INT)
BEGIN
    UPDATE employees
    SET status = 'inactive'
    WHERE id = p_employee_id;
END //

DELIMITER ;
```

### PR-11. View `v_department_payroll`.
```sql
CREATE VIEW v_department_payroll AS
SELECT
    d.name AS department,
    SUM(e.salary)  AS total_payroll,
    COUNT(e.id)    AS active_employees
FROM departments d
LEFT JOIN employees e
       ON e.department_id = d.id
      AND e.status = 'active'
GROUP BY d.id, d.name;
```

### PR-12. User `hr_reporting` doar pe view-uri.
```sql
CREATE USER 'hr_reporting'@'%' IDENTIFIED BY 'ReportPass!23';

GRANT SELECT ON hr_db.v_department_payroll TO 'hr_reporting'@'%';
GRANT SELECT ON hr_db.v_public_employees   TO 'hr_reporting'@'%';
GRANT SELECT ON hr_db.v_department_stats   TO 'hr_reporting'@'%';

FLUSH PRIVILEGES;
```
