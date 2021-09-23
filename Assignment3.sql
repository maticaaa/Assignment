-- Question
-- 1. Join, because join performs better than subquery.


-- 2. CTE is for common table expression, and we will use it when we want to reuse or have a reference of a result set

-- 3. Table variable is a local variable storing data temporarily. The scope of table variable is only a single block. It will be stored in the temp table.

-- 4. DELETE will remove rows one by one and won't free the space, while TRUNCATE will simply remove all the rows in the table and it can free the space of the table. 
--	  TRUNCATE will perform better if we just want to clear the rows in a table

-- 5. Identity colomn is a possible way to generate key value in a table. DELETE won't affect the next value of the identity colomn, while TRUNCATE will reset the next value of identity colomn to the initial value.

-- 6. gdelete from table_nameh will delete all the rows one by one in the table but won't free the space, while gtruncate table table_nameh will remove all the rows and clear the space.

-- Querys
-- 1
SELECT City
FROM Employees
INTERSECT
SELECT City
FROM Customers
GO

-- 2
-- a
SELECT DISTINCT City
FROM Customers
WHERE City NOT IN  
(SELECT City
FROM Employees)
GO

-- b
SELECT City
FROM Customers
EXCEPT
SELECT City
FROM Employees
GO

-- 3
SELECT p.ProductID, SumQuantity
FROM Products p INNER JOIN 
(
SELECT ProductID, SUM(Quantity) SumQuantity FROM [Order Details] GROUP BY ProductID
) od ON p.ProductID = od.ProductID
ORDER BY 1
GO

-- 4
SELECT c.City, SUM(od.Quantity) "Total Products"
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
GO

-- 5
-- a
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2
GO

-- b
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2
GO

-- 6
SELECT c.City
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT ProductID) >= 2
GO

-- 7
SELECT DISTINCT o.CustomerID, c.ContactName
FROM Orders o INNER JOIN Customers c ON o.CustomerID = c.CustomerID AND o.ShipCity != c.City
GO

-- 8
SELECT t1.pid, p.ProductName "Product Name", 
(
SELECT TOP 1 c.city
FROM Orders o 
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE od.ProductId = t1.pid
GROUP BY c.City
ORDER BY SUM(od.Quantity) DESC 
) "Most Popular in"
FROM 
(SELECT TOP 5 od.ProductID pid
FROM [Order Details] od
GROUP BY od.ProductID
ORDER BY COUNT(od.OrderID) DESC
) t1 
INNER JOIN Products p ON t1.pid = p.ProductID
GO

-- 9
-- a
SELECT City
FROM Employees
WHERE City NOT IN(SELECT DISTINCT ShipCity FROM Orders)

-- b
SELECT City
FROM Employees emp LEFT JOIN Orders o ON emp.City = o.ShipCity
WHERE o.OrderID IS NULL

-- 10
SELECT TOP 1 emp.City
FROM Orders o INNER JOIN Employees emp ON o.EmployeeID = emp.EmployeeID
GROUP BY emp.City
ORDER BY COUNT(o.OrderID) DESC
GO

SELECT TOP 1 emp.City
FROM Orders o INNER JOIN Employees emp ON o.EmployeeID = emp.EmployeeID INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY emp.City
ORDER BY SUM(od.Quantity) DESC
GO

-- 11. Use CTE with ROW_NUMBER() function and PARTITION BY keyword so that the value of all the duplicate records in the new colomn with be large than 1, and we will delete all the rows based on the new colomn

-- 12 
WITH EMPCTE
AS
(
SELECT empid, mgrid, 1 AS lvl
FROM Employee
UNION ALL
SELECT empid, mgrid, ct.lvl + 1
FROM Employee e INNER JOIN EMPCTE ct ON e.mgrid = ct.empid
)

SELECT empid
FROM EMPCTE
WHERE lvl = (SELECT MIN(lvl) FROM EMPCTE)
GO

-- 13
WITH DEPTCTE
AS
(
SELECT deptid, COUNT(empid) cnt
FROM Employee e INNER JOIN Dept d ON e.deptid = d.deptid
GROUP BY deptid
ORDER BY COUNT(empid) DESC
)
SELECT deptid, cnt
FROM DEPTCTE
WHERE cnt = (SELECT MAX(cnt) from DEPTCTE)
GO

-- 14
SELECT d.deptname, dt.empid, dt.salary, dt.RNK
FROM Dept d INNER JOIN
(SELECT empid, deptid, salary, RANK() OVER(PARTITION BY deptid ORDER BY salary DESC) RNK
FROM Employee e) dt ON d.deptid = dt.deptid
WHERE RNK <= 3
GO