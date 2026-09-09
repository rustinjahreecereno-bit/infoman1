CREATE DATABASE IF NOT EXISTS infoman1_vetclinic;

USE infoman1_vetclinic;

-- Task 2: Core Tables

CREATE TABLE owner (
    owner_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE pet (
    pet_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    species VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    owner_id INT NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

CREATE TABLE veterinarian (
    vet_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

-- Task 3: Relationship Tables

CREATE TABLE appointment (
    appointment_id INT PRIMARY KEY,
    appointment_date DATE NOT NULL,
    reason_for_visit VARCHAR(255) NOT NULL,
    pet_id INT NOT NULL,
    vet_id INT NOT NULL,
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id),
    FOREIGN KEY (vet_id) REFERENCES veterinarian(vet_id)
);

CREATE TABLE vaccination_record (
    pet_id INT NOT NULL,
    vaccine_name VARCHAR(100) NOT NULL,
    vaccination_date DATE NOT NULL,
    PRIMARY KEY (pet_id, vaccine_name, vaccination_date),
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
);

-- Task 4: Verification

SHOW TABLES;

DESCRIBE owner;
DESCRIBE pet;
DESCRIBE veterinarian;
DESCRIBE appointment;
DESCRIBE vaccination_record;