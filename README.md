# Retail Transaction Analysis Using SQL

## Overview

This project demonstrates a complete SQL-based data analytics workflow using retail transaction data. The analysis includes dataset exploration, data validation, data cleaning, data quality assessment, exploratory data analysis, and business-focused reporting.

The goal of the project is to identify transaction patterns, product trends, basket-size behavior, monthly purchasing activity, and actionable business insights while documenting important data-quality findings and dataset limitations.

## Business Problem

A retail business wants to better understand its transaction activity, product demand, customer demographics, basket sizes, and monthly purchasing trends.

The company needs reliable analysis that can support decisions related to product promotions, cross-selling opportunities, customer segmentation, and performance reporting. Before producing these insights, the data must first be explored, validated, cleaned, and assessed for quality.

## Project Objectives

- Explore the structure and contents of the source data
- Validate row counts, data types, missing values, and duplicate records
- Clean and standardize customer and transaction fields
- Create analysis-ready dimension and fact tables
- Assess data relationships and identify dataset limitations
- Analyze product demand, basket sizes, customer demographics, and monthly trends
- Translate SQL results into clear business insights

## Dataset

The project uses two original source tables:

| Table | Description |
|-------|-------------|
| `customer_details` | Contains customer demographic information, including customer ID, age, sex, and tenure. |
| `basket_details` | Contains transaction-level purchase records, including product IDs, basket sizes, and purchase dates. |

To support efficient analysis, two cleaned tables were created:

| Table | Description |
|-------|-------------|
| `dim_customers` | Cleaned customer dimension table with standardized demographic information. |
| `fact_baskets` | Cleaned transaction fact table used for business analysis. |

## Tools Used

- SQL
- SQLiteStudio (Letos)
- GitHub

## Project Workflow

| Step | Description |
|------|-------------|
| Dataset Exploration | Explored the structure, contents, and quality of the raw data. |
| Data Validation | Verified row counts, data types, missing values, and duplicate records. |
| Data Cleaning | Standardized customer and transaction data into clean analysis-ready tables. |
| Data Quality Assessment | Confirmed the accuracy and consistency of the cleaned data. |
| Exploratory Data Analysis | Explored purchasing patterns, customer demographics, and transaction trends. |
| Business Questions | Answered business-focused questions and translated SQL results into actionable insights. |

## Key Business Insights

- The majority of transactions contained **two purchased items**, indicating relatively small basket sizes.
- Monthly transaction activity declined from **May to June**, highlighting changes in purchasing patterns over time.
- Product demand was concentrated among a small number of products, suggesting opportunities for inventory optimization and targeted promotions.
- Data validation revealed that only a subset of customer IDs matched between the customer and transaction datasets. This limitation was documented and considered throughout customer-level analyses to ensure accurate reporting.

## SQL Skills Demonstrated

This project demonstrates practical experience with:

- Data Exploration
- Data Validation
- Data Cleaning
- Data Quality Assessment
- Exploratory Data Analysis (EDA)
- Data Modeling (Dimension & Fact Tables)
- Joins
- Aggregate Functions
- CASE Statements
- GROUP BY and HAVING
- Common Table Expressions (CTEs)
- Subqueries
- Date Analysis
- Business Reporting
- SQL Documentation and Commenting

## Repository Structure

```text
Retail-Transaction-Analysis-SQL
│
├── Database
│   └── RetailTransactionAnalysis.db
│
├── Images
│
├── SQL_Files
│   ├── 00_Dataset_Exploration.sql
│   ├── 01_Data_Validation.sql
│   ├── 02_Data_Cleaning.sql
│   ├── 03_Data_Quality_Assessment.sql
│   ├── 04_Exploratory_Data_Analysis.sql
│   ├── 05_Business_Questions.sql
│   └── 09_SQL_Reference_Queries.sql
│
└── README.md
```

## Future Improvements

Planned enhancements for this project include:

- Creating an interactive Power BI dashboard to visualize key business insights
- Expanding the dataset to support more comprehensive customer-level analysis
- Incorporating additional sales and product information to generate deeper business insights

## About the Author

Hi, I'm **Amina Ajmal**, a Business Analytics graduate from **William Paterson University of New Jersey**.

I'm currently building a portfolio of hands-on analytics projects to strengthen my skills in **SQL, Excel, Python, and Power BI** while pursuing opportunities as a **Data Analyst** or **Business Analyst**.

Through these projects, I aim to demonstrate my ability to clean, analyze, and interpret data to solve real-world business problems and support data-driven decision-making.

**LinkedIn:** [Amina Ajmal](https://www.linkedin.com/in/amina-ajmal-262895285/)

**Portfolio Website:** *(Coming Soon)*

Thank you for taking the time to review my project!
Thank you for taking the time to review my project!
