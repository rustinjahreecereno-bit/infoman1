SELECT
    department,
    AVG(salary) AS average_salary
FROM employee
GROUP BY department
HAVING AVG(salary) > 70000
ORDER BY average_salary DESC;

SELECT
    department,
    COUNT(*) AS active_headcount
FROM employee
WHERE status = 'Active'
GROUP BY department
HAVING COUNT(*) > 50
ORDER BY active_headcount DESC;