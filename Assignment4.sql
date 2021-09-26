-- Question
-- 1. View is virtual table containing the reference of the data in one or multiple tables

-- 2. Yes, the real data rows will be modified.

-- 3. Stored procedure is a set of prepared sql queries. We can reuse the stored procedure and can have input and output parameters.

-- 4. View is a virtual table, while stored procedure can accept parameters and contain programming logic.

-- 5. Stored procedure is used for DML, while functions is used for calculation.

-- 6. Yes.

-- 7. No, because we need use EXEC or just the name to execute a stored procedure.

-- 8. Trigger is a set of sql queries that will automatically executed when an event occurs. We have DML trigger and DDL trigger.

-- 9. When we want to log the changes in the table.

-- 10. Stored procedure is executed when we call it, while trigger will automatically executed when an event occurs.

-- Query

-- 4.
CREATE VIEW view_product_order_Yixuan
AS
SELECT p.ProductName, SUM(od.Quantity) "Total ordered quantity"
FROM Products p INNER JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
GO

SELECT * FROM view_product_order_Yixuan
GO

-- 5
CREATE PROC sp_product_order_quantity_Yixuan
@pid int,
@total int out
AS
BEGIN
SELECT @total = SUM(Quantity)
FROM [Order Details]
WHERE ProductID = @pid
END
GO

BEGIN
declare @total int
EXEC sp_product_order_quantity_Yixuan 30, @total out
print @total
END
GO

-- 6
CREATE PROC sp_product_order_city_Yixuan
@pname nvarchar(40)
AS
BEGIN
SELECT TOP 5 o.ShipCity, SUM(od.Quantity) "Total quantity"
FROM Orders o INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE od.ProductID = (SELECT ProductID FROM Products WHERE ProductName = @pname)
GROUP BY O.ShipCity
ORDER BY SUM(OD.Quantity) DESC
END
GO

sp_product_order_city_Yixuan Chai
GO

-- 8
CREATE TRIGGER tr_employee_perritories_yixuan ON EmployeeTerritories
FOR INSERT, UPDATE
AS
DECLARE @tid int
SELECT @tid = TerritoryID FROM Territories WHERE TerritoryDescription = 'Stevens Point'
IF((SELECT COUNT(EmployeeID) FROM EmployeeTerritories WHERE TerritoryID = @tid) > 100)
	BEGIN
	UPDATE EmployeeTerritories
	SET TerritoryID = (SELECT TerritoryID FROM Territories WHERE TerritoryDescription = 'Troy')
	WHERE TerritoryID = @tid
	END
GO

DROP TRIGGER tr_employee_perritories_yixuan
GO

-- 9
CREATE TABLE people_yixuan
(
	Id int,
	"Name" varchar(20),
	City int
)
GO

CREATE TABLE city_yixuan
(
	Id int,
	City varchar(20)
)
GO

INSERT INTO people_yixuan VALUES(1, 'Aaron Rodgers', 2);
INSERT INTO people_yixuan VALUES(2, 'Russell Wilson', 1);
INSERT INTO people_yixuan VALUES(3, 'Jody Nelson', 2);

INSERT INTO city_yixuan VALUES(1, 'Seattle');
INSERT INTO city_yixuan VALUES(2, 'Green Bay');
GO

CREATE VIEW Packers_yixuan
AS
SELECT Name
FROM people_yixuan
WHERE City = (SELECT Id FROM city_yixuan WHERE City = 'Green Bay')
GO

DROP TABLE people_yixuan
DROP TABLE city_yixuan
DROP VIEW Packers_yixuan
GO

-- 10
CREATE PROC sp_birthday_employees_yixuan
AS
BEGIN
	CREATE TABLE birthday_employees_yixuan
	(
		Eid int,
		Efirstname nvarchar(10),
		Elastname nvarchar(20)
	)
	INSERT INTO birthday_employees_yixuan 
	SELECT EmployeeID, FirstName, LastName
	FROM Employees
	WHERE MONTH(BirthDate) = 2
END
GO

sp_birthday_employees_yixuan
GO

SELECT * FROM birthday_employees_yixuan
GO

DROP TABLE birthday_employees_yixuan
GO

-- 11
CREATE PROC sp_yixuan_1
AS
BEGIN
SELECT dt.City
FROM (SELECT c.City, c.CustomerID
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID RIGHT JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.City, c.CustomerID
HAVING COUNT(ProductID) <= 1) dt
GROUP BY dt.City
HAVING COUNT(dt.CustomerID) >= 2
END
GO

CREATE PROC sp_yixuan_2
AS
BEGIN
EXEC sp_yixuan_1
END
GO

-- 12. Use full join and the condition is that all colomn other than the primary key would be equal. If the two tables don't have the same data, we will find some null values in the colomns for the primary key of the two tables

-- 14
SELECT CASE WHEN MiddleName IS NULL
	THEN FirstName + ' ' + LastName 
	ELSE FirstName + ' ' + LastName + ' ' + MiddleName + '.'
FROM t1
GO

-- 15
SELECT TOP 1 Mark
FROM Students
WHERE Sex = 'F'
ORDER BY Marks DESC

-- 16
SELECT Student, Marks, Sex
FROM Students
ORDER BY Sex, Marks DESC