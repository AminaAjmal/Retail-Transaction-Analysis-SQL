-- =====================================================
-- Project: Retail Transaction Analysis using SQL
-- File: 02_Data_Cleaning.sql
-- Author: Amina Ajmal
--
-- Description:
-- This project demonstrates a complete SQL-based data analytics workflow,
-- including dataset exploration, data validation, data cleaning,
-- exploratory data analysis, and business reporting. The analysis uncovers
-- purchasing trends, transaction patterns, and actionable business insights
-- from a retail transaction dataset while documenting data quality findings
-- and validation results.
--
-- Purpose:
-- Transform the raw imported data into cleaned,
-- standardized dimension and fact tables that
-- will be used for analysis throughout the project.
-- =====================================================


-- ============================================
-- Create Customer Dimension Table
-- ============================================

DROP TABLE IF EXISTS dim_customers;

CREATE TABLE dim_customers AS
SELECT
    CAST(customer_id AS INTEGER) AS customer_id,
    CASE
    WHEN UPPER(TRIM(sex)) = 'MALE' THEN 'MALE'
    WHEN UPPER(TRIM(sex)) = 'FEMALE' THEN 'FEMALE'
    WHEN UPPER(TRIM(sex)) = 'UNKNOWN' THEN 'UNKNOWN'
    ELSE NULL
END AS sex,
-- Replace implausible ages (less than 0 or greater than 100)
-- with NULL while preserving valid ages.
    CASE
        WHEN CAST(customer_age AS REAL) BETWEEN 0 AND 100
        THEN CAST(customer_age AS REAL)
        ELSE NULL
    END AS customer_age,
    CAST(tenure AS INTEGER) AS tenure
FROM customer_details;

-- ============================================
-- Create Basket Fact Table
-- ============================================

DROP TABLE IF EXISTS fact_baskets;

CREATE TABLE fact_baskets AS

SELECT
    CAST(customer_id AS INTEGER) AS customer_id,
    CAST(product_id AS INTEGER) AS product_id,
    TRIM(basket_date) AS basket_date,
    CAST(basket_count AS INTEGER) AS basket_count
FROM basket_details;


-- ============================================
-- Verify Cleaned Tables
-- ============================================

PRAGMA table_info(dim_customers);

PRAGMA table_info(fact_baskets);


-- ============================================
-- Preview Cleaned Customer Table
-- ============================================

SELECT *
FROM dim_customers
LIMIT 10;


-- ============================================
-- Preview Cleaned Basket Table
-- ============================================

SELECT *
FROM fact_baskets
LIMIT 10;