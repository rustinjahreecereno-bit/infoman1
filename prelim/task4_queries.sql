USE toolshare_prelim;

SELECT tool_name, category
FROM tool
WHERE category = 'Power Tools';

SELECT member_id, member_name, join_date
FROM member
WHERE join_date > '2025-01-01';

SELECT borrow_id, member_id, tool_id, borrow_date, return_date
FROM borrowing
WHERE return_date IS NULL;

SELECT borrow_id, member_id, tool_id, borrow_date, return_date
FROM borrowing
WHERE member_id = 1;

SELECT tool_id, tool_name, purchase_date
FROM tool
WHERE purchase_date < '2024-01-01';