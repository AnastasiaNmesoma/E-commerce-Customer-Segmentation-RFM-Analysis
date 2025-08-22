CREATE DATABASE EcommerceCustomerDB;
USE EcommerceCustomerDB;

/*Explore all Object in the dataset*/
SELECT * FROM INFORMATION_SCHEMA.COLUMNS


-- A report that shows all metrics of the busimess
SELECT 'Total Sales' AS Measure_Name, ROUND(SUM(UnitPrice * Quantity), 0) AS Measure_Value FROM Ecommerce_transaction
UNION ALL
SELECT 'Total Quantity sold', SUM(Quantity) FROM Ecommerce_transaction
UNION ALL
SELECT 'Avg selling price', ROUND(AVG(UnitPrice), 2) FROM Ecommerce_transaction
UNION ALL
SELECT 'Total No. Orders', COUNT(InvoiceNO) FROM Ecommerce_transaction
UNION ALL
SELECT 'Total No. Product', COUNT(DISTINCT StockCode) FROM Ecommerce_transaction
UNION ALL
SELECT 'Total No. Customers', COUNT(DISTINCT CustomerID) FROM Ecommerce_transaction

-- Checking Missing Values
SELECT
    SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceNo,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) AS Missing_Description,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Missing_UnitPrice,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM Ecommerce_transaction;

-- Total sales from known customers
SELECT ROUND(SUM(UnitPrice * Quantity), 0) AS Known_Customer_Sales
FROM Ecommerce_transaction
WHERE CustomerID IS NOT NULL;

-- Create a customer-focused dataset
SELECT StockCode, Quantity, UnitPrice, InvoiceNo, InvoiceDate, CustomerID, Country
INTO Cus_Segmentation_Data
FROM Ecommerce_transaction
WHERE CustomerID IS NOT NULL;

-- Checking Missing Values in the New Table
SELECT
    SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceNo,
    SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN InvoiceDate IS NULL THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Missing_UnitPrice,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Missing_Country
FROM Cus_Segmentation_Data;

--Removing Duplicates
WITH RankedTransactions AS (
    SELECT *, 
        ROW_NUMBER() OVER (PARTITION BY InvoiceNo, StockCode, Quantity, UnitPrice, CustomerID ORDER BY InvoiceDate) AS rn
    FROM Cus_Segmentation_Data
)
DELETE FROM RankedTransactions WHERE rn > 1;

-- Checking for non-numeric stock codes
SELECT DISTINCT StockCode
FROM Cus_Segmentation_Data
WHERE ISNUMERIC(StockCode) = 0
ORDER BY StockCode;

-- Remove rows with non-numeric stockcodes
DELETE FROM Cus_Segmentation_Data
WHERE StockCode IN ('BANK CHARGES', 'C2', 'CRUK', 'D', 'DOT', 'M', 'PADS', 'POST');

/*Checking and removing Anomlies*/

-- Count of high UnitPrice
SELECT COUNT(*) FROM Cus_Segmentation_Data WHERE UnitPrice > 1000;

-- Count of Quantity > 1000
SELECT COUNT(*) FROM Cus_Segmentation_Data WHERE Quantity > 1000;

-- Checkin for row normality
SELECT * 
FROM Cus_Segmentation_Data 
WHERE Quantity > 1000
ORDER BY Quantity DESC;

/*Compare revenue from high qauantity rows with total revenue*/

-- Revenue from high quantity rows
SELECT ROUND(SUM(Quantity * UnitPrice), 0) AS HighQuantityRevenue
FROM Cus_Segmentation_Data
WHERE Quantity > 1000;

-- Compare with total revenue
SELECT ROUND(SUM(Quantity * UnitPrice), 0) AS TotalRevenue
FROM Cus_Segmentation_Data;

-- Count of quantity < 0
SELECT COUNT(*) FROM Cus_Segmentation_Data WHERE Quantity < 0;
SELECT * FROM Cus_Segmentation_Data WHERE Quantity < 0;

/* Creating a new column 'TransactionType'*/

-- Add new column
ALTER TABLE Cus_Segmentation_Data
ADD TransactionType VARCHAR(20);

-- Populate the column
UPDATE Cus_Segmentation_Data
SET TransactionType = CASE 
    WHEN Quantity < 0 THEN 'Return'
    ELSE 'Purchase'
END;


/*Adding the NOT NULL Constraint*/
ALTER TABLE  Cus_Segmentation_Data
ALTER COLUMN UnitPrice FLOAT NOT NULL;

ALTER TABLE  Cus_Segmentation_Data
ALTER COLUMN CustomerID NVARCHAR(50) NOT NULL;

ALTER TABLE  Cus_Segmentation_Data
ALTER COLUMN InvoiceDate DATETIME NOT NULL;

ALTER TABLE  Cus_Segmentation_Data
ALTER COLUMN TransactionType NVARCHAR(20) NOT NULL;


/*Adding a uniqe Identifyer for each row*/
ALTER TABLE Cus_Segmentation_Data
ADD RowID INT IDENTITY(1001,1) PRIMARY KEY;


--  Add new columns to hold split date and time
ALTER TABLE Cus_Segmentation_Data
ADD 
    Invoice_Date DATE,     -- New column for just the date
    Invoice_Time TIME;     -- New column for just the time

-- Update the new columns by extracting from InvoiceDate
UPDATE Cus_Segmentation_Data
SET 
    Invoice_Date = CAST(InvoiceDate AS DATE),   -- Extracts date only
    Invoice_Time = CAST(InvoiceDate AS TIME);   -- Extracts time only

-- Drop the Original InvoiceDate column
ALTER TABLE Cus_Segmentation_Data
DROP COLUMN InvoiceDate 

SELECT Distinct Invoice_Time FROM Cus_Segmentation_Data

/*Basic Discriptive Analysis*/

-- First and Last Transaction
SELECT 
    CAST(MIN(Invoice_Date) AS DATE) AS First_Transaction, 
    CAST(MAX(Invoice_Date) AS DATE) AS Last_Transaction
FROM Cus_Segmentation_Data;

-- Most Frequent Customers
SELECT TOP 10 
    CustomerID, 
    COUNT(DISTINCT InvoiceNo) AS Orders, 
    ROUND(SUM(UnitPrice * Quantity), 0) AS Total_Spent
FROM Cus_Segmentation_Data
GROUP BY CustomerID
ORDER BY Total_Spent DESC;

-- Order Distribution by date
SELECT 
    CAST(Invoice_Date AS DATE) AS OrderDate, 
    COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM Cus_Segmentation_Data
GROUP BY CAST(Invoice_Date AS DATE)
ORDER BY Total_Orders DESC;

-- Hour of day analysis
SELECT 
    DATEPART(HOUR, Invoice_Time) AS HourOfDay, 
    COUNT(RowID) AS Orders
FROM Cus_Segmentation_Data
GROUP BY DATEPART(HOUR, Invoice_Time)
ORDER BY Orders DESC;

-- Customers by country
SELECT 
    Country, 
    COUNT(DISTINCT CustomerID) AS Num_Customer, 
    COUNT(DISTINCT InvoiceNO) AS Num_Orders,
    ROUND(SUM(UnitPrice * Quantity), 0) AS Revenue
FROM Cus_Segmentation_Data
GROUP BY Country
ORDER BY Revenue DESC;


/*Repeat customers vs One-time Customers*/

-- Customers who made more than 1 purchase
SELECT 
    COUNT(*) AS Repeat_Customers FROM (
        SELECT CustomerID FROM Cus_Segmentation_Data
        GROUP BY CustomerID
        HAVING COUNT(DISTINCT InvoiceNo) > 1
    ) AS repeaters;

-- One-time customers
SELECT 
    COUNT(*) AS One_Time_Customers FROM (
        SELECT CustomerID FROM Cus_Segmentation_Data
        GROUP BY CustomerID
        HAVING COUNT(DISTINCT InvoiceNo) = 1
    ) AS one_timers;

-- Top 10 highest unit prices
SELECT TOP 10
    StockCode, 
    UnitPrice,
    InvoiceNo,
    Quantity, 
    CustomerID,
    Country
FROM Cus_Segmentation_Data
ORDER BY UnitPrice DESC

SELECT * FROM Cus_Segmentation_Data WHERE Quantity IS NULL


-- Purchase frequency
SELECT
    Customerid,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders 
FROM Cus_Segmentation_Data
GROUP BY Customerid

-- First and last purchase dates
SELECT 
    CustomerID,
    MIN(Invoice_Date) AS first_purchase_date,
    MAX(Invoice_Date) AS last_purchase_date,
    DATEDIFF(DAY, MIN(Invoice_Date), MAX(Invoice_Date))
FROM Cus_Segmentation_Data
GROUP BY CustomerID;