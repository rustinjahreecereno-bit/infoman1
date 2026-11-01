USE university_db;

SELECT course_code, course_name, credits
FROM courses
WHERE (course_description IS NULL OR credits BETWEEN 4 AND 6)
AND course_code LIKE '%ADV%'
ORDER BY course_name ASC;