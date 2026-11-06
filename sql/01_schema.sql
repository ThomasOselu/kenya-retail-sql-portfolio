-- Kenya Retail Sales & Inventory Analytics
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS inventory_snapshots;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS stores;

CREATE TABLE stores (
    store_id INTEGER PRIMARY KEY,
    store_name TEXT NOT NULL,
    county TEXT NOT NULL
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    unit_cost REAL NOT NULL CHECK (unit_cost >= 0),
    list_price REAL NOT NULL CHECK (list_price >= 0)
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    town TEXT,
    customer_segment TEXT NOT NULL
);

CREATE TABLE sales (
    sale_id INTEGER PRIMARY KEY,
    sale_date TEXT NOT NULL,
    store_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price REAL NOT NULL CHECK (unit_price >= 0),
    discount_amount REAL NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE inventory_snapshots (
    snapshot_date TEXT NOT NULL,
    store_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    stock_on_hand INTEGER NOT NULL CHECK (stock_on_hand >= 0),
    PRIMARY KEY (snapshot_date, store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_store ON sales(store_id);
CREATE INDEX idx_sales_product ON sales(product_id);
CREATE INDEX idx_inventory_date ON inventory_snapshots(snapshot_date);
