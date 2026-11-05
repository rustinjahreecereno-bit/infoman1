# INFOMAN1 — Week 10 Lab Answers

Name: Cereno, Rustin Jahree F.  
Student ID: 2511082  
GitHub repo: https://github.com/rustinjahreecereno-bit/infoman1  
Date submitted:

## Task 1 — Safe INSERT

**Approach / explanation:**

I used INSERT INTO to add two new products to the products table. I explicitly listed the target columns to make sure each value was assigned to the correct column. After each insertion, I used SELECT with the product SKU to verify that the new product was saved correctly.

**Code / query used:**

```sql
INSERT INTO products
    (product_name, sku, price, stock_quantity, status)
VALUES
    ('Scientific Calculator', 'CALC-SCI-001', 850.00, 20, 'Active');

SELECT *
FROM products
WHERE sku = 'CALC-SCI-001';

INSERT INTO products
    (product_name, sku, price, stock_quantity, status)
VALUES
    ('Compass', 'CMP-001', 120.00, 50, 'Active');

SELECT *
FROM products
WHERE sku = 'CMP-001';
```

**Evidence:**

- `week10_queries.sql` — Contains the product insertion and verification queries.
- `week10_output.txt` — Contains the actual MySQL outputs.

**Verified results:**

| Product ID | Product Name | SKU | Price | Stock Quantity | Status |
|---:|---|---|---:|---:|---|
| 6 | Scientific Calculator | CALC-SCI-001 | 850.00 | 20 | Active |
| 7 | Compass | CMP-001 | 120.00 | 50 | Active |

**Rejected INSERT example:**

After adding the UNIQUE constraint in Task 4, I attempted to insert another product using the existing SKU `TEST-UNQ-001`. MySQL rejected the insertion with:

`ERROR 1062 (23000): Duplicate entry 'TEST-UNQ-001' for key 'uq_products_sku'`

This happened because the SKU was already assigned to another product.

**Reflection question: Why does listing target columns explicitly make an INSERT safer, and what fills in for columns you omit?**

Listing target columns explicitly makes an INSERT safer because it ensures that each value is assigned to the intended column, even if the table structure changes. Columns that are omitted use their declared default values, or their implicit defaults when applicable. In this task, the product_id was automatically generated because it uses AUTO_INCREMENT.

## Task 2 — UPDATE & DELETE Without Collateral Damage

**Approach / explanation:**

I followed the preview, execute, and verify procedure for both the UPDATE and DELETE statements. Before changing the Calculator's price, I checked its record using product_id 6. Before deleting the Eraser, I checked its record using product_id 5. I then executed each statement using the same product identifier and verified the results.

**Code / query used:**

**A. UPDATE the Scientific Calculator**

Preview:

```sql
SELECT *
FROM products
WHERE product_id = 6;
```

Execute:

```sql
UPDATE products
SET price = 875.00
WHERE product_id = 6;
```

Verify:

```sql
SELECT *
FROM products
WHERE product_id = 6;
```

**B. DELETE the Eraser**

Preview:

```sql
SELECT *
FROM products
WHERE product_id = 5;
```

Execute:

```sql
DELETE FROM products
WHERE product_id = 5;
```

Verify:

```sql
SELECT *
FROM products
WHERE product_id = 5;
```

**Evidence:**

- `week10_queries.sql` — Contains the preview, UPDATE, DELETE, and verification queries.
- `week10_output.txt` — Contains the actual MySQL outputs.

**Verified results:**

| Operation | Product | Product ID | Result |
|---|---|---:|---|
| UPDATE | Scientific Calculator | 6 | Price changed from 850.00 to 875.00 |
| DELETE | Eraser | 5 | Record successfully deleted |

The UPDATE affected one row. The DELETE also affected one row. The verification SELECT for the Eraser returned Empty set.

**Reflection question: What would your UPDATE and DELETE have done without their WHERE clauses, and why is a stable identifier safer than a name?**

Without its WHERE clause, the UPDATE would change the price of every product in the table. The DELETE would attempt to remove every product record, although existing foreign-key references from the sales table could prevent the deletion. A stable identifier such as product_id is safer because it uniquely identifies a record. Product names may be duplicated or changed, which can cause the wrong records to be modified or deleted.

## Task 3 — Self Join & Cross Join

**Approach / explanation:**

I used a SELF JOIN to connect employees with their respective managers using the employees table twice with different aliases. I used LEFT JOIN so that employees without a manager would still appear in the results. I also used CROSS JOIN to combine every available color with every available size.

**Code / query used:**

**A. SELF JOIN — Employees and Managers**

```sql
SELECT
    e.employee_name AS employee_name,
    m.employee_name AS manager_name
FROM employees AS e
LEFT JOIN employees AS m
    ON e.manager_id = m.employee_id
ORDER BY e.employee_id;
```

**B. CROSS JOIN — Every Color and Size Combination**

```sql
SELECT
    c.color_name,
    s.size_name
FROM colors AS c
CROSS JOIN sizes AS s
ORDER BY c.color_name, s.size_name;
```

**Evidence:**

- `week10_queries.sql` — Contains the SELF JOIN and CROSS JOIN queries.
- `week10_output.txt` — Contains the actual MySQL query outputs.

**Verified results — SELF JOIN:**

| Employee Name | Manager Name |
|---|---|
| Lea Ramos | NULL |
| Carlo Reyes | Lea Ramos |
| Dana Cruz | Lea Ramos |

The SELF JOIN returned 3 rows. LEFT JOIN keeps Lea Ramos because she has no manager_id, and the unmatched manager_name is displayed as NULL.

**Verified results — CROSS JOIN:**

| Color | Size |
|---|---|
| Blue | L |
| Blue | M |
| Blue | S |
| Green | L |
| Green | M |
| Green | S |
| Red | L |
| Red | M |
| Red | S |

The CROSS JOIN returned 9 rows.

There are 3 colors and 3 sizes, producing 3 × 3 = 9 possible combinations.

**Business use:** A bookstore can use CROSS JOIN to generate all possible product variants, such as notebooks available in different colors and sizes. It must be intentional because an accidental missing ON condition in a regular JOIN can produce an unwanted Cartesian product and multiply the number of records.

**Reflection question: Why does the self join need two aliases and a LEFT JOIN, and when is a CROSS JOIN the deliberate choice rather than a missing ON?**

A SELF JOIN needs two aliases because the same table represents two different roles: the employee and the manager. LEFT JOIN keeps employees who have no matching manager, such as Lea Ramos. A CROSS JOIN is deliberate when every possible combination is needed, such as generating all color and size variants. It should not be used accidentally because it can produce unrelated combinations and excessive rows.

## Task 4 — Constraints & Table Evolution

**Approach / explanation:**

I used ALTER TABLE to add a contact_number column and enforce three data integrity rules on the products table. Before adding the constraints, I checked the existing records for NULL product names, missing SKUs, missing prices, and non-positive prices. I tested each constraint using one valid insertion and one invalid insertion to confirm that MySQL accepted valid records and rejected invalid ones.

**Code / query used:**

**A. Add the contact_number column**

```sql
ALTER TABLE products
ADD COLUMN contact_number VARCHAR(20);
```

**B. Check existing records before adding constraints**

```sql
SELECT
    product_id,
    product_name,
    sku,
    price
FROM products
WHERE product_name IS NULL
   OR sku IS NULL
   OR price IS NULL
   OR price <= 0;
```

The query returned Empty set, confirming that no existing records violated the planned rules.

**C. Add the NOT NULL constraint**

```sql
ALTER TABLE products
MODIFY COLUMN product_name VARCHAR(100) NOT NULL;
```

Valid INSERT:

```sql
INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Constraint Test Product', 'TEST-NN-001', 1.00, 1, 'Active', '09170000001');

SELECT *
FROM products
WHERE sku = 'TEST-NN-001';
```

The valid insertion was accepted and returned one record.

Invalid INSERT:

```sql
INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    (NULL, 'TEST-NN-002', 1.00, 1, 'Active', '09170000002');
```

Actual MySQL error:

`ERROR 1048 (23000): Column 'product_name' cannot be null`

**D. Add the UNIQUE constraint**

First, check for existing duplicate SKUs:

```sql
SELECT
    sku,
    COUNT(*) AS occurrences
FROM products
GROUP BY sku
HAVING COUNT(*) > 1;
```

The query returned Empty set.

Add the constraint:

```sql
ALTER TABLE products
ADD CONSTRAINT uq_products_sku UNIQUE (sku);
```

Valid INSERT:

```sql
INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Unique Constraint Test', 'TEST-UNQ-001', 5.00, 1, 'Active', '09170000003');

SELECT *
FROM products
WHERE sku = 'TEST-UNQ-001';
```

The valid insertion was accepted and returned one record.

Invalid INSERT:

```sql
INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Duplicate SKU Test', 'TEST-UNQ-001', 10.00, 5, 'Active', '09170000004');
```

Actual MySQL error:

`ERROR 1062 (23000): Duplicate entry 'TEST-UNQ-001' for key 'uq_products_sku'`

**E. Add the CHECK constraint**

```sql
ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price > 0);
```

Valid INSERT:

```sql
INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Check Constraint Test', 'TEST-CHK-001', 5.00, 1, 'Active', '09170000005');

SELECT *
FROM products
WHERE sku = 'TEST-CHK-001';
```

The valid insertion was accepted and returned one record.

Invalid INSERT:

```sql
INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Invalid Price Test', 'TEST-CHK-002', 0.00, 1, 'Active', '09170000006');
```

Actual MySQL error:

`ERROR 3819 (HY000): Check constraint 'chk_products_price' is violated.`

Verification of the rejected product:

```sql
SELECT *
FROM products
WHERE sku = 'TEST-CHK-002';
```

The query returned Empty set.

**F. Clean up temporary test products**

```sql
DELETE FROM products
WHERE product_id IN (8, 9, 11);

SELECT *
FROM products
WHERE product_id IN (8, 9, 11);
```

The DELETE affected 3 rows, and the verification query returned Empty set.

**G. Verify the final table definition**

```sql
SHOW CREATE TABLE products;
```

**Evidence:**

- `week10_queries.sql` — Contains the ALTER TABLE statements, valid and rejected INSERT tests, preview queries, and cleanup statements.
- `week10_output.txt` — Contains the actual MySQL query outputs, errors, and verification results.
- `SHOW CREATE TABLE products` — Confirms that the three constraints and the contact_number column are present.

**Verified database rules:**

| Requirement | Actual database definition | Result |
|---|---|---|
| Product name must not be NULL | `product_name VARCHAR(100) NOT NULL` | Verified |
| SKU must be unique | `UNIQUE KEY uq_products_sku (sku)` | Verified |
| Price must be positive | `CHECK (price > 0)` | Verified |
| Contact number column | `contact_number VARCHAR(20)` | Verified |

**MySQL syntax caveat:**

MySQL versions earlier than 8.0.16 accepted CHECK syntax but did not enforce the constraint. MySQL 8.0.16 and later enforce CHECK constraints by default unless `NOT ENFORCED` is specified. Our server reported version 26.7.0, and the zero-price insertion was rejected with ERROR 3819, confirming that the CHECK constraint was enforced.

The `CHECK (price > 0)` rule rejects zero and negative prices. It does not independently prohibit NULL prices because the price column remains nullable.

**Reflection question: Why do constraints block future bad writes without repairing old bad rows, and what must you do before adding NOT NULL?**

Constraints enforce rules on the data when they are added and prevent future writes that violate those rules. They do not automatically repair existing records. Before adding NOT NULL, existing rows must be checked for NULL values and corrected or removed if necessary. In this task, I used SELECT to check the existing records before applying the constraint.

## Task 5 — Reflection

**Approach / explanation:**

I compared application-level validation with database-level constraints using the product rules tested in Task 4. I also used the rejected duplicate-SKU insertion as an example of how database constraints prevent invalid records.

**Code / query used:**

Not applicable. This task requires a written reflection rather than an SQL query.

**Evidence:**

The reflection is included in this `answers.md` file. The supporting MySQL results from Task 4 demonstrate the valid and rejected product insertions.

**Reflection question:**

For a campus bookstore, I would use application-level checks to give the cashier immediate feedback, such as warning that a product name is required or a price must be positive. I would still rely on database constraints as the final protection because records can also be added through SQL scripts, imports, or another application. In Task 4, the NOT NULL, UNIQUE, and CHECK (price > 0) rules protect the products table even if a form does not validate every field.

A mistake I reproduced during testing was trying to insert a second product with the existing SKU TEST-UNQ-001. MySQL rejected the write with ERROR 1062, identifying the duplicate key, and the attempted record was not saved. The correction is to use an unused SKU for the new product. Keeping the UNIQUE constraint in the database also protects the table if another application or direct SQL statement tries to save the duplicate. Application checks improve usability by warning users early, while database constraints enforce data integrity for every write path.

## Self-Check

- [ ] All tasks committed with individual, meaningful commit messages
- [ ] All files placed inside `week10/`
- [ ] This file completed and renamed `answers.md`
- [ ] Repository link pasted into Moodle 