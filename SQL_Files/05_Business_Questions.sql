/*
===============================================================================
 Business Questions & Insights
 Project: Retail Transaction Analysis using SQL
 Author: Amina Ajmal
 Database: CustomerBehaviorAnalysis.db

 Description:
 This file contains SQL queries designed to answer real-world business questions
 using retail transaction data. Each query is written to provide actionable
 insights that can support business decision-making.

 Objectives:
 • Analyze customer purchasing behavior
 • Identify high-value customers
 • Discover purchasing trends
 • Support data-driven business decisions

 Skills Demonstrated:
 • Joins
 • Aggregate Functions
 • GROUP BY & HAVING
 • CASE WHEN
 • Subqueries
 • Correlated Subqueries
 • EXISTS / NOT EXISTS
 • CTEs
 • Window Functions
 • UNION / UNION ALL

===============================================================================
*/
-- ============================================================================
-- Business Question 1
-- Which customers purchased the highest total number of items?
--
-- Business Objective:
-- Identify the customers with the highest purchase volume. This information
-- can help the business recognize its most active customers for loyalty
-- programs, targeted promotions, and customer retention strategies.
-- ============================================================================
SELECT
    c.customer_id,
    c.sex,
    c.customer_age,
    c.tenure,
    SUM(b.basket_count) AS total_items
FROM fact_baskets b
JOIN dim_customers c
    ON b.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.sex,
    c.customer_age,
    c.tenure
ORDER BY total_items DESC
LIMIT 10;
-- Business Insight:
-- The analysis identified the top 10 customers based on total purchase volume.
-- The highest purchase total in the dataset was 5 items, achieved by three
-- customers, while the remaining top customers purchased between 3 and 4 items.
-- Most of the top-performing customers are male, with ages ranging from the
-- early twenties to the late sixties. Several of these customers have long
-- tenures with the company, suggesting that long-term customers may contribute
-- significantly to purchase activity. However, some newer customers also appear
-- among the top purchasers, indicating that high engagement is not limited to
-- long-tenured customers.
-- These findings suggest that the business should continue investing in customer
-- loyalty initiatives while also identifying the factors that encourage newer
-- customers to become highly engaged. Additionally, customer records with
-- missing age information should be reviewed to improve the accuracy of future
-- customer segmentation and marketing analysis.

-- ============================================================================
-- Business Question 2
-- Which customers purchased more than the average number of items?
--
-- Business Objective:
-- Identify customers whose purchasing activity exceeds the average customer.
-- These customers represent above-average engagement and may be excellent
-- candidates for loyalty programs, personalized marketing, and retention
-- strategies.
SELECT
    c.customer_id,
    SUM(b.basket_count) AS total_items
FROM fact_baskets b
JOIN dim_customers c
    ON b.customer_id = c.customer_id
GROUP BY
    c.customer_id
HAVING
    SUM(b.basket_count) >
    (
        SELECT
            AVG(total_items)
        FROM
        (
            SELECT
                customer_id,
                SUM(basket_count) AS total_items
            FROM fact_baskets
            GROUP BY customer_id
        ) AS customer_totals
    )
ORDER BY
    total_items DESC;
    
-- Business Insight:
-- This analysis identified customers whose total purchase volume exceeds the
-- average purchase volume across all customers. A total of 16 customers
-- purchased more than the average number of items, with the highest purchase
-- total reaching 5 items.
-- These customers represent the business's most engaged customer segment and
-- are more likely to respond positively to loyalty programs, personalized
-- promotions, and customer retention initiatives. By understanding the
-- purchasing behavior of these above-average customers, the business can
-- identify opportunities to encourage similar purchasing patterns among the
-- broader customer base and improve long-term customer value.

-- ============================================================================
-- Business Question 3
-- Which age group purchased the highest total number of items?
--
-- Business Objective:
-- Segment customers by age and compare their total purchase volume to identify
-- the most active age group. This information can support targeted marketing,
-- customer segmentation, and promotional planning.
SELECT
    CASE
        WHEN c.customer_age IS NULL THEN 'Unknown'
        WHEN c.customer_age < 25 THEN 'Under 25'
        WHEN c.customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and older'
    END AS age_group,
    SUM(b.basket_count) AS total_items
FROM fact_baskets b
JOIN dim_customers c
    ON b.customer_id = c.customer_id
GROUP BY
    CASE
        WHEN c.customer_age IS NULL THEN 'Unknown'
        WHEN c.customer_age < 25 THEN 'Under 25'
        WHEN c.customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and older'
    END
ORDER BY
    total_items DESC;
    
-- Note:
-- Customer demographic analysis is based only on records where customer IDs
-- matched between the customer and transaction tables (64 matched customers).
-- Business Insight:
-- Customers aged 25–34 purchased the highest number of items (59), making
-- them the most active customer segment. The 35–44 age group ranked second
-- with 48 total items purchased, indicating that customers between the ages
-- of 25 and 44 account for the majority of purchases in this dataset.
--
-- Customers under 25, 45–54, and 55 and older showed significantly lower
-- purchase volumes, while a small number of purchases were associated with
-- customers whose age was unavailable (Unknown). Based on these findings,
-- the business should consider focusing marketing campaigns, loyalty
-- programs, and promotional efforts on customers aged 25–44, while also
-- investigating opportunities to increase engagement among the other age
-- groups.

-- ============================================================================
-- Business Question 4
-- Do male and female customers purchase different numbers of items?
--
-- Business Objective:
-- Compare the total number of items purchased by male and female customers to
-- identify purchasing patterns by gender. These insights can help businesses
-- understand customer behavior, support targeted marketing strategies, and
-- identify customer segments with higher purchase activity.
SELECT
    c.sex,
    SUM(b.basket_count) AS total_items
FROM fact_baskets b
JOIN dim_customers c
    ON b.customer_id = c.customer_id
GROUP BY c.sex
ORDER BY total_items DESC;

-- Note:
-- Customer demographic analysis is based only on records where customer IDs
-- matched between the customer and transaction tables (64 matched customers).
-- Business Insight:
-- Male customers purchased a total of 122 items, while female customers
-- purchased 33 items. Based on this dataset, male customers account for a
-- significantly larger share of total purchases. This suggests that the
-- business's current customer base or purchasing activity is more heavily
-- concentrated among male customers. Further analysis could investigate
-- whether this difference is driven by customer demographics, product
-- preferences, or differences in the number of customers within each group.

-- ============================================================================
-- Business Question 5
-- What is the distribution of basket sizes?
--
-- Business Objective:
-- Analyze how many items customers purchase per transaction by examining the
-- distribution of basket sizes. This helps identify common purchasing patterns
-- and provides insights into typical customer buying behavior, which can
-- support inventory planning, merchandising, and promotional strategies.
SELECT
    basket_count,
    COUNT(*) AS number_of_transactions
FROM fact_baskets
GROUP BY basket_count
ORDER BY basket_count;
-- Business Insight:
-- • Transactions containing 2 items accounted for the majority of purchase activity,
--   representing 13,323 out of 15,000 transactions (88.8%).
-- • Transactions with 3 or more items became progressively less frequent, indicating
--   that larger basket sizes were relatively uncommon.
-- • The results suggest that most transactions consisted of relatively small basket sizes,
--   with only a small percentage containing four or more items.
-- • These insights can help businesses develop cross-selling strategies, product bundle
--   promotions, and personalized offers to encourage customers to purchase additional
--   items and increase the average transaction value.
-- ============================================================================
-- Business Question 6
-- Which customer age groups contribute the highest percentage of total purchases?
--
-- Business Objective:
-- Calculate the percentage contribution of each customer age group to the
-- overall purchase volume. This analysis helps identify the customer segments
-- that contribute most to purchasing activity and supports data-driven
-- marketing, customer engagement, and retention strategies.
SELECT
    CASE
        WHEN c.customer_age IS NULL THEN 'Unknown'
        WHEN c.customer_age < 25 THEN 'Under 25'
        WHEN c.customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN c.customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN c.customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and older'
    END AS age_group,

    SUM(b.basket_count) AS total_items,

    ROUND(
        SUM(b.basket_count) * 100.0
        /
        SUM(SUM(b.basket_count)) OVER (),
        2
    ) AS percentage_of_total

FROM fact_baskets b
JOIN dim_customers c
    ON b.customer_id = c.customer_id

GROUP BY
    age_group

ORDER BY
    total_items DESC;
-- Business Insight:
-- Customers aged 25–34 contributed the highest share of total purchased items,
-- accounting for 38.06% of all purchases, followed by customers aged 35–44 at
-- 30.97%. Together, these two age groups represent nearly 69% of the total
-- purchase volume. This suggests that customers between the ages of 25 and 44
-- are the primary contributors to purchasing activity in the available dataset.
-- Businesses could prioritize these customer segments when developing targeted
-- marketing campaigns, promotional offers, and customer retention strategies.

-- ============================================================================
-- Business Question 7
-- How has customer purchase activity changed over time?
--
-- Business Objective:
-- Analyze purchase trends over time to identify periods of higher or lower
-- purchasing activity. This analysis helps businesses understand seasonal
-- patterns, monitor customer demand, and support data-driven planning for
-- inventory, marketing campaigns, and resource allocation.
SELECT
    strftime('%Y-%m', b.basket_date) AS purchase_month,
    SUM(b.basket_count) AS total_items
FROM fact_baskets b
GROUP BY
    strftime('%Y-%m', b.basket_date)
ORDER BY
    purchase_month;
-- Business Insight:
-- Purchase activity was higher in May 2019, with a total of 19,209 items
-- purchased, compared to 13,097 items in June 2019. Based on the available
-- data, purchase volume declined by approximately 31.8% from May to June.
-- Businesses could investigate whether this change was influenced by seasonal
-- demand, promotional campaigns, inventory availability, or other operational
-- factors. Additional historical data would help determine whether this
-- represents a normal trend or an unusual change in purchasing behavior.

-- ============================================================================
-- Business Question 8
-- What are the key customer and purchase performance metrics?
--
-- Business Objective:
-- Create an executive-level summary of the customer and purchase data by
-- calculating key performance indicators, including the total number of
-- customers, customers with recorded purchases, customers without recorded
-- purchases, total items purchased, and the average number of items purchased
-- per customer with purchase activity.
SELECT
    -- Total customers in the customer table
    (
        SELECT COUNT(*)
        FROM dim_customers
    ) AS total_customers,

    -- Customers from the customer table who have matching purchase records
    (
        SELECT COUNT(DISTINCT c.customer_id)
        FROM dim_customers c
        JOIN fact_baskets b
            ON c.customer_id = b.customer_id
    ) AS customers_with_purchases,

    -- Customers with no matching purchase records
    (
        SELECT COUNT(*)
        FROM dim_customers c
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM fact_baskets b
            WHERE b.customer_id = c.customer_id
        )
    ) AS customers_without_purchases,

    -- Total items purchased by matched customers only
    (
        SELECT SUM(b.basket_count)
        FROM fact_baskets b
        JOIN dim_customers c
            ON b.customer_id = c.customer_id
    ) AS total_items_purchased,

    -- Average items purchased per matched purchasing customer
    ROUND(
        (
            SELECT SUM(b.basket_count) * 1.0
            FROM fact_baskets b
            JOIN dim_customers c
                ON b.customer_id = c.customer_id
        )
        /
        NULLIF(
            (
                SELECT COUNT(DISTINCT c.customer_id)
                FROM dim_customers c
                JOIN fact_baskets b
                    ON c.customer_id = b.customer_id
            ),
            0
        ),
        2
    ) AS avg_items_per_purchasing_customer;
    
-- Business Insight:
-- • The customer dataset contains 20,000 records, while only 64 customer IDs
--   matched records in the transaction dataset.
-- • These matched customers purchased a total of 155 items, with an average of
--   2.42 items per matched customer.
-- • The limited overlap between the customer and transaction tables highlights
--   the importance of validating relationships between datasets before
--   performing customer-level analysis.
-- • By identifying this data limitation during the validation process, the
--   analysis ensures that business insights are based on verified relationships,
--   resulting in more accurate and reliable reporting.