-- Necessary Cleaning

SELECT Row_ID, COUNT(*) AS Duplicate_Count
FROM superstore_sales
GROUP BY Row_ID
HAVING COUNT(*) > 1; -- Checking Duplicates


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

SELECT 
    RETURN_STATUS,
    COUNT(*) AS STATUS_COUNT
FROM superstore_sales
WHERE RETURN_STATUS NOT REGEXP '^[0-9]+$'
GROUP BY RETURN_STATUS;

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