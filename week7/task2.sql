USE university_db;

SELECT CONCAT(
    LEFT(first_name, 1),
    '. ',
    last_name,
    ' ($',
    ROUND(salary),
    ')'
) AS `Instructor Details`
FROM instructors
LIMIT 5;