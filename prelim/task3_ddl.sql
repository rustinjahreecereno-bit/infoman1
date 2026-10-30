CREATE DATABASE IF NOT EXISTS toolshare_prelim;
USE toolshare_prelim;

CREATE TABLE storage_location (
    location_code VARCHAR(10) PRIMARY KEY,
    description VARCHAR(100) NOT NULL
);

CREATE TABLE member (
    member_id INT PRIMARY KEY,
    member_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    join_date DATE NOT NULL
);

CREATE TABLE certification (
    cert_id INT PRIMARY KEY,
    cert_name VARCHAR(100) NOT NULL
);

CREATE TABLE tool (
    tool_id INT PRIMARY KEY,
    tool_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    purchase_date DATE NOT NULL,
    location_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (location_code)
        REFERENCES storage_location(location_code)
);

CREATE TABLE borrowing (
    borrow_id INT PRIMARY KEY,
    member_id INT NOT NULL,
    tool_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE NULL,
    FOREIGN KEY (member_id)
        REFERENCES member(member_id),
    FOREIGN KEY (tool_id)
        REFERENCES tool(tool_id)
);

CREATE TABLE member_certification (
    member_id INT NOT NULL,
    cert_id INT NOT NULL,
    completion_date DATE NOT NULL,
    PRIMARY KEY (member_id, cert_id),
    FOREIGN KEY (member_id)
        REFERENCES member(member_id),
    FOREIGN KEY (cert_id)
        REFERENCES certification(cert_id)
);

CREATE TABLE tool_requirement (
    tool_id INT NOT NULL,
    cert_id INT NOT NULL,
    PRIMARY KEY (tool_id, cert_id),
    FOREIGN KEY (tool_id)
        REFERENCES tool(tool_id),
    FOREIGN KEY (cert_id)
        REFERENCES certification(cert_id)
);