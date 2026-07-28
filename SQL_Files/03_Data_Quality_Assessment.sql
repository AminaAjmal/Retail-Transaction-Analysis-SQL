-- =====================================================
-- Project: Retail Transaction Analysis using SQL
-- File: 03_Data_Quality_Assessment.sql
-- Author: Amina Ajmal
--
-- Purpose:
-- Assess the completeness, consistency, and reliability
-- of the cleaned customer and basket tables.
-- =====================================================

-- Check whether any customer ID appears more than once.
-- Expected result: zero rows.

SELECT
    customer_id,
    COUNT(*) AS record_count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Count missing values in important customer fields.
-- Expected result: all counts should be zero.

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
        AS missing_customer_ids,

    SUM(CASE
            WHEN sex IS NULL OR TRIM(sex) = ''
            THEN 1 ELSE 0
        END) AS missing_sex_values,

    SUM(CASE WHEN customer_age IS NULL THEN 1 ELSE 0 END)
        AS missing_customer_ages,

    SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END)
        AS missing_tenure_values
FROM dim_customers;

-- Count missing values in important basket fields.
-- Expected result: all counts should be zero.

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
        AS missing_customer_ids,

    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END)
        AS missing_product_ids,

    SUM(CASE
            WHEN basket_date IS NULL
              OR TRIM(basket_date) = ''
            THEN 1 ELSE 0
        END) AS missing_basket_dates,

    SUM(CASE WHEN basket_count IS NULL THEN 1 ELSE 0 END)
        AS missing_basket_counts
FROM fact_baskets;

-- Identify ages outside the expected adult range.
-- Expected result: zero rows.

SELECT *
FROM dim_customers
WHERE customer_age < 18
   OR customer_age > 100
   OR customer_age IS NULL;
   
SELECT
    customer_age,
    COUNT(*) AS customer_count
FROM customer_details
GROUP BY customer_age
ORDER BY CAST(customer_age AS REAL);

SELECT
    customer_age,
    COUNT(*) AS customer_count
FROM customer_details
WHERE CAST(customer_age AS REAL) > 100
GROUP BY customer_age
ORDER BY CAST(customer_age AS REAL);

SELECT
    customer_age,
    COUNT(*) AS customer_count
FROM customer_details
WHERE CAST(customer_age AS REAL) <= 100
GROUP BY customer_age
ORDER BY CAST(customer_age AS REAL);

-- Identify negative or missing customer tenure values.
-- Expected result: zero rows.

SELECT *
FROM dim_customers
WHERE tenure < 0
   OR tenure IS NULL;
   
-- Review the distinct sex values and their frequencies.
-- Expected result: Consistent category names (e.g., M/F or Male/Female).

SELECT
    sex,
    COUNT(*) AS customer_count
FROM dim_customers
GROUP BY sex
ORDER BY customer_count DESC;

-- Identify zero, negative, or missing basket quantities.
-- Expected result: zero rows.

SELECT *
FROM fact_baskets
WHERE basket_count <= 0
   OR basket_count IS NULL;
   
-- Identify missing or invalid basket dates.
-- Expected result: zero rows.

SELECT
    basket_date,
    COUNT(*) AS record_count
FROM fact_baskets
WHERE basket_date IS NULL
   OR TRIM(basket_date) = ''
   OR DATE(basket_date) IS NULL
GROUP BY basket_date;

-- Identify possible duplicate basket records.
-- Returned rows should be reviewed before removal.

SELECT
    customer_id,
    product_id,
    basket_date,
    basket_count,
    COUNT(*) AS duplicate_count
FROM fact_baskets
GROUP BY
    customer_id,
    product_id,
    basket_date,
    basket_count
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Find basket records without a matching customer.
-- Expected result: zero rows.

SELECT
    b.customer_id,
    b.product_id,
    b.basket_date,
    b.basket_count
FROM fact_baskets AS b
LEFT JOIN dim_customers AS c
    ON b.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT
    (SELECT COUNT(DISTINCT customer_id) FROM dim_customers) AS customers_in_dim,
    (SELECT COUNT(DISTINCT customer_id) FROM fact_baskets) AS customers_in_fact;
    
SELECT *
FROM dim_customers
LIMIT 10;

SELECT *
FROM fact_baskets
LIMIT 10;

-- Find customers with no matching basket records.
-- Returned rows may represent inactive customers or
-- customers not included in the transaction data.

SELECT
    c.customer_id,
    c.sex,
    c.customer_age,
    c.tenure
FROM dim_customers AS c
LEFT JOIN fact_baskets AS b
    ON c.customer_id = b.customer_id
WHERE b.customer_id IS NULL;

-- Count customers that exist in both tables.

SELECT COUNT(DISTINCT c.customer_id) AS matching_customers
FROM dim_customers AS c
INNER JOIN fact_baskets AS b
    ON c.customer_id = b.customer_id;
    
-- Summarize the cleaned dataset.

SELECT
    (SELECT COUNT(*) FROM dim_customers)
        AS total_customer_records,

    (SELECT COUNT(DISTINCT customer_id)
     FROM dim_customers)
        AS unique_customer_ids,

    (SELECT COUNT(*) FROM fact_baskets)
        AS total_basket_records,

    (SELECT COUNT(DISTINCT customer_id)
     FROM fact_baskets)
        AS customers_with_basket_activity,

    (SELECT COUNT(DISTINCT product_id)
     FROM fact_baskets)
        AS unique_products;