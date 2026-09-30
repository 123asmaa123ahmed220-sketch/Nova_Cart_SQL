/*
============================================================
                    NovaCart SQL Lab
                  SQL Questions Worksheet
============================================================

Student Name : ______________________________
Section      : ______________________________
ID           : __________________________________

Platform: Microsoft SQL Server / SSMS

Instructions:
1. Complete the database design and implementation before solving
   these questions.
2. Do not modify the database structure just to make a question easier.
3. Write your SQL solution directly below each question.
4. Use meaningful aliases and readable formatting.
5. All queries must execute successfully on your completed NovaCartDB.
6. Use the separate Hints PDF only when you are genuinely stuck.
7. Do not hard-code results that should be calculated from the data.

Database:
    NovaCartDB

============================================================
*/

USE NovaCartDB;
GO


/*============================================================
                MISSION 1 — CUSTOMER & PRODUCT OVERVIEW
============================================================*/

-- M1-Q1
-- Display all customers.

-- Your query:



------------------------------------------------------------

-- M1-Q2
-- Display the product name, category, and current price
-- for every product.

-- Your query:



------------------------------------------------------------

-- M1-Q3
-- Display products whose current price is greater than 5000.

-- Your query:



------------------------------------------------------------

-- M1-Q4
-- Display all customers ordered by join date, newest first.

-- Your query:



------------------------------------------------------------

-- M1-Q5
-- Display the total number of customers.

-- Your query:



/*============================================================
             MISSION 2 — AGGREGATION & BUSINESS TOTALS
============================================================*/

-- M2-Q1
-- Calculate the average current product price.

-- Your query:



------------------------------------------------------------

-- M2-Q2
-- Display the highest and lowest current product prices.

-- Your query:



------------------------------------------------------------

-- M2-Q3
-- Calculate the total available stock quantity.

-- Your query:



------------------------------------------------------------

-- M2-Q4
-- Calculate the total amount recorded in Payments.

-- Your query:



------------------------------------------------------------

-- M2-Q5
-- Display the number of orders for each order status.

-- Your query:



------------------------------------------------------------

-- M2-Q6
-- Display the total payment amount for each payment method.

-- Your query:



/*============================================================
               MISSION 3 — ORDER & SALES ANALYSIS
============================================================*/

-- M3-Q1
-- Calculate the total sales amount for each order.
-- Use quantity multiplied by the historical unit price.

-- Your query:



------------------------------------------------------------

-- M3-Q2
-- Display only orders whose total sales exceed 5000.

-- Your query:



------------------------------------------------------------

-- M3-Q3
-- Display each order together with:
-- customer name, order date, and order status.

-- Your query:



------------------------------------------------------------

-- M3-Q4
-- Display each order with:
-- product name, purchased quantity, and historical unit price.

-- Your query:



------------------------------------------------------------

-- M3-Q5
-- Display the total amount spent by each customer.

-- Your query:



/*============================================================
              MISSION 4 — REVIEWS & RELATIONSHIPS
============================================================*/

-- M4-Q1
-- Display the number of reviews received by each product,
-- including products with no reviews.

-- Your query:



------------------------------------------------------------

-- M4-Q2
-- Display all reviews together with:
-- customer name and product name.

-- Your query:



------------------------------------------------------------

-- M4-Q3
-- Display customers who have placed at least one order.

-- Your query:



------------------------------------------------------------

-- M4-Q4
-- Display products that have never been ordered.

-- Your query:



------------------------------------------------------------

-- M4-Q5
-- Display products that have never received a review.

-- Your query:



------------------------------------------------------------

-- M4-Q6
-- Display all customers and their number of orders,
-- including customers who have never placed an order.

-- Your query:



/*============================================================
                       MISSION 5 — SUBQUERIES
============================================================*/

-- M5-Q1
-- Display customers who placed more orders than the average
-- number of orders among customers who placed at least one order.

-- Your query:



------------------------------------------------------------

-- M5-Q2
-- Display products whose current price is above the average
-- current product price.

-- Your query:



------------------------------------------------------------

-- M5-Q3
-- Display customers whose total spending is greater than
-- the average total spending among customers who have made
-- at least one payment.

-- Your query:



/*============================================================
                MISSION 6 — COMMON TABLE EXPRESSIONS
============================================================*/

-- M6-Q1
-- Using a CTE, calculate total revenue by month.

-- Your query:



------------------------------------------------------------

-- M6-Q2
-- Using a CTE, calculate total spending by customer.
-- Return only customers whose total spending exceeds 10000.

-- Your query:



/*============================================================
                  MISSION 7 — WINDOW FUNCTIONS
============================================================*/

-- M7-Q1
-- Rank customers by total spending using RANK(),
-- with the highest spending ranked first.

-- Your query:



------------------------------------------------------------

-- M7-Q2
-- Rank products by total quantity sold using DENSE_RANK(),
-- with the highest quantity ranked first.

-- Your query:



------------------------------------------------------------

-- M7-Q3
-- Display each payment together with the previous payment amount
-- using LAG().
-- Order the sequence by payment date and payment ID.

-- Your query:



------------------------------------------------------------

-- M7-Q4
-- Display a running total of payment amounts.
-- Order the sequence by payment date and payment ID.

-- Your query:



/*============================================================
                         MISSION 8 — VIEWS
============================================================*/

-- M8-Q1
-- Create a view named vw_revenue_by_month
-- that displays monthly revenue.

-- Your query:



------------------------------------------------------------

-- M8-Q2
-- Create a view named vw_best_selling_products
-- that displays:
--   Product Name
--   Total Quantity Sold
--   Total Revenue

-- Your query:



------------------------------------------------------------

-- M8-Q3
-- Create a view named vw_customer_summary
-- that displays:
--   Customer Name
--   Number of Orders
--   Total Amount Spent

-- Your query:



/*============================================================
                           END
============================================================*/
