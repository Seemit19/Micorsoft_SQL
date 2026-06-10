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