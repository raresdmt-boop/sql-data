# Schema Objects — Exerciții propuse

Folosește baza `hr_db` (vezi `init.sql` + `seed.sql`). 2 tabele: `departments` (5 rânduri) + `employees` (11 rânduri).

> 💡 După fiecare obiect creat, verifică-l cu `SHOW INDEX`, `SHOW CREATE VIEW`, `SHOW TRIGGERS`, `SHOW PROCEDURE STATUS` etc.

---

## DDL — modificări de schemă

- [ ] **EX-1.** Adaugă o coloană nouă `phone VARCHAR(20) NULL` în tabela `employees`. Verifică cu `DESCRIBE employees;`.
- [ ] **EX-2.** Modifică tipul coloanei `salary` din `DECIMAL(10, 2)` în `DECIMAL(12, 2)`.
- [ ] **EX-3.** Adaugă o constrângere `CHECK (salary > 0)` la tabela `employees`.
- [ ] **EX-4.** Redenumește coloana `phone` în `phone_number`.
- [ ] **EX-5.** Șterge coloana `phone_number` din tabelă.

## Indexes

- [ ] **EX-6.** Creează un index simplu pe `employees.last_name` numit `idx_employees_last_name`. Verifică cu `SHOW INDEX FROM employees;`.
- [ ] **EX-7.** Creează un index compus pe `(department_id, salary)` numit `idx_employees_dept_salary`.
- [ ] **EX-8.** Rulează `EXPLAIN SELECT * FROM employees WHERE last_name = 'Popescu';` și observă coloana `key` — ce index a folosit?
- [ ] **EX-9.** Șterge indexul `idx_employees_last_name`.
- [ ] **EX-10.** Creează un index UNIQUE pe `email` (deși e deja UNIQUE prin constrângere) — observă mesajul de eroare. Apoi încearcă pe `(first_name, last_name)`.

## Views

- [ ] **EX-11.** Creează o view `v_active_employees` care arată `id`, `first_name`, `last_name`, `salary` doar pentru cei cu `salary >= 8000`.
- [ ] **EX-12.** Interoghează view-ul: `SELECT * FROM v_active_employees ORDER BY salary DESC;`.
- [ ] **EX-13.** Creează o view `v_employees_with_department` care face JOIN între `employees` și `departments` și afișează numele complet + numele departamentului.
- [ ] **EX-14.** Modifică prima view cu `CREATE OR REPLACE VIEW` ca să includă și `hired_at`.
- [ ] **EX-15.** Șterge ambele view-uri.

## Stored Procedures

- [ ] **EX-16.** Creează o procedură `give_raise(IN p_dept_id INT, IN p_percent DECIMAL(5, 2))` care mărește salariul cu `p_percent` procente pentru toți angajații din departamentul `p_dept_id`.
- [ ] **EX-17.** Apelează procedura: `CALL give_raise(1, 5);` (5% mărire pentru Engineering). Verifică cu un `SELECT`.
- [ ] **EX-18.** Creează o procedură `count_employees_by_department()` (fără parametri) care afișează un raport cu numele departamentului și numărul de angajați.

## Stored Functions

- [ ] **EX-19.** Creează o funcție `full_name(p_id INT) RETURNS VARCHAR(170)` care returnează `'first_name last_name'` pentru un angajat. Folosește-o: `SELECT id, full_name(id) FROM employees;`.
- [ ] **EX-20.** Creează o funcție `years_of_service(p_id INT) RETURNS INT` care returnează numărul de ani întregi de când angajatul e angajat. *Hint:* `TIMESTAMPDIFF(YEAR, hired_at, CURDATE())`.

## Triggers

- [ ] **EX-21.** Creează tabela `salary_log (id, employee_id, old_salary, new_salary, changed_at)`. *Hint:* `DATETIME DEFAULT CURRENT_TIMESTAMP`.
- [ ] **EX-22.** Creează un trigger `trg_employees_salary_log` care se declanșează `AFTER UPDATE` pe `employees` și inserează un rând în `salary_log` doar dacă `OLD.salary <> NEW.salary`.
- [ ] **EX-23.** Testează trigger-ul: `UPDATE employees SET salary = 13500 WHERE id = 1;` și verifică `SELECT * FROM salary_log;`.
- [ ] **EX-24.** Listează toate trigger-urile cu `SHOW TRIGGERS;`.

## Provocări

- [ ] **CH-1.** Creează o procedură `transfer_employee(IN p_employee_id INT, IN p_new_department INT)` care, într-o tranzacție, mută angajatul în alt departament și logează modificarea într-o tabelă `transfer_log`. Folosește `START TRANSACTION` și `COMMIT`/`ROLLBACK` după caz.
- [ ] **CH-2.** Creează o view `v_department_stats` care arată pentru fiecare departament: numele, numărul de angajați, salariul mediu, salariul maxim, salariul minim.
- [ ] **CH-3.** Creează un user MySQL `app_reader` cu parolă, care are doar drept de `SELECT` pe baza `hr_db` și **nu** poate vedea coloana `salary`. *Hint:* dă `SELECT` pe o view care exclude `salary`, nu pe tabelă direct.

---

## Scenarii frecvente în producție

- [ ] **PR-1.** Adaugă o coloană `status VARCHAR(20) NOT NULL DEFAULT 'active'` în `employees`, ca bază pentru soft-offboarding.
- [ ] **PR-2.** Creează un index pe `hired_at` pentru raportări frecvente după data angajării.
- [ ] **PR-3.** Creează un index compus pe `(department_id, hired_at)` și rulează `EXPLAIN` pe un query care caută angajații dintr-un departament angajați după o anumită dată.
- [ ] **PR-4.** Creează o view `v_public_employees` care expune doar `id`, nume complet, departament și `hired_at`, fără email sau salary.
- [ ] **PR-5.** Creează o view `v_unassigned_employees` pentru angajații fără `department_id`.
- [ ] **PR-6.** Creează o procedură `hire_employee(...)` care inserează un nou angajat și validează că salariul este pozitiv.
- [ ] **PR-7.** Creează o funcție `department_name(p_employee_id INT)` care returnează numele departamentului pentru un angajat sau `NULL` dacă nu este asignat.
- [ ] **PR-8.** Creează tabela `employee_audit_log (id, employee_id, action_name, changed_at, notes)` și un trigger `AFTER INSERT` pe `employees` care loghează fiecare angajare nouă.
- [ ] **PR-9.** Creează un trigger `BEFORE UPDATE` care blochează setarea unui salariu mai mic sau egal cu 0. *Hint:* `SIGNAL SQLSTATE '45000'`.
- [ ] **PR-10.** Creează o procedură `deactivate_employee(IN p_employee_id INT)` care mută `status` în `'inactive'` fără să șteargă datele.
- [ ] **PR-11.** Creează o view `v_department_payroll` care arată suma salariilor pe departament și numărul de angajați activi.
- [ ] **PR-12.** Creează un user `hr_reporting` care are acces doar la view-urile de raportare, nu la tabelele brute.
