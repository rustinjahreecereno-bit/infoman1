INFOMAN1 — Week 4 Lab Answers

Task 1 — Create the Database

The database infoman1_vetclinic was successfully created using MySQL.

Command used:

CREATE DATABASE infoman1_vetclinic;

The database was verified using:

SHOW DATABASES;

The output confirmed that infoman1_vetclinic exists.

Screenshot: screenshots/task1_show_databases.png

Task 2 — Create the Core Tables

The following core tables were created:

owner

pet

veterinarian

owner

CREATE TABLE owner (
    owner_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

The owner_id column is the primary key. first_name, last_name, and phone_number use appropriate text data types and are required using NOT NULL.

Screenshot: screenshots/task2_describe_owner.png

pet

CREATE TABLE pet (
    pet_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    species VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    owner_id INT NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
);

The pet_id column is the primary key. The owner_id column is a foreign key referencing owner(owner_id).

Screenshot: screenshots/task2_describe_pet.png

veterinarian

CREATE TABLE veterinarian (
    vet_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialization VARCHAR(100) NOT NULL
);

The vet_id column is the primary key.

Screenshot: screenshots/task2_describe_veterinarian.png

Task 3 — Create the Relationship Tables

The relationship tables created were appointment and vaccination_record.

appointment

CREATE TABLE appointment (
    appointment_id INT PRIMARY KEY,
    appointment_date DATE NOT NULL,
    reason_for_visit VARCHAR(255) NOT NULL,
    pet_id INT NOT NULL,
    vet_id INT NOT NULL,
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id),
    FOREIGN KEY (vet_id) REFERENCES veterinarian(vet_id)
);

The appointment_id column is the primary key. The pet_id foreign key references pet(pet_id), and the vet_id foreign key references veterinarian(vet_id).

Screenshot: screenshots/task3_describe_appointment.png

vaccination_record

CREATE TABLE vaccination_record (
    pet_id INT NOT NULL,
    vaccine_name VARCHAR(100) NOT NULL,
    vaccination_date DATE NOT NULL,
    PRIMARY KEY (pet_id, vaccine_name, vaccination_date),
    FOREIGN KEY (pet_id) REFERENCES pet(pet_id)
);

The vaccination_record table uses a composite primary key consisting of pet_id, vaccine_name, and vaccination_date. The pet_id column is also a foreign key referencing pet(pet_id). This implements the weak entity from the Week 3 design.

Screenshot: screenshots/task3_describe_vaccination_record.png

Task 4 — Verify the Schema

The five required tables were verified using SHOW TABLES;:

appointment

owner

pet

vaccination_record

veterinarian

Screenshot: screenshots/task4_show_tables.png

DESCRIBE Verification

The structure of every table was checked using DESCRIBE.

owner — primary key owner_id; all required attributes are present and use the intended data types.

pet — primary key pet_id; owner_id is present as a foreign key to owner(owner_id).

veterinarian — primary key vet_id; all required attributes are present and use the intended data types.

appointment — primary key appointment_id; pet_id and vet_id are present as foreign keys.

vaccination_record — composite primary key (pet_id, vaccine_name, vaccination_date); pet_id is also a foreign key to pet(pet_id).

The actual MySQL structure matches the intended relational schema from Week 3. No mismatches were found during verification.

Screenshots:

screenshots/task4_describe_owner.png

screenshots/task4_describe_pet.png

screenshots/task4_describe_veterinarian.png

screenshots/task4_describe_appointment.png

screenshots/task4_describe_vaccination_record.png

Task 5 — Fix a Deliberate Mistake

Mistake

A test table was deliberately created with a phone number using the inappropriate INT data type:

CREATE TABLE mistake_test (
    phone_number INT
);

The command:

DESCRIBE mistake_test;

showed that phone_number had the type int.

Screenshot: screenshots/task5_mistake.png

Correction

The incorrect data type was changed using:

ALTER TABLE mistake_test
MODIFY phone_number VARCHAR(20);

The table was then verified again using:

DESCRIBE mistake_test;

The output confirmed that phone_number is now varchar(20).

VARCHAR(20) is more appropriate for a phone number because it stores the value as text rather than as a numerical value.

Screenshot: screenshots/task5_correction.png

Schema Validation

Table

Primary Key

Foreign Key(s)

owner

owner_id

None

pet

pet_id

owner_id → owner(owner_id)

veterinarian

vet_id

None

appointment

appointment_id

pet_id → pet(pet_id); vet_id → veterinarian(vet_id)

vaccination_record

pet_id, vaccine_name, vaccination_date

pet_id → pet(pet_id)

The implemented schema contains all five tables required for the veterinary clinic database. Primary keys identify each table's records, while foreign keys enforce the relationships between owners and pets, pets and appointments, veterinarians and appointments, and pets and vaccination records.