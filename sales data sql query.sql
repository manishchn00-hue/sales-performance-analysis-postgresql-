--A. CREATE TABLE (SCHEMA)
CREATE TABLE sales_data (
    order_id VARCHAR(20),
    order_date TIMESTAMP,
    ship_date TIMESTAMP,
    customer_id INT,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(50),
    product_id INT,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(50),
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(4,2),
    profit NUMERIC(10,2)
);


--B. LOAD DATASET INTO POSTGRESQL
COPY sales_data
FROM 'D:/PROJECT/sales-performance-analysis-postgresql/data/raw/sales_performance_postgresql.csv'
DELIMITER ','CSV HEADER;


--C. VERIFY DATA (VERY IMPORTANT)
SELECT COUNT(*) FROM sales_data;
SELECT * FROM sales_data LIMIT 10;
SELECT MIN(order_date), MAX(order_date) FROM sales_data;


--D. BASIC DATA CHECKS(Check NULL values)
SELECT * FROM sales_data WHERE sales IS NULL OR profit IS NULL;


--E. KPI ANALYSIS
--1. Total Sales
SELECT SUM(sales) AS total_sales FROM sales_data;

--2. Total Profit
SELECT SUM(profit) AS total_profit FROM sales_data;

--3.Profit Margin
SELECT (SUM(profit)/SUM(sales))*100 AS profit_margin FROM sales_data;


--F. TIME-SERIES ANALYSIS
--Monthly Sales Trend
SELECT DATE_TRUNC('month', order_date) AS month, SUM(sales) AS monthly_sales FROM sales_data GROUP BY month ORDER BY month;


--G. CATEGORY & PRODUCT ANALYSIS
--1. Category-wise Sales
SELECT category, SUM(sales) AS total_sales FROM sales_data GROUP BY category ORDER BY total_sales DESC;

--2. Top 10 Products
SELECT product_name, SUM(sales) AS total_sales FROM sales_data GROUP BY product_name ORDER BY total_sales DESC LIMIT 10;


--H. REGION & CUSTOMER ANALYSIS
--1. Region-wise Sales 
SELECT region, SUM(sales) AS total_sales FROM sales_data GROUP BY region ORDER BY total_sales DESC;

--2.Segment-wise Average Order Value
SELECT segment, AVG(sales) AS avg_order_value FROM sales_data GROUP BY segment;


--I. DISCOUNT & PROFIT ANALYSIS
SELECT discount, SUM(profit) AS total_profit FROM sales_data GROUP BY discount ORDER BY discount;


--J. ADVANCED SQL (WINDOW FUNCTION)
-- MONTHWISE TOTAL SALES & PREVIOUS MONTH SALES
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS total_sales
    FROM sales_data
    GROUP BY month
)
SELECT month,
       total_sales,
       LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales
FROM monthly_sales;





