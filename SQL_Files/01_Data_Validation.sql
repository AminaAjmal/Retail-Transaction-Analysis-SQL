-- =====================================================
-- Project: Retail Transaction Analysis using SQL
-- File: 01_Data_Validation.sql
-- Author: Amina Ajmal
--
-- Purpose:
-- Validate that the raw CSV files were imported
-- correctly before cleaning and analysis.
-- =====================================================


-- ============================================
-- 1. List all tables in the database
-- ============================================

SELECT name
FROM sqlite_master
WHERE type = 'table'
ORDER BY name;


-- ============================================
-- 2. Review the structure of the raw tables
-- ============================================

PRAGMA table_info(customer_details);

PRAGMA table_info(basket_details);


-- ============================================
-- 3. Preview the raw customer data
-- ============================================

SELECT *
FROM customer_details
LIMIT 10;


-- ============================================
-- 4. Preview the raw basket data
-- ============================================

SELECT *
FROM basket_details
LIMIT 10;


-- ============================================
-- 5. Count raw customer records
-- ============================================

SELECT
    COUNT(*) AS total_customer_records
FROM customer_details;


-- ============================================
-- 6. Count raw basket records
-- ============================================

SELECT
    COUNT(*) AS total_basket_records
FROM basket_details;


-- ============================================
-- 7. Check the number of distinct customers
-- ============================================

SELECT
    COUNT(DISTINCT customer_id) AS distinct_customer_ids
FROM customer_details;


-- ============================================
-- 8. Check the number of distinct products
-- ============================================

SELECT
    COUNT(DISTINCT product_id) AS distinct_product_ids
FROM basket_details;