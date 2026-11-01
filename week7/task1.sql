USE university_db;

SELECT first_name, last_name, major
FROM students
WHERE major IN ('Computer Science', 'Information Technology')
AND last_name LIKE 'S%'
AND NOT (section = 'Online');