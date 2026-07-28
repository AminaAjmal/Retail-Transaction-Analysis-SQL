-- =====================================================
-- Project: Retail Transaction Analysis using SQL
-- File: 04_Exploratory_Data_Analysis.sql
-- Author: Amina Ajmal
--
-- Purpose:
--Explore customer demographics, transaction activity,
--product trends, and purchasing patterns to identify
--meaningful business insights
-- =====================================================

-- Customer demographics by sex.

SELECT
    sex,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dim_customers),
        2
    ) AS percentage_of_customers
FROM dim_customers
GROUP BY sex
ORDER BY customer_count DESC;
/*
Purpose:
Determine the distribution of customers by sex and calculate
the percentage each group represents within the customer population.

Technical Interpretation:
The query grouped customers by the sex field, counted the
number of customers in each category, and calculated each
category's percentage of the total customer population.

Business Insight:
The customer population is predominantly male (76.61%),
while 23.34% are female. Only 0.05% of records contained
unknown or invalid values, indicating high data quality
for this attribute after cleaning.
*/

-- ============================================
-- 2. Customer Age Statistics
-- ============================================

SELECT
    ROUND(AVG(customer_age), 2) AS average_age,
    MIN(customer_age) AS youngest_customer,
    MAX(customer_age) AS oldest_customer
FROM dim_customers;
/*
Purpose:
Calculate the average, minimum, and maximum customer ages to gain
a general understanding of the customer age distribution.

Technical Interpretation:
The query uses aggregate functions to summarize the customer_age
column. AVG() calculates the average age, MIN() identifies the
youngest customer, and MAX() identifies the oldest customer.
ROUND() formats the average age to two decimal places. Because
invalid ages were converted to NULL during data cleaning, SQLite
automatically excludes those records from the calculations.

Business Insight:
The recorded customer ages range from 3 to 100 years, indicating
that the business serves customers across a wide age range.
However, the presence of very young customers (e.g., age 3) may
reflect family accounts, guardian purchases, or limitations in the
source data rather than actual purchasers. Additional business
context would be needed to determine the exact meaning of these
records before drawing business conclusions.
*/

-- ============================================
-- 3. Customer Age Group Distribution
-- ============================================

SELECT
    CASE
        WHEN customer_age BETWEEN 0 AND 17 THEN '0-17'
        WHEN customer_age BETWEEN 18 AND 24 THEN '18-24'
        WHEN customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN customer_age BETWEEN 45 AND 54 THEN '45-54'
        WHEN customer_age BETWEEN 55 AND 64 THEN '55-64'
        WHEN customer_age >= 65 THEN '65+'
        ELSE 'Unknown'
    END AS age_group,

    COUNT(*) AS customer_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dim_customers),
        2
    ) AS percentage_of_customers

FROM dim_customers

GROUP BY age_group

ORDER BY
CASE
    WHEN age_group='0-17' THEN 1
    WHEN age_group='18-24' THEN 2
    WHEN age_group='25-34' THEN 3
    WHEN age_group='35-44' THEN 4
    WHEN age_group='45-54' THEN 5
    WHEN age_group='55-64' THEN 6
    WHEN age_group='65+' THEN 7
    ELSE 8
END;
/*
Purpose:
Group customers into predefined age categories to better understand
the age distribution of the customer base and identify the largest
customer segments.

Technical Interpretation:
The CASE statement categorizes each customer into an age group based
on the customer_age value. Customers with NULL ages are assigned to
the 'Unknown' category through the ELSE condition. The query then
counts the number of customers in each age group, calculates the
percentage of the total customer population, and orders the results
in a logical age sequence using ORDER BY CASE.

Business Insight:
Customers aged 25–34 represent the largest known age group,
accounting for 31.45% of the customer base. However, 33.53% of
customers fall into the 'Unknown' category because their ages were
missing or invalid and were converted to NULL during data cleaning.
This indicates a significant limitation in the source data. While
the available data suggests the business primarily serves young
adults, improving age data quality would allow for more accurate
customer segmentation and marketing decisions.
*/

-- ============================================
-- 4. Customer Tenure Statistics
-- ============================================

SELECT
    ROUND(AVG(tenure), 2) AS average_tenure,
    MIN(tenure) AS minimum_tenure,
    MAX(tenure) AS maximum_tenure
FROM dim_customers;
/*
Purpose:
Calculate the average, minimum, and maximum customer tenure to
understand the overall length of customer relationships recorded
in the dataset.

Technical Interpretation:
The query uses aggregate functions to summarize the tenure column.
AVG() calculates the average tenure, MIN() identifies the shortest
recorded tenure, and MAX() identifies the longest recorded tenure.
ROUND() formats the average tenure to two decimal places for
improved readability.

Business Insight:
The average customer tenure is 44.40 tenure units, with values
ranging from 4 to 133. These results suggest that the dataset
contains both relatively new and long-term customers. However,
because the dataset does not specify the unit of measurement for
tenure (e.g., months or years), the values should be interpreted
using the dataset's recorded units rather than assuming a specific
time period.
*/

-- ============================================
-- 5. Customer Tenure Group Distribution
-- ============================================

SELECT
    CASE
        WHEN tenure BETWEEN 0 AND 12 THEN '0-12'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24'
        WHEN tenure BETWEEN 25 AND 36 THEN '25-36'
        WHEN tenure BETWEEN 37 AND 48 THEN '37-48'
        WHEN tenure BETWEEN 49 AND 60 THEN '49-60'
        WHEN tenure > 60 THEN '60+'
        ELSE 'Unknown'
    END AS tenure_group,

    COUNT(*) AS customer_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dim_customers),
        2
    ) AS percentage_of_customers

FROM dim_customers

GROUP BY tenure_group

ORDER BY
CASE
    WHEN tenure_group = '0-12' THEN 1
    WHEN tenure_group = '13-24' THEN 2
    WHEN tenure_group = '25-36' THEN 3
    WHEN tenure_group = '37-48' THEN 4
    WHEN tenure_group = '49-60' THEN 5
    WHEN tenure_group = '60+' THEN 6
    ELSE 7
END;
/*
Purpose:
Group customers into tenure categories to analyze customer loyalty
and understand how customer relationships are distributed across
different tenure ranges.

Technical Interpretation:
The CASE statement categorizes customers into predefined tenure
groups based on their tenure values. The query counts the number
of customers in each group, calculates the percentage of the total
customer population, and orders the groups logically using
ORDER BY CASE.

Business Insight:
The largest customer segment (24.58%) has a tenure greater than
60 units, suggesting that a substantial portion of customers have
maintained long-term relationships with the business. The second
largest group (21.09%) falls within the 25–36 tenure range,
indicating a healthy base of established customers. Only 10.79%
of customers are in the 0–12 tenure group, suggesting that the
customer base is primarily composed of existing rather than newly
acquired customers. Since the dataset does not specify the unit
of tenure, these findings should be interpreted using the recorded
tenure values rather than assuming a specific time period.
*/

-- ============================================
-- 6. Overall Purchase Summary
-- ============================================

SELECT
    COUNT(*) AS total_purchase_records,
    COUNT(DISTINCT customer_id) AS customers_with_purchase_records,
    COUNT(DISTINCT product_id) AS unique_products,
    SUM(basket_count) AS total_items_purchased,
    ROUND(AVG(basket_count), 2) AS average_items_per_record
FROM fact_baskets;

/*
Purpose:
Generate a high-level summary of the purchase records to understand
the overall size and characteristics of the purchasing data. This
summary provides key metrics that establish a baseline for further
analysis of customer purchasing behavior.

Technical Interpretation:
The query counts the total number of purchase records, the number
of unique customers who made purchases, the number of distinct
products purchased, the total quantity of items purchased using
the basket_count column, and the average number of items recorded
per purchase record. Since the dataset does not contain a basket
or transaction identifier, each row is treated as an individual
purchase record.

Business Insight:
The dataset contains 15,000 purchase records from 13,871 unique
customers involving 13,161 distinct products. Across all purchase
records, customers purchased a total of 32,306 items, averaging
2.15 items per purchase record. The large number of unique
products compared to the number of purchase records suggests a
diverse product catalog with relatively few repeated purchases of
the same product. Because the dataset does not include a basket
or transaction identifier, the analysis is performed at the
purchase-record level rather than at the transaction level.
*/

-- ============================================
-- 7. Top 10 Most Purchased Products
-- ============================================

SELECT
    product_id,
    SUM(basket_count) AS total_items_purchased,
    COUNT(*) AS purchase_records
FROM fact_baskets
GROUP BY product_id
ORDER BY total_items_purchased DESC
LIMIT 10;
/*
Business Question:
Which products are purchased most frequently based on the total
number of items purchased?

Purpose:
Identify the highest-performing products by calculating the total
quantity purchased and the number of purchase records for each
product. This helps determine which products contribute most to
overall purchasing activity.

Technical Interpretation:
The query groups purchase records by product_id and uses SUM() to
calculate the total quantity purchased for each product. COUNT(*)
calculates the number of purchase records associated with each
product. The results are sorted in descending order of total items
purchased, and LIMIT 10 returns only the ten highest-performing
products.

Key Findings:
- Product 43524799 ranked first with 69 total items purchased
  across 32 purchase records.
- The second and third highest-ranked products recorded 59 and
  50 total items purchased, respectively.
- A noticeable decrease in purchase volume occurs after the top
  three products.

Business Insight:
The analysis indicates that a relatively small number of products
generate the highest purchase volumes. These products may represent
key revenue drivers and should be monitored for inventory
availability, demand forecasting, and promotional planning.
Comparing total items purchased with purchase records also reveals
that customers sometimes purchase multiple units of the same
product within a single purchase record.
*/

-- ============================================
-- 8. Contribution of Top 10 Products
-- ============================================

SELECT
    SUM(total_items_purchased)
FROM
(
    SELECT
        product_id,
        SUM(basket_count) AS total_items_purchased
    FROM fact_baskets
    GROUP BY product_id
    ORDER BY total_items_purchased DESC
    LIMIT 10
) AS top10_products;

SELECT
    top10_total_items,
    overall_total_items,
    ROUND(
        top10_total_items * 100.0 / overall_total_items,
        2
    ) AS top10_percentage
FROM
(
    SELECT
        (
            SELECT SUM(total_items_purchased)
            FROM
            (
                SELECT
                    product_id,
                    SUM(basket_count) AS total_items_purchased
                FROM fact_baskets
                GROUP BY product_id
                ORDER BY total_items_purchased DESC
                LIMIT 10
            ) AS top10_products
        ) AS top10_total_items,

        (
            SELECT SUM(basket_count)
            FROM fact_baskets
        ) AS overall_total_items
);
-- ============================================
-- 8. Contribution of the Top 10 Products
-- ============================================

/*
Business Question:
What percentage of total purchased items is contributed by the
Top 10 most-purchased products?

Purpose:
The purpose of this analysis is to determine whether purchase volume
is concentrated among a small number of products or distributed across
a large product assortment.

The previous analysis identified the Top 10 most-purchased products.
This query combines the purchase volume of those products so it can be
compared with the total number of items purchased in the dataset.

Technical Interpretation:
The inner query groups the data by product_id and calculates the total
number of items purchased for each product using SUM(basket_count).

The results are sorted from highest to lowest purchase volume, and
LIMIT 10 keeps only the Top 10 products.

The inner query is placed inside parentheses and treated as a temporary
table named top10_products.

The outer query then adds together the total_items_purchased values for
those 10 products.

Key Findings:
The Top 10 products accounted for 364 purchased items.

The dataset contains 32,306 purchased items overall.

The Top 10 product contribution was calculated as:

364 / 32,306 * 100 = 1.13%

Therefore, the Top 10 products contributed approximately 1.13% of the
total purchased items in the dataset.

Business Insight:
The Top 10 products represent only a small portion of total purchase
volume. This suggests that customer purchasing activity is distributed
across a broad range of products rather than being heavily concentrated
among a few bestsellers.

This may indicate that the business has a highly diversified product
portfolio and is not strongly dependent on a small number of products.

However, additional analysis would be needed to determine whether this
distribution reflects healthy product variety or a highly fragmented
catalog containing many products with low purchase volume.

This analysis measures item volume only. Revenue and profitability
cannot be evaluated because product prices and costs are not available
in the dataset.
*/