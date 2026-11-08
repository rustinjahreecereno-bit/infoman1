# INFOMAN1 — Week 11 Lab Answers

**Name:** Cereno, Rustin Jahree F.  
**Student ID:** 2511082  
**GitHub repo:** https://github.com/rustinjahreecereno-bit/infoman1  
**Date submitted:** [Enter submission date]

---

## Task 1 — Diagnose the Anomalies

**Approach / explanation:**

I examined the original `student_enrollment` table using SELECT queries to identify update, insertion, and deletion anomalies. I checked how many records contained the same department information, demonstrated the difficulty of representing a course without a student, and inspected the only record containing course IT102. I did not execute any INSERT or DELETE statements during this diagnostic task.

**Code / query used:**

```sql
USE infoman1_normalization;

-- A. Update anomaly:
-- Count how many rows contain the department information.
SELECT
    dept_id,
    department_name,
    COUNT(*) AS rows_to_update
FROM student_enrollment
WHERE dept_id = 'D01'
GROUP BY dept_id, department_name;

-- B. Insert anomaly:
-- Demonstrate the course information that would need to be
-- stored without any student information.
SELECT
    'IT103' AS course_id,
    'Intro to Networks' AS course_title,
    'D01' AS dept_id,
    'Computing Studies' AS department_name,
    NULL AS student_id,
    NULL AS student_name,
    NULL AS enrolled_courses,
    NULL AS grade;

-- Check whether IT103 exists in the original table.
SELECT *
FROM student_enrollment
WHERE course_id = 'IT103';

-- C. Delete anomaly:
-- Inspect Ana Cruz's IT102 enrollment.
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

-- Count the records containing IT102.
SELECT
    course_id,
    course_title,
    COUNT(*) AS rows_containing_course
FROM student_enrollment
WHERE course_id = 'IT102'
GROUP BY course_id, course_title;
```

**Evidence:**

- `week11_output.txt` — Task 1(a), Task 1(b), and Task 1(c) query results.
- `week11_queries.sql` — SQL script containing the diagnostic queries.

**Reflection question:**

The deletion anomaly surprised me most because deleting a student's enrollment could also remove the only stored information about a course. The main structural problem causing all three anomalies is that student, enrollment, course, and department information are stored together in one denormalized table instead of being separated into related tables. As a result, unrelated information depends on the same enrollment records.

---

## Task 2 — Reach First Normal Form

**Approach / explanation:**

I created a new table named `enrollment_1nf` to achieve First Normal Form. I removed the multi-valued `enrolled_courses` field from the row structure and represented each student-course enrollment as a separate record. I also established a composite primary key using `student_id` and `course_id` to prevent duplicate enrollment combinations.

**Code / query used:**

```sql
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
(student_id, student_name, course_id, course_title,
 dept_id, department_name, grade)
VALUES
(101, 'Ana Cruz', 'IT101', 'Database Systems',
 'D01', 'Computing Studies', 1.50),
(102, 'Ben Lim', 'IT101', 'Database Systems',
 'D01', 'Computing Studies', 1.75),
(101, 'Ana Cruz', 'IT102', 'Web Development',
 'D01', 'Computing Studies', 1.25);

-- Verify the 1NF records.
SELECT *
FROM enrollment_1nf
ORDER BY student_id, course_id;

-- Verify the primary key.
SHOW CREATE TABLE enrollment_1nf;
```

**Evidence:**

- `week11_output.txt` — Three 1NF records and the table structure showing the composite primary key.
- `week11_queries.sql` — Task 2 table creation and insertion statements.

**Reflection question:**

Student names still repeat because one student can enroll in multiple courses, resulting in multiple rows with the same `student_id` and `student_name`. The next normal form, Second Normal Form (2NF), removes this partial dependency by separating student information into its own table.

---

## Task 3 — Reach Second Normal Form

**Approach / explanation:**

I separated student information, course information, and enrollment information into three related tables: `students`, `courses`, and `enrollments`. This removed the partial dependencies from the original composite-key structure. The grade remains in `enrollments` because it depends on the complete combination of student and course IDs. The `courses` table still temporarily contains `department_name` at this stage because its transitive dependency is addressed in Task 4.

**Code / query used:**

```sql
-- Create the students table.
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL
);

INSERT INTO students
VALUES
(101, 'Ana Cruz'),
(102, 'Ben Lim');


-- Create the courses table for the 2NF stage.
CREATE TABLE courses (
    course_id VARCHAR(10) PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    dept_id VARCHAR(10) NOT NULL,
    department_name VARCHAR(100) NOT NULL
);

INSERT INTO courses
VALUES
('IT101', 'Database Systems', 'D01', 'Computing Studies'),
('IT102', 'Web Development', 'D01', 'Computing Studies');


-- Create the enrollments table.
CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    grade DECIMAL(4,2) NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id)
        REFERENCES students(student_id),
    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

INSERT INTO enrollments
VALUES
(101, 'IT101', 1.50),
(102, 'IT101', 1.75),
(101, 'IT102', 1.25);


-- Verify the separated tables.
SELECT * FROM students ORDER BY student_id;

SELECT * FROM courses ORDER BY course_id;

SELECT * FROM enrollments
ORDER BY student_id, course_id;


-- Reconstruct the enrollment information using JOIN.
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
```

**Evidence:**

- `week11_output.txt` — Students, courses, and enrollments records, followed by the reconstruction JOIN.
- `week11_queries.sql` — Task 3 table creation, data insertion, and JOIN statements.

**Functional Dependencies:**

- `student_id → student_name`
- `course_id → course_title`
- `course_id → dept_id`
- `dept_id → department_name`
- `(student_id, course_id) → grade`

**Reflection question:**

The student name depends only on `student_id`, which is one part of the composite primary key `(student_id, course_id)`. However, the grade depends on the complete combination because it represents the grade of a particular student in a particular course. Therefore, student information belongs in the `students` table, while grades remain in the `enrollments` table.

---

## Task 4 — Reach Third Normal Form

### Normalization Decision Path

| Final Table | 1NF: Atomic Values | 2NF: No Partial Dependencies | 3NF: No Transitive Dependencies | Verdict |
|---|---|---|---|---|
| students | Yes | Yes — single-column primary key | Yes | 3NF |
| departments | Yes | Yes — single-column primary key | Yes | 3NF |
| courses | Yes | Yes — course facts depend on course_id | Yes — department_name was separated | 3NF |
| enrollments | Yes | Yes — grade depends on the complete composite key | Yes — no non-key transitive dependency | 3NF |

**Approach / explanation:**

I identified that `department_name` depended on `dept_id`, rather than directly on the course's primary key. To remove this transitive dependency, I created a separate `departments` table and moved the department name into it. I retained `dept_id` in `courses` as a foreign key and used a four-table JOIN to reconstruct the original enrollment information.

**Code / query used:**

```sql
-- Create the departments table.
CREATE TABLE departments (
    dept_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

INSERT INTO departments
VALUES ('D01', 'Computing Studies');


-- Remove the transitive dependency from courses.
ALTER TABLE courses
DROP COLUMN department_name,
ADD CONSTRAINT fk_courses_department
FOREIGN KEY (dept_id)
REFERENCES departments(dept_id);


-- Verify the final table structures.
SHOW CREATE TABLE students;

SHOW CREATE TABLE departments;

SHOW CREATE TABLE courses;

SHOW CREATE TABLE enrollments;


-- Reconstruct the complete information using four tables.
SELECT
    s.student_id,
    s.student_name,
    c.course_id,
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
```

**Functional Dependencies:**

- `student_id → student_name`
- `course_id → course_title`
- `course_id → dept_id`
- `dept_id → department_name`
- `(student_id, course_id) → grade`

The transitive dependency `course_id → dept_id → department_name` was removed by creating a separate `departments` table. The `courses` table now references departments through a foreign key.

**Evidence:**

- `week11_output.txt` — Department and course records, final four-table JOIN, and `SHOW CREATE TABLE` results for all four tables.
- `week11_queries.sql` — Task 4 department creation, ALTER TABLE statement, and final JOIN.

**Reflection question:**

The department name is indirectly dependent on the course because `course_id` determines `dept_id`, and `dept_id` determines `department_name`. The final four-table JOIN proves that the information was preserved because it successfully reconstructed all three original enrollment records, including their student names, course titles, department names, and grades.

---

## Task 5 — Reflection

**Approach / explanation:**

I reviewed the changes from the original denormalized table through 1NF, 2NF, and 3NF. I compared how the information was distributed across the final tables and used the final JOIN result to check that the original enrollment records were preserved.

**Code / query used:**

Not applicable. This task is a written reflection based on the completed normalization activities.

**Evidence:**

- Written reflection below.
- `week11_output.txt` — Final JOIN results used to verify the normalized database.

**150–200 Word Reflection:**

Normalization into 3NF was useful because each fact is stored in the table where it depends on that table's key. In the final design, student names are kept in students, department names in departments, course details in courses, and grades in enrollments. This reduces repeated values and makes updates safer. In contrast, I would keep some denormalized repetition only when a measured reporting or performance need justifies it, and when the application has a reliable process to keep repeated values synchronized.

One issue I observed during the 2NF stage was that “Computing Studies” appeared in both course rows. That repetition meant a department-name change could require updates to several course records. I corrected it by creating the departments table, keeping dept_id in courses as a foreign key, and retrieving the department name through a join. I also checked the final four-table join against the original three enrollment records. If splitting tables drops a needed key or relationship, the clearest warning is that the reconstructed join returns fewer records than the original data. The join should preserve all three student-course pairs and their grades.

---

## Self-Check

- [ ] All tasks committed with individual, meaningful commit messages
- [x] All files placed inside `week11/`
- [x] This file completed and named `answers.md`
- [ ] Repository link pasted into Moodle (no files uploaded)
