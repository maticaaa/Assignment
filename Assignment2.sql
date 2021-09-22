-- Questions
-- 1. What is a result set?
-- Result set is the returning set of the rows from the SELECT query.

-- 2. What is the difference between Union and Union All?
-- 1) UNION removes all the duplicated rows, but UNION All contains all the rows.
-- 2) UNION sorts the rows by the first colomn, but UNION All doesn't.
-- 3) UNIONcannot be used in recursive cte, but UNION ALL can.

-- 3.	What are the other Set Operators SQL Server has?
-- MINUS, INTERSECT

-- 4.	What is the difference between Union and Join?
-- UNION combines rows vertically, while JOIN combines tables based on the shared infromation between them.

-- 5.	What is the difference between INNER JOIN and FULL JOIN?
-- INNER JOIN only retrieves the matched rows, while FULL JOIN retrieves all the rows from the two tables.

-- 6.	What is difference between left join and outer join
-- LEFT JOIN retrieves all the rows from the left table and the matched rows from the right table,
-- while OUTER JOIN retrieves all the rows from both of the two tables.

-- 7.	What is cross join?
-- CROSS JOIN retrieves the cartesian product of rows from the two tables.

-- 8.	What is the difference between WHERE clause and HAVING clause?
-- 1) WHERE applies to individual rows, while HAVING applies to groups as a whole.
-- 2) WHERE is executed before the aggregation functions, while HAVING is executed after the aggregation functions.
-- 3ÅjWHERE can be used with SELECT and UPDATE, while HAVING can only be used with SELECT.

-- 9.	Can there be multiple group by columns?
-- Yes, all the colomns other than the aggregation colomns should be in the GROUP BY.


-- Querys
-- 1
SELECT COUNT(*)
FROM Production.Product
GO

-- 2
SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID is NOT NULL
GO

-- 3
SELECT ProductSubcategoryID, Count(*) CountedProducts
FROM Production.Product
WHERE ProductSubcategoryID is NOT NULL
GROUP BY ProductSubcategoryID
GO

-- 4
SELECT COUNT(*)
FROM Production.Product
WHERE ProductSubcategoryID is NULL
GO

-- 5
SELECT SUM(Quantity)
FROM Production.ProductInventory 
GO

-- 6
SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100
GO

-- 7
SELECT Shelf, ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100
GO

-- 8
SELECT AVG(Quantity) Average
FROM Production.ProductInventory
WHERE LocationID = 10

-- 9
SELECT ProductID, Shelf, AVG(Quantity) TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf
GO

-- 10
SELECT ProductID, Shelf, AVG(Quantity) TheAvg
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY ProductID, Shelf
GO

-- 11
SELECT Color, Class, COUNT(*), AVG(ListPrice)
FROM Production.Product
WHERE Color is NOT NULL AND Class is not NULL
GROUP BY Color, Class
GO

-- 12
SELECT c.Name Country, s.Name Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
ORDER BY 1
GO

-- 13
SELECT c.Name Country, s.Name Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany ', 'Canada')
ORDER BY 1
GO

-- 14
SELECT DISTINCT ProductID
FROM [Order Details] 
WHERE OrderID IN (
SELECT OrderID
FROM Orders
WHERE YEAR(GETDATE()) - YEAR(OrderDate) < 25
)
ORDER BY ProductID
GO

-- 15
SELECT TOP 5 ShipPostalCode "Top 5 Locations"
FROM Orders
WHERE ShipPostalCode is NOT NULL
GROUP BY ShipPostalCode
ORDER BY COUNT(*) DESC
GO

-- 16
SELECT TOP 5 ShipPostalCode "Top 5 Locations"
FROM Orders
WHERE ShipPostalCode is NOT NULL AND OrderID IN (
SELECT OrderID
FROM Orders
WHERE YEAR(GETDATE()) - YEAR(OrderDate) < 25
)
GROUP BY ShipPostalCode
ORDER BY COUNT(*) DESC

-- 17
SELECT ShipCity, COUNT(DISTINCT CustomerID) "Number of customers"
FROM Orders
GROUP BY ShipCity
GO

-- 18
SELECT ShipCity, COUNT(DISTINCT CustomerID) AS "Number of customers"
FROM Orders
GROUP BY ShipCity
HAVING COUNT(DISTINCT CustomerID) > 2
GO

-- 19
SELECT ContactName
FROM Customers
WHERE CustomerID IN(
SELECT DISTINCT CustomerID
FROM Orders
WHERE OrderDate > '1998-01-01'
)
ORDER BY 1
GO

-- 20
SELECT ContactName, dt.MostRecent "Most recent order dates"
FROM Customers c INNER JOIN (
SELECT CustomerID, MAX(OrderDate) MostRecent
FROM Orders
GROUP BY CustomerID
) dt ON c.CustomerID = dt.CustomerID
ORDER BY 1
GO

-- 21
SELECT ContactName, dt.OrderCounts
FROM Customers c INNER JOIN (
SELECT CustomerID, COUNT(*) OrderCounts
FROM Orders
GROUP BY CustomerID
) dt ON c.CustomerID = dt.CustomerID
ORDER BY 1
GO

-- 22
SELECT CustomerID
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY CustomerID
HAVING COUNT(od.Quantity) > 100
GO

-- 23
SELECT DISTINCT sup.CompanyName "Supplier Company Name", ship.CompanyName "Shipping Company Name" 
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
	INNER JOIN Products p ON od.ProductID = p.ProductID 
	INNER JOIN Suppliers sup ON p.SupplierID = sup.SupplierID
	INNER JOIN Shippers ship ON o.ShipVia = ship.ShipperID
ORDER BY 1

-- 24
SELECT DISTINCT o.OrderDate, p.ProductName
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
		INNER JOIN Products p ON p.ProductID = od.ProductID
ORDER BY 1 DESC

-- 25
SELECT e1.FirstName + e1.LastName, e2.FirstName + e2.LastName
FROM Employees e1 INNER JOIN Employees e2 ON e1.Title = e2.Title
WHERE e1.EmployeeID > e2.EmployeeID 

-- 26
SELECT m.FirstName + ' ' + m.LastName "Manager Name"
FROM Employees e INNER JOIN Employees m ON e.ReportsTo = m.EmployeeID
GROUP BY m.FirstName, m.LastName
HAVING COUNT(e.EmployeeID) > 2

-- 27
SELECT City, CompanyName "NAME", ContactName "Contact Name", 'Customer' "Type"
FROM Customers
UNION ALL
SELECT City, CompanyName, ContactName, 'Supplier'
FROM Suppliers
ORDER BY City