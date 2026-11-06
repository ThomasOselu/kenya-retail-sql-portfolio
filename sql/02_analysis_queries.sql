-- Run these queries after importing the CSV files.
-- Revenue is net sales after discounts. All values are in KES.

-- 1. Overall business KPIs
SELECT
    COUNT(*) AS transaction_lines,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price - discount_amount), 2) AS net_revenue_kes,
    ROUND(SUM(discount_amount), 2) AS discounts_kes,
    ROUND(AVG(quantity * unit_price - discount_amount), 2) AS avg_line_value_kes
FROM sales;

-- 2. Monthly revenue trend
SELECT
    strftime('%Y-%m', sale_date) AS sales_month,
    ROUND(SUM(quantity * unit_price - discount_amount), 2) AS revenue_kes,
    SUM(quantity) AS units_sold
FROM sales
GROUP BY sales_month
ORDER BY sales_month;

-- 3. Month-on-month revenue change using a window function
WITH monthly AS (
    SELECT strftime('%Y-%m', sale_date) AS sales_month,
           SUM(quantity * unit_price - discount_amount) AS revenue
    FROM sales
    GROUP BY strftime('%Y-%m', sale_date)
),
with_previous AS (
    SELECT sales_month, revenue,
           LAG(revenue) OVER (ORDER BY sales_month) AS previous_month_revenue
    FROM monthly
)
SELECT sales_month,
       ROUND(revenue, 2) AS revenue_kes,
       ROUND(previous_month_revenue, 2) AS previous_month_kes,
       ROUND(100.0 * (revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0), 2) AS mom_change_pct
FROM with_previous
ORDER BY sales_month;

-- 4. Best performing products
SELECT p.product_name, p.category,
       SUM(s.quantity) AS units_sold,
       ROUND(SUM(s.quantity*s.unit_price-s.discount_amount), 2) AS revenue_kes
FROM sales s
JOIN products p ON p.product_id=s.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue_kes DESC
LIMIT 10;

-- 5. Revenue by county / store
SELECT st.county, st.store_name,
       ROUND(SUM(s.quantity*s.unit_price-s.discount_amount), 2) AS revenue_kes,
       COUNT(DISTINCT s.sale_id) AS transaction_lines
FROM sales s
JOIN stores st ON st.store_id=s.store_id
GROUP BY st.county, st.store_id, st.store_name
ORDER BY revenue_kes DESC;

-- 6. Category contribution to revenue
WITH category_sales AS (
    SELECT p.category,
           SUM(s.quantity*s.unit_price-s.discount_amount) AS revenue
    FROM sales s JOIN products p ON p.product_id=s.product_id
    GROUP BY p.category
)
SELECT category, ROUND(revenue,2) AS revenue_kes,
       ROUND(100.0*revenue/SUM(revenue) OVER (),2) AS revenue_share_pct
FROM category_sales
ORDER BY revenue DESC;

-- 7. Customer value and segmentation
SELECT c.customer_segment, c.customer_id, c.customer_name,
       COUNT(DISTINCT s.sale_id) AS purchase_lines,
       ROUND(SUM(s.quantity*s.unit_price-s.discount_amount),2) AS lifetime_revenue_kes
FROM customers c
JOIN sales s ON s.customer_id=c.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_segment
ORDER BY lifetime_revenue_kes DESC
LIMIT 20;

-- 8. Repeat customer rate (customer has more than one distinct sale line)
WITH customer_activity AS (
    SELECT customer_id, COUNT(DISTINCT sale_id) AS purchases
    FROM sales GROUP BY customer_id
)
SELECT COUNT(*) AS active_customers,
       SUM(CASE WHEN purchases > 1 THEN 1 ELSE 0 END) AS repeat_customers,
       ROUND(100.0*SUM(CASE WHEN purchases > 1 THEN 1 ELSE 0 END)/COUNT(*),2) AS repeat_customer_pct
FROM customer_activity;

-- 9. Latest inventory position by product and store
WITH ranked_inventory AS (
    SELECT *, ROW_NUMBER() OVER (
        PARTITION BY store_id, product_id ORDER BY snapshot_date DESC
    ) AS rn
    FROM inventory_snapshots
)
SELECT st.store_name, p.product_name, ri.snapshot_date, ri.stock_on_hand
FROM ranked_inventory ri
JOIN stores st ON st.store_id=ri.store_id
JOIN products p ON p.product_id=ri.product_id
WHERE ri.rn=1 AND ri.stock_on_hand <= 10
ORDER BY ri.stock_on_hand, st.store_name;

-- 10. Estimated gross profit by category
SELECT p.category,
       ROUND(SUM(s.quantity*s.unit_price-s.discount_amount),2) AS net_revenue_kes,
       ROUND(SUM(s.quantity*p.unit_cost),2) AS estimated_cost_kes,
       ROUND(SUM(s.quantity*s.unit_price-s.discount_amount)-SUM(s.quantity*p.unit_cost),2) AS estimated_gross_profit_kes,
       ROUND(100.0*(SUM(s.quantity*s.unit_price-s.discount_amount)-SUM(s.quantity*p.unit_cost))
             / NULLIF(SUM(s.quantity*s.unit_price-s.discount_amount),0),2) AS gross_margin_pct
FROM sales s JOIN products p ON p.product_id=s.product_id
GROUP BY p.category
ORDER BY estimated_gross_profit_kes DESC;

-- 11. Products with high sales but low latest stock (replenishment watchlist)
WITH product_demand AS (
    SELECT store_id, product_id, SUM(quantity) AS units_sold
    FROM sales
    WHERE sale_date >= '2025-10-01'
    GROUP BY store_id, product_id
),
latest_stock AS (
    SELECT store_id, product_id, stock_on_hand
    FROM (
        SELECT *, ROW_NUMBER() OVER (
            PARTITION BY store_id, product_id ORDER BY snapshot_date DESC
        ) AS rn
        FROM inventory_snapshots
    )
    WHERE rn=1
)
SELECT st.store_name, p.product_name, COALESCE(d.units_sold,0) AS units_sold_last_quarter,
       COALESCE(ls.stock_on_hand,0) AS latest_stock
FROM product_demand d
JOIN stores st ON st.store_id=d.store_id
JOIN products p ON p.product_id=d.product_id
LEFT JOIN latest_stock ls ON ls.store_id=d.store_id AND ls.product_id=d.product_id
WHERE COALESCE(ls.stock_on_hand,0) < 15
ORDER BY units_sold_last_quarter DESC
LIMIT 30;
