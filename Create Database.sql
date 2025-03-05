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
