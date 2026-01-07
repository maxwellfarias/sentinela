# Database Anomalies and Best Practices

> Understanding problems in poorly designed databases and how to avoid them

## 📚 Table of Contents

1. [What are Database Anomalies?](#what-are-database-anomalies)
2. [Insert Anomalies](#insert-anomalies)
3. [Update Anomalies](#update-anomalies)
4. [Delete Anomalies](#delete-anomalies)
5. [How Normalization Prevents Anomalies](#how-normalization-prevents-anomalies)
6. [Database Design Best Practices](#database-design-best-practices)
7. [Naming Conventions](#naming-conventions)
8. [Common Mistakes to Avoid](#common-mistakes-to-avoid)

---

## What are Database Anomalies?

**Database anomalies** are problems that occur in poorly designed databases where data becomes inconsistent, redundant, or lost during normal operations (INSERT, UPDATE, DELETE).

```
┌─────────────────────────────────────────────────────────────────────┐
│                    THE THREE TYPES OF ANOMALIES                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. INSERT ANOMALY                                                   │
│     Cannot add data without other unrelated data                    │
│                                                                      │
│  2. UPDATE ANOMALY                                                   │
│     Changing data in one place leaves other copies inconsistent     │
│                                                                      │
│  3. DELETE ANOMALY                                                   │
│     Deleting data unintentionally removes other information         │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ROOT CAUSE: Data redundancy from poor normalization                │
│  SOLUTION: Proper normalization (1NF → 2NF → 3NF → BCNF)           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Insert Anomalies

An **insert anomaly** occurs when you cannot add certain data to the database without also adding other unrelated data.

### Example: The Problem

```
┌─────────────────────────────────────────────────────────────────────┐
│                    INSERT ANOMALY EXAMPLE                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  EMPLOYEE Table (poorly designed):                                   │
│  ┌─────────┬──────────┬──────────┬────────────┬──────────────┐      │
│  │ EmpID   │ EmpName  │ DeptID   │ DeptName   │ DeptBudget   │      │
│  │ (PK)    │          │          │            │              │      │
│  ├─────────┼──────────┼──────────┼────────────┼──────────────┤      │
│  │ E001    │ Alice    │ D01      │ Engineering│ 500,000      │      │
│  │ E002    │ Bob      │ D01      │ Engineering│ 500,000      │      │
│  │ E003    │ Charlie  │ D02      │ Marketing  │ 300,000      │      │
│  └─────────┴──────────┴──────────┴────────────┴──────────────┘      │
│                                                                      │
│  PROBLEM: We want to add a NEW department "Research" (D03)          │
│  with budget 400,000, but we have NO employees for it yet.          │
│                                                                      │
│  ATTEMPTED INSERT:                                                   │
│  ┌─────────┬──────────┬──────────┬────────────┬──────────────┐      │
│  │ ???     │ ???      │ D03      │ Research   │ 400,000      │      │
│  └─────────┴──────────┴──────────┴────────────┴──────────────┘      │
│                                                                      │
│  ✗ CANNOT INSERT! EmpID is the primary key - cannot be NULL         │
│  ✗ We're FORCED to wait until we hire someone for Research          │
│                                                                      │
│  This is an INSERT ANOMALY!                                          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Solution: Separate Tables

```
┌─────────────────────────────────────────────────────────────────────┐
│                    INSERT ANOMALY SOLUTION                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  DEPARTMENT Table:                                                   │
│  ┌──────────┬────────────┬──────────────┐                           │
│  │ DeptID   │ DeptName   │ DeptBudget   │                           │
│  │ (PK)     │            │              │                           │
│  ├──────────┼────────────┼──────────────┤                           │
│  │ D01      │ Engineering│ 500,000      │                           │
│  │ D02      │ Marketing  │ 300,000      │                           │
│  │ D03      │ Research   │ 400,000      │  ← CAN ADD NOW!           │
│  └──────────┴────────────┴──────────────┘                           │
│                                                                      │
│  EMPLOYEE Table:                                                     │
│  ┌─────────┬──────────┬──────────┐                                  │
│  │ EmpID   │ EmpName  │ DeptID   │                                  │
│  │ (PK)    │          │ (FK)     │                                  │
│  ├─────────┼──────────┼──────────┤                                  │
│  │ E001    │ Alice    │ D01      │                                  │
│  │ E002    │ Bob      │ D01      │                                  │
│  │ E003    │ Charlie  │ D02      │                                  │
│  └─────────┴──────────┴──────────┘                                  │
│                                                                      │
│  ✓ Department data is independent of employee data                  │
│  ✓ Can add departments without employees                            │
│  ✓ Can add employees and assign to existing departments             │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Update Anomalies

An **update anomaly** occurs when changing data in one place doesn't update all copies of that data, leading to inconsistency.

### Example: The Problem

```
┌─────────────────────────────────────────────────────────────────────┐
│                    UPDATE ANOMALY EXAMPLE                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  EMPLOYEE Table (poorly designed):                                   │
│  ┌─────────┬──────────┬──────────┬────────────┬──────────────┐      │
│  │ EmpID   │ EmpName  │ DeptID   │ DeptName   │ DeptBudget   │      │
│  │ (PK)    │          │          │            │              │      │
│  ├─────────┼──────────┼──────────┼────────────┼──────────────┤      │
│  │ E001    │ Alice    │ D01      │ Engineering│ 500,000      │      │
│  │ E002    │ Bob      │ D01      │ Engineering│ 500,000      │      │
│  │ E003    │ Charlie  │ D01      │ Engineering│ 500,000      │      │
│  │ E004    │ Diana    │ D02      │ Marketing  │ 300,000      │      │
│  └─────────┴──────────┴──────────┴────────────┴──────────────┘      │
│                                                                      │
│  SCENARIO: Engineering budget increases to 600,000                   │
│                                                                      │
│  We need to UPDATE 3 ROWS!                                           │
│                                                                      │
│  WHAT IF we only update ONE row?                                     │
│  ┌─────────┬──────────┬──────────┬────────────┬──────────────┐      │
│  │ E001    │ Alice    │ D01      │ Engineering│ 600,000      │ ←UPDATED
│  │ E002    │ Bob      │ D01      │ Engineering│ 500,000      │ ←MISSED!
│  │ E003    │ Charlie  │ D01      │ Engineering│ 500,000      │ ←MISSED!
│  │ E004    │ Diana    │ D02      │ Marketing  │ 300,000      │      │
│  └─────────┴──────────┴──────────┴────────────┴──────────────┘      │
│                                                                      │
│  ✗ DATA INCONSISTENCY!                                              │
│  ✗ What is the Engineering budget? 600,000 or 500,000?              │
│                                                                      │
│  This is an UPDATE ANOMALY!                                          │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Solution: Single Source of Truth

```
┌─────────────────────────────────────────────────────────────────────┐
│                    UPDATE ANOMALY SOLUTION                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  DEPARTMENT Table:                                                   │
│  ┌──────────┬────────────┬──────────────┐                           │
│  │ DeptID   │ DeptName   │ DeptBudget   │                           │
│  │ (PK)     │            │              │                           │
│  ├──────────┼────────────┼──────────────┤                           │
│  │ D01      │ Engineering│ 600,000      │  ← UPDATE ONCE!           │
│  │ D02      │ Marketing  │ 300,000      │                           │
│  └──────────┴────────────┴──────────────┘                           │
│                                                                      │
│  EMPLOYEE Table:                                                     │
│  ┌─────────┬──────────┬──────────┐                                  │
│  │ EmpID   │ EmpName  │ DeptID   │                                  │
│  │ (PK)    │          │ (FK)     │                                  │
│  ├─────────┼──────────┼──────────┤                                  │
│  │ E001    │ Alice    │ D01      │                                  │
│  │ E002    │ Bob      │ D01      │                                  │
│  │ E003    │ Charlie  │ D01      │                                  │
│  │ E004    │ Diana    │ D02      │                                  │
│  └─────────┴──────────┴──────────┘                                  │
│                                                                      │
│  ✓ Budget stored in ONE place only                                  │
│  ✓ Single update changes data for everyone                          │
│  ✓ No risk of inconsistency                                         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Delete Anomalies

A **delete anomaly** occurs when deleting data unintentionally removes other important information.

### Example: The Problem

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DELETE ANOMALY EXAMPLE                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  EMPLOYEE Table (poorly designed):                                   │
│  ┌─────────┬──────────┬──────────┬────────────┬──────────────┐      │
│  │ EmpID   │ EmpName  │ DeptID   │ DeptName   │ DeptBudget   │      │
│  │ (PK)    │          │          │            │              │      │
│  ├─────────┼──────────┼──────────┼────────────┼──────────────┤      │
│  │ E001    │ Alice    │ D01      │ Engineering│ 500,000      │      │
│  │ E002    │ Bob      │ D01      │ Engineering│ 500,000      │      │
│  │ E003    │ Charlie  │ D02      │ Marketing  │ 300,000      │ ←ONLY ONE
│  └─────────┴──────────┴──────────┴────────────┴──────────────┘      │
│                                                                      │
│  SCENARIO: Charlie (E003) leaves the company                         │
│  We delete his record...                                             │
│                                                                      │
│  AFTER DELETE:                                                       │
│  ┌─────────┬──────────┬──────────┬────────────┬──────────────┐      │
│  │ E001    │ Alice    │ D01      │ Engineering│ 500,000      │      │
│  │ E002    │ Bob      │ D01      │ Engineering│ 500,000      │      │
│  └─────────┴──────────┴──────────┴────────────┴──────────────┘      │
│                                                                      │
│  ✗ We LOST ALL information about Marketing department!              │
│  ✗ DeptID D02, DeptName "Marketing", Budget 300,000 - ALL GONE!     │
│  ✗ We didn't want to delete the department, just the employee!      │
│                                                                      │
│  This is a DELETE ANOMALY!                                           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Solution: Separate Entity Storage

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DELETE ANOMALY SOLUTION                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  DEPARTMENT Table:                                                   │
│  ┌──────────┬────────────┬──────────────┐                           │
│  │ DeptID   │ DeptName   │ DeptBudget   │                           │
│  │ (PK)     │            │              │                           │
│  ├──────────┼────────────┼──────────────┤                           │
│  │ D01      │ Engineering│ 500,000      │                           │
│  │ D02      │ Marketing  │ 300,000      │  ← PRESERVED!             │
│  └──────────┴────────────┴──────────────┘                           │
│                                                                      │
│  EMPLOYEE Table (BEFORE delete):                                     │
│  ┌─────────┬──────────┬──────────┐                                  │
│  │ EmpID   │ EmpName  │ DeptID   │                                  │
│  │ (PK)    │          │ (FK)     │                                  │
│  ├─────────┼──────────┼──────────┤                                  │
│  │ E001    │ Alice    │ D01      │                                  │
│  │ E002    │ Bob      │ D01      │                                  │
│  │ E003    │ Charlie  │ D02      │  ← DELETE THIS                   │
│  └─────────┴──────────┴──────────┘                                  │
│                                                                      │
│  EMPLOYEE Table (AFTER delete):                                      │
│  ┌─────────┬──────────┬──────────┐                                  │
│  │ E001    │ Alice    │ D01      │                                  │
│  │ E002    │ Bob      │ D01      │                                  │
│  └─────────┴──────────┴──────────┘                                  │
│                                                                      │
│  ✓ Charlie deleted                                                  │
│  ✓ Marketing department information PRESERVED                       │
│  ✓ Department exists independently of employees                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## How Normalization Prevents Anomalies

```
┌─────────────────────────────────────────────────────────────────────┐
│            NORMALIZATION vs ANOMALIES                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Anomaly Type    │ Caused By           │ Prevented By               │
│  ────────────────┼─────────────────────┼────────────────────────────│
│  INSERT          │ Entities combined   │ Separating entities        │
│                  │ in one table        │ into proper tables         │
│  ────────────────┼─────────────────────┼────────────────────────────│
│  UPDATE          │ Redundant data      │ Single source of truth     │
│                  │ (same value in      │ (store each fact once)     │
│                  │ multiple rows)      │                            │
│  ────────────────┼─────────────────────┼────────────────────────────│
│  DELETE          │ Multiple facts in   │ Separating independent     │
│                  │ same row            │ facts into tables          │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  NORMALIZATION SUMMARY:                                              │
│                                                                      │
│  1NF: Atomic values → Prevents multi-value issues                   │
│  2NF: No partial deps → Prevents UPDATE anomalies (composite keys)  │
│  3NF: No transitive deps → Prevents all three anomaly types         │
│  BCNF: Every determinant is a key → Maximum anomaly prevention      │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Database Design Best Practices

### 1. Always Start with Requirements

```
┌─────────────────────────────────────────────────────────────────────┐
│                    REQUIREMENTS FIRST                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  BEFORE designing tables, understand:                               │
│                                                                      │
│  □ What data needs to be stored?                                    │
│  □ What are the business rules?                                     │
│  □ What queries will be common?                                     │
│  □ What are the relationships between entities?                     │
│  □ What are the constraints (unique values, required fields)?       │
│                                                                      │
│  DOCUMENT everything before writing CREATE TABLE statements!        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 2. Normalize, Then Denormalize Only If Needed

```
┌─────────────────────────────────────────────────────────────────────┐
│                    NORMALIZATION STRATEGY                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Step 1: ALWAYS normalize to at least 3NF (or BCNF)                │
│          • Ensures data integrity                                   │
│          • Prevents anomalies                                       │
│          • Creates clean structure                                  │
│                                                                      │
│  Step 2: MEASURE performance with real queries                      │
│          • Test with realistic data volumes                         │
│          • Identify slow queries                                    │
│          • Profile JOIN operations                                  │
│                                                                      │
│  Step 3: DENORMALIZE strategically IF needed                        │
│          • Only for proven performance issues                       │
│          • Document the trade-offs                                  │
│          • Consider caching alternatives first                      │
│                                                                      │
│  ⚠️  Never skip normalization "for performance" without measuring! │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 3. Use Appropriate Data Types

```sql
-- ✓ GOOD: Appropriate data types
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,           -- Integer for IDs
    ProductName VARCHAR(100) NOT NULL,   -- Variable length for names
    Price DECIMAL(10, 2) NOT NULL,       -- Exact precision for money
    Weight DECIMAL(8, 3),                -- Precise measurements
    CreatedAt TIMESTAMP DEFAULT NOW(),   -- Timestamp for dates
    IsActive BOOLEAN DEFAULT TRUE,       -- Boolean for flags
    Description TEXT                     -- Large text when needed
);

-- ✗ BAD: Poor data type choices
CREATE TABLE Product (
    ProductID VARCHAR(255),              -- String for numeric ID?
    ProductName TEXT,                    -- TEXT for short names?
    Price FLOAT,                         -- FLOAT loses precision!
    Weight VARCHAR(50),                  -- String for numbers?
    CreatedAt VARCHAR(20),               -- String for dates?
    IsActive VARCHAR(10)                 -- String for boolean?
);
```

### 4. Define Constraints Properly

```sql
-- Complete constraint example
CREATE TABLE Employee (
    -- Primary Key
    EmpID INT PRIMARY KEY,
    
    -- Not Null constraints
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    
    -- Unique constraint
    UNIQUE (Email),
    
    -- Check constraints
    Salary DECIMAL(10, 2) CHECK (Salary > 0),
    Age INT CHECK (Age >= 18 AND Age <= 120),
    
    -- Foreign Key
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    -- Default values
    HireDate DATE DEFAULT CURRENT_DATE,
    IsActive BOOLEAN DEFAULT TRUE
);
```

### 5. Index Strategically

```sql
-- Indexing best practices

-- Primary keys are automatically indexed
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,  -- Auto-indexed
    ...
);

-- Index foreign keys (used in JOINs)
CREATE INDEX idx_order_customer ON Orders(CustomerID);

-- Index frequently searched columns
CREATE INDEX idx_customer_email ON Customer(Email);

-- Index columns used in WHERE clauses
CREATE INDEX idx_order_date ON Orders(OrderDate);

-- Composite index for multi-column searches
CREATE INDEX idx_name ON Customer(LastName, FirstName);

-- ⚠️ Don't over-index!
-- Each index slows down INSERT/UPDATE/DELETE
-- Only index columns that are frequently queried
```

### 6. Use Foreign Keys for Referential Integrity

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FOREIGN KEY BENEFITS                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. PREVENTS orphan records                                         │
│     • Can't insert Order with invalid CustomerID                   │
│     • Can't delete Customer with existing Orders (unless cascaded) │
│                                                                      │
│  2. DOCUMENTS relationships                                         │
│     • Schema shows how tables connect                               │
│     • Self-documenting design                                       │
│                                                                      │
│  3. ENABLES cascading actions                                       │
│     • ON DELETE CASCADE: Delete child records automatically        │
│     • ON DELETE SET NULL: Nullify FK on parent delete              │
│     • ON UPDATE CASCADE: Update FKs when parent key changes        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

```sql
-- Foreign key with cascade options
CREATE TABLE OrderItem (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    
    -- When Order is deleted, delete its items
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE,
    
    -- When Product is deleted, prevent if used
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE RESTRICT
);
```

---

## Naming Conventions

### Table Names

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TABLE NAMING CONVENTIONS                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  RECOMMENDATION: Singular, PascalCase or snake_case                 │
│                                                                      │
│  ✓ GOOD:                        ✗ AVOID:                            │
│  Customer                       Customers (plural)                   │
│  OrderItem                      tbl_Customers (prefix)              │
│  customer                       CUSTOMER (all caps)                 │
│  order_item                     orderitem (hard to read)            │
│                                                                      │
│  CONSISTENCY IS KEY - pick one style and stick with it!             │
│                                                                      │
│  JUNCTION TABLES:                                                    │
│  • Combine both entity names                                        │
│  • StudentCourse or student_course                                  │
│  • Or use a descriptive name: Enrollment                            │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Column Names

```
┌─────────────────────────────────────────────────────────────────────┐
│                    COLUMN NAMING CONVENTIONS                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  PRIMARY KEYS:                                                       │
│  • TableNameID or table_name_id                                     │
│  • CustomerID, ProductID, customer_id                               │
│                                                                      │
│  FOREIGN KEYS:                                                       │
│  • Same name as the referenced PK                                   │
│  • Customer.CustomerID ← Order.CustomerID                           │
│                                                                      │
│  BOOLEAN COLUMNS:                                                    │
│  • IsActive, HasChildren, CanEdit                                   │
│  • is_active, has_children, can_edit                                │
│                                                                      │
│  DATE/TIME COLUMNS:                                                  │
│  • CreatedAt, UpdatedAt, DeletedAt                                  │
│  • OrderDate, ShipDate, DueDate                                     │
│                                                                      │
│  ✓ GOOD:                        ✗ AVOID:                            │
│  FirstName                      First_Name (inconsistent)           │
│  first_name                     fname (abbreviation)                │
│  CreatedAt                      col1 (meaningless)                  │
│  IsActive                       active (unclear if boolean)         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Example: Consistent Naming

```sql
-- Consistent PascalCase convention
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt TIMESTAMP DEFAULT NOW()
);

CREATE TABLE Order (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10, 2),
    IsPaid BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- OR Consistent snake_case convention
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);
```

---

## Common Mistakes to Avoid

### 1. Storing Calculated Values

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CALCULATED VALUES                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ✗ BAD: Storing calculated values                                   │
│                                                                      │
│  CREATE TABLE Order (                                                │
│      OrderID INT PRIMARY KEY,                                       │
│      Subtotal DECIMAL(10,2),                                        │
│      TaxRate DECIMAL(4,2),                                          │
│      Tax DECIMAL(10,2),         ← Calculated: Subtotal × TaxRate   │
│      Total DECIMAL(10,2)        ← Calculated: Subtotal + Tax       │
│  );                                                                  │
│                                                                      │
│  PROBLEMS:                                                           │
│  • If Subtotal changes, Tax and Total become inconsistent           │
│  • Redundant storage                                                │
│  • Maintenance burden                                               │
│                                                                      │
│  ✓ GOOD: Calculate when needed                                      │
│                                                                      │
│  CREATE TABLE Order (                                                │
│      OrderID INT PRIMARY KEY,                                       │
│      Subtotal DECIMAL(10,2),                                        │
│      TaxRate DECIMAL(4,2)                                           │
│  );                                                                  │
│                                                                      │
│  -- Calculate in queries or views:                                  │
│  SELECT OrderID, Subtotal, TaxRate,                                 │
│         Subtotal * TaxRate AS Tax,                                  │
│         Subtotal * (1 + TaxRate) AS Total                          │
│  FROM Order;                                                         │
│                                                                      │
│  EXCEPTION: Store calculated values if:                             │
│  • Calculation is expensive and value is frequently accessed        │
│  • Historical accuracy required (prices at time of order)           │
│  • Use materialized views or triggers to maintain consistency       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 2. Using Generic Column Names

```
┌─────────────────────────────────────────────────────────────────────┐
│                    AVOID GENERIC NAMES                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ✗ BAD:                                                              │
│  ┌─────────┬────────┬────────┬────────┬────────┐                    │
│  │ ID      │ Name   │ Type   │ Value  │ Status │                    │
│  └─────────┴────────┴────────┴────────┴────────┘                    │
│                                                                      │
│  • ID of what?                                                      │
│  • Name of what?                                                    │
│  • Type of what?                                                    │
│                                                                      │
│  ✓ GOOD:                                                             │
│  ┌────────────┬──────────────┬─────────────┬───────────┬──────────┐ │
│  │ CustomerID │ CustomerName │ AccountType │ Balance   │ IsActive │ │
│  └────────────┴──────────────┴─────────────┴───────────┴──────────┘ │
│                                                                      │
│  • Clear and self-documenting                                       │
│  • No ambiguity in JOINs                                           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 3. Not Using Transactions

```sql
-- ✗ BAD: Operations without transaction
UPDATE Account SET Balance = Balance - 100 WHERE AccountID = 1;
UPDATE Account SET Balance = Balance + 100 WHERE AccountID = 2;
-- What if the second UPDATE fails? Money disappears!

-- ✓ GOOD: Use transactions
BEGIN TRANSACTION;
    UPDATE Account SET Balance = Balance - 100 WHERE AccountID = 1;
    UPDATE Account SET Balance = Balance + 100 WHERE AccountID = 2;
COMMIT;
-- If anything fails, ROLLBACK ensures both accounts unchanged
```

### 4. Ignoring NULL Handling

```
┌─────────────────────────────────────────────────────────────────────┐
│                    NULL HANDLING                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  UNDERSTAND NULL:                                                    │
│  • NULL means "unknown" or "not applicable"                         │
│  • NULL ≠ 0, NULL ≠ '', NULL ≠ FALSE                               │
│  • NULL comparisons are tricky                                      │
│                                                                      │
│  COMPARISON PITFALLS:                                                │
│  • NULL = NULL  → NULL (not TRUE!)                                  │
│  • NULL <> 1    → NULL (not TRUE!)                                  │
│  • Use IS NULL or IS NOT NULL                                       │
│                                                                      │
│  BEST PRACTICES:                                                     │
│  • Use NOT NULL for required fields                                 │
│  • Provide DEFAULT values when appropriate                          │
│  • Use COALESCE() to handle NULLs in queries                       │
│                                                                      │
│  -- Handle NULL in queries                                          │
│  SELECT COALESCE(MiddleName, '') AS MiddleName FROM Customer;      │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 5. EAV (Entity-Attribute-Value) Anti-Pattern

```
┌─────────────────────────────────────────────────────────────────────┐
│                    AVOID EAV ANTI-PATTERN                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ✗ BAD: Entity-Attribute-Value pattern                              │
│                                                                      │
│  ┌────────────┬───────────────┬───────────────┐                     │
│  │ EntityID   │ AttributeName │ AttributeValue│                     │
│  ├────────────┼───────────────┼───────────────┤                     │
│  │ 1          │ FirstName     │ Alice         │                     │
│  │ 1          │ LastName      │ Smith         │                     │
│  │ 1          │ Email         │ alice@ex.com  │                     │
│  │ 2          │ FirstName     │ Bob           │                     │
│  │ 2          │ LastName      │ Jones         │                     │
│  └────────────┴───────────────┴───────────────┘                     │
│                                                                      │
│  PROBLEMS:                                                           │
│  • No type safety (everything is string)                            │
│  • Complex queries to get one "row"                                 │
│  • Can't enforce constraints                                        │
│  • Poor performance                                                 │
│  • No referential integrity                                         │
│                                                                      │
│  ✓ GOOD: Proper table design                                        │
│                                                                      │
│  ┌────────────┬───────────┬──────────┬───────────────┐              │
│  │ CustomerID │ FirstName │ LastName │ Email         │              │
│  ├────────────┼───────────┼──────────┼───────────────┤              │
│  │ 1          │ Alice     │ Smith    │ alice@ex.com  │              │
│  │ 2          │ Bob       │ Jones    │ bob@ex.com    │              │
│  └────────────┴───────────┴──────────┴───────────────┘              │
│                                                                      │
│  Use EAV ONLY when you truly need dynamic attributes                │
│  (e.g., product specifications that vary by category)               │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Summary Checklist

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DATABASE DESIGN CHECKLIST                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  BEFORE DESIGNING:                                                   │
│  □ Gather and document requirements                                 │
│  □ Identify all entities and their attributes                       │
│  □ Define relationships and cardinalities                           │
│  □ Identify business rules and constraints                          │
│                                                                      │
│  DURING DESIGN:                                                      │
│  □ Create ER diagram                                                │
│  □ Normalize to at least 3NF (preferably BCNF)                     │
│  □ Define primary keys for all tables                               │
│  □ Implement foreign keys for relationships                         │
│  □ Apply appropriate constraints (NOT NULL, UNIQUE, CHECK)          │
│  □ Choose correct data types                                        │
│  □ Use consistent naming conventions                                │
│                                                                      │
│  AFTER DESIGN:                                                       │
│  □ Review for anomalies (INSERT, UPDATE, DELETE)                    │
│  □ Test with sample data                                            │
│  □ Plan indexes for common queries                                  │
│  □ Document the schema                                              │
│  □ Review with stakeholders                                         │
│                                                                      │
│  MAINTENANCE:                                                        │
│  □ Use migrations for schema changes                                │
│  □ Backup regularly                                                 │
│  □ Monitor query performance                                        │
│  □ Update documentation with changes                                │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

**Previous:** [← Normalization](./04_normalization.md)

**Next:** [Practical Example →](./06_practical_example.md)
