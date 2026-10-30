# Task 2 — Relational Schema

storage_location(<u>location_code</u>, description)

member(<u>member_id</u>, member_name, phone, join_date)

tool(<u>tool_id</u>, tool_name, category, purchase_date, location_code [FK])

certification(<u>cert_id</u>, cert_name)

borrowing(<u>borrow_id</u>, member_id [FK], tool_id [FK], borrow_date, return_date)

member_certification(<u>member_id</u> [FK], <u>cert_id</u> [FK], completion_date)

tool_requirement(<u>tool_id</u> [FK], <u>cert_id</u> [FK])

Note: In member_certification, member_id and cert_id together form the composite primary key. In tool_requirement, tool_id and cert_id together form the composite primary key. All attributes marked [FK] are foreign keys.