# Vehicle Rental Management System — MySQL

## Project Overview

A relational database project designed for a vehicle rental business.

This project focuses on **SQL/database development**, rather than Excel-style reporting. It demonstrates database design, data integrity, business rules, automation, transactions and query performance.

## Objectives

- Design a normalized relational database.
- Manage customers, vehicles, branches, bookings and rentals.
- Maintain relationships using primary and foreign keys.
- Automate business rules with triggers and stored procedures.
- Use transactions for multi-step operations.
- Improve query performance using indexes.
- Demonstrate intermediate and advanced MySQL features.

## Technology

- MySQL 8.0+
- SQL
- GitHub

## Database Structure

### Main Tables

- `vehicle_types` — vehicle categories and daily rates
- `branches` — rental locations
- `customers` — customer information
- `employees` — branch employees
- `vehicles` — vehicle inventory and availability
- `bookings` — vehicle reservations
- `rentals` — active and completed rentals
- `payments` — rental payments
- `maintenance` — vehicle maintenance records

## Relationships

```text
branches
   ├── employees
   └── vehicles

vehicle_types
   └── vehicles

customers
   ├── bookings
   └── rentals

vehicles
   ├── bookings
   ├── rentals
   └── maintenance

rentals
   └── payments
```

## SQL Concepts Demonstrated

### Fundamentals
- SELECT
- INSERT
- UPDATE
- DELETE
- WHERE
- ORDER BY
- GROUP BY
- HAVING
- CASE

### Relational SQL
- INNER JOIN
- LEFT JOIN
- Multi-table joins
- Primary keys
- Foreign keys
- Constraints

### Advanced SQL
- Subqueries
- Correlated existence checks with `EXISTS`
- Common Table Expressions (CTEs)
- Window functions
- Views
- Stored procedures
- Stored functions
- Triggers
- Transactions
- Indexes
- `EXPLAIN` and query optimization

## Business Rules

1. A rental can only be created for an available vehicle.
2. A vehicle becomes `RENTED` when an active rental is created.
3. A returned vehicle becomes `AVAILABLE`.
4. Vehicle odometer readings are updated on return.
5. Late returns can generate a late fee.
6. Rental amounts cannot be negative.
7. Customer email, phone and driving-license numbers are unique.
8. Relationships are protected through foreign keys.
9. Multi-step operations can be handled using transactions.

## Project Files

| File | Purpose |
|---|---|
| `01_database_schema.sql` | Creates the database and prepares objects |
| `02_create_tables.sql` | Creates tables, constraints and indexes |
| `03_insert_data.sql` | Inserts realistic sample data |
| `04_crud_operations.sql` | CRUD examples |
| `05_joins.sql` | Join queries |
| `06_subqueries.sql` | Subquery examples |
| `07_ctes.sql` | CTE-based queries |
| `08_window_functions.sql` | Ranking, running totals and comparisons |
| `09_views.sql` | Reusable database views |
| `10_stored_procedures.sql` | Rental and vehicle-return procedures |
| `11_stored_functions.sql` | Reusable SQL functions |
| `12_triggers.sql` | Automatic vehicle-status updates |
| `13_transactions.sql` | Transaction and rollback patterns |
| `14_indexes_optimization.sql` | Indexing and `EXPLAIN` |
| `15_business_rules_and_tests.sql` | Business-rule validation queries |

## How to Run

Use MySQL Workbench or another MySQL 8.0+ client.

Run the files in this order:

```text
01_database_schema.sql
02_create_tables.sql
03_insert_data.sql
04_crud_operations.sql
05_joins.sql
06_subqueries.sql
07_ctes.sql
08_window_functions.sql
09_views.sql
10_stored_procedures.sql
11_stored_functions.sql
12_triggers.sql
13_transactions.sql
14_indexes_optimization.sql
15_business_rules_and_tests.sql
```

> Note: The CRUD file contains a temporary test customer and removes it afterward.

## Portfolio Highlights

This project demonstrates the ability to:

- Design relational database schemas.
- Work with normalized tables and relationships.
- Write complex SQL queries.
- Encapsulate business logic in stored procedures/functions.
- Automate database actions with triggers.
- Maintain data consistency with constraints and transactions.
- Use indexes and execution plans for performance tuning.

## Future Enhancements

- User authentication and role-based access.
- Reservation conflict validation using transactions.
- Dynamic pricing.
- Automated overdue status scheduling.
- Payment refund workflow.
- Audit logging.
- Integration with a web application/API.

## Author

**Akalya S**

MySQL | SQL | Data Analysis | Power BI | Excel
