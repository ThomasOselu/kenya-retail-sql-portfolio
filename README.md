# Kenya Retail Sales & Inventory Analytics | SQL Portfolio Project

![SQL](https://img.shields.io/badge/SQL-SQLite-blue)
![Project](https://img.shields.io/badge/Project-Data%20Analytics-green)
![Status](https://img.shields.io/badge/Status-Completed%20Analysis-yellow)
![Dataset](https://img.shields.io/badge/Dataset-Synthetic-orange)

## 1. Project Overview

The **Kenya Retail Sales & Inventory Analytics Project** is an end-to-end SQL data analytics project designed to demonstrate practical data analysis, database management, business intelligence, and problem-solving skills.

The project simulates a retail business operating across eight branches in Kenya. The business collects sales, customer, product, store, and inventory information but needs to transform this data into meaningful insights to support management decisions.

Using SQL and SQLite, this project analyzes retail transactions, revenue performance, customer purchasing behaviour, product profitability, branch performance, and inventory levels.

The primary objective is to demonstrate how SQL can be used to transform raw business data into actionable insights that help organizations improve sales performance, profitability, customer retention, and inventory management.

**Project type:** Exploratory and business-focused data analysis  
**Industry:** Retail / FMCG  
**Geographical focus:** Kenya  
**Database:** SQLite  
**Language:** SQL  
**Tools:** SQLite, DB Browser for SQLite, Excel and Power BI (for optional visualization)

> **Dataset disclaimer:** This project uses synthetic data generated for educational and portfolio demonstration purposes. It does not represent actual transactions or customers from a real Kenyan retail company.

---

## 2. Business Problem

Retail businesses generate large volumes of transactional and inventory data every day. However, having data does not automatically translate into better business decisions.

Management needs answers to several important questions:

- How much revenue is the business generating?
- Which months record the highest and lowest sales?
- Which products contribute most to total revenue?
- Which branches perform best across different counties?
- Which customer segments generate the most revenue?
- How many customers make repeat purchases?
- Which products generate the highest estimated gross profit?
- Which branches have products with critically low inventory?
- What products should management prioritize for replenishment?

Without proper analysis, management may struggle to identify sales opportunities, monitor business performance, and control inventory costs.

This project addresses these challenges by using SQL to organize, analyze, and interpret the available business data.

---

## 3. Project Objectives

The main objectives are:

1. Design and manage a relational database for retail sales and inventory information.
2. Analyze overall sales performance and calculate key business KPIs.
3. Identify monthly revenue trends and changes in business performance.
4. Evaluate product and category performance.
5. Compare sales performance across different store locations.
6. Analyze customer purchasing behaviour and repeat purchases.
7. Estimate gross profit and gross profit margins.
8. Identify inventory shortages and potential replenishment requirements.
9. Perform data quality checks to improve the reliability of analysis.
10. Translate SQL findings into practical business recommendations.

---

## 4. Dataset Description

The project contains five datasets representing different aspects of the retail business.

| Dataset | Description | Records |
|---|---|---:|
| Sales | Retail transaction records | 6,881 |
| Products | Product names, categories and prices | 23 |
| Customers | Customer details and segments | 250 |
| Stores | Retail branches and counties | 8 |
| Inventory | Monthly inventory snapshots | 2,208 |

The dataset covers the period **January 2025 to December 2025**.

All monetary values are expressed in Kenyan Shillings (KES).

### 4.1 Sales Dataset

File: `sales.csv`

Contains transactional information about products sold across the retail branches.

| Column | Description |
|---|---|
| sale_id | Unique sales record identifier |
| sale_date | Date of the transaction |
| store_id | Identifier of the selling branch |
| product_id | Identifier of the product sold |
| customer_id | Identifier of the purchasing customer |
| quantity | Number of units sold |
| unit_price | Selling price per unit |
| discount_amount | Total discount applied to the sales line |

### 4.2 Products Dataset

File: `products.csv`

Contains product information.

| Column | Description |
|---|---|
| product_id | Unique product identifier |
| product_name | Name of the product |
| category | Product category |
| unit_cost | Estimated purchase cost per unit |
| list_price | Standard selling price |

Product categories include:

- Beverages
- Food
- Personal Care
- Household
- Snacks

### 4.3 Customers Dataset

File: `customers.csv`

Contains customer information used to understand purchasing patterns.

| Column | Description |
|---|---|
| customer_id | Unique customer identifier |
| customer_name | Customer name |
| town | Customer's town |
| customer_segment | Retail or Wholesale |

### 4.4 Stores Dataset

File: `stores.csv`

Contains information about the eight simulated retail branches.

| Column | Description |
|---|---|
| store_id | Unique branch identifier |
| store_name | Branch name |
| county | County where the branch operates |

The branches are located in:

- Nairobi CBD
- Westlands
- Thika
- Nakuru Town
- Mombasa Central
- Kisumu
- Eldoret
- Machakos

### 4.5 Inventory Dataset

File: `inventory_snapshots.csv`

Contains monthly stock information for different products across the branches.

| Column | Description |
|---|---|
| snapshot_date | Date of the inventory snapshot |
| store_id | Branch identifier |
| product_id | Product identifier |
| stock_on_hand | Available inventory units |

---

## 5. Database Design and Relationships

The project uses a relational database structure to organize information and minimize unnecessary duplication.

### Database tables

- `sales`
- `products`
- `customers`
- `stores`
- `inventory_snapshots`

### Table relationships

The sales table connects to the products, customers, and stores tables through their respective identifiers.

The inventory table connects to products and stores to track stock levels across branches.

```text
                 PRODUCTS
                     |
                     |
CUSTOMERS ------ SALES ------ STORES
                     |
                     |
                Transaction
                 Analysis

              INVENTORY_SNAPSHOTS
                  /        \
             PRODUCTS     STORES
```

Primary keys and foreign keys are used to establish relationships and maintain referential integrity.

Indexes are also created on frequently queried columns to support efficient data retrieval.

---

## 6. Tools and Technologies

| Tool | Purpose |
|---|---|
| SQL | Data extraction, transformation and analysis |
| SQLite | Relational database management |
| DB Browser for SQLite | Database exploration and query execution |
| Microsoft Excel | Optional analysis and reporting |
| Power BI | Optional interactive dashboard development |
| GitHub | Project version control and portfolio presentation |

### SQL concepts demonstrated

This project demonstrates practical knowledge of:

- SELECT statements
- WHERE and ORDER BY
- GROUP BY and HAVING
- Aggregate functions
- INNER JOIN and LEFT JOIN
- CASE statements
- Common Table Expressions (CTEs)
- Subqueries
- Window functions
- LAG()
- ROW_NUMBER()
- Date functions
- NULLIF()
- Data quality validation
- Index creation
- Relational database design

---

## 7. Business Analysis and SQL Queries

The analysis is organized around eleven key business questions.

### Analysis 1: Overall Business Performance

**Business question:** What is the overall sales performance of the retail business?

Key metrics:
- Total transaction lines
- Total units sold
- Total net revenue
- Total discounts
- Average sales line value

Revenue calculation:

```sql
SELECT
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    ROUND(
        SUM(quantity * unit_price - discount_amount), 2
    ) AS total_revenue
FROM sales;
```

**Business value:** Provides management with an overview of overall business performance.

### Analysis 2: Monthly Revenue Performance

**Business question:** How does revenue change throughout the year?

The analysis groups sales by month and calculates monthly revenue and units sold.

**Business value:** Helps identify revenue trends, seasonal patterns, and periods requiring additional marketing or sales activities.

### Analysis 3: Month-on-Month Revenue Growth

**Business question:** Is the business growing or experiencing declining sales?

The LAG() window function compares current monthly revenue against the previous month's revenue.

Growth formula:

Revenue Growth (%) =

(Current Month Revenue - Previous Month Revenue) / Previous Month Revenue × 100

**Business value:** Helps management monitor business growth and identify months requiring corrective action.

### Analysis 4: Top-Performing Products

**Business question:** Which products contribute most to business revenue?

The analysis joins the sales and products tables to calculate product-level revenue and quantities sold.

**Business value:** Helps identify high-performing products that should receive priority in marketing and inventory planning.

### Analysis 5: Branch and County Performance

**Business question:** Which retail branches generate the highest revenue?

The analysis combines sales and store information to compare revenue across the eight branches.

**Business value:** Supports branch performance evaluation, resource allocation, and regional sales strategies.

### Analysis 6: Product Category Contribution

**Business question:** Which product categories contribute most to total revenue?

The analysis calculates revenue contribution percentages for each product category.

**Business value:** Helps management understand product mix and identify categories with growth opportunities.

### Analysis 7: Customer Value Analysis

**Business question:** Which customers contribute most to the business?

Customer purchasing records are analyzed to identify customers with the highest lifetime revenue within the available dataset.

**Business value:** Helps support customer retention strategies and targeted marketing.

### Analysis 8: Repeat Customer Analysis

**Business question:** What proportion of active customers make repeat purchases?

The analysis identifies customers with multiple distinct sales records.

**Business value:** Helps management evaluate customer purchasing frequency and understand customer retention patterns.

### Analysis 9: Inventory Position Analysis

**Business question:** Which products have low stock levels across the retail branches?

The ROW_NUMBER() window function identifies the latest available monthly inventory snapshot for each product and store combination.

**Business value:** Helps management identify potential stock shortages and improve replenishment planning.

### Analysis 10: Product Category Profitability

**Business question:** Which product categories generate the highest estimated gross profit?

Estimated gross profit is calculated as:

Gross Profit = Net Revenue - Estimated Cost of Goods Sold

Gross Margin (%) = Gross Profit / Net Revenue × 100

**Business value:** Supports pricing, purchasing, and product portfolio decisions.

### Analysis 11: Inventory Replenishment Watchlist

**Business question:** Which products have relatively high recent sales demand but low recorded inventory?

The analysis combines recent sales performance with the latest inventory snapshots.

**Business value:** Helps management prioritize products for stock replenishment and reduce the risk of stockouts.

---

## 8. Key Performance Indicators (KPIs)

The project calculates the following business KPIs:

| KPI | Calculation |
|---|---|
| Net Revenue | Quantity × Unit Price - Discounts |
| Units Sold | SUM(Quantity) |
| Average Sales Line Value | Net Revenue / Transaction Lines |
| Monthly Revenue Growth | Current vs Previous Month |
| Product Revenue | Revenue grouped by Product |
| Category Contribution | Category Revenue / Total Revenue |
| Customer Revenue | Revenue grouped by Customer |
| Repeat Customer Rate | Repeat Customers / Active Customers |
| Estimated Gross Profit | Net Revenue - Estimated Product Cost |
| Gross Profit Margin | Estimated Gross Profit / Net Revenue |

All calculations are implemented using SQL.

---

## 9. Data Cleaning and Quality Assurance

Reliable analysis depends on reliable data.

The project includes a dedicated SQL script for checking data quality.

File: `sql/03_data_quality_checks.sql`

The following checks are performed:

1. Duplicate sales identifiers.
2. Missing product, store, and customer relationships.
3. Invalid or negative sales quantities.
4. Negative unit prices and discounts.
5. Discounts exceeding the gross sales amount.
6. Minimum and maximum transaction dates.

These checks help identify potential data problems before reporting results.

---

## 10. Repository Structure

The GitHub repository is organized as follows:

```text
kenya-retail-sql-portfolio/
│
├── data/
│   ├── customers.csv
│   ├── inventory_snapshots.csv
│   ├── products.csv
│   ├── sales.csv
│   └── stores.csv
│
├── database/
│   └── kenya_retail.db
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_analysis_queries.sql
│   └── 03_data_quality_checks.sql
│
├── README.md
│
└── GITHUB_UPLOAD_STEPS.txt
```

---

## 11. How to Run the Project

### Requirements

- Windows, macOS, or Linux computer.
- DB Browser for SQLite.
- GitHub account (for publishing the project).

### Step 1: Download the project

Clone the repository:

```bash
git clone https://github.com/YOUR-USERNAME/kenya-retail-sql-portfolio.git
```

Alternatively, download the repository as a ZIP file and extract it.

### Step 2: Open the database

1. Launch DB Browser for SQLite.
2. Select Open Database.
3. Navigate to the project directory.
4. Open `database/kenya_retail.db`.

### Step 3: Execute SQL queries

1. Select the Execute SQL tab.
2. Open `sql/02_analysis_queries.sql`.
3. Execute each query individually.
4. Review the returned results.
5. Export relevant results to CSV where necessary.

### Step 4: Run data quality checks

Open:

```text
sql/03_data_quality_checks.sql
```

Execute the queries and review the results.

### Step 5: Explore the results

Use the results to identify patterns, calculate KPIs, and develop business recommendations.

### Rebuilding the database

The database can also be recreated from the supplied CSV datasets.

1. Create an empty SQLite database.
2. Execute `sql/01_schema.sql`.
3. Import the CSV files into their corresponding tables.
4. Import parent tables before transactional tables:
   - Stores
   - Products
   - Customers
   - Sales
   - Inventory snapshots
5. Execute the analysis queries.

---

## 12. Business Recommendations

The purpose of data analysis is not simply to produce numbers. It is to help organizations make better decisions.

The following are the types of recommendations that can be developed from the analysis:

| Area | Potential business recommendation |
|---|---|
| Sales performance | Develop strategies to improve revenue during weak-performing months. |
| Product performance | Prioritize products with strong revenue contribution. |
| Branch performance | Investigate performance differences between branches. |
| Customer retention | Develop loyalty and repeat-purchase initiatives. |
| Inventory management | Prioritize replenishment of products with high demand and low stock. |
| Profitability | Review product pricing and purchasing costs to improve margins. |

**Note:** These are proposed analytical recommendations, not confirmed findings. Final recommendations should be based on the actual SQL query results.

---

## 13. Project Limitations and Assumptions

For transparency, the analysis uses the following assumptions:

1. All monetary values are denominated in KES.
2. All dataset records are synthetic.
3. Sales records represent transaction line items rather than complete customer baskets.
4. Customer repeat activity is measured using distinct sales record IDs. A production system should use a true invoice or order identifier.
5. Gross profit is estimated using the product unit cost provided in the dataset.
6. Product costs are assumed to remain constant during the analysis period.
7. Inventory records are monthly snapshots rather than real-time stock movements.
8. The replenishment analysis uses historical sales demand and recorded inventory positions; it does not calculate a fully validated reorder point or safety stock.
9. The dataset represents one calendar year, so longer-term seasonal conclusions cannot be established.

---

## 14. Future Improvements

The project can be extended by introducing additional technologies and more advanced analytical techniques.

Potential improvements include:

- Building an interactive Power BI sales dashboard.
- Developing automated SQL reporting.
- Adding customer RFM segmentation.
- Creating product demand forecasting models using Python.
- Introducing inventory turnover analysis.
- Calculating stockout and replenishment metrics using daily inventory movements.
- Implementing a more detailed customer retention analysis.
- Comparing performance across multiple financial years.
- Adding automated data quality reporting.

---

## 15. Skills Demonstrated

Through this project, I demonstrate practical capabilities in:

**Technical skills**
- SQL querying and analysis
- SQLite database management
- Relational database design
- Data extraction and transformation
- Data aggregation and manipulation
- Window functions and CTEs
- Data validation and quality assurance
- Business KPI calculations

**Analytical skills**
- Business performance analysis
- Sales trend analysis
- Customer behaviour analysis
- Product profitability analysis
- Inventory analysis
- Problem-solving
- Data-driven decision-making

**Business understanding**
- Retail operations
- Revenue management
- Customer retention
- Product performance
- Inventory management
- Business reporting

---

## 16. Conclusion

The Kenya Retail Sales & Inventory Analytics Project demonstrates how SQL can be applied to real-world business problems.

By combining relational database design, SQL queries, business KPI calculations, and data quality validation, the project provides a structured approach to understanding retail performance.

It also demonstrates the importance of converting raw transactional data into insights that support operational efficiency, revenue growth, profitability, and customer retention.

This project forms part of my continuous development as a Data Analyst, with a focus on applying technical skills to practical business challenges.

---

## 17. Author

**Thomas Oselu**

Aspiring Data Analyst | SQL | Excel | Power BI | Python

Nairobi, Kenya

- GitHub: [(https://github.com/ThomasOselu)]
- LinkedIn: [https://www.linkedin.com/in/thomas-oselu/](https://www.linkedin.com/in/thomas-oselu/)

**Interested in:** Data Analytics, Business Intelligence, Retail Analytics, Financial Analytics, and Data-Driven Decision Making.

---

*Thank you for exploring this project. Feedback and suggestions for improvement are welcome.*
