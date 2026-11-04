SELECT
    COUNT(*) AS total_employees,
    COUNT(commission) AS employees_with_commission
FROM employee;

SELECT SUM(salary) AS total_monthly_payroll
FROM employee;

SELECT
    AVG(salary) AS average_salary,
    MIN(hire_date) AS earliest_hire_date,
    MAX(hire_date) AS latest_hire_date
FROM employee;

SELECT
    SUM(salary + COALESCE(commission, 0)) AS total_compensation
FROM employee;