SELECT emp_id, first_name, last_name
FROM employee
WHERE last_name LIKE '%ez';

SELECT COUNT(*) AS matching_employees
FROM employee
WHERE last_name LIKE '%ez';

SELECT emp_id, first_name, department
FROM employee
WHERE first_name LIKE 'Ma%';

SELECT COUNT(*) AS matching_employees
FROM employee
WHERE first_name LIKE 'Ma%';

SELECT COUNT(*) AS matching_codes
FROM employee
WHERE emp_code LIKE 'E____';

SELECT emp_code, first_name, last_name
FROM employee
WHERE emp_code LIKE 'E_0__';

SELECT COUNT(*) AS matching_codes
FROM employee
WHERE emp_code LIKE 'E_0__';