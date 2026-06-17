/* 
It is advised to execute " USE SalesDB; " to actitvate the database.
*/
USE SalesDB;
-- * window function can only be used in SELECT and ORDER BY clauses. That mean it can't be used to filter data.

SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) AS Totalsales
FROM Sales.Orders
ORDER BY SUM(Sales) OVER (PARTITION BY OrderStatus);

-- error while using in WHERE clause
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) AS Totalsales
FROM Sales.Orders
GROUP BY SUM(Sales) OVER (PARTITION BY OrderStatus);

-- nesting is not allowed in Window Functions
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(SUM(Sales) OVER (PARTITION BY OrderStatus)) OVER (PARTITION BY OrderStatus) AS Totalsales
FROM Sales.Orders;

-- SQL executes window function after the WHERE clause.
-- retriving data for only product 101 and 102.
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	ProductID,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus) AS Totalsales
FROM Sales.Orders
WHERE ProductID IN (101,102);

-- window function can be used together with GROUP BY in same query only if same column are used in window function:
-- rank customers on their total sales

SELECT
	CustomerID,
	SUM(Sales) AS totalsales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) AS rank_customer
FROM Sales.Orders
GROUP BY CustomerID;

-- error example : using column that is not explicitly used before that is "Sales"
SELECT
	CustomerID,
	SUM(Sales) AS totalsales,
	RANK() OVER(ORDER BY Sales DESC) AS rank_customer
FROM Sales.Orders
GROUP BY CustomerID;

-- aggregate window function
-- count : returns the number of rows present in a window.
-- count(*) : count every row.
-- count(column_name) : count only non-null values.
-- find total number of Orders with order id and order date for each customer
SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() AS total_records,
	COUNT(*) OVER(PARTITION BY CustomerID) AS order_by_customer
FROM Sales.Orders;

-- sum : returns the sum of value within a window. allows only valid numeric value.
-- Find the total sales across all orders
-- And the total sales for each product
-- Additionally provide details such order Id, order date

SELECT
	OrderID,
	OrderDate,
	Sales,
	ProductID,
	SUM(Sales) OVER () TotalSales,
	SUM(Sales) OVER (PARTITION BY ProductID) SalesByProducts
FROM Sales.Orders;

-- sum allong with other aggregate functions can be used as comparison analysis.
-- compare the current value and aggregated value of window functions 

SELECT
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER() AS total_sales,
	ROUND(CAST(Sales AS Float) / SUM(Sales) OVER () * 100,2) AS PercentageOfTotal
FROM Sales.Orders

