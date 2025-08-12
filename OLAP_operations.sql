-- 1. Database Creation
CREATE DATABASE sales_data;

USE sales_data;

CREATE TABLE sales_sample (
    Product_Id INTEGER,
    Region VARCHAR(50),
    Date DATE,
    Sales_Amount NUMERIC
);

-- DESC sales_sample;

-- 2. Data Creation
INSERT INTO sales_sample (Product_Id, Region, Date, Sales_Amount) VALUES
(1, 'East', '2025-01-15', 1500),
(2, 'West', '2025-01-15', 2000),
(1, 'North', '2025-01-16', 1800),
(3, 'South', '2025-01-16', 2100),
(2, 'East', '2025-01-17', 1600),
(3, 'West', '2025-01-17', 2200),
(1, 'South', '2025-01-18', 1900),
(2, 'North', '2025-01-18', 2300),
(3, 'East', '2025-01-19', 1700),
(1, 'West', '2025-01-19', 2400);

-- Verify the inserted data
SELECT * FROM sales_sample;

-- 3. Drill Down - Analyze sales data at a more detailed level
-- Drill down from region to product level to understand sales performance
SELECT 
    Region,
    Product_Id,
    COUNT(*) as Number_of_Sales,
    SUM(Sales_Amount) as Total_Sales
FROM sales_sample
GROUP BY Region, Product_Id
ORDER BY Region, Product_Id;

-- 4. Rollup - To summarize sales data at different levels of granularity
SELECT 
    IFNULL(Region, 'All Regions') as Region,
    IFNULL(CAST(Product_Id AS CHAR), 'All Products') as Product_Id,
    SUM(Sales_Amount) as Total_Sales
FROM sales_sample
GROUP BY Region, Product_Id
UNION ALL
SELECT 
    Region,
    'All Products',
    SUM(Sales_Amount)
FROM sales_sample
GROUP BY Region
UNION ALL
SELECT 
    'All Regions',
    'All Products',
    SUM(Sales_Amount)
FROM sales_sample
ORDER BY Region, Product_Id;

-- 5. Cube - To analyze sales data from multiple dimensions simultaneously
SELECT 
    Date,
    NULL as Region,
    NULL as Product_Id,
    SUM(Sales_Amount) as Total_Sales,
    'By Date' as Analysis_Dimension
FROM sales_sample
GROUP BY Date

UNION ALL

SELECT 
    NULL as Date,
    Region,
    NULL as Product_Id,
    SUM(Sales_Amount),
    'By Region' as Analysis_Dimension
FROM sales_sample
GROUP BY Region

UNION ALL

SELECT 
    NULL as Date,
    NULL as Region,
    Product_Id,
    SUM(Sales_Amount),
    'By Product' as Analysis_Dimension
FROM sales_sample
GROUP BY Product_Id

ORDER BY Analysis_Dimension;

-- 6. Slice - Extract data for specific date range (2025-01-15 to 2025-01-17)
SELECT 
    Date,
    Product_Id,
    Region,
    Sales_Amount
FROM sales_sample
WHERE Date BETWEEN '2025-01-15' AND '2025-01-17'
ORDER BY Date;

-- 7. Dice - Extract data for East region, Product 1, and date range (2025-01-15 to 2025-01-17)
SELECT 
    Date,
    Product_Id,
    Region,
    Sales_Amount
FROM sales_sample
WHERE Region = 'East'
    AND Product_Id = 1
    AND Date BETWEEN '2025-01-15' AND '2025-01-17'
ORDER BY Date;
