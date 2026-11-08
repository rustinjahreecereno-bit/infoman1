
CREATE DATABASE IF NOT EXISTS infoman1_normalization;
USE infoman1_normalization;


-- TASK 1: DIAGNOSE THE ANOMALIES

-- Update anomaly: Count rows carrying department D01

SELECT
    dept_id,
    department_name,
    COUNT(*) AS rows_to_update
FROM student_enrollment
WHERE dept_id = 'D01'
GROUP BY dept_id, department_name;


-- Insert anomaly: Demonstrate a course without a student

SELECT
    'IT103' AS course_id,
    'Intro to Networks' AS course_title,
    'D01' AS dept_id,
    'Computing Studies' AS department_name,
    NULL AS student_id,
    NULL AS student_name,
    NULL AS enrolled_courses,
    NULL AS grade;

SELECT
    course_id,
    course_title,
    dept_id,
    department_name
FROM student_enrollment
WHERE course_id = 'IT103';


-- Delete anomaly: Preview Ana's IT102 enrollment

SELECT
    student_id,
    student_name,
    course_id,
    course_title,
    dept_id,
    department_name,
    grade
FROM student_enrollment
WHERE student_id = 101
AND course_id = 'IT102';

-- Count records containing IT102

SELECT
    course_id,
    course_title,
    COUNT(*) AS rows_containing_course
FROM student_enrollment
WHERE course_id = 'IT102'
GROUP BY course_id, course_title;


-- TASK 2: FIRST NORMAL FORM (1NF)

CREATE TABLE enrollment_1nf (
    student_id INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    course_title VARCHAR(100) NOT NULL,
    dept_id VARCHAR(10) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    grade DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO enrollment_1nf
    (student_id, student_name, course_id, course_title, dept_id, department_name, grade)
VALUES
    (101, 'Ana Cruz', 'IT101', 'Database Systems', 'D01', 'Computing Studies', 1.50),
    (102, 'Ben Lim', 'IT101', 'Database Systems', 'D01', 'Computing Studies', 1.75),
    (101, 'Ana Cruz', 'IT102', 'Web Development', 'D01', 'Computing Studies', 1.25);

-- Verify atomic enrollment records

SELECT *
FROM enrollment_1nf
ORDER BY student_id, course_id;

-- Verify the composite primary key

SHOW CREATE TABLE enrollment_1nf;


-- TASK 3: SECOND NORMAL FORM (2NF)

-- Students table

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

INSERT INTO students (student_id, student_name)
VALUES
    (101, 'Ana Cruz'),
    (102, 'Ben Lim');


-- Courses table at the 2NF stage

CREATE TABLE courses (
    course_id VARCHAR(10) PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    dept_id VARCHAR(10) NOT NULL,
    department_name VARCHAR(100) NOT NULL
);

INSERT INTO courses
    (course_id, course_title, dept_id, department_name)
VALUES
    ('IT101', 'Database Systems', 'D01', 'Computing Studies'),
    ('IT102', 'Web Development', 'D01', 'Computing Studies');


-- Enrollments table

CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    grade DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO enrollments (student_id, course_id, grade)
VALUES
    (101, 'IT101', 1.50),
    (102, 'IT101', 1.75),
    (101, 'IT102', 1.25);


-- Reconstruct the enrollment report at the 2NF stage

SELECT
    s.student_id,
    s.student_name,
    c.course_id,
    c.course_title,
    c.dept_id,
    c.department_name,
    e.grade
FROM students AS s
INNER JOIN enrollments AS e
    ON s.student_id = e.student_id
INNER JOIN courses AS c
    ON e.course_id = c.course_id
ORDER BY s.student_id, c.course_id;


-- TASK 4: THIRD NORMAL FORM (3NF)

-- Create departments table

CREATE TABLE departments (
    dept_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

INSERT INTO departments (dept_id, department_name)
VALUES ('D01', 'Computing Studies');


-- Remove the transitive dependency from courses

ALTER TABLE courses
DROP COLUMN department_name,
ADD CONSTRAINT fk_courses_department
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);


-- Verify final table structures

SHOW CREATE TABLE students;
SHOW CREATE TABLE departments;
SHOW CREATE TABLE courses;
SHOW CREATE TABLE enrollments;


-- Final four-table JOIN

SELECT
    s.student_name,
    c.course_title,
    d.department_name,
    e.grade
FROM students AS s
INNER JOIN enrollments AS e
    ON s.student_id = e.student_id
INNER JOIN courses AS c
    ON e.course_id = c.course_id
INNER JOIN departments AS d
    ON c.dept_id = d.dept_id
ORDER BY s.student_id, c.course_id;
