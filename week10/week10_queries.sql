
USE infoman1_bookstore;

-- TASK 1: SAFE INSERT

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


-- TASK 2: UPDATE AND DELETE WITHOUT COLLATERAL DAMAGE

-- Calculator: Preview

SELECT *
FROM products
WHERE product_id = 6;

-- Calculator: Execute UPDATE

UPDATE products
SET price = 875.00
WHERE product_id = 6;

-- Calculator: Verify

SELECT *
FROM products
WHERE product_id = 6;


-- Eraser: Preview

SELECT *
FROM products
WHERE product_id = 5;

-- Eraser: Execute DELETE

DELETE FROM products
WHERE product_id = 5;

-- Eraser: Verify

SELECT *
FROM products
WHERE product_id = 5;


-- TASK 3: SELF JOIN AND CROSS JOIN

-- SELF JOIN: Employees and Managers

SELECT
    e.employee_name AS employee_name,
    m.employee_name AS manager_name
FROM employees AS e
LEFT JOIN employees AS m
    ON e.manager_id = m.employee_id
ORDER BY e.employee_id;


-- CROSS JOIN: Every Color and Size Combination

SELECT
    c.color_name,
    s.size_name
FROM colors AS c
CROSS JOIN sizes AS s
ORDER BY c.color_name, s.size_name;

-- CROSS JOIN: Count all combinations

SELECT COUNT(*) AS total_combinations
FROM colors AS c
CROSS JOIN sizes AS s;


-- TASK 4: CONSTRAINTS AND TABLE EVOLUTION

-- Add contact number column

ALTER TABLE products
ADD COLUMN contact_number VARCHAR(20);


-- Check existing records before adding constraints

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


-- NOT NULL constraint

ALTER TABLE products
MODIFY COLUMN product_name VARCHAR(100) NOT NULL;

-- Valid write

INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Constraint Test Product', 'TEST-NN-001', 1.00, 1, 'Active', '09170000001');

SELECT *
FROM products
WHERE sku = 'TEST-NN-001';

-- Invalid write: NULL product name

INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    (NULL, 'TEST-NN-002', 1.00, 1, 'Active', '09170000002');


-- UNIQUE constraint

SELECT
    sku,
    COUNT(*) AS occurrences
FROM products
GROUP BY sku
HAVING COUNT(*) > 1;

ALTER TABLE products
ADD CONSTRAINT uq_products_sku UNIQUE (sku);

-- Valid write

INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Unique Constraint Test', 'TEST-UNQ-001', 5.00, 1, 'Active', '09170000003');

SELECT *
FROM products
WHERE sku = 'TEST-UNQ-001';

-- Invalid write: Duplicate SKU

INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Duplicate SKU Test', 'TEST-UNQ-001', 10.00, 5, 'Active', '09170000004');


-- CHECK constraint

ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price > 0);

-- Valid write

INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Check Constraint Test', 'TEST-CHK-001', 5.00, 1, 'Active', '09170000005');

SELECT *
FROM products
WHERE sku = 'TEST-CHK-001';

-- Invalid write: Zero price

INSERT INTO products
    (product_name, sku, price, stock_quantity, status, contact_number)
VALUES
    ('Invalid Price Test', 'TEST-CHK-002', 0.00, 1, 'Active', '09170000006');

-- Verify rejected write

SELECT *
FROM products
WHERE sku = 'TEST-CHK-002';


-- Clean up temporary test products

SELECT
    product_id,
    product_name,
    sku,
    price
FROM products
WHERE sku IN (
    'TEST-NN-001',
    'TEST-UNQ-001',
    'TEST-CHK-001'
)
ORDER BY product_id;

DELETE FROM products
WHERE product_id IN (8, 9, 11);

SELECT *
FROM products
WHERE product_id IN (8, 9, 11);


-- Verify final table structure

SHOW CREATE TABLE products;
