# NovaCart SQL Database Lab

A comprehensive, end-to-end relational database project built with **Microsoft SQL Server (T-SQL)** and **SQL Server Management Studio (SSMS)**. This project models an e-commerce platform ("NovaCart"), covering relational schema design, data integrity enforcement, synthetic data ingestion, edge-case preparation, and advanced analytical queries.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Database Schema & Architecture](#database-schema--architecture)
- [Business Requirements & Design Decisions](#business-requirements--design-decisions)
- [Technologies Used](#technologies-used)
- [SQL Concepts Covered](#sql-concepts-covered)
- [Project Structure](#project-structure)
- [Analytical Missions & Business Questions](#analytical-missions--business-questions)
- [How to Run the Project](#how-to-run-the-project)
- [Author & Acknowledgments](#author--acknowledgments)

---

## Project Overview

**NovaCart** simulates a production-grade e-commerce backend database. The system models the lifecycle of online retail transactions:
- Customer registration and address tracking
- Product catalog organized across categories
- Order placement and lifecycle tracking (`Pending` &rarr; `Shipped` &rarr; `Delivered` / `Cancelled`)
- Multi-item order details with historical transaction price preservation
- Payment reconciliation (Credit Card, PayPal, Cash on Delivery)
- Customer reviews and product satisfaction ratings

The lab is divided into three progressive phases:
1. **Database Setup (`01_Database_Setup.sql`)**: DDL script defining the schema, constraints, and baseline seed data.
2. **Data Preparation (`02_Data_Preparation.sql`)**: Data validation, verification of constraints, and edge-case simulation (e.g., handling products with zero orders).
3. **SQL Missions (`03_SQL_Missions.sql`)**: Comprehensive analytical reporting utilizing joins, aggregations, correlated subqueries, Common Table Expressions (CTEs), window functions, and database views.

---

## Database Schema & Architecture

The database follows a normalized relational structure designed to eliminate redundancy while preserving historical transactional integrity.

### Entity-Relationship Diagram (ERD)

![NovaCart ERD](docs/Final_Novacart.drawio.png)

### Data Dictionary

| Table | Primary Key | Foreign Keys | Key Constraints & Rules |
| :--- | :--- | :--- | :--- |
| **`Customer`** | `CustomerID` | None | `FullName`, `Email`, `JoinDate` are `NOT NULL` |
| **`Category`** | `CategoryID` | None | `CategoryName` is `NOT NULL` |
| **`Product`** | `ProductID` | `CategoryID` &rarr; `Category(CategoryID)` | `SellingPrice`, `StockQuantity` are `NOT NULL` |
| **`[Order]`** | `OrderID` | `CustomerID` &rarr; `Customer(CustomerID)` | `CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))` |
| **`OrderItem`** | `(OrderID, ProductID)` | `OrderID` &rarr; `[Order](OrderID)`<br>`ProductID` &rarr; `Product(ProductID)` | Composite PK; stores historical `UnitPrice` and `Quantity` |
| **`Payment`** | `PaymentID` | `OrderID` &rarr; `[Order](OrderID)` | `OrderID` is `UNIQUE` (1:1 relation);<br>`CHECK (PaymentMethod IN ('Credit Card', 'PayPal', 'COD'))` |
| **`Review`** | `ReviewID` | `CustomerID` &rarr; `Customer(CustomerID)` | `CHECK (Rating BETWEEN 1 AND 5)` |

---

## Business Requirements & Design Decisions

Key architectural decisions implemented to satisfy core e-commerce business rules:

1. **Junction Table for Multi-Product Orders (`OrderItem`)**:
   - Resolves the many-to-many relationship between `[Order]` and `Product`.
   - Allows each order to contain multiple distinct line items with independent quantities.

2. **Historical Price Preservation**:
   - `UnitPrice` is captured directly in `OrderItem` at checkout time rather than relying solely on `Product.SellingPrice`.
   - Prevents past financial records from being altered when catalog prices change in the future.

3. **Line-Item Quantity vs. Inventory Quantity**:
   - Purchased quantity belongs exclusively to the order-product combination (`OrderItem.Quantity`), leaving `Product.StockQuantity` for current warehouse stock.

4. **Domain Integrity via CHECK Constraints**:
   - Order statuses are strictly restricted to valid lifecycle stages: `'Pending'`, `'Shipped'`, `'Delivered'`, `'Cancelled'`.
   - Supported payment methods are constrained to `'Credit Card'`, `'PayPal'`, and `'COD'`.
   - Review ratings are bounded between `1` and `5`.

5. **One-to-One Payment Enforcement**:
   - `OrderID` is defined as `UNIQUE` in the `Payment` table to guarantee that each order is tied to exactly one payment record.

---

## Technologies Used

- **Database Engine**: Microsoft SQL Server
- **Database Management Tool**: SQL Server Management Studio (SSMS)
- **Language**: Transact-SQL (T-SQL)
- **Data Generator**: Python (`pyodbc`, `faker`, `random`) for generating realistic synthetic data volumes
- **Data Modeling & Diagramming**: Diagrams.net / Draw.io

---

## SQL Concepts Covered

This lab demonstrates practical mastery of core and advanced SQL concepts:

- **Data Definition Language (DDL)**:
  - Database instantiation (`CREATE DATABASE`)
  - Table creation (`CREATE TABLE`)
  - Primary keys, foreign keys, and composite keys
  - Integrity constraints (`NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`)
- **Data Manipulation Language (DML)**:
  - Multi-row insertions (`INSERT INTO ... VALUES (...)`)
  - Record updates and conditional deletions (`UPDATE`, `DELETE`)
- **Filtering & Set Logic**:
  - `WHERE`, `IN`, `NOT IN`, `EXISTS`, `NOT EXISTS`
  - Combining row sets using `UNION ALL`
- **Data Aggregation & Grouping**:
  - Aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`)
  - Grouping and group-level filtering (`GROUP BY`, `HAVING`)
- **Relational Joins**:
  - `INNER JOIN` across multiple related entities
  - `LEFT JOIN` for identifying missing records / orphan cases
- **Subqueries & Derived Tables**:
  - Scalar subqueries for benchmarking against database-wide averages
  - Correlated subqueries and derived table aggregations
- **Common Table Expressions (CTEs)**:
  - Readable multi-step calculations using `WITH ... AS (...)`
  - Monthly revenue aggregation and high-value customer identification
- **Window (Analytic) Functions**:
  - Ranking: `RANK()` and `DENSE_RANK()` over ordered partitions
  - Offset operations: `LAG()` for transaction-to-transaction comparisons
  - Running totals: `SUM() OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`
- **Database Views**:
  - `vw_revenue_by_month`: Monthly financial reporting
  - `vw_best_selling_products`: Product-level sales volume and revenue analysis
  - `vw_customer_summary`: Lifetime customer value (LTV) and order count summary

---

## Project Structure

```text
NovaCart-SQL-Database-Lab/
│
├── sql/
│   ├── 01_Database_Setup.sql       # DDL schema definition & initial seed data
│   ├── 02_Data_Preparation.sql     # Validation queries & edge-case preparation
│   └── 03_SQL_Missions.sql         # Business queries, CTEs, Window functions & Views
│
├── scripts/
│   └── dataset.py                  # Python script for synthetic dataset generation (pyodbc + Faker)
│
├── docs/
│   ├── Final_Novacart.drawio.png   # Entity-Relationship Diagram (Chen ERD format)
│   └── NovaCart_SQL_Lab.docx       # Lab documentation & architectural design Q&A
│
├── .gitignore                      # Git ignore rules for SQL Server, Python, and IDE files
└── README.md                       # Comprehensive project documentation
```

---

## Analytical Missions & Business Questions

The queries in `sql/03_SQL_Missions.sql` answer practical business and operational questions:

1. **Customer & Sales Activity**:
   - Order history per customer including order dates and current statuses.
   - Breakdown of line items (product name, quantity, unit price) per order.
   - Total spending per customer across completed payments.
   - Identifying customers who have never placed an order (`LEFT JOIN` / `NOT EXISTS`).

2. **Catalog & Inventory Performance**:
   - Identifying unsold inventory (`NOT EXISTS` / `NOT IN`).
   - Products priced above the catalog average price.
   - Product sales ranking based on total units sold (`DENSE_RANK()`).

3. **Financial & Trend Analysis**:
   - Monthly revenue aggregation via Common Table Expressions (`WITH MonthlyRevenue`).
   - Running total of payments over time using windowed frames (`ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`).
   - Payment delta analysis comparing consecutive transactions with `LAG()`.

4. **Reusable Views**:
   - `vw_revenue_by_month`: Pre-aggregated revenue grouped by year and month.
   - `vw_best_selling_products`: Product sales volume and generated gross revenue.
   - `vw_customer_summary`: Aggregated customer profile tracking total orders and total spend.

---

## How to Run the Project

### Prerequisites
- [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) (2019 or later recommended)
- [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- *(Optional)* Python 3.8+ with `pyodbc` and `faker` (if re-generating synthetic data)

### Step-by-Step Execution

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/<your-username>/NovaCart-SQL-Database-Lab.git
   cd NovaCart-SQL-Database-Lab
   ```

2. **Step 1: Setup the Database & Baseline Data**:
   - Open SSMS and connect to your SQL Server instance.
   - Open [`sql/01_Database_Setup.sql`](sql/01_Database_Setup.sql).
   - Execute the script (`F5`).
   - This creates the `NovaCart` database, establishes all 7 tables with their constraints, and seeds baseline records.

3. **Step 2 *(Optional)*: Generate Synthetic Dataset**:
   - To expand the dataset to 50 products, 200 orders, and 100 reviews:
   ```bash
   pip install pyodbc faker
   python scripts/dataset.py
   ```

4. **Step 3: Prepare & Audit Data**:
   - Open [`sql/02_Data_Preparation.sql`](sql/02_Data_Preparation.sql) in SSMS.
   - Execute the script (`F5`) to audit distributions and prepare edge-case scenarios (e.g., verifying products with zero orders).

5. **Step 4: Execute SQL Missions & Create Views**:
   - Open [`sql/03_SQL_Missions.sql`](sql/03_SQL_Missions.sql) in SSMS.
   - Execute the queries to analyze customer behavior, calculate running totals, rank sales, and create analytical views (`vw_revenue_by_month`, `vw_best_selling_products`, `vw_customer_summary`).

---

## Author & Acknowledgments

- **Project**: NovaCart SQL Database Lab
- **Platform**: Microsoft SQL Server / SSMS
- Designed as a practical showcase of relational database design, data integrity, and T-SQL analytics for data portfolios.
