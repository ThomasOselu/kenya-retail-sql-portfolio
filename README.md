# Kenya Retail Sales & Inventory Analytics (SQL Portfolio Project)

## Project overview
A portfolio-ready SQL analytics project using a fictional Kenyan retail chain. It analyzes sales, product performance, store performance, customer repeat activity, gross margin, and inventory risk. All monetary values are in Kenyan shillings (KES).

**Dataset note:** All records are synthetic and generated for learning and demonstration. They do not represent a real company or real customers.

## Business questions
1. How much net revenue and how many units did the business sell?
2. Which months, stores, counties, products, and categories perform best?
3. Is revenue improving month over month?
4. Which customers contribute the most revenue, and what share are repeat customers?
5. Which products may need replenishment?
6. Which categories deliver the highest estimated gross profit and margin?

## SQL skills demonstrated
- Relational database design, primary keys, foreign keys and indexes
- Joins and aggregations (`JOIN`, `GROUP BY`, `HAVING`)
- Conditional logic (`CASE`)
- Common table expressions (`WITH`)
- Window functions (`LAG`, `ROW_NUMBER`, windowed `SUM`)
- Date functions, null handling and division-by-zero protection
- Data quality validation and business KPI definition

## Repository structure
```text
kenya-retail-sql-portfolio/
├── data/
│   ├── customers.csv
│   ├── inventory_snapshots.csv
│   ├── products.csv
│   ├── sales.csv
│   └── stores.csv
├── sql/
│   ├── 01_schema.sql
│   ├── 02_analysis_queries.sql
│   └── 03_data_quality_checks.sql
├── database/
│   └── kenya_retail.db
└── README.md
```

## Step-by-step: run with SQLite

### Option A — DB Browser for SQLite (beginner-friendly)
1. Install **DB Browser for SQLite** from https://sqlitebrowser.org/.
2. Extract this repository ZIP.
3. Open `database/kenya_retail.db` using **Open Database**.
4. Select the **Execute SQL** tab.
5. Open and run `sql/02_analysis_queries.sql` one query at a time (highlight a query and press the play button).
6. Run `sql/03_data_quality_checks.sql` to validate the data.
7. Export useful query results as CSV and use them in Excel or Power BI for a dashboard.

### Option B — SQLite command line
From the project root:
```bash
sqlite3 database/kenya_retail.db
```
Then run:
```sql
.read sql/02_analysis_queries.sql
.read sql/03_data_quality_checks.sql
```
If SQLite is not installed, install it from https://www.sqlite.org/download.html.

## Rebuild the database from CSV files
The included database is ready to query. To rebuild it:
1. Create an empty SQLite database named `database/kenya_retail.db`.
2. Run `sql/01_schema.sql`.
3. Import each CSV into its matching table using DB Browser's **File > Import > Table from CSV file**.
4. Import in this order: `stores.csv`, `products.csv`, `customers.csv`, `sales.csv`, `inventory_snapshots.csv`.
5. Ensure the imported column names match the CSV headers.

## Recommended GitHub workflow
1. Create a new public GitHub repository named `kenya-retail-sql-portfolio`.
2. Upload the folders and files in this project.
3. Keep the README at the repository root.
4. Add screenshots of at least four query results: monthly revenue, top products, store performance, and low-stock watchlist.
5. Add a short `Insights & Recommendations` section to your README based on the results you actually run. Do not invent findings.
6. Pin the repository on your GitHub profile.

## How to make this project stand out
- Add a Power BI dashboard with cards for net revenue, units sold, average transaction value, and repeat-customer rate.
- Add a monthly revenue line chart, revenue by county bar chart, category contribution chart, and low-stock table.
- Include a short business recommendation for each major finding.
- Explain assumptions: revenue = quantity × unit price − discount; gross profit is estimated using product unit cost; inventory is a monthly snapshot, not a live stock ledger.

## Suggested CV bullet
Built a SQL retail analytics project using SQLite to analyze 8-store sales and inventory data, applying joins, CTEs, window functions, KPI calculations and data-quality checks to identify revenue trends, high-performing products, customer value and stock-replenishment risks.

## Important interpretation notes
- `sales` contains transaction line items; each row is one product line, not necessarily one customer basket.
- Therefore, the repeat-customer metric uses distinct sale IDs in this simulated dataset. In a real business, use a true invoice/order ID to measure repeat orders.
- Gross profit is an estimate and assumes the current product unit cost applies to all 2025 sales.
- Inventory snapshots are generated monthly and are not directly reconciled against daily sales.
