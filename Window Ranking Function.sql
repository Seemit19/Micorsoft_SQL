 -- 
 USE SalesDB;

 -- ROW_NUMBER() assign unique value to each row, do not handle ties, do not skip or jump ranks.
 -- rank the orders based on their sales from highest to lowest

	 SELECT
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() OVER(ORDER BY Sales DESC) AS Ranked_by_sales
	 FROM Sales.Orders;

 -- RANK() also assign rank to each row but this time it is not necessarily unique value, handles ties by providing same rank to same values, also skips or jump rank.
 -- rank the orders based on their sales from highest to lowest

  SELECT
	OrderID,
	ProductID,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS Ranked_by_sales
 FROM Sales.Orders;

 -- DENSE_RANK() also assign rank to each row but this time it is not necessarily unique value, handles ties by providing same rank to same values, but do not skip or jump ranks.
 -- rank the orders based on their sales from highest to lowest

  SELECT
	OrderID,
	ProductID,
	Sales,
	DENSE_RANK() OVER(ORDER BY Sales DESC) AS Ranked_by_sales
 FROM Sales.Orders;

 --