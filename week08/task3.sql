SELECT
    department,
    COUNT(*) AS headcount,
    AVG(salary) AS average_salary,
    COUNT(DISTINCT job_title) AS distinct_job_titles
FROM employee
GROUP BY department
ORDER BY department;

SELECT
    department,
    job_title,
    COUNT(*) AS headcount
FROM employee
GROUP BY department, job_title
ORDER BY department, job_title;