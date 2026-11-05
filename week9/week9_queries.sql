
-- TASK 1: INNER JOIN BASICS

SELECT
    s.student_name,
    s.program,
    o.order_id,
    o.order_date
FROM students AS s
INNER JOIN orders AS o
    ON s.student_id = o.student_id
ORDER BY o.order_id;


-- TASK 2: FINDING MISSING RELATIONSHIPS

-- Task 2(a): Display all students, including those without orders

SELECT
    s.student_name,
    s.program,
    o.order_id,
    o.order_date
FROM students AS s
LEFT JOIN orders AS o
    ON s.student_id = o.student_id
ORDER BY s.student_id, o.order_id;


-- Task 2(b): Display students who never ordered

SELECT
    s.student_name,
    s.program
FROM students AS s
LEFT JOIN orders AS o
    ON s.student_id = o.student_id
WHERE o.order_id IS NULL
ORDER BY s.student_id;


-- TASK 3: FOUR-TABLE CANTEEN REPORT

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


-- TASK 4: ALIASES, FILTERS, AND THE SILENT INNER JOIN

-- Task 4(a): Keep all students using the date condition in ON

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


-- Task 4(b): Put the date condition in WHERE

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
