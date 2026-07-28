-- ==========================================================
-- SQL Learning & Practice
-- Project: Customer Purchase Behavior Analysis
-- Database: CustomerBehaviorAnalysis.db
-- Author: Amina Ajmal
--
-- Purpose:
-- This file is used to learn and practice SQL concepts before
-- applying them to the portfolio analysis files.
--
-- Concepts Covered:
-- 1. INNER JOIN
-- 2. LEFT JOIN
-- 3. RIGHT JOIN (Concept Only - Not Supported in SQLite)
-- 4. SELF JOIN
-- 5. Subqueries
-- 6. Common Table Expressions (CTEs)
-- 7. Window Functions
-- ==========================================================

SELECT *
FROM dim_customers
LIMIT 5;

-- ==========================================================
-- Lesson 1: INNER JOIN
-- ==========================================================

SELECT *
FROM dim_customers
INNER JOIN fact_baskets
ON dim_customers.customer_id = fact_baskets.customer_id
LIMIT 10;

-- ==========================================================
-- Lesson 2: Selecting Only the Columns You Need
-- ==========================================================

-- Instead of using SELECT *, choose only the columns
-- needed to answer the business question.

SELECT
    dim_customers.customer_id,
    dim_customers.customer_age,
    fact_baskets.product_id
FROM dim_customers
INNER JOIN fact_baskets
ON dim_customers.customer_id = fact_baskets.customer_id;

-- ==========================================================
-- Lesson 3: Understanding Column References
-- ==========================================================

-- SQL allows you to omit the table name if the column
-- exists in only one table.

SELECT
    customer_age,
    product_id
FROM dim_customers
INNER JOIN fact_baskets
ON dim_customers.customer_id = fact_baskets.customer_id;


-- The following query WILL NOT work because customer_id
-- exists in both tables, making it ambiguous.

-- SELECT
--     customer_id
-- FROM dim_customers
-- INNER JOIN fact_baskets
-- ON dim_customers.customer_id = fact_baskets.customer_id;


-- Correct version

SELECT
    dim_customers.customer_id,
    customer_age,
    product_id
FROM dim_customers
INNER JOIN fact_baskets
ON dim_customers.customer_id = fact_baskets.customer_id;

-- ==========================================================
-- Lesson 4: Table Aliases
-- ==========================================================

-- Aliases provide shorter names for tables,
-- making queries easier to read.

SELECT
    c.customer_id,
    c.customer_age,
    b.product_id,
    b.basket_count
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
ON c.customer_id = b.customer_id;


-- Another example

SELECT
    c.sex,
    b.product_id
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
ON c.customer_id = b.customer_id;

-- ==========================================================
-- Lesson 5: LEFT JOIN
-- ==========================================================

-- LEFT JOIN keeps every row from the table on the left,
-- even if there is no matching row in the table on the right.

SELECT
    c.customer_id,
    c.sex,
    b.product_id
FROM dim_customers AS c
LEFT JOIN fact_baskets AS b
ON c.customer_id = b.customer_id;            

-- ==========================================================
-- Lesson 5 Practice:
-- Find Customers Who Have Never Made a Purchase
-- ==========================================================

SELECT
    c.customer_id,
    c.sex,
    c.customer_age
FROM dim_customers AS c
LEFT JOIN fact_baskets AS b
ON c.customer_id = b.customer_id
WHERE b.customer_id IS NULL;

-- ==========================================================
-- Practice: Total Items Purchased by Each Sex
-- ==========================================================

SELECT
    c.sex,
    SUM(b.basket_count) AS total_items_purchased
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
ON c.customer_id = b.customer_id
GROUP BY c.sex
ORDER BY total_items_purchased DESC;

-- ==========================================================
-- Lesson 6: GROUP BY with Aggregate Functions
-- ==========================================================

-- Business Question:
-- What is the average customer age for each gender?

SELECT
    c.sex,
    AVG(c.customer_age) AS average_age
FROM dim_customers AS c
GROUP BY c.sex;


-- ==========================================================
-- Lesson 6 Practice:
-- Average Customer Age for Each Product Purchased
-- ==========================================================

-- Business Question:
-- What is the average customer age of customers
-- who purchased each product?

SELECT
    b.product_id,
    AVG(c.customer_age) AS average_customer_age
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
ON c.customer_id = b.customer_id
GROUP BY b.product_id;


-- ==========================================================
-- Lesson 6 Practice:
-- Total Items Purchased by Each Gender
-- ==========================================================

-- Business Question:
-- Which gender purchased the most items?

SELECT
    c.sex,
    SUM(b.basket_count) AS total_items_purchased
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
ON c.customer_id = b.customer_id
GROUP BY c.sex
ORDER BY total_items_purchased DESC;


-- ==========================================================
-- Lesson 6 Practice:
-- Number of Purchase Records by Gender
-- ==========================================================

-- Business Question:
-- How many purchase records belong to each gender?

SELECT
    c.sex,
    COUNT(*) AS purchase_records
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
ON c.customer_id = b.customer_id
GROUP BY c.sex
ORDER BY purchase_records DESC;

-- ============================================================
-- LESSON 7: HAVING CLAUSE
-- ============================================================

/*
What is HAVING?

HAVING filters groups AFTER GROUP BY and aggregate functions
(COUNT, SUM, AVG, MIN, MAX) have been calculated.

Think of SQL execution order:

1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. ORDER BY

Rule to Remember:
- WHERE filters individual rows.
- HAVING filters groups.
*/

-- ============================================================
-- Example 1
-- Business Question:
-- Show products that have been purchased more than 20 times.
-- ============================================================

SELECT
    product_id,
    COUNT(*) AS purchase_records
FROM fact_baskets
GROUP BY product_id
HAVING COUNT(*) > 20;

---------------------------------------------------------------

-- ============================================================
-- Example 2
-- Business Question:
-- Show products whose total quantity sold exceeds 100.
-- ============================================================

SELECT
    product_id,
    SUM(basket_count) AS total_items_sold
FROM fact_baskets
GROUP BY product_id
HAVING SUM(basket_count) > 100;

---------------------------------------------------------------

-- ============================================================
-- Example 3
-- Business Question:
-- Show products whose average basket quantity is greater than 3.
-- ============================================================

SELECT
    product_id,
    AVG(basket_count) AS average_basket_count
FROM fact_baskets
GROUP BY product_id
HAVING AVG(basket_count) > 3;

---------------------------------------------------------------

-- ============================================================
-- Example 4
-- Business Question:
-- Identify customers who have made more than five purchases.
-- ============================================================

SELECT
    customer_id,
    COUNT(*) AS purchase_records
FROM fact_baskets
GROUP BY customer_id
HAVING COUNT(*) > 5;

---------------------------------------------------------------

-- ============================================================
-- Example 5
-- Business Question:
-- Find customers whose total purchased quantity exceeds 20 items.
-- ============================================================

SELECT
    customer_id,
    SUM(basket_count) AS total_items_purchased
FROM fact_baskets
GROUP BY customer_id
HAVING SUM(basket_count) > 20;

---------------------------------------------------------------

-- ============================================================
-- Example 6
-- Business Question:
-- Show only genders that have more than 100 purchase records.
-- ============================================================

SELECT
    c.sex,
    COUNT(*) AS purchase_records
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
    ON c.customer_id = b.customer_id
GROUP BY c.sex
HAVING COUNT(*) > 100;

---------------------------------------------------------------

-- ============================================================
-- Example 7
-- Business Question:
-- Show genders whose average customer age is greater than 35.
-- ============================================================

SELECT
    c.sex,
    AVG(c.customer_age) AS average_age
FROM dim_customers AS c
GROUP BY c.sex
HAVING AVG(c.customer_age) > 35;

---------------------------------------------------------------

-- ============================================================
-- Example 8
-- Business Question:
-- Show products that generated more than 500 total items sold,
-- ordered from highest to lowest.
-- ============================================================

SELECT
    product_id,
    SUM(basket_count) AS total_items_sold
FROM fact_baskets
GROUP BY product_id
HAVING SUM(basket_count) > 500
ORDER BY total_items_sold DESC;

---------------------------------------------------------------

-- ============================================================
-- KEY TAKEAWAYS
-- ============================================================

/*
WHERE
- Filters individual rows
- Executed BEFORE GROUP BY

HAVING
- Filters groups
- Executed AFTER GROUP BY
- Usually used with:
    COUNT()
    SUM()
    AVG()
    MIN()
    MAX()

Interview Tip:
If the business question asks about:
- Total
- Average
- Count
- Maximum
- Minimum

Ask yourself:
"Do I need to group the data first?"

If YES → Use HAVING.
If NO → Use WHERE.
*/

-- ============================================================
-- LESSON 8: CASE WHEN
-- ============================================================

/*
What is CASE WHEN?

CASE WHEN allows you to create a new column based on one or
more conditions.

Think of it as SQL's version of Excel's IF() function.

General Syntax:

CASE
    WHEN condition THEN result
    WHEN another_condition THEN result
    ELSE result
END

Rule to Remember:
- SQL evaluates conditions from TOP to BOTTOM.
- SQL stops at the FIRST condition that is TRUE.
*/

-- ============================================================
-- Example 1
-- Business Question:
-- Classify customers into age groups.
-- ============================================================

SELECT
    customer_id,
    customer_age,
    CASE
        WHEN customer_age < 18 THEN 'Minor'
        WHEN customer_age < 30 THEN 'Young Adult'
        WHEN customer_age < 60 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group
FROM dim_customers;

---------------------------------------------------------------

-- ============================================================
-- Example 2
-- Business Question:
-- Label customers as Minor or Adult.
-- ============================================================

SELECT
    customer_id,
    customer_age,
    CASE
        WHEN customer_age < 18 THEN 'Minor'
        ELSE 'Adult'
    END AS customer_status
FROM dim_customers;

---------------------------------------------------------------

-- ============================================================
-- Example 3
-- Business Question:
-- Categorize purchases by basket size.
--
-- 1-2  = Small
-- 3-5  = Medium
-- 6+   = Large
-- ============================================================

SELECT
    product_id,
    basket_count,
    CASE
        WHEN basket_count <= 2 THEN 'Small'
        WHEN basket_count <= 5 THEN 'Medium'
        ELSE 'Large'
    END AS purchase_size
FROM fact_baskets;

---------------------------------------------------------------

-- ============================================================
-- Example 4
-- Business Question:
-- Label customers as Male or Female.
-- ============================================================

SELECT
    customer_id,
    sex,
    CASE
        WHEN sex = 'M' THEN 'Male'
        ELSE 'Female'
    END AS gender_label
FROM dim_customers;

---------------------------------------------------------------

-- ============================================================
-- Example 5
-- Business Question:
-- Count customers in each age group.
-- ============================================================

SELECT
    CASE
        WHEN customer_age < 18 THEN 'Minor'
        WHEN customer_age < 30 THEN 'Young Adult'
        WHEN customer_age < 60 THEN 'Adult'
        ELSE 'Senior'
    END AS age_group,
    COUNT(*) AS total_customers
FROM dim_customers
GROUP BY
    CASE
        WHEN customer_age < 18 THEN 'Minor'
        WHEN customer_age < 30 THEN 'Young Adult'
        WHEN customer_age < 60 THEN 'Adult'
        ELSE 'Senior'
    END
ORDER BY total_customers DESC;

---------------------------------------------------------------

-- ============================================================
-- Example 6
-- Business Question:
-- Count purchases by purchase size.
-- ============================================================

SELECT
    CASE
        WHEN basket_count <= 2 THEN 'Small'
        WHEN basket_count <= 5 THEN 'Medium'
        ELSE 'Large'
    END AS purchase_size,
    COUNT(*) AS number_of_purchases
FROM fact_baskets
GROUP BY
    CASE
        WHEN basket_count <= 2 THEN 'Small'
        WHEN basket_count <= 5 THEN 'Medium'
        ELSE 'Large'
    END
ORDER BY number_of_purchases DESC;

---------------------------------------------------------------

-- ============================================================
-- KEY TAKEAWAYS
-- ============================================================

/*
CASE WHEN
- Creates a new column based on conditions.
- Similar to Excel's IF() function.
- SQL evaluates conditions from top to bottom.
- SQL stops at the first TRUE condition.

Common Uses:
- Age Groups
- Customer Segments
- Purchase Size
- High / Medium / Low Sales
- Active / Inactive Customers
- Product Categories

CASE WHEN is commonly used with:
- SELECT
- GROUP BY
- ORDER BY
- Aggregate Functions
*/

-- ============================================
-- LESSON 9 - SUBQUERIES
-- ============================================

-- Practice 1
-- Show all customers older than the average customer age.

SELECT
    customer_id,
    customer_age
FROM dim_customers
WHERE customer_age > (
select avg(customer_age)
from dim_customers
    ______________________
);


-- ============================================

-- Practice 2
-- Show the oldest customer.

SELECT
    customer_id,
 customer_age
FROM dim_customers
WHERE customer_age = (select max(customer_age)
from dim_customers
    ______________________
);


-- ============================================

-- Practice 3
-- Show the customer id of customers who purchased Product 101.

SELECT
    customer_id
FROM dim_customers
WHERE customer_id IN (
    SELECT customer_id
    FROM fact_baskets
    WHERE product_id = 101
);

SELECT
    customer_id,
    product_id,
    basket_count,
    SUM(basket_count) OVER (
        PARTITION BY customer_id
    ) AS customer_total
FROM fact_baskets;