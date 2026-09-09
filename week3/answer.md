# INFOMAN1 — Week 3 Lab Answers

## Task 1 — Classify Attributes and Identify Weak Entities

### Attribute Classification

| Entity             | Attribute          | Classification | Reason                                                                     |
| ------------------ | ------------------ | -------------- | -------------------------------------------------------------------------- |
| Owner              | `owner_id`         | Simple         | Unique identifier for an owner.                                            |
| Owner              | `full_name`        | Composite      | Consists of `first_name` and `last_name`.                                  |
| Owner              | `phone_number`     | Simple         | A single phone number attribute.                                           |
| Pet                | `pet_id`           | Simple         | Unique identifier for a pet.                                               |
| Pet                | `name`             | Simple         | Stores the pet's name.                                                     |
| Pet                | `species`          | Simple         | Stores the pet's species.                                                  |
| Pet                | `age`              | Simple         | Given directly in the scenario; no birth date is provided for deriving it. |
| Veterinarian       | `vet_id`           | Simple         | Unique identifier for a veterinarian.                                      |
| Veterinarian       | `full_name`        | Composite      | Consists of `first_name` and `last_name`.                                  |
| Veterinarian       | `specialization`   | Simple         | Stores the veterinarian's specialization.                                  |
| Appointment        | `appointment_id`   | Simple         | Unique identifier for an appointment.                                      |
| Appointment        | `appointment_date` | Simple         | Stores the appointment date.                                               |
| Appointment        | `reason_for_visit` | Simple         | Stores the reason for the visit.                                           |
| Vaccination Record | `vaccine_name`     | Simple         | Identifies the vaccine used as part of the vaccination record.             |
| Vaccination Record | `vaccination_date` | Simple         | Stores the vaccination date.                                               |

### Multivalued Attribute

Vaccination history is **multivalued with respect to Pet** because one pet can have zero, one, or several vaccination records.

Instead of storing multiple vaccination values in the Pet table, the vaccination history is represented using a separate `Vaccination_Record` entity.

### Derived Attribute

No derived attribute is explicitly stated in the scenario.

Although `age` could normally be calculated from a date of birth, the scenario does not provide `birth_date`. Therefore, `age` is treated as a regular attribute rather than a derived attribute.

### Weak Entity

`Vaccination_Record` is a **weak entity**.

A weak entity cannot be uniquely identified by its own attributes and depends on an owner entity for identification.

The scenario states that a vaccination record:

* only makes sense in relation to the specific pet it belongs to; and
* cannot be uniquely identified or looked up on its own.

Therefore, `Vaccination_Record` depends on `Pet`.

Its identifying key is:

**`(pet_id, vaccine_name, vaccination_date)`**

Here, `pet_id` comes from the parent `Pet` entity, while `vaccine_name` and `vaccination_date` form the partial key.

---

## Task 2 — Specify Cardinality & Participation

Crow's Foot notation uses the outer symbol for **cardinality** and the inner symbol for **participation**.

| Relationship             | Entity             | Cardinality | Participation | Meaning                                                              |
| ------------------------ | ------------------ | ----------- | ------------- | -------------------------------------------------------------------- |
| Owner–Pet                | Owner              | 0..many     | Optional      | An owner may have no pets or multiple pets.                          |
| Owner–Pet                | Pet                | Exactly 1   | Mandatory     | Every pet must belong to exactly one owner.                          |
| Pet–Appointment          | Pet                | 0..many     | Optional      | A pet may have no appointments or multiple appointments.             |
| Pet–Appointment          | Appointment        | Exactly 1   | Mandatory     | Every appointment must specify exactly one pet.                      |
| Veterinarian–Appointment | Veterinarian       | 0..many     | Optional      | A veterinarian may conduct no appointments or multiple appointments. |
| Veterinarian–Appointment | Appointment        | Exactly 1   | Mandatory     | Every appointment must specify exactly one veterinarian.             |
| Pet–Vaccination Record   | Pet                | 0..many     | Optional      | A pet may have zero, one, or several vaccination records.            |
| Pet–Vaccination Record   | Vaccination Record | Exactly 1   | Mandatory     | Every vaccination record belongs to exactly one pet.                 |

### Crow's Foot Relationships

```text
Owner              Pet
  ||---------------o{
  1                0..many


Pet                Appointment
  ||---------------o{
  1                0..many


Veterinarian       Appointment
  ||---------------o{
  1                0..many


Pet                Vaccination_Record
  ||---------------o{
  1                0..many
```

### Business Rule Evidence

**Owner–Pet**

> A pet owner is not required to have any pets on file, but every pet must belong to exactly one owner.

Therefore:

* Owner = optional, many (`0..many`)
* Pet = mandatory, one (`1`)

**Pet–Appointment**

> An appointment must specify exactly one veterinarian and exactly one pet.

Therefore:

* Pet = optional, many (`0..many`)
* Appointment = mandatory, one (`1`)

**Veterinarian–Appointment**

> A veterinarian can conduct multiple appointments over time or none at all.

Therefore:

* Veterinarian = optional, many (`0..many`)
* Appointment = mandatory, one (`1`)

**Pet–Vaccination Record**

> A pet may have zero, one, or several vaccination records.

Therefore:

* Pet = optional, many (`0..many`)
* Vaccination Record = mandatory, one (`1`)

---

## Task 3 — Build the Logical ERD

The logical ERD contains five entities:

### Owner

* **PK:** `owner_id`
* `first_name`
* `last_name`
* `phone_number`

### Pet

* **PK:** `pet_id`
* `name`
* `species`
* `age`
* **FK:** `owner_id`

### Veterinarian

* **PK:** `vet_id`
* `first_name`
* `last_name`
* `specialization`

### Appointment

* **PK:** `appointment_id`
* `appointment_date`
* `reason_for_visit`
* **FK:** `pet_id`
* **FK:** `vet_id`

### Vaccination_Record

* **PK:** `pet_id`
* **PK / Partial Key:** `vaccine_name`
* **PK / Partial Key:** `vaccination_date`
* **FK:** `pet_id`

### Relationships

```text
Owner
  1
  |
  | 0..many
  |
 Pet
 / \
/   \
0..many  0..many
/         \
Appointment  Vaccination_Record
    |
    |
    |
Veterinarian
```

There is **no M:N relationship explicitly stated in the case study**, so no junction entity is necessary.

The following transformations were made:

1. Composite `full_name` → `first_name` + `last_name`
2. Multivalued vaccination history → `Vaccination_Record`
3. Weak `Vaccination_Record` → identified using `pet_id` + partial key
4. No M:N relationship → no junction table required

**Diagram file:** `erd_diagram.png`

---

## Task 4 — Translate to Relational Schema Notation

### Owner

**Owner**(`__owner_id__`, first_name, last_name, phone_number)

* PK: `owner_id`

### Pet

**Pet**(`__pet_id__`, name, species, age, owner_id*)

* PK: `pet_id`
* FK: `owner_id`
* `owner_id` references `Owner(owner_id)`

### Veterinarian

**Veterinarian**(`__vet_id__`, first_name, last_name, specialization)

* PK: `vet_id`

### Appointment

**Appointment**(`__appointment_id__`, appointment_date, reason_for_visit, pet_id*, vet_id*)

* PK: `appointment_id`
* FK: `pet_id`
* FK: `vet_id`
* `pet_id` references `Pet(pet_id)`
* `vet_id` references `Veterinarian(vet_id)`

### Vaccination_Record

**Vaccination_Record**(`__pet_id__`, `__vaccine_name__`, `__vaccination_date__`)

* Composite PK: (`pet_id`, `vaccine_name`, `vaccination_date`)
* FK: `pet_id`
* `pet_id` references `Pet(pet_id)`

### Complete Schema

```text
Owner(__owner_id__, first_name, last_name, phone_number)

Pet(__pet_id__, name, species, age, owner_id*)
    owner_id* references Owner(owner_id)

Veterinarian(__vet_id__, first_name, last_name, specialization)

Appointment(__appointment_id__, appointment_date, reason_for_visit, pet_id*, vet_id*)
    pet_id* references Pet(pet_id)
    vet_id* references Veterinarian(vet_id)

Vaccination_Record(__pet_id__, __vaccine_name__, __vaccination_date__)
    pet_id* references Pet(pet_id)
```

---

## Task 5 — Key Justification & Schema Validation

### Key Justification

#### Owner — `owner_id`

`owner_id` is used as the primary key.

This is treated as a **surrogate key** because it is an identifier specifically provided for identifying an owner. A person's name is not appropriate as a primary key because different owners can have the same name. A phone number may also change.

Therefore:

```text
Owner(__owner_id__, first_name, last_name, phone_number)
```

provides a stable identifier for each owner.

#### Appointment — `appointment_id`

`appointment_id` is used as the primary key for Appointment.

It is a **surrogate key** because the scenario specifically identifies appointments using an appointment ID.

The appointment date, pet, veterinarian, and reason should not be combined to identify an appointment because the same pet and veterinarian could have multiple appointments.

Therefore:

```text
Appointment(__appointment_id__, appointment_date, reason_for_visit, pet_id*, vet_id*)
```

uses `appointment_id` as its primary key.

#### Vaccination_Record — Composite Key

`Vaccination_Record` uses:

```text
(pet_id, vaccine_name, vaccination_date)
```

as its composite primary key.

This is appropriate because the vaccination record is a weak entity. It cannot be uniquely identified independently of its parent Pet.

`pet_id` identifies the parent pet, while `vaccine_name` and `vaccination_date` provide the partial identification of the vaccination record.

---

### Schema Validation

#### Owner Requirements

The scenario states that an owner has:

* owner ID
* full name
* phone number

Represented by:

```text
Owner(owner_id, first_name, last_name, phone_number)
```

The composite `full_name` is resolved into `first_name` and `last_name`.

#### Owner–Pet Requirement

The scenario states:

> A pet owner is not required to have any pets on file.

Therefore, Owner has optional participation in the Owner–Pet relationship.

#### Pet Ownership Requirement

The scenario states:

> Every pet must belong to exactly one owner.

Therefore, Pet contains `owner_id` as a foreign key referencing Owner.

#### Pet Requirements

The scenario states that a pet has:

* pet ID
* name
* species
* age

Represented by:

```text
Pet(pet_id, name, species, age, owner_id)
```

#### Appointment Requirements

The scenario states that an appointment has:

* appointment ID
* appointment date
* reason for visit

Represented by:

```text
Appointment(appointment_id, appointment_date, reason_for_visit, pet_id, vet_id)
```

#### Appointment–Veterinarian Requirement

The scenario states:

> An appointment must specify exactly one veterinarian.

Therefore, `vet_id` is included in Appointment as a foreign key.

#### Appointment–Pet Requirement

The scenario states:

> An appointment must specify exactly one pet.

Therefore, `pet_id` is included in Appointment as a foreign key.

#### Veterinarian Requirement

The scenario states:

> A veterinarian can conduct multiple appointments over time or none at all.

Therefore, the Veterinarian side of the relationship is optional and can have many appointments.

#### Vaccination Requirement

The scenario states:

> A pet may have zero, one, or several vaccination records.

Therefore, Pet has an optional one-to-many relationship with Vaccination_Record.

#### Weak Entity Requirement

The scenario states:

> Each vaccination record only makes sense in relation to the specific pet it belongs to.

and:

> It cannot be uniquely identified or looked up on its own.

Therefore, Vaccination_Record is modeled as a weak entity dependent on Pet.

Its identifying key is:

```text
(pet_id, vaccine_name, vaccination_date)
```

---

## Self-Check

* [ ] All tasks committed with individual, meaningful commit messages
* [x] All files placed inside `week3/`
* [x] This file completed `answers.md`
* [ ] `erd_diagram.png` exported from draw.io
* [ ] Repository link pasted into Moodle
