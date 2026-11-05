# INFOMAN1 — Week 9 Lab Answers

Name: Cereno, Rustin Jahree F.  
Student ID: 2511082  
GitHub repo: https://github.com/rustinjahreecereno-bit/infoman1  
Date submitted:

## Task 1 — INNER JOIN Basics

**Approach / explanation:**

I used INNER JOIN to combine the students and orders tables through their common student_id column. I used table aliases to make the query easier to read and ORDER BY to arrange the results according to order_id. The query returns only students who have matching records in the orders table.

**Code / query used:**

```sql
SELECT
    s.student_name,
    s.program,
    o.order_id,
    o.order_date
FROM students AS s
INNER JOIN orders AS o
    ON s.student_id = o.student_id
ORDER BY o.order_id;
```

**Evidence:**

- `week9_queries.sql` — Contains the Task 1 query.
- `week9_output.txt` — Contains the actual MySQL query output.

**Verified results:**

The query returned 3 rows:

| Student | Program | Order ID | Order Date |
|---|---|---:|---|
| Ana Cruz | BSIT | 101 | 2026-08-10 |
| Ana Cruz | BSIT | 102 | 2026-08-15 |
| Dan Reyes | BSIT | 103 | 2026-08-16 |

**Reflection question: Why does an INNER JOIN hide students who never ordered, and when is that exactly the behavior a sales report wants?**

An INNER JOIN only displays records that have matching values in both connected tables. Students without matching orders are excluded from the results. This behavior is useful in a completed-sales report because the report should only display students who actually placed orders.

## Task 2 — Finding Missing Relationships

**Approach / explanation:**

I used LEFT JOIN to combine the students and orders tables while keeping every student in the results. Students without matching orders displayed NULL in the order columns. I then used WHERE with IS NULL to identify students who never placed an order.

**Code / query used:**

**Query A — Display all students, including those without orders**

```sql
SELECT
    s.student_name,
    s.program,
    o.order_id,
    o.order_date
FROM students AS s
LEFT JOIN orders AS o
    ON s.student_id = o.student_id
ORDER BY s.student_id, o.order_id;
```

**Query B — Display only students who never ordered**

```sql
SELECT
    s.student_name,
    s.program
FROM students AS s
LEFT JOIN orders AS o
    ON s.student_id = o.student_id
WHERE o.order_id IS NULL
ORDER BY s.student_id;
```

**Evidence:**

- `week9_queries.sql` — Contains both LEFT JOIN queries.
- `week9_output.txt` — Contains the actual MySQL query outputs.

**Verified results:**

Query A returned 5 rows:

| Student | Program | Order ID | Order Date |
|---|---|---:|---|
| Ana Cruz | BSIT | 101 | 2026-08-10 |
| Ana Cruz | BSIT | 102 | 2026-08-15 |
| Ben Lim | BSCS | NULL | NULL |
| Cara Yu | BSIS | NULL | NULL |
| Dan Reyes | BSIT | 103 | 2026-08-16 |

Query B returned 2 rows:

| Student | Program |
|---|---|
| Ben Lim | BSCS |
| Cara Yu | BSIS |

**Reflection question: What does NULL mean in the unmatched columns of a LEFT JOIN, and why must you test it with IS NULL instead of equals?**

NULL indicates that no matching record was found in the right-side table. In this example, Ben Lim and Cara Yu have no matching orders. We use IS NULL to check for missing values because NULL represents an unknown or absent value and cannot be compared using the ordinary equality operator (=).

## Task 3 — Four-Table Canteen Report

**Approach / explanation:**

I used three INNER JOIN operations to connect the students, orders, order_items, and menu_items tables. Each JOIN has its own ON condition using the appropriate primary key and foreign key relationship. I also used table aliases to identify the source of each column and calculated the line total by multiplying quantity by price.

**Code / query used:**

```sql
SELECT
    s.student_name,
    s.program,
    o.order_id,
    m.item_name,
    oi.quantity,
    m.price,
    oi.quantity * m.price AS line_total
FROM students AS s
INNER JOIN orders AS o
    ON s.student_id = o.student_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN menu_items AS m
    ON oi.menu_id = m.menu_id
ORDER BY o.order_id, m.item_name;
```

**Evidence:**

- `week9_queries.sql` — Contains the four-table JOIN query.
- `week9_output.txt` — Contains the actual MySQL query output.

**Verified results:**

The query returned 4 rows:

| Student | Program | Order ID | Item | Quantity | Price | Line Total |
|---|---|---:|---|---:|---:|---:|
| Ana Cruz | BSIT | 101 | Iced Tea | 1 | 30.00 | 30.00 |
| Ana Cruz | BSIT | 101 | Siomai Rice | 2 | 65.00 | 130.00 |
| Ana Cruz | BSIT | 102 | Burger Steak | 1 | 89.00 | 89.00 |
| Dan Reyes | BSIT | 103 | Siomai Rice | 1 | 65.00 | 65.00 |

**Reflection question: Why does each JOIN in a multi-table chain need its own ON condition, and what goes wrong when two joins share one?**

Each JOIN needs its own ON condition to specify how the current table connects to the next table through related keys. Without the correct ON condition, SQL may combine unrelated records, produce incorrect results, or generate a Cartesian product with too many rows. Using the correct key relationships ensures that the information from all four tables is properly connected.

## Task 4 — Aliases, Filters, and the Silent Inner Join

**Approach / explanation:**

I compared two LEFT JOIN queries using the August 2026 date condition. In the first query, I placed the date condition in the ON clause to preserve students without matching August orders. In the second query, I placed the same condition in the WHERE clause to observe how it removes unmatched records containing NULL values.

**Code / query used:**

**Query A — August orders while preserving all students**

```sql
SELECT
    s.student_name,
    m.item_name,
    oi.quantity * m.price AS line_total
FROM students AS s
LEFT JOIN orders AS o
    ON s.student_id = o.student_id
    AND o.order_date >= '2026-08-01'
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
LEFT JOIN menu_items AS m
    ON oi.menu_id = m.menu_id
ORDER BY o.order_date DESC, o.order_id DESC, m.item_name;
```

**Query B — LEFT JOIN with the date condition in WHERE**

```sql
SELECT
    s.student_name,
    m.item_name,
    oi.quantity * m.price AS line_total
FROM students AS s
LEFT JOIN orders AS o
    ON s.student_id = o.student_id
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
LEFT JOIN menu_items AS m
    ON oi.menu_id = m.menu_id
WHERE o.order_date >= '2026-08-01'
ORDER BY o.order_date DESC, o.order_id DESC, m.item_name;
```

**Evidence:**

- `week9_queries.sql` — Contains both Task 4 query versions.
- `week9_output.txt` — Contains the actual MySQL outputs for both versions.

**Verified results:**

| Query | Description | Rows returned |
|---|---|---:|
| Query A | Date condition in ON clause | 6 |
| Query B | Date condition in WHERE clause | 4 |
| Difference | Unmatched students removed | 2 |

Query A preserved all students and returned:

| Student | Item | Line Total |
|---|---|---:|
| Dan Reyes | Siomai Rice | 65.00 |
| Ana Cruz | Burger Steak | 89.00 |
| Ana Cruz | Iced Tea | 30.00 |
| Ana Cruz | Siomai Rice | 130.00 |
| Ben Lim | NULL | NULL |
| Cara Yu | NULL | NULL |

Query B returned only the four purchased-item records because Ben Lim and Cara Yu did not have matching orders.

**Fix:** Move the date condition into the ON clause of the LEFT JOIN if students without matching August orders must remain in the report.

**Reflection question: Why does adding WHERE on the right-side table remove the NULL rows a LEFT JOIN just preserved, and where should that rule live instead?**

A WHERE condition on the right-side table removes unmatched rows because their values are NULL and do not satisfy the date condition. This causes the LEFT JOIN to behave like an INNER JOIN for that condition. To preserve unmatched students, the date condition should be placed in the ON clause of the LEFT JOIN instead.

## Task 5 — Reflection

**Approach / explanation:**

I compared the results of INNER JOIN and LEFT JOIN using the canteen database. I also examined how filtering a column from the right-side table using WHERE can remove unmatched records from a LEFT JOIN.

**Code / query used:**

Not applicable. This task requires a written reflection rather than an SQL query.

**Evidence:**

The reflection is included in this `answers.md` file and is based on the actual results from Tasks 1–4.

**Reflection question:**

For a campus report that lists every student, including those who have never bought anything, I would use a LEFT JOIN from students to orders. This keeps all students in the report and displays NULL in the order columns for students with no matching order, as shown in Task 2(a). For a completed-sales report, I would use an INNER JOIN because the report should contain only students with an actual order, as shown in Task 1.

One issue I observed in Task 4 was that a LEFT JOIN did not preserve non-buyers after I placed a condition on the right-side orders table in the WHERE clause. The first version, with the date condition in the ON clause, returned six rows, including Ben Lim and Cara Yu with NULL item details. The second version returned only four rows. The WHERE condition rejected rows where order_date was NULL, so the result behaved like an INNER JOIN for that condition. I fixed the report by moving the August date condition into the orders JOIN's ON clause, allowing students without matching August orders to remain visible.

## Self-Check

- [ ] All tasks committed with individual, meaningful commit messages
- [ ] All files placed inside `week9/`
- [ ] This file completed and renamed `answers.md`
- [ ] Repository link pasted into Moodle (no files uploaded)