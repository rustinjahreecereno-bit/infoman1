# INFOMAN1 — Week 8 Lab Answers

Name: Cereno, Rustin Jahree F.
Student ID: 2511082
GitHub repo: https://github.com/rustinjahreecereno-bit/infoman1
Date submitted: 

**Dataset check:** `SELECT COUNT(*) FROM employee;` returned: **500**


## Task 1 — Pattern Matching Basics

### Approach / explanation:

I used the `LIKE` operator with the `%` wildcard to find employees whose last names end in `ez` and first names start with `Ma`. I also used the `_` wildcard to verify that all employee codes contain exactly five characters starting with `E`, and to find employee codes with `0` as the third character.

### Code / query used:

```sql
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
```

### Evidence:

The following files contain the SQL queries and actual MySQL results:

- `task1.sql` — Contains all Task 1 queries and row-count verification queries.
- `task1_output.txt` — Contains the MySQL query outputs and result counts.

**Verified results:**

| Query | Description | Number of rows |
|---|---|---:|
| 1.1 | Last names ending in `ez` | 161 |
| 1.2 | First names starting with `Ma` | 112 |
| 1.3(a) | Employee codes matching `E____` | 500 |
| 1.3(b) | Employee codes matching `E_0__` | 48 |

### Reflection question: Why do we use the `%` wildcard instead of the `_` wildcard when searching for fields containing a specific keyword?

We use `%` because it matches zero or more characters, allowing us to search for a keyword even when the number of characters before or after it is unknown. In contrast, `_` matches exactly one character, making it more suitable when we know the exact number of characters to match.


## Task 2 — Basic Aggregation

**Approach / explanation:**
_[Write 2–4 sentences describing how you solved this task.]_

**Code / query used (if applicable):**
```sql
-- paste your SQL here
```

**Evidence (screenshot filename, output, or file reference in this folder):**
_[e.g. `task2_output.png`, or paste console/query output here.]_

**Reflection question:**
_[What is the difference between `COUNT(*)` and `COUNT(column_name)`?]_

## Task 3 — Grouping Data

**Approach / explanation:**
_[Write 2–4 sentences describing how you solved this task.]_

**Code / query used (if applicable):**
```sql
-- paste your SQL here
```

**Evidence (screenshot filename, output, or file reference in this folder):**
_[e.g. `task3_output.png`, or paste console/query output here.]_

**Reflection question:**
_[Why is it generally invalid to include columns in the `SELECT` list that are not in the `GROUP BY` clause, unless they are inside an aggregate function?]_

## Task 4 — Advanced Filtering with HAVING

**Approach / explanation:**
_[Write 2–4 sentences describing how you solved this task.]_

**Code / query used (if applicable):**
```sql
-- paste your SQL here
```

**Evidence (screenshot filename, output, or file reference in this folder):**
_[e.g. `task4_output.png`, or paste console/query output here.]_

**Reflection question:**
_[Why must we use the `HAVING` clause here instead of the `WHERE` clause to filter by the average value?]_

## Self-Check

- [ ] All tasks committed with individual, meaningful commit messages
- [ ] All files placed inside `week08/`
- [ ] This file completed and renamed `answers.md`
- [ ] Repository link pasted into Moodle (no files uploaded)
