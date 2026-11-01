# INFOMAN1 — Week 7 Lab Answers


## Task 1 — Complex Student Roster

**Approach / explanation:**

To retrieve the required student records, I used the `IN` operator to select students whose major is either Computer Science or Information Technology. I used the `LIKE` operator with the pattern `'S%'` to find students whose last names start with the letter S. Finally, I used the `NOT` operator to exclude students enrolled in the Online section. The `AND` operator ensures that all three conditions must be satisfied.

**Code / query used (if applicable):**

```sql
SELECT first_name, last_name, major
FROM students
WHERE major IN ('Computer Science', 'Information Technology')
AND last_name LIKE 'S%'
AND NOT (section = 'Online');
```

**Query Result:**

| first_name | last_name | major |
|---|---|---|
| Sofia | Santos | Computer Science |
| Samuel | Santiago | Information Technology |
| Sarah | Sy | Computer Science |
| Daniel | Serrano | Information Technology |
| Liza | Soberano | Computer Science |

**Evidence (screenshot filename, output, or file reference in this folder):**

`task1_output.png`

The screenshot shows the executed SQL query and the five matching student records.

**Reflection question:**

Why is it often better to use the `IN` operator rather than chaining multiple `OR` conditions when filtering by a specific list of values?

**Answer:**

The `IN` operator is often better because it makes SQL queries shorter, cleaner, and easier to understand when filtering a column against multiple values. Instead of writing several `OR` conditions, we can list all the accepted values inside the `IN` operator. This also makes the query easier to maintain when adding or removing values.

## Task 2 — Formatting Employee Data

**Approach / explanation:**

I used the LEFT() function to extract the first initial of each instructor's first name. I used CONCAT() to combine the initial, last name, salary symbol, and rounded salary into one formatted string. The ROUND() function rounds each instructor's salary to the nearest whole number. I also used a column alias to name the output "Instructor Details" and LIMIT 5 to display only the first five records.

**Code / query used (if applicable):**

```sql
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
```

**Query Result:**

| Instructor Details |
|---|
| J. Smith ($55001) |
| M. Santos ($62500) |
| R. Johnson ($49000) |
| A. Reyes ($71250) |
| P. Cruz ($47001) |

**Evidence:**

`task2_output.png`

**Reflection question:**

How do string functions like CONCAT affect the performance of a query compared to retrieving raw columns and formatting them in the application layer (e.g., in Java or Python)?

**Answer:**

String functions like CONCAT allow the database to combine and format values before returning the results. However, retrieving raw columns and formatting them in the application layer may be more flexible and can reduce unnecessary database processing when the formatted output is not needed by the database itself. The better approach depends on the application's requirements and the amount of data being processed.

## Task 3 — Project Deadline Analysis

**Approach / explanation:**

I used the DATEDIFF() function to calculate the number of days between the assigned date and due date of each assignment. I assigned the calculated result the alias Days_To_Complete to make the output easier to understand. I used the WHERE condition to display only assignments with a completion period greater than 14 days. Finally, I used ORDER BY with DESC to arrange the assignments from the longest duration to the shortest.

**Code / query used (if applicable):**

```sql
SELECT
    assignment_name,
    DATEDIFF(due_date, assigned_date) AS Days_To_Complete
FROM assignments
WHERE DATEDIFF(due_date, assigned_date) > 14
ORDER BY Days_To_Complete DESC;
```

**Query Result:**

| assignment_name | Days_To_Complete |
|---|---:|
| Capstone Proposal | 44 |
| Midterm Lab Report | 25 |
| Normalization Case | 21 |
| SQL Basics Worksheet | 20 |

**Evidence:**

`task3_output.png`

**Reflection question:**

Why is column aliasing particularly important when using mathematical or date functions in the SELECT clause?

**Answer:**

Column aliasing is important because it gives calculated results meaningful and understandable names. Instead of displaying a complicated expression such as DATEDIFF(due_date, assigned_date), an alias like Days_To_Complete clearly explains what the calculated value represents. It also makes query results easier to read and reference when organizing output.

## Task 4 — Comprehensive Data Audit

**Approach / explanation:**

I used the IS NULL operator to identify courses with missing descriptions. I also used BETWEEN 4 AND 6 to find courses with credits ranging from 4 to 6, inclusive. The OR operator allows either of these conditions to be satisfied, while the AND operator requires the course code to contain ADV using LIKE '%ADV%'. I placed parentheses around the OR condition to ensure that the filtering follows the intended logical order. Finally, I used ORDER BY course_name ASC to arrange the results alphabetically.

**Code / query used (if applicable):**

```sql
SELECT course_code, course_name, credits
FROM courses
WHERE (course_description IS NULL OR credits BETWEEN 4 AND 6)
AND course_code LIKE '%ADV%'
ORDER BY course_name ASC;
```

**Query Result:**

| course_code | course_name | credits |
|---|---|---:|
| CS-ADV305 | Advanced Algorithms | 4 |
| CS-ADV400 | Advanced Capstone Project | 6 |
| CS-ADV101 | Advanced Database Systems | 5 |
| IT-ADV210 | Advanced Networking | 3 |
| ENG-ADV110 | Advanced Technical Writing | 2 |
| IT-ADV150 | Advanced Web Development | 6 |

**Evidence:**

`task4_output.png`

**Reflection question:**

Explain how MySQL evaluates the expression A OR B AND C. How did you use parentheses (if you did) to ensure your query filtered the exact data requested in the instructions?

**Answer:**

MySQL evaluates AND before OR when parentheses are not used. Therefore, the expression A OR B AND C is interpreted as A OR (B AND C). In my query, I used parentheses around (A OR B) to ensure that the course must either have a missing description or have between 4 and 6 credits. The AND condition then requires the course code to contain ADV. This ensures that the query follows the exact filtering requirements.

## Self-Check

- [x] All tasks committed with individual, meaningful commit messages
- [x] All files placed inside `week7/`
- [x] This file completed and renamed `answers.md`
- [x] Repository link pasted into Moodle (no files uploaded)
