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