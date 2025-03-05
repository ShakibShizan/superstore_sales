DROP DATABASE superstore_db;

CREATE DATABASE superstore_db;
USE superstore_db;

CREATE TABLE superstore_sales (
    Row_ID INT PRIMARY KEY,
    Order_Priority VARCHAR(50),
    Discount DECIMAL(10,2),
    Unit_Price DECIMAL(10,2),
    Shipping_Cost DECIMAL(10,2),
    Customer_ID BIGINT,
    Customer_Name VARCHAR(300),
    Ship_Mode VARCHAR(50),
    Customer_Segment VARCHAR(50),
    Product_Category VARCHAR(50),
    Product_Sub_Category VARCHAR(50),
    Product_Container VARCHAR(50),
    Product_Name VARCHAR(500),
    Product_Base_Margin VARCHAR(100),
    Region VARCHAR(50),
    Manager VARCHAR(100),
    State_or_Province VARCHAR(100),
    Order_Date TEXT,
    Ship_Date TEXT,
    Profit DECIMAL(15,2),
    Quantity_ordered_new INT,
    Sales DECIMAL(15,2),
    Order_ID BIGINT,
    Return_Status VARCHAR(50)
);

SELECT COUNT(*) FROM superstore_sales; -- 9423
SELECT * FROM superstore_sales;



-- Necessary Cleaning

SELECT Row_ID, COUNT(*) AS Duplicate_Count
FROM superstore_sales
GROUP BY Row_ID
HAVING COUNT(*) > 1; -- Checking Duplicates

SET SQL_SAFE_UPDATES = 0;

SELECT ORDER_DATE, SHIP_DATE
FROM superstore_sales
WHERE Order_Date NOT REGEXP '^[0-9]+$' 
   OR  SHIP_DATE NOT REGEXP '^[0-9]+$';

DELETE FROM superstore_sales
WHERE Order_Date NOT REGEXP '^[0-9]+$'
   OR Ship_Date NOT REGEXP '^[0-9]+$'; -- 47 NON-NUMERIC VALUES DELETED

SELECT COUNT(*) FROM superstore_sales; -- 9376

SELECT 
	ORDER_DATE, 
    DATE_ADD('1899-12-30',INTERVAL Order_Date DAY)
FROM superstore_sales
WHERE ORDER_DATE NOT BETWEEN 35000 AND 42000;

DELETE FROM superstore_sales
WHERE ORDER_DATE NOT BETWEEN 35000 AND 42000; -- 254 rows extreme values deleted


SELECT COUNT(*) AS blank_null_rows FROM superstore_sales	-- FIND 72 BLANK ROWS
WHERE 
    Order_Priority IS NULL OR TRIM(Order_Priority) = '' OR
    Customer_Name IS NULL OR TRIM(Customer_Name) = '' OR
    Ship_Mode IS NULL OR TRIM(Ship_Mode) = '' OR
    Customer_Segment IS NULL OR TRIM(Customer_Segment) = '' OR
    Product_Category IS NULL OR TRIM(Product_Category) = '' OR
    Product_Sub_Category IS NULL OR TRIM(Product_Sub_Category) = '' OR
    Product_Container IS NULL OR TRIM(Product_Container) = '' OR
    Product_Name IS NULL OR TRIM(Product_Name) = '' OR
    Product_Base_Margin IS NULL OR TRIM(Product_Base_Margin) = '' OR
    Region IS NULL OR TRIM(Region) = '' OR
    Manager IS NULL OR TRIM(Manager) = '' OR
    State_or_Province IS NULL OR TRIM(State_or_Province) = '' OR
    Order_Date IS NULL OR TRIM(Order_Date) = '' OR
    Ship_Date IS NULL OR TRIM(Ship_Date) = '' OR
    Return_Status IS NULL OR TRIM(Return_Status) = '';
    
DELETE FROM superstore_sales
WHERE 
    Order_Priority IS NULL OR TRIM(Order_Priority) = '' OR
    Customer_Name IS NULL OR TRIM(Customer_Name) = '' OR
    Ship_Mode IS NULL OR TRIM(Ship_Mode) = '' OR
    Customer_Segment IS NULL OR TRIM(Customer_Segment) = '' OR
    Product_Category IS NULL OR TRIM(Product_Category) = '' OR
    Product_Sub_Category IS NULL OR TRIM(Product_Sub_Category) = '' OR
    Product_Container IS NULL OR TRIM(Product_Container) = '' OR
    Product_Name IS NULL OR TRIM(Product_Name) = '' OR
    Product_Base_Margin IS NULL OR TRIM(Product_Base_Margin) = '' OR
    Region IS NULL OR TRIM(Region) = '' OR
    Manager IS NULL OR TRIM(Manager) = '' OR
    State_or_Province IS NULL OR TRIM(State_or_Province) = '' OR
    Order_Date IS NULL OR TRIM(Order_Date) = '' OR
    Ship_Date IS NULL OR TRIM(Ship_Date) = '' OR
    Return_Status IS NULL OR TRIM(Return_Status) = '';

SELECT COUNT(*) FROM superstore_sales; -- 9050





-- BASIC INSIGHTS (EDA)
SELECT
    CONCAT(ROUND(AVG(DISCOUNT) * 100, 0), '%') AS AVERAGE_DISCOUNT,
    CONCAT('$ ', ROUND(AVG(SHIPPING_COST), 0)) AS AVERAGE_SHIPPING_COST,
    CONCAT(ROUND(AVG(Product_Base_Margin) * 100, 0), '%') AS AVERAGE_Product_Base_Margin,
    CONCAT('$ ', ROUND(ABS(SUM(PROFIT)), 0)) AS TOTAL_PROFIT,
    CONCAT('$ ', ROUND(SUM(SALES), 0)) AS TOTAL_SALES,
    CONCAT(ROUND(ABS((SUM(PROFIT)) / SUM(SALES)) * 100, 2), '%') AS PROFIT_MARGIN,
    COUNT(DISTINCT Order_ID) AS PLACED_ORDER,
    SUM(ABS(Quantity_ordered_new)) AS TOTAL_QUANTITY_ORDERED
FROM superstore_sales;

-- TOP PRODUCTS CATEGORY
SELECT 
    Product_Category,
    SUM(SALES) AS SALES,
    ABS(SUM(PROFIT)) AS PROFIT,
    CONCAT(ROUND(ABS(SUM(PROFIT)) / SUM(SALES) * 100, 2), '%') AS PROFIT_MARGIN
FROM superstore_sales
GROUP BY Product_Category
ORDER BY PROFIT_MARGIN;

-- TOP REGION CATEGORY
SELECT 
    Region,
    SUM(SALES) AS SALES,
    ABS(SUM(PROFIT)) AS PROFIT,
    CONCAT(ROUND(ABS(SUM(PROFIT)) / SUM(SALES) * 100, 2), '%') AS PROFIT_MARGIN
FROM superstore_sales
WHERE RETURN_STATUS NOT REGEXP '^[0-9]+$'
GROUP BY Region;


SELECT 
    RETURN_STATUS,
    COUNT(*) AS STATUS_COUNT,
    CONCAT(ROUND((COUNT(*) * 100.0) / SUM(COUNT(*)) OVER (), 2), '%') AS RATIO_PERCENT
FROM superstore_sales
WHERE RETURN_STATUS NOT REGEXP '^[0-9]+$'
GROUP BY RETURN_STATUS;



-- Transformation
SELECT 
	Order_Date,
    DATE_ADD('1899-12-30',INTERVAL Order_Date DAY) AS FORMATTED_ORDER_DATE,
    Ship_Date,
    DATE_ADD('1899-12-30',INTERVAL Ship_Date DAY) AS FORMATTED_SHIP_DATE
FROM
    superstore_sales; -- Assuming a valid range (1995 to 2013).
    

SELECT 
    ORDER_DATE,
    YEAR(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY)) AS Year,
    MONTHNAME(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY)) AS MONTH_NAME
FROM superstore_sales
ORDER BY ORDER_DATE;

SELECT 
    MIN(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY)) AS FIRST_ORDER_DATE, -- 1996-05-26
    MAX(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY)) AS LAST_ORDER_DATE	 -- 2013-12-31
FROM superstore_sales;


SELECT
    Customer_Name,
    MAX(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY)) AS LAST_ORDER_DATE,
    DATEDIFF(
        (SELECT MAX(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY)) FROM superstore_sales),
        MAX(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY))
    ) AS RECENCY
FROM superstore_sales
GROUP BY Customer_Name
ORDER BY RECENCY;

/* RFM segmentation:
Segmentation the customers based on their recency(r),frequency(f) & monetary(m)
*/

CREATE OR REPLACE VIEW RFM_SCORE_DATA AS
WITH CUSTOMER_AGGREGATED_DATA AS (
    SELECT
        CUSTOMER_NAME,
DATEDIFF(
        (SELECT MAX(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY)) FROM superstore_sales),
        MAX(DATE_ADD('1899-12-30', INTERVAL ORDER_DATE DAY))
    ) AS RECENCY_VALUE,
        COUNT(DISTINCT Order_ID) AS FREQUENCY_VALUE,
        ROUND(SUM(SALES), 0) AS MONETARY_VALUE
    FROM superstore_sales
    GROUP BY CUSTOMER_NAME
),
RFM_SCORE AS (
    SELECT 
        C.*,
        NTILE(4) OVER (ORDER BY RECENCY_VALUE DESC) AS R_SCORE,
        NTILE(4) OVER (ORDER BY FREQUENCY_VALUE ASC) AS F_SCORE,
        NTILE(4) OVER (ORDER BY MONETARY_VALUE ASC) AS M_SCORE
    FROM CUSTOMER_AGGREGATED_DATA AS C
)
SELECT
    R.CUSTOMER_NAME, 
    RECENCY_VALUE,
    R_SCORE,
    R.FREQUENCY_VALUE,
    F_SCORE,
    R.MONETARY_VALUE,
    M_SCORE,
    (R_SCORE + F_SCORE + M_SCORE) AS TOTAL_RFM_SCORE,
    CONCAT_WS('', R_SCORE, F_SCORE, M_SCORE) AS RFM_SCORE_COMBINATION
FROM RFM_SCORE AS R;

SELECT * FROM RFM_SCORE_DATA WHERE RFM_SCORE_COMBINATION = '111';

SELECT RFM_SCORE_COMBINATION FROM RFM_SCORE_DATA;

CREATE OR REPLACE VIEW RFM_ANALYSIS AS
SELECT 
    RFM_SCORE_DATA.*,
    CASE
        WHEN RFM_SCORE_COMBINATION IN (111, 112, 121, 132, 211, 211, 212, 114, 141) THEN 'CHURNED CUSTOMER'
        WHEN RFM_SCORE_COMBINATION IN (133, 134, 143, 224, 334, 343, 344, 144) THEN 'SLIPPING AWAY, CANNOT LOSE'
        WHEN RFM_SCORE_COMBINATION IN (311, 411, 331) THEN 'NEW CUSTOMERS'
        WHEN RFM_SCORE_COMBINATION IN (222, 231, 221,  223, 233, 322) THEN 'POTENTIAL CHURNERS'
        WHEN RFM_SCORE_COMBINATION IN (323, 333,321, 341, 422, 332, 432) THEN 'ACTIVE'
        WHEN RFM_SCORE_COMBINATION IN (433, 434, 443, 444) THEN 'LOYAL'
    ELSE 'Other'
    END AS CUSTOMER_SEGMENT
FROM RFM_SCORE_DATA;

SELECT
	CUSTOMER_SEGMENT,
    COUNT(*) AS NUMBER_OF_CUSTOMERS,
    ROUND(AVG(MONETARY_VALUE),0) AS AVERAGE_MONETARY_VALUE
FROM RFM_ANALYSIS
GROUP BY CUSTOMER_SEGMENT;


