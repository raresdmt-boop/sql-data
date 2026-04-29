#
# CREATE TABLE student (
#     student_id INT AUTO_INCREMENT,
#     name VARCHAR(20),
#     major VARCHAR(20),
#     PRIMARY KEY(student_id)
# );
#
# DESCRIBE student;
# SELECT name, major
# FROM student
# WHERE name<>'Jack';
#
# DROP TABLE student;
# # DEFAULT 'undecided', UNIQUE, NOT NULL, primary is unique and not null
# # ALTER TABLE student ADD gpa DECIMAL(3,2);
# #
# # ALTER TABLE student DROP COLUMN gpa;
#
# INSERT INTO student(name, major) VALUES('Jack', 'Biology');
# INSERT INTO student(name, major) VALUES('Kate', 'Sociology');
# INSERT INTO student(name, major) VALUES('Claire', 'Chemistry');
# INSERT INTO student(name, major) VALUES('Jack', 'Biology');
# INSERT INTO student(name, major) VALUES('Mike', 'Computer Science');
#
# DELETE FROM student;
#
#
-- Find all employees
Select * from employee;
-- Find all employees ordered by salary;
SELECT *
FROM employee
ORDER BY salary DESC
-- Find all emp ordered by sex then name;
SELECT *
FROM employee
ORDER BY sex, first_name, last_name;
-- Find the first 5 employees in the table;
SELECT *
FROM employee
LIMIT 5;
-- Find the first and last name of all employees;
SELECT first_name AS forename, last_name AS surname
FROM employee;
-- Find out all the different genders
SELECT DISTINCT sex
FROM employee;
-- ============================= FUNCTION ========================
-- Find the number of employees
SELECT COUNT(emp_id)
FROM employee;
-- Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1970-01-01';
-- Find the average of all employee's salaries
SELECT AVG(salary)
FROM employee;
-- Find the average of male employee's salaries
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';
-- Find the sum of all employee salaries
SELECT SUM(salary)
FROM employee;
-- Find out how many male and females there are
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;
-- Find the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

-- ===================================WILDCARDS=======================
-- Find any clients who are an LLC
SELECT *
FROM client
WHERE client_name LIKE '%LLC';
-- Find any branch suppliers that are in the label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '% Label%';
-- Find any employee born in October
SELECT *
FROM employee
WHERE birth_day LIKE '____-02%';
-- Find any clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school%';

-- ================================UNION========================
-- Find a list of employee and branch names
SELECT first_name AS Company_Names
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name
FROM client;
-- Find a list of all clients and branch suppliers' names
SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;
-- Find a list of all money spent or earned by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

-- ========================================JOINS===============================
INSERT INTO branch VALUES (4, 'Buffalo', NULL, NULL);

SELECT *
FROM branch;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch    -- LEFT JOIN, RIGHT JOIN
ON employee.emp_id = branch.mgr_id;

-- ==================================NESTED QUERIES================================
-- Find names of all employees who have
-- sold more than 30.000 to a single client
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
    );
-- Find all clients who are handled by the branch that
-- Michael Scott manages
-- Assume you know Michael's ID

SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE mgr_id = 102
    LIMIT 1
    );




