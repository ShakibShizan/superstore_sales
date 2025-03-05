CREATE DATABASE SUPERSTORE_DB;

Use SUPERSTORE_DB;

-- MISSING VALUE
SELECT *
FROM SUPERSTORE_DB.all_info
WHERE 
	ROW_ID IS NULL OR
    Order_Priority IS NULL OR
    Discount IS NULL OR
    Unit_Price IS NULL OR
    Shipping_Cost IS NULL OR
    Customer_ID IS NULL OR
    Customer_Name IS NULL OR
    Ship_Mode IS NULL OR
    Customer_Segment IS NULL OR
    Product_Category IS NULL OR
    Product_Sub_Category IS NULL OR
    Product_Container IS NULL OR
    Product_Name IS NULL OR
    Product_Base_Margin IS NULL OR
    Region IS NULL OR
    Manager IS NULL OR
    State_or_Province IS NULL OR
    City IS NULL OR
    Postal_Code IS NULL OR
    Order_Date IS NULL OR
    Ship_Date IS NULL OR
    Profit IS NULL OR
    Quantity_ordered_new IS NULL OR
    Sales IS NULL OR
    Order_ID IS NULL OR
    Return_Status IS NULL;

-- DUPLICATE    
SELECT
    ï»¿Row_ID
FROM
    ALL_INFO
GROUP BY
    ï»¿Row_ID
HAVING
    COUNT(*) > 1;

-- RENAME    
ALTER TABLE ALL_INFO
RENAME COLUMN `ï»¿Row_ID` TO temp_Row_ID;
ALTER TABLE ALL_INFO
RENAME COLUMN temp_Row_ID TO Row_ID;



-- BASIC INSIGHTS

SELECT 
	CONCAT(ROUND(((AVG(DISCOUNT))*100),0),'%') AS USUAL_DISCOUNT, -- 5%
    ROUND(AVG(Shipping_Cost),0) AS AVG_SHIPPING_COST, -- 10
    ROUND(SUM(PROFIT),0) AS TOTAL_PROFIT, -- 21772
    ROUND(SUM(SALES),0) AS TOTAL_SALES, -- 121129
	SUM(Quantity_ordered_new) AS QUANTITY_TOTAL_ORDER -- 2118
FROM ALL_INFO ;

SELECT
	CONCAT(ROUND(AVG(days_difference),0), ' DAYS') AS GAP_ORDER_VS_SHIPPING
FROM DATE_TABLE;

SELECT
	RETURN_STATUS,
	COUNT(RETURN_STATUS)
FROM ALL_INFO
GROUP BY RETURN_STATUS;

SELECT
	Order_Priority,
	COUNT(Order_Priority) AS Order_Priority_Total
FROM ALL_INFO
GROUP BY Order_Priority;

SELECT
	Ship_Mode,
	COUNT(Ship_Mode) AS Ship_Mode_Total
FROM ALL_INFO
GROUP BY Ship_Mode;

SELECT
	Customer_Segment,
	COUNT(Customer_Segment) AS Customer_Segment_Total
FROM ALL_INFO
GROUP BY Customer_Segment;

SELECT
	Product_Category,
	COUNT(Product_Category) as Product_Category_total
FROM ALL_INFO
GROUP BY Product_Category;

SELECT
	Region,
	COUNT(Region)
FROM ALL_INFO
GROUP BY Region;



-- Date format
CREATE OR REPLACE VIEW DATE_TABLE AS
    SELECT 
        Ship_Date,
        DATE_ADD('1899-12-30',
            INTERVAL Ship_Date DAY) AS formatted_ship_date,
        YEAR(DATE_ADD('1899-12-30',
                INTERVAL ship_date DAY)) AS ship_year,
        QUARTER(DATE_ADD('1899-12-30',
                INTERVAL ship_date DAY)) AS ship_quarter,
        MONTHNAME(DATE_ADD('1899-12-30',
                    INTERVAL ship_date DAY)) AS ship_month_name,
        Order_Date,
        DATE_ADD('1899-12-30',
            INTERVAL Order_Date DAY) AS formatted_order_date,
        YEAR(DATE_ADD('1899-12-30',
                INTERVAL Order_Date DAY)) AS order_year,
        QUARTER(DATE_ADD('1899-12-30',
                INTERVAL Order_Date DAY)) AS order_quarter,
        MONTHNAME(DATE_ADD('1899-12-30',
                    INTERVAL Order_Date DAY)) AS order_month_name,
        DATEDIFF(DATE_ADD('1899-12-30',
                    INTERVAL Ship_Date DAY),
                DATE_ADD('1899-12-30',
                    INTERVAL Order_Date DAY)) AS days_difference
    FROM
        superstore_sales.sample_data AS DATE_TABLE;
        
        
-- Year base profit and sales
SELECT 
    date_table.ship_year,
    round(sum(all_info.profit),0) as Profit_per_year,
    round(sum(all_info.sales),0) as sales_per_year
FROM 
    DATE_TABLE
LEFT JOIN 
    ALL_INFO
ON 
    date_table.Order_Date = all_info.Order_Date
GROUP BY 
    date_table.ship_year
order by date_table.ship_year desc;


-- Quarter based
SELECT 
    date_table.ship_quarter,
    round(sum(all_info.profit),0) as Profit_per_year,
    round(sum(all_info.sales),0) as sales_per_year
FROM 
    DATE_TABLE
LEFT JOIN 
    ALL_INFO
ON 
    date_table.Order_Date = all_info.Order_Date
GROUP BY 
    date_table.ship_quarter
order by date_table.ship_quarter desc;


-- month based profit and sales
SELECT 
    date_table.ship_month_name,
    round(sum(all_info.profit),0) as Profit_per_year,
    round(sum(all_info.sales),0) as sales_per_year
FROM 
    DATE_TABLE
LEFT JOIN 
    ALL_INFO
ON 
    date_table.Order_Date = all_info.Order_Date
GROUP BY 
    date_table.ship_month_name
order by date_table.ship_month_name desc;


-- Customer segmentwise insignts

SELECT
    CUSTOMER_NAME,
    CUSTOMER_SEGMENT,
    ROUND(SUM(SALES), 0) AS SALES,
    ROUND(SUM(PROFIT), 0) AS PROFIT,
    CONCAT(ROUND(((ROUND(SUM(PROFIT), 0) / ROUND(SUM(SALES), 0)) * 100),0), '%') AS PROFIT_MARGIN_PERCENTAGE
FROM
    SUPERSTORE_DB.all_info
GROUP BY
    CUSTOMER_NAME,
    CUSTOMER_SEGMENT
ORDER BY
    PROFIT DESC;

-- Product wise analysis
CREATE OR REPLACE VIEW PRODUCT_SUMMARY AS
    SELECT 
        PRODUCT_NAME,
        PRODUCT_CATEGORY,
        SUM(Quantity_ordered_new) AS TOTAL_ORDER,
        DISCOUNT,
        ROUND(SUM(SALES), 0) AS SALES,
        ROUND(SUM(PROFIT), 0) AS PROFIT,
        CONCAT(ROUND((SUM(PROFIT) / SUM(SALES)) * 100, 0),
                '%') AS PROFIT_MARGIN_PERCENTAGE
    FROM
        SUPERSTORE_DB.all_info
    GROUP BY PRODUCT_NAME , PRODUCT_CATEGORY , DISCOUNT;
        
        
    SELECT
        PRODUCT_NAME,
        PRODUCT_CATEGORY,
        PROFIT,
        NTILE(4) OVER (ORDER BY PROFIT DESC) AS PROFIT_NTILE,
        SALES,
        NTILE(4) OVER (ORDER BY SALES DESC) AS SALES_NTILE,
        DISCOUNT,
        NTILE(4) OVER (ORDER BY DISCOUNT DESC) AS DISCOUNT_NTILE,
        TOTAL_ORDER,
        NTILE(4) OVER (ORDER BY TOTAL_ORDER DESC) AS ORDER_COUNT_NTILE,
        PROFIT_MARGIN_PERCENTAGE,
        NTILE(4) OVER (ORDER BY CAST(REPLACE(PROFIT_MARGIN_PERCENTAGE, '%', '') AS DECIMAL) DESC) AS PROFIT_MARGIN_NTILE
    FROM
        PRODUCT_SUMMARY AS PRODUCT_DATA;

CREATE OR REPLACE VIEW PRODUCT_SEGMENTATION AS
WITH PRODUCT_DATA AS (
    SELECT
        PRODUCT_NAME,
        PRODUCT_CATEGORY,
        PROFIT,
        NTILE(4) OVER (ORDER BY PROFIT DESC) AS PROFIT_NTILE,
        SALES,
        NTILE(4) OVER (ORDER BY SALES DESC) AS SALES_NTILE,
        DISCOUNT,
        NTILE(4) OVER (ORDER BY DISCOUNT DESC) AS DISCOUNT_NTILE,
        TOTAL_ORDER,
        NTILE(4) OVER (ORDER BY TOTAL_ORDER DESC) AS ORDER_COUNT_NTILE,
        PROFIT_MARGIN_PERCENTAGE,
        NTILE(4) OVER (ORDER BY CAST(REPLACE(PROFIT_MARGIN_PERCENTAGE, '%', '') AS DECIMAL) DESC) AS PROFIT_MARGIN_NTILE,
        CONCAT(NTILE(4) OVER (ORDER BY PROFIT DESC), 
               NTILE(4) OVER (ORDER BY SALES DESC), 
               NTILE(4) OVER (ORDER BY DISCOUNT DESC), 
               NTILE(4) OVER (ORDER BY TOTAL_ORDER DESC), 
               NTILE(4) OVER (ORDER BY CAST(REPLACE(PROFIT_MARGIN_PERCENTAGE, '%', '') AS DECIMAL) DESC)) AS PRODUCT_COMBINATION
    FROM PRODUCT_SUMMARY
)
SELECT 
    PRODUCT_NAME,
     PRODUCT_CATEGORY,
        PROFIT,
        DISCOUNT,
        TOTAL_ORDER,
        PROFIT_MARGIN_PERCENTAGE,
        PRODUCT_COMBINATION,
        
    CASE
        WHEN PRODUCT_COMBINATION IN (41214,34344,42424,34344,34244,32114,42314,33123,42423,33423,34243,43114,43414,34444,34323,33243,41133,41213,33233,41223,42213,34243,41234,13414,42214,33323,33143,42413,42133,41133,44434,44424,44334,44234,44334,44144,44134,43444,43434,43324,43224,43143,34343,34213,33313,32113,31113,31233,32133,33133,33333,33433,41143,42244,44444) THEN 'LOSS'
        WHEN PRODUCT_COMBINATION IN (11221, 11222, 12121, 12122, 12221, 12222, 21121, 21122, 22121, 22122, 22221, 22222) THEN 'PROFITABLE'
        WHEN PRODUCT_COMBINATION IN (11112, 11111, 11212, 11211, 12112, 12111, 12212, 12211,11411,11211,11311) THEN 'MOST_TREDNY_PROFITABLE_PRODUCT'
        ELSE 'Other'
    END AS PRODUCT_SEGMENT
FROM PRODUCT_DATA;







