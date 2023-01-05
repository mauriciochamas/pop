CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

describe employee

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- -----------------------------------------------------------------------------

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

select * from works_with
select * from branch_supplier
select * from employee order by salary desc
select * from client
select * from employee order by sex, first_name

select * from employee limit 5
select first_name as Nombre, last_name as Apellido from employee limit 5
select distinct sex as Genero from employee
select unique sex from employee
=== WILDCARDS===
select COUNT(emp_id) from employee
select COUNT(super_id) from employee
select COUNT(emp_id) from employee where sex = "F" AND birth_day > "1971-01-01"

select AVG(salary) from employee where sex = "M"
select AVG(salary) from employee where sex = "F"

select sum(salary) from employee

select COUNT(sex), sex from employee group by SEX


select COUNT(super_id), sex from employee group by sex

select emp_id, SUM(total_sales) from works_with group by emp_id
select client_id, SUM(total_sales) from works_with group by client_id order by emp_id
select * from works_with

select emp_id, sum(total_sales) from works_with group by emp_id
select client_id, sum(total_sales) from works_with group by client_id
select client_name, sum(total_sales) from works_with group by client_id
select * from works_with

select client_name from client where client_name like "%LLC"
select emp_id from employee where birth_day like "____-10-__"
=== UNION ===
select SUM(total_sales) from works_with
union 
select sum(salary) from employee

INSERT into branch values(4, "Bufalo", NULL, NULL)
select * from branch
===JOIN===
select employee.first_name as Encargado, branch.branch_name as Empresa
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id
===LEFT/RIGHT JOIN===
select employee.first_name as Encargado, branch.branch_name as Empresa
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id

select employee.first_name as Encargado, branch.branch_name as Empresa
FROM branch
LEFT JOIN employee
ON employee.emp_id = branch.mgr_id

select employee.first_name as Encargado, branch.branch_name as Empresa
FROM employee
right JOIN branch
ON employee.emp_id = branch.mgr_id

select employee.first_name as Encargado, branch.branch_name as Empresa
FROM employee
INNER JOIN branch
ON employee.emp_id = branch.mgr_id

===NESTED QUERY===
"SELECT works_with.emp_id, employee.first_name where total_sales>30000
FROM WORKS_WITH
JOIN employee
ON works_with.emp_id = employee.emp_id"

select employee.first_name, employee.last_name from employee
where emp_id IN(select emp_id from works_with where total_sales > 30000)

select client_name from client where client_id IN(
    select client_id from works_with where emp_id = 102)

select branch_name from branch where mgr_id = 102
IN(
    select client_id from works_with where emp_id = 102)

===DELETE===
delete from employee where emp_id = 102
select * from branch
select * from employee

delete from branch where branch_id = 2
select * from branch_supplier

===Trigger===
DELIMITER $$
CREATE
    TRIGGER my_trigger before insert
    on employee
    for each row begin
        insert into trigger_test VALUES('agregar un nuevo empleado');
    end$$
DELIMITER ;

INSERT into employee
VALUES(109, "Oscar", "Martinez", "1968-02-19", "M", 6900, 106, 3)

SELECT * FROM TRIGGER_TEST

DELIMITER $$
CREATE
    TRIGGER my_trigger1 before insert
    on employee
    for each row begin
        insert into trigger_test VALUES(New.first_name);
    end$$
DELIMITER ;

INSERT into employee
VALUES(109, "Oscar", "Martinez", "1968-02-19", "M", 6900, 106, 3)

select * from trigger_test
