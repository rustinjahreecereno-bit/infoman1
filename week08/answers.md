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


### Task 2 — Basic Aggregation

### Approach / explanation:

I used aggregate functions to calculate the total number of employees, employees earning commission, total monthly payroll, average salary, earliest and latest hire dates, and total compensation. I used `COALESCE()` to handle NULL commission values by treating them as zero.

### Code / query used:

```sql
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
```

### Evidence:

- `task2.sql` — Contains all four aggregation queries.
- `task2_output.txt` — Contains the MySQL query outputs.

**Verified results:**

| Measurement | Result |
|---|---:|
| Total employees | 500 |
| Employees with commission | 352 |
| Employees without commission | 148 |
| Total monthly payroll | 33,282,250.00 |
| Average salary | 66,564.50 |
| Earliest hire date | 2015-01-03 |
| Latest hire date | 2026-09-14 |
| Total compensation | 35,387,750.00 |

### Reflection: Difference between COUNT(*) and COUNT(column_name)?

`COUNT(*)` counts all rows in a table, including rows with NULL values. In contrast, `COUNT(column_name)` only counts rows where the specified column is not NULL. In this dataset, COUNT(*) returned 500 while COUNT(commission) returned 352 because 148 employees have NULL commission values.

**Why was COALESCE needed in Task 2.4?**

`COALESCE(commission, 0)` replaces NULL commission values with zero. This ensures that employees without commission still have their salaries included when calculating total compensation.


## Task 3 — Grouping Data

### Approach / explanation:

I used the GROUP BY clause to organize employees according to their departments. In the first query, I calculated the headcount, average salary, and number of distinct job titles for each department. In the second query, I grouped the employees by both department and job title to determine the headcount for each combination.

### Code / query used:

```sql
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
```

### Evidence:

- `task3.sql` — Contains both grouping queries.
- `task3_output.txt` — Contains the actual MySQL query outputs.

**Verified results — Task 3.1:**

| Department | Headcount | Average salary | Distinct job titles |
|---|---:|---:|---:|
| Engineering | 125 | 75,160.00 | 3 |
| Finance | 69 | 79,513.043478 | 3 |
| HR | 50 | 62,610.00 | 3 |
| Sales | 144 | 71,799.652778 | 3 |
| Support | 112 | 44,028.571429 | 3 |

**Verified results — Task 3.2:**

The second query returned 15 department and job-title combinations. The headcounts were:

| Department | Job title | Headcount |
|---|---|---:|
| Engineering | DevOps Engineer | 42 |
| Engineering | QA Analyst | 39 |
| Engineering | Software Engineer | 44 |
| Finance | Accountant | 21 |
| Finance | Finance Manager | 24 |
| Finance | Financial Analyst | 24 |
| HR | HR Manager | 18 |
| HR | HR Specialist | 20 |
| HR | Recruiter | 12 |
| Sales | Account Manager | 50 |
| Sales | Sales Manager | 49 |
| Sales | Sales Representative | 45 |
| Support | Support Agent | 40 |
| Support | Support Lead | 29 |
| Support | Support Specialist | 43 |

### Reflection question: Why is it generally invalid to include columns in the SELECT list that are not in the GROUP BY clause, unless they are inside an aggregate function?

It is generally invalid because a group can contain multiple values for a column that is not included in GROUP BY. MySQL would not know which value to display for that group. Aggregate functions such as COUNT and AVG provide a single calculated result for each group.


## Task 4 — Advanced Filtering with HAVING

### Approach / explanation:

I used the HAVING clause to filter departments based on their average salary and active employee headcount. For the first query, I selected 70,000 as the threshold after inspecting the average salaries from Task 3.1. For the second query, I used WHERE to select only Active employees, then GROUP BY and HAVING to display departments with more than 50 active employees.

### Code / query used:

```sql
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
```

### Evidence:

- `task4.sql` — Contains both queries using HAVING.
- `task4_output.txt` — Contains the actual MySQL query outputs.

**Verified results — Task 4.1:**

| Department | Average salary |
|---|---:|
| Finance | 79,513.043478 |
| Engineering | 75,160.000000 |
| Sales | 71,799.652778 |

**Chosen threshold:** 70,000. I selected this threshold after examining the average salaries from Task 3.1. Finance, Engineering, and Sales have average salaries above this amount.

**Verified results — Task 4.2:**

| Department | Active headcount |
|---|---:|
| Sales | 116 |
| Engineering | 104 |
| Support | 99 |
| Finance | 52 |

### Reflection question: Why must we use HAVING instead of WHERE to filter by the average value?

For Task 4.1, HAVING is required because it filters departments after AVG(salary) is calculated for each group, whereas WHERE filters individual employee records before grouping.

For Task 4.2, HAVING is required because it filters departments based on their grouped active-employee counts, after WHERE has selected only Active employees.

## Self-Check

- [ ] All tasks committed with individual, meaningful commit messages
- [ ] All files placed inside `week08/`
- [ ] This file completed and renamed `answers.md`
- [ ] Repository link pasted into Moodle (no files uploaded)
