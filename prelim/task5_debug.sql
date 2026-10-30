USE toolshare_prelim;

SELECT member_id
FROM member
WHERE member_name = 'Maria Santos';

SELECT borrow_date, return_date
FROM borrowing
WHERE member_id = 1;