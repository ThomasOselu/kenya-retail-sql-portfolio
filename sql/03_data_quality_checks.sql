-- Data quality checks: every query should return zero rows / zero counts where noted.

-- Duplicate primary keys (should return no rows)
SELECT sale_id, COUNT(*) AS row_count
FROM sales GROUP BY sale_id HAVING COUNT(*) > 1;

-- Sales with missing dimension matches (should return no rows if foreign keys were enforced)
SELECT s.*
FROM sales s
LEFT JOIN products p ON p.product_id=s.product_id
LEFT JOIN stores st ON st.store_id=s.store_id
LEFT JOIN customers c ON c.customer_id=s.customer_id
WHERE p.product_id IS NULL OR st.store_id IS NULL OR c.customer_id IS NULL;

-- Invalid quantities or negative financial values (should return no rows)
SELECT * FROM sales
WHERE quantity <= 0 OR unit_price < 0 OR discount_amount < 0
   OR discount_amount > quantity * unit_price;

-- Date coverage
SELECT MIN(sale_date) AS first_sale_date, MAX(sale_date) AS last_sale_date,
       COUNT(*) AS sales_rows
FROM sales;
