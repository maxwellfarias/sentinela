# Entity Relationships and Cardinalities

> Understanding the building blocks of database design

## 📚 Table of Contents

1. [What is an Entity?](#what-is-an-entity)
2. [Attributes](#attributes)
3. [Relationships](#relationships)
4. [Cardinalities](#cardinalities)
5. [How to Read Cardinalities](#how-to-read-cardinalities)
6. [Types of Binary Relationships](#types-of-binary-relationships)
7. [Breaking Down Many-to-Many Relationships](#breaking-down-many-to-many-relationships)

---

## What is an Entity?

An **entity** represents a distinct object or concept in the real world that we want to store information about. Entities become tables in our database.

### Characteristics of an Entity

- Has a unique identifier (will become the Primary Key)
- Has attributes that describe it
- Can participate in relationships with other entities

### Examples of Entities

```
┌─────────────────────────────────────────────────────────────────┐
│                     COMMON ENTITIES                              │
├─────────────────────────────────────────────────────────────────┤
│  👤 CUSTOMER      📦 PRODUCT       📋 ORDER       🏢 DEPARTMENT │
│  👨‍💼 EMPLOYEE      📚 BOOK          🎓 STUDENT     📝 COURSE     │
│  🏥 HOSPITAL      👨‍⚕️ DOCTOR        💊 MEDICINE    📅 APPOINTMENT│
└─────────────────────────────────────────────────────────────────┘
```

### Entity Representation

In ER diagrams, entities are represented as rectangles:

```
    ┌──────────────┐       ┌──────────────┐       ┌──────────────┐
    │   CUSTOMER   │       │    ORDER     │       │   PRODUCT    │
    └──────────────┘       └──────────────┘       └──────────────┘
```

---

## Attributes

**Attributes** are the properties or characteristics that describe an entity.

### Types of Attributes

#### 1. Simple (Atomic) Attributes
Cannot be divided further.

```
Customer
├── CustomerID (Simple)
├── Age (Simple)
└── Email (Simple)
```

#### 2. Composite Attributes
Can be divided into smaller sub-parts.

```
Customer
└── Address (Composite)
    ├── Street
    ├── City
    ├── State
    └── ZipCode
```

#### 3. Single-valued Attributes
Hold only one value.

```
Customer
└── DateOfBirth (Single-valued: "1990-05-15")
```

#### 4. Multi-valued Attributes
Can hold multiple values.

```
Customer
└── PhoneNumbers (Multi-valued: ["555-0101", "555-0102"])
```

> ⚠️ **Important**: Multi-valued attributes violate First Normal Form (1NF) and must be handled during normalization!

#### 5. Derived Attributes
Calculated from other attributes.

```
Customer
├── DateOfBirth: "1990-05-15"
└── Age (Derived from DateOfBirth): 35
```

### Attribute Representation in ER Diagrams

```
                    ○ PhoneNumbers      (Multi-valued: double ellipse)
                    │
    ┌───────────────┼───────────────┐
    │           CUSTOMER            │
    └───────────────┼───────────────┘
                    │
    ┌───────┬───────┼───────┬───────┐
    │       │       │       │       │
    ○       ○       ○       ○ - - ○
CustomerID Name    Email    Age    (Derived: dashed)
   (PK)
   
Legend:
○       = Simple attribute
○ - - ○ = Derived attribute
◎       = Multi-valued attribute (double ellipse)
```

---

## Relationships

A **relationship** describes how two or more entities are associated with each other.

### Relationship Components

```
┌──────────────┐                              ┌──────────────┐
│   CUSTOMER   │◄────────── Places ──────────►│    ORDER     │
└──────────────┘                              └──────────────┘
     Entity 1         Relationship                Entity 2
```

### Relationship Representation

Relationships are represented as diamonds in ER diagrams:

```
┌──────────────┐           ◇           ┌──────────────┐
│   CUSTOMER   │─────────<Places>──────│    ORDER     │
└──────────────┘                       └──────────────┘
```

### Degree of Relationships

| Degree | Name | Description |
|--------|------|-------------|
| 1 | Unary | Entity relates to itself |
| 2 | Binary | Two entities involved |
| 3 | Ternary | Three entities involved |
| n | N-ary | Multiple entities involved |

#### Unary Relationship Example (Self-referencing)

```
    ┌──────────────────────────────────────┐
    │                                      │
    ▼                                      │
┌──────────────┐                           │
│   EMPLOYEE   │──────────<Manages>────────┘
└──────────────┘
    
An employee manages other employees
```

#### Binary Relationship Example

```
┌──────────────┐                       ┌──────────────┐
│   CUSTOMER   │─────────<Places>──────│    ORDER     │
└──────────────┘                       └──────────────┘
    
A customer places orders
```

#### Ternary Relationship Example

```
         ┌──────────────┐
         │   SUPPLIER   │
         └──────┬───────┘
                │
                │
                ◇ Supplies
               ╱ ╲
              ╱   ╲
             ╱     ╲
┌───────────┐       ┌───────────┐
│  PROJECT  │       │   PART    │
└───────────┘       └───────────┘

A supplier supplies parts to projects
```

---

## Cardinalities

**Cardinality** defines the numerical relationship between entities - how many instances of one entity can be associated with instances of another entity.

### The Two Components of Cardinality

1. **Minimum Cardinality**: The minimum number of instances (0 or 1)
2. **Maximum Cardinality**: The maximum number of instances (1 or N/Many)

### Cardinality Notation

```
┌────────────────────────────────────────────────────────────────┐
│                    CARDINALITY NOTATION                         │
├────────────────────────────────────────────────────────────────┤
│  (min, max) or simplified: just the max                        │
├────────────────────────────────────────────────────────────────┤
│  (0,1)  = Zero or One      │  Optional, at most one           │
│  (1,1)  = Exactly One      │  Mandatory, exactly one          │
│  (0,N)  = Zero or Many     │  Optional, unlimited             │
│  (1,N)  = One or Many      │  Mandatory, at least one         │
└────────────────────────────────────────────────────────────────┘
```

---

## How to Read Cardinalities

> 🔑 **Key Insight**: The cardinality information on the **"other side"** of the relationship tells you how to interpret it.

### Reading from the "Other Side"

When reading cardinalities, you look at what's written on the **opposite** side of the entity you're describing.

```
┌──────────────┐           ◇           ┌──────────────┐
│   CUSTOMER   │──(1,1)─<Places>─(1,N)─│    ORDER     │
└──────────────┘                       └──────────────┘
        ▲                                     ▲
        │                                     │
        │                                     │
   Read (1,N)                            Read (1,1)
   from Order side                       from Customer side
```

### Interpretation Example

Let's analyze: `Customer (1,1) ──<Places>── (1,N) Order`

#### From Customer's Perspective (reading the Order side: 1,N)

| Cardinality | Interpretation |
|-------------|----------------|
| **Minimum (1)** | One customer places **at least 1** order |
| **Maximum (N)** | One customer can place **many** orders |

#### From Order's Perspective (reading the Customer side: 1,1)

| Cardinality | Interpretation |
|-------------|----------------|
| **Minimum (1)** | One order is placed by **exactly 1** customer |
| **Maximum (1)** | One order is placed by **only 1** customer |

### Complete Reading Pattern

```
┌─────────────────────────────────────────────────────────────────┐
│                    HOW TO READ CARDINALITIES                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│    [CUSTOMER]           <Solicits>              [ORDER]          │
│                                                                  │
│    ════════════════════════════════════════════════════════════ │
│                                                                  │
│    Reading for CUSTOMER:                                         │
│    ─────────────────────                                         │
│    • Minimum cardinality: 1 customer for 1 order                │
│    • Maximum cardinality: 1 customer for MANY orders            │
│                                                                  │
│    Reading for ORDER:                                            │
│    ─────────────────                                             │
│    • Minimum cardinality: 1 order is solicited by 1 customer    │
│    • Maximum cardinality: 1 order is solicited by 1 customer    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Types of Binary Relationships

### 1. One-to-One (1:1)

Each instance of Entity A is associated with **at most one** instance of Entity B, and vice versa.

```
┌──────────────┐                       ┌──────────────┐
│   EMPLOYEE   │──(1,1)─<Has>─(1,1)───│   PARKING    │
│              │         1:1          │    SPOT      │
└──────────────┘                       └──────────────┘

One employee has one parking spot
One parking spot belongs to one employee
```

**SQL Implementation:**

```sql
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE ParkingSpot (
    SpotID INT PRIMARY KEY,
    Location VARCHAR(50),
    EmployeeID INT UNIQUE,  -- UNIQUE ensures 1:1
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
```

### 2. One-to-Many (1:N)

Each instance of Entity A can be associated with **many** instances of Entity B, but each instance of Entity B is associated with **only one** instance of Entity A.

```
┌──────────────┐                       ┌──────────────┐
│  DEPARTMENT  │──(1,1)─<Has>─(1,N)───│   EMPLOYEE   │
│              │         1:N          │              │
└──────────────┘                       └──────────────┘

One department has many employees
One employee belongs to one department
```

**SQL Implementation:**

```sql
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    DepartmentID INT,  -- FK on the "many" side
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);
```

### 3. Many-to-Many (N:M or N:N)

Each instance of Entity A can be associated with **many** instances of Entity B, and vice versa.

```
┌──────────────┐                       ┌──────────────┐
│   STUDENT    │──(0,N)─<Enrolls>─(0,N)│   COURSE     │
│              │         N:M          │              │
└──────────────┘                       └──────────────┘

One student enrolls in many courses
One course has many students
```

> ⚠️ **Important**: Many-to-many relationships **cannot be directly implemented** in relational databases. They must be decomposed using a junction (associative) table.

---

## Breaking Down Many-to-Many Relationships

### The Problem

Relational databases cannot directly represent M:N relationships because:
- A single foreign key column cannot hold multiple values
- Adding multiple FK columns is impractical and violates 1NF

### The Solution: Junction Table (Associative Entity)

Create a new entity (table) that sits between the two entities, converting the M:N relationship into two 1:N relationships.

### Naming Convention

The junction table is usually named by combining the two entity names:
- `Student` + `Course` = `Student_Course` or `Enrollment`
- `Customer` + `Package` = `Customer_Package`
- `Author` + `Book` = `Author_Book`

### Step-by-Step Decomposition

#### Before (M:N Relationship):

```
┌──────────────┐                       ┌──────────────┐
│   STUDENT    │──────────(N:M)────────│   COURSE     │
│──────────────│                       │──────────────│
│ StudentID PK │                       │ CourseID PK  │
│ Name         │                       │ CourseName   │
│ Email        │                       │ Credits      │
└──────────────┘                       └──────────────┘
```

#### After (Two 1:N Relationships):

```
┌──────────────┐       ┌──────────────────┐       ┌──────────────┐
│   STUDENT    │       │    ENROLLMENT    │       │   COURSE     │
│──────────────│       │──────────────────│       │──────────────│
│ StudentID PK │───┐   │ StudentID PK,FK  │   ┌───│ CourseID PK  │
│ Name         │   └──►│ CourseID  PK,FK  │◄──┘   │ CourseName   │
│ Email        │  1:N  │ EnrollmentDate   │  N:1  │ Credits      │
└──────────────┘       │ Grade            │       └──────────────┘
                       └──────────────────┘
                       (Junction/Associative Table)
```

### SQL Implementation:

```sql
-- Parent Tables
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    Credits INT
);

-- Junction Table (Composite Primary Key)
CREATE TABLE Enrollment (
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    Grade DECIMAL(3,2),
    PRIMARY KEY (StudentID, CourseID),  -- Composite PK
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);
```

### Sample Data:

```
STUDENT                         COURSE
┌────────────┬─────────────┐   ┌──────────┬─────────────────┬─────────┐
│ StudentID  │ Name        │   │ CourseID │ CourseName      │ Credits │
├────────────┼─────────────┤   ├──────────┼─────────────────┼─────────┤
│ 1          │ Alice       │   │ 101      │ Database Design │ 3       │
│ 2          │ Bob         │   │ 102      │ Web Development │ 4       │
│ 3          │ Charlie     │   │ 103      │ Data Structures │ 3       │
└────────────┴─────────────┘   └──────────┴─────────────────┴─────────┘

ENROLLMENT (Junction Table)
┌───────────┬──────────┬────────────────┬───────┐
│ StudentID │ CourseID │ EnrollmentDate │ Grade │
├───────────┼──────────┼────────────────┼───────┤
│ 1         │ 101      │ 2024-01-15     │ 3.50  │
│ 1         │ 102      │ 2024-01-15     │ 3.75  │
│ 2         │ 101      │ 2024-01-16     │ 4.00  │
│ 2         │ 103      │ 2024-01-16     │ 3.25  │
│ 3         │ 102      │ 2024-01-17     │ NULL  │
└───────────┴──────────┴────────────────┴───────┘

Reading the data:
• Alice (1) is enrolled in Database Design (101) and Web Development (102)
• Bob (2) is enrolled in Database Design (101) and Data Structures (103)
• Charlie (3) is enrolled in Web Development (102)
```

### Advantages of Junction Tables

1. **Eliminates redundancy**: No repeated data
2. **Allows additional attributes**: EnrollmentDate, Grade, etc.
3. **Maintains referential integrity**: FKs ensure valid relationships
4. **Supports complex queries**: Easy to query relationships

---

## Summary: Quick Reference

```
┌────────────────────────────────────────────────────────────────────┐
│               RELATIONSHIP TYPES QUICK REFERENCE                    │
├─────────────────────┬──────────────────────────────────────────────┤
│ Relationship        │ Implementation                                │
├─────────────────────┼──────────────────────────────────────────────┤
│ One-to-One (1:1)    │ FK with UNIQUE constraint on either side     │
│ One-to-Many (1:N)   │ FK on the "many" side                        │
│ Many-to-Many (N:M)  │ Junction table with composite PK             │
└─────────────────────┴──────────────────────────────────────────────┘
```

---

**Previous:** [← Introduction](./00_introduction.md)

**Next:** [Peter Chen Notation →](./02_peter_chen_notation.md)
