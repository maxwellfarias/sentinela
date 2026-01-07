# Functional Dependencies

> The foundation for understanding normalization

## 📚 Table of Contents

1. [What is a Functional Dependency?](#what-is-a-functional-dependency)
2. [Terminology](#terminology)
3. [Types of Functional Dependencies](#types-of-functional-dependencies)
4. [Total Functional Dependency](#total-functional-dependency)
5. [Partial Functional Dependency](#partial-functional-dependency)
6. [Transitive Functional Dependency](#transitive-functional-dependency)
7. [Multivalued Dependency](#multivalued-dependency)
8. [Why Dependencies Matter](#why-dependencies-matter)

---

## What is a Functional Dependency?

A **functional dependency** is a relationship between attributes where the value of one attribute (or set of attributes) determines the value of another attribute.

### Notation

```
X → Y
```

Read as: **"X determines Y"** or **"Y depends on X"** or **"Y is functionally dependent on X"**

### Simple Example

```
StudentID → StudentName

If I know the StudentID, I can determine the StudentName.
StudentID 123 always corresponds to "Alice Smith"
```

### Visual Representation

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FUNCTIONAL DEPENDENCY                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│                         X → Y                                        │
│                                                                      │
│    ┌─────────────┐         ┌─────────────┐                          │
│    │      X      │────────▶│      Y      │                          │
│    │ (Determinant)│         │ (Dependent) │                          │
│    └─────────────┘         └─────────────┘                          │
│                                                                      │
│    "X determines Y"                                                  │
│    "Y depends on X"                                                  │
│    "Given X, we can find Y"                                         │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Terminology

### Determinant
The attribute(s) on the **left side** of the arrow. It's the "input" that determines other values.

### Dependent
The attribute(s) on the **right side** of the arrow. Its value is determined by the determinant.

### Key Principle

> 🔑 A **Primary Key** in a relation functionally determines **ALL** other non-key attributes in that row.

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PRIMARY KEY DETERMINES ALL                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│    STUDENT Table:                                                    │
│    ┌───────────┬─────────────┬───────────────┬──────────┐           │
│    │ StudentID │ Name        │ Email         │ Major    │           │
│    │ (PK)      │             │               │          │           │
│    └───────────┴─────────────┴───────────────┴──────────┘           │
│                                                                      │
│    Functional Dependencies:                                          │
│                                                                      │
│    StudentID → Name                                                  │
│    StudentID → Email                                                 │
│    StudentID → Major                                                 │
│                                                                      │
│    Or combined:                                                      │
│    StudentID → {Name, Email, Major}                                 │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Types of Functional Dependencies

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TYPES OF DEPENDENCIES                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. TOTAL (FULL) FUNCTIONAL DEPENDENCY                              │
│     • Attribute depends on the ENTIRE composite key                 │
│     • Required for 2NF                                              │
│                                                                      │
│  2. PARTIAL FUNCTIONAL DEPENDENCY                                   │
│     • Attribute depends on PART of a composite key                  │
│     • Violates 2NF                                                  │
│                                                                      │
│  3. TRANSITIVE FUNCTIONAL DEPENDENCY                                │
│     • Attribute depends on a NON-KEY attribute                      │
│     • Violates 3NF                                                  │
│                                                                      │
│  4. MULTIVALUED DEPENDENCY                                          │
│     • One attribute determines a SET of values                      │
│     • Violates 4NF (not covered in detail here)                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Total Functional Dependency

A **total (or full) functional dependency** occurs when an attribute depends on the **entire** composite primary key, not just part of it.

### Example: Order Items Table

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ORDER_ITEM TABLE                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌───────────┬────────────┬──────────────┬────────────┐             │
│  │ OrderNum  │ ProductCode│ Quantity     │ UnitPrice  │             │
│  │ (PK)      │ (PK)       │              │            │             │
│  ├───────────┼────────────┼──────────────┼────────────┤             │
│  │ 1001      │ P001       │ 5            │ 29.99      │             │
│  │ 1001      │ P002       │ 2            │ 49.99      │             │
│  │ 1002      │ P001       │ 1            │ 29.99      │             │
│  │ 1002      │ P003       │ 3            │ 19.99      │             │
│  └───────────┴────────────┴──────────────┴────────────┘             │
│                                                                      │
│  Composite Primary Key: (OrderNum, ProductCode)                     │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  TOTAL FUNCTIONAL DEPENDENCY:                                        │
│                                                                      │
│  (OrderNum, ProductCode) → Quantity                                 │
│                                                                      │
│  ┌───────────────────────────┐                                      │
│  │  OrderNum + ProductCode   │─────────▶ Quantity                   │
│  │      (BOTH needed)        │                                      │
│  └───────────────────────────┘                                      │
│                                                                      │
│  To know the Quantity, you need BOTH:                               │
│  • Which order? (OrderNum)                                          │
│  • Which product? (ProductCode)                                     │
│                                                                      │
│  OrderNum alone doesn't tell you Quantity                           │
│  ProductCode alone doesn't tell you Quantity                        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Why is This Important?

Total functional dependency is **good**! It means:
- The attribute truly belongs with that composite key
- No redundancy is introduced
- The table is in 2NF (regarding this attribute)

---

## Partial Functional Dependency

A **partial functional dependency** occurs when an attribute depends on **only part** of a composite primary key.

### Example: Order Items with Problem

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ORDER_ITEM TABLE (WITH PROBLEM)                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌───────────┬────────────┬──────────────┬──────────────────┐       │
│  │ OrderNum  │ ProductCode│ Quantity     │ ProductName      │       │
│  │ (PK)      │ (PK)       │              │                  │       │
│  ├───────────┼────────────┼──────────────┼──────────────────┤       │
│  │ 1001      │ P001       │ 5            │ Widget A         │       │
│  │ 1001      │ P002       │ 2            │ Widget B         │       │
│  │ 1002      │ P001       │ 1            │ Widget A         │ ← REPEATED!
│  │ 1002      │ P003       │ 3            │ Widget C         │       │
│  └───────────┴────────────┴──────────────┴──────────────────┘       │
│                                                                      │
│  Composite Primary Key: (OrderNum, ProductCode)                     │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  PARTIAL FUNCTIONAL DEPENDENCY (PROBLEM!):                           │
│                                                                      │
│  ProductCode → ProductName                                          │
│                                                                      │
│  ┌────────────┐                                                     │
│  │ ProductCode│─────────▶ ProductName                               │
│  │  (PART of  │                                                     │
│  │   the PK)  │                                                     │
│  └────────────┘                                                     │
│                                                                      │
│  ProductName depends ONLY on ProductCode!                           │
│  OrderNum is NOT needed to determine ProductName                    │
│                                                                      │
│  P001 is ALWAYS "Widget A" regardless of which order                │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  PROBLEMS CAUSED:                                                    │
│                                                                      │
│  1. REDUNDANCY: "Widget A" stored multiple times                    │
│  2. UPDATE ANOMALY: Change ProductName in one place, forget others  │
│  3. WASTED SPACE: Repeated data                                     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Visual: Partial vs Total Dependency

```
┌─────────────────────────────────────────────────────────────────────┐
│            PARTIAL vs TOTAL FUNCTIONAL DEPENDENCY                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  COMPOSITE KEY: (OrderNum, ProductCode)                             │
│                                                                      │
│  TOTAL DEPENDENCY (✓ Good):                                         │
│  ┌───────────────────────────────┐                                  │
│  │ OrderNum    +    ProductCode  │                                  │
│  │      ↓              ↓         │                                  │
│  │      └──────┬───────┘         │                                  │
│  │             ▼                 │                                  │
│  │          Quantity             │  Depends on BOTH parts           │
│  └───────────────────────────────┘                                  │
│                                                                      │
│  PARTIAL DEPENDENCY (✗ Bad):                                        │
│  ┌───────────────────────────────┐                                  │
│  │ OrderNum    +    ProductCode  │                                  │
│  │                     ↓         │                                  │
│  │                     ▼         │                                  │
│  │              ProductName      │  Depends on ONLY ONE part        │
│  └───────────────────────────────┘                                  │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Solution: Remove Partial Dependencies (2NF)

```sql
-- BEFORE: Single table with partial dependency
-- ORDER_ITEM(OrderNum, ProductCode, Quantity, ProductName)

-- AFTER: Decomposed into two tables

-- Table 1: Product information
CREATE TABLE Product (
    ProductCode VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(100)
);

-- Table 2: Order items (without ProductName)
CREATE TABLE OrderItem (
    OrderNum INT,
    ProductCode VARCHAR(10),
    Quantity INT,
    PRIMARY KEY (OrderNum, ProductCode),
    FOREIGN KEY (ProductCode) REFERENCES Product(ProductCode)
);
```

---

## Transitive Functional Dependency

A **transitive functional dependency** occurs when a non-key attribute depends on another non-key attribute, which in turn depends on the primary key.

### The Chain

```
PK → A → B

If:
  • PK → A  (PK determines A)
  • A → B   (A determines B, but A is NOT a key!)
Then:
  • PK → B  is a TRANSITIVE dependency (through A)
```

### Example: Employee Table

```
┌─────────────────────────────────────────────────────────────────────┐
│                    EMPLOYEE TABLE (WITH PROBLEM)                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌───────────┬─────────────┬────────────┬─────────────────┐         │
│  │ EmpID     │ EmpName     │ DeptCode   │ DeptName        │         │
│  │ (PK)      │             │            │                 │         │
│  ├───────────┼─────────────┼────────────┼─────────────────┤         │
│  │ E001      │ Alice       │ D01        │ Engineering     │         │
│  │ E002      │ Bob         │ D01        │ Engineering     │ ← REPEATED!
│  │ E003      │ Charlie     │ D02        │ Marketing       │         │
│  │ E004      │ Diana       │ D02        │ Marketing       │ ← REPEATED!
│  └───────────┴─────────────┴────────────┴─────────────────┘         │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  FUNCTIONAL DEPENDENCIES:                                            │
│                                                                      │
│  EmpID → EmpName      (PK determines EmpName) ✓                     │
│  EmpID → DeptCode     (PK determines DeptCode) ✓                    │
│  DeptCode → DeptName  (Non-key determines DeptName) ✗ TRANSITIVE!   │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  VISUALIZATION:                                                      │
│                                                                      │
│  ┌─────────┐                                                        │
│  │  EmpID  │───────────────────────────────────▶ EmpName            │
│  │  (PK)   │                                                        │
│  └────┬────┘                                                        │
│       │                                                             │
│       │          ┌──────────┐                                       │
│       └─────────▶│ DeptCode │─────────▶ DeptName                    │
│                  │(Non-Key) │                                       │
│                  └──────────┘                                       │
│                        ↑                                            │
│              Transitive Dependency!                                 │
│              DeptName depends on DeptCode,                          │
│              NOT directly on EmpID                                  │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  PROBLEMS CAUSED:                                                    │
│                                                                      │
│  1. REDUNDANCY: "Engineering" and "Marketing" repeated              │
│  2. UPDATE ANOMALY: Rename dept in one row, forget others           │
│  3. INSERT ANOMALY: Can't add dept without an employee              │
│  4. DELETE ANOMALY: Delete last employee, lose dept info            │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Solution: Remove Transitive Dependencies (3NF)

```sql
-- BEFORE: Single table with transitive dependency
-- EMPLOYEE(EmpID, EmpName, DeptCode, DeptName)

-- AFTER: Decomposed into two tables

-- Table 1: Department information
CREATE TABLE Department (
    DeptCode VARCHAR(10) PRIMARY KEY,
    DeptName VARCHAR(100)
);

-- Table 2: Employee (without DeptName)
CREATE TABLE Employee (
    EmpID VARCHAR(10) PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptCode VARCHAR(10),
    FOREIGN KEY (DeptCode) REFERENCES Department(DeptCode)
);
```

---

## Multivalued Dependency

A **multivalued dependency** (MVD) occurs when one attribute determines **a set of values** for another attribute, independent of other attributes.

### Notation

```
A ↠ B

Read as: "A multi-determines B"
```

### The Problem: Independent Multi-valued Facts

```
┌─────────────────────────────────────────────────────────────────────┐
│                    THE MULTIVALUED DEPENDENCY PROBLEM                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  SCENARIO:                                                           │
│  • Each employee works on multiple PROJECTS                         │
│  • Each employee has multiple SKILLS                                │
│  • Projects and Skills are INDEPENDENT of each other                │
│                                                                      │
│  WRONG APPROACH - Single Table:                                      │
│  ┌────────────┬─────────────┬─────────────┐                         │
│  │ Employee   │ Project     │ Skill       │                         │
│  ├────────────┼─────────────┼─────────────┤                         │
│  │ Ana        │ Website     │ Java        │                         │
│  │ Ana        │ Website     │ Python      │                         │
│  │ Ana        │ App         │ Java        │                         │
│  │ Ana        │ App         │ Python      │                         │
│  │ Bob        │ API         │ SQL         │                         │
│  └────────────┴─────────────┴─────────────┘                         │
│                                                                      │
│  Ana has 2 projects and 2 skills = 4 rows!                          │
│  2 × 2 = 4 (Cartesian product = redundancy)                         │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  WHY 4 ROWS FOR ANA?                                                 │
│                                                                      │
│  Ana's Projects: {Website, App}           ─┐                        │
│  Ana's Skills: {Java, Python}             ─┤─▶ INDEPENDENT!         │
│                                             │                        │
│  The fact that Ana knows Java has NOTHING to do with                │
│  whether she works on Website or App.                               │
│                                                                      │
│  But we're FORCED to combine them:                                  │
│  (Website, Java), (Website, Python), (App, Java), (App, Python)     │
│                                                                      │
├─────────────────────────────────────────────────────────────────────┤
│  MULTIVALUED DEPENDENCIES:                                           │
│                                                                      │
│  Employee ↠ Project    (Ana determines {Website, App})              │
│  Employee ↠ Skill      (Ana determines {Java, Python})              │
│                                                                      │
│  These are INDEPENDENT sets of values!                              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Problems with Multivalued Dependencies

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PROBLEMS                                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. EXCESSIVE REDUNDANCY                                            │
│     • If Ana has 3 projects and 4 skills = 12 rows!                │
│     • Each project repeated 4 times                                 │
│     • Each skill repeated 3 times                                   │
│                                                                      │
│  2. UPDATE ANOMALY                                                  │
│     • Ana learns a new skill (React)                                │
│     • Must add 2 new rows (one for each project)                    │
│     • Forget one? Data inconsistency!                               │
│                                                                      │
│  3. DELETE ANOMALY                                                  │
│     • Ana leaves project "Website"                                  │
│     • Must delete 2 rows (one for each skill)                       │
│     • Forget one? Data inconsistency!                               │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Solution: Decompose into Separate Tables

```
┌─────────────────────────────────────────────────────────────────────┐
│                    SOLUTION: DECOMPOSITION                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  BEFORE (1 table with 5 rows, redundant):                           │
│  ┌────────────┬─────────────┬─────────────┐                         │
│  │ Employee   │ Project     │ Skill       │                         │
│  ├────────────┼─────────────┼─────────────┤                         │
│  │ Ana        │ Website     │ Java        │                         │
│  │ Ana        │ Website     │ Python      │                         │
│  │ Ana        │ App         │ Java        │                         │
│  │ Ana        │ App         │ Python      │                         │
│  │ Bob        │ API         │ SQL         │                         │
│  └────────────┴─────────────┴─────────────┘                         │
│                                                                      │
│  AFTER (2 tables with 5 rows total, no redundancy):                 │
│                                                                      │
│  EMPLOYEE_PROJECT:              EMPLOYEE_SKILL:                      │
│  ┌────────────┬─────────────┐  ┌────────────┬─────────────┐         │
│  │ Employee   │ Project     │  │ Employee   │ Skill       │         │
│  ├────────────┼─────────────┤  ├────────────┼─────────────┤         │
│  │ Ana        │ Website     │  │ Ana        │ Java        │         │
│  │ Ana        │ App         │  │ Ana        │ Python      │         │
│  │ Bob        │ API         │  │ Bob        │ SQL         │         │
│  └────────────┴─────────────┘  └────────────┴─────────────┘         │
│                                                                      │
│  Ana: 2 rows in first table + 2 rows in second = 4 rows total       │
│  vs 4 rows in the single table (same count, but NO redundancy!)     │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### SQL Implementation

```sql
-- Separate tables for independent multi-valued facts

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100)
);

CREATE TABLE EmployeeProject (
    EmployeeID INT,
    ProjectName VARCHAR(100),
    PRIMARY KEY (EmployeeID, ProjectName),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE EmployeeSkill (
    EmployeeID INT,
    Skill VARCHAR(100),
    PRIMARY KEY (EmployeeID, Skill),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
```

---

## Why Dependencies Matter

Understanding functional dependencies is **essential** because:

### 1. Foundation for Normalization

```
┌─────────────────────────────────────────────────────────────────────┐
│            DEPENDENCIES AND NORMAL FORMS                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Normal Form    │    Eliminates                                      │
│  ──────────────────────────────────────────────────────             │
│  1NF            │    Multi-valued attributes                        │
│  2NF            │    PARTIAL functional dependencies                │
│  3NF            │    TRANSITIVE functional dependencies             │
│  BCNF           │    All non-trivial dependencies on non-superkeys  │
│  4NF            │    MULTIVALUED dependencies                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 2. Identifies Data Anomalies

By understanding dependencies, you can predict and prevent:
- **Insert Anomalies**: Unable to add data without other unrelated data
- **Update Anomalies**: Inconsistent updates across redundant data
- **Delete Anomalies**: Losing information when deleting data

### 3. Guides Table Design

Dependencies tell you:
- Which attributes belong together
- Where to split tables
- How to define primary keys

---

## Summary

```
┌─────────────────────────────────────────────────────────────────────┐
│                    FUNCTIONAL DEPENDENCY SUMMARY                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  NOTATION:                                                           │
│  • X → Y    Functional dependency (X determines Y)                  │
│  • A ↠ B    Multivalued dependency (A multi-determines B)           │
│                                                                      │
│  TYPES:                                                              │
│  ┌─────────────────┬────────────────────────────────────────────┐   │
│  │ Type            │ Description                                 │   │
│  ├─────────────────┼────────────────────────────────────────────┤   │
│  │ Total           │ Depends on ENTIRE composite key            │   │
│  │ Partial         │ Depends on PART of composite key (Bad!)    │   │
│  │ Transitive      │ Non-key depends on another non-key (Bad!)  │   │
│  │ Multivalued     │ Determines independent sets of values      │   │
│  └─────────────────┴────────────────────────────────────────────┘   │
│                                                                      │
│  SOLUTIONS:                                                          │
│  • Partial → Decompose to achieve 2NF                               │
│  • Transitive → Decompose to achieve 3NF                            │
│  • Multivalued → Decompose to achieve 4NF                           │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

**Previous:** [← Peter Chen Notation](./02_peter_chen_notation.md)

**Next:** [Normalization →](./04_normalization.md)
