# Task 5 — Debug a Cross-Week Mismatch

## 1. Why the Original Query Fails

The original query is:

```sql
SELECT borrow_date, return_date
FROM borrowing
WHERE member_name = 'Maria Santos';
```

This query fails because the `borrowing` table does not contain a `member_name` column. The member's name is stored in the `member` table, while the `borrowing` table stores the member's ID as `member_id`.

## 2. Corrected Queries

First, find Maria Santos's member ID:

```sql
SELECT member_id
FROM member
WHERE member_name = 'Maria Santos';
```

The result is `member_id = 1`.

Next, retrieve her borrowing records:

```sql
SELECT borrow_date, return_date
FROM borrowing
WHERE member_id = 1;
```

The query returns two records:

| borrow_date | return_date |
|---|---|
| 2025-09-01 | 2025-09-10 |
| 2025-09-12 | NULL |

## 3. Week 3–5 Concepts Demonstrated

**Week 3 — Relational Schema:** The borrowing record references a member through the `member_id` foreign key instead of storing the member's name in the borrowing table.

**Week 4 — DDL Implementation:** The `CREATE TABLE borrowing` statement defines `member_id` as a column and foreign key, but does not define `member_name`. Therefore, the original query refers to a column that does not exist in that table.

**Week 5 — SELECT and WHERE:** A `WHERE` condition must refer to a column available in the table being queried. The corrected approach first finds the member ID in the `member` table and then uses that ID to filter rows in the `borrowing` table.

---

# Task 3 — Data Type Justifications

1. **VARCHAR(20) for phone:** Phone numbers are stored as text because they may contain leading zeroes and are not used for arithmetic.

2. **DATE for date fields:** `DATE` is appropriate for join dates, purchase dates, borrowing dates, return dates, and certification completion dates because the specification records calendar dates.

3. **VARCHAR(10) for location_code:** Storage location codes such as A3, B1, and C2 are short text identifiers rather than numeric values.