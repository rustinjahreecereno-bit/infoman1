-- Week 5: Performance Task Using SQL 2
-- Database: infoman1_vetclinic

USE infoman1_vetclinic;

-- Task 1A: Select every column and every row from pet
SELECT * FROM pet;

-- Task 1B: Select only name and species
SELECT name, species
FROM pet;

-- Task 2: Filter pets by species
SELECT *
FROM pet
WHERE species = 'Dog';

-- Task 3A: Numeric comparison
SELECT *
FROM pet
WHERE age > 3;

-- Task 3B: Date comparison
SELECT *
FROM appointment
WHERE appointment_date > '2026-09-10';

-- Task 4A: Combined SELECT and WHERE with a string condition
SELECT name, species, age
FROM pet
WHERE species = 'Dog';

-- Task 4B: Combined SELECT and WHERE with a date condition
SELECT appointment_id, appointment_date, reason_for_visit
FROM appointment
WHERE appointment_date > '2026-09-10';

-- Task 4C: Deliberate mismatch
-- Correct query:
SELECT name, species
FROM pet
WHERE species = 'Dog';

-- Deliberate mismatch: changed 'Dog' to lowercase 'dog'
SELECT name, species
FROM pet
WHERE species = 'dog';

-- Actual effect:
-- Both queries returned Buddy and Max.
-- The lowercase value did not cause an error or change the results.
-- This indicates that the text comparison is case-insensitive
-- under the current MySQL collation.