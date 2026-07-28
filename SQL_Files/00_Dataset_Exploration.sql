-- =====================================================
-- Project: Retail Transaction Analysis using SQL
-- File: 00_Dataset_Exploration.sql
-- Author: Amina Ajmal
--
-- Purpose:
-- Explore the structure and contents of the dataset before
-- performing validation, cleaning, and business analysis.
-- ============================================

SELECT *
FROM fact_baskets
LIMIT 10;

SELECT
    customer_id,
    COUNT(*) AS purchase_records
FROM fact_baskets
GROUP BY customer_id
ORDER BY purchase_records DESC
LIMIT 10;

SELECT
    customer_id,
    product_id,
    COUNT(*) AS times_purchased
FROM fact_baskets
GROUP BY customer_id, product_id
ORDER BY times_purchased DESC
LIMIT 10;

SELECT
    customer_id,
    basket_date,
    COUNT(*) AS products_on_same_day
FROM fact_baskets
GROUP BY customer_id, basket_date
ORDER BY products_on_same_day DESC
LIMIT 10;

-- ============================================================================
-- DATA AUDIT
--
-- Purpose:
-- Compare the original and cleaned tables to verify that the cleaning process
-- preserved data integrity before performing business analysis.

SELECT 'customer_details' AS table_name, COUNT(*) AS total_rows
FROM customer_details

UNION ALL

SELECT 'dim_customers', COUNT(*)
FROM dim_customers

UNION ALL

SELECT 'basket_details', COUNT(*)
FROM basket_details

UNION ALL

SELECT 'fact_baskets', COUNT(*)
FROM fact_baskets;

SELECT
    SUM(basket_count) AS total_items_original
FROM basket_details;

SELECT
    COUNT(DISTINCT customer_id) AS customers_original
FROM basket_details;

SELECT
    COUNT(DISTINCT customer_id) AS customers_cleaned
FROM fact_baskets;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id || '-' || product_id || '-' || basket_date) AS unique_rows
FROM basket_details;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id || '-' || product_id || '-' || basket_date) AS unique_rows
FROM fact_baskets;

SELECT *
FROM basket_details
LIMIT 10;

SELECT *
FROM fact_baskets
LIMIT 10;

SELECT
    MIN(basket_count),
    MAX(basket_count),
    AVG(basket_count)
FROM basket_details;

SELECT
    MIN(basket_count),
    MAX(basket_count),
    AVG(basket_count)
FROM fact_baskets;

SELECT
    COUNT(DISTINCT b.customer_id) AS matched_customers
FROM fact_baskets b
JOIN dim_customers c
    ON b.customer_id = c.customer_id;
    
SELECT
    SUM(b.basket_count) AS matched_items
FROM fact_baskets b
JOIN dim_customers c
    ON b.customer_id = c.customer_id;
    
SELECT
    c.customer_id,
    c.sex,
    c.customer_age,
    b.product_id,
    b.basket_count
FROM dim_customers c
JOIN fact_baskets b
    ON c.customer_id = b.customer_id
LIMIT 20;

-- End of Dataset Exploration