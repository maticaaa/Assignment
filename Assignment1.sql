-- 1
SELECT ProductID, "Name", Color, ListPrice 
FROM Production.Product
GO

-- 2
SELECT ProductID, "Name", Color, ListPrice 
FROM Production.Product
WHERE ListPrice <> 0
GO

-- 3
SELECT ProductID, "Name", Color, ListPrice 
FROM Production.Product
WHERE Color is NULL
GO

-- 4
SELECT ProductID, "Name", Color, ListPrice 
FROM Production.Product
WHERE Color is NOT NULL
GO

-- 5
SELECT ProductID, "Name", Color, ListPrice 
FROM Production.Product
WHERE Color is NOT NULL AND ListPrice > 0
GO

-- 6
SELECT "Name" + ' ' + Color "Name and Color"
FROM Production.Product
WHERE Color is NOT NULL
GO

-- 7
SELECT 'Name: ' + "Name" + ' -- ' + 'Color: ' + Color "Name and Color"
FROM Production.Product
WHERE Color is NOT NULL
GO

-- 8
SELECT ProductID, "Name"
FROM Production.Product
WHERE ProductID BETWEEN 400 and 500
GO

-- 9
SELECT ProductID, "Name", Color
FROM Production.Product
WHERE Color IN ('Black', 'Blue')
GO

-- 10
SELECT "Name" "Products that begins with the letter S"
FROM Production.Product
WHERE "Name" LIKE 'S%'
GO

-- 11
SELECT "Name", ListPrice
FROM Production.Product
--WHERE "Name" LIKE 'S%'
ORDER BY "Name"
GO

-- 12
SELECT "Name", ListPrice
FROM Production.Product
WHERE "Name" LIKE 'A%' OR "Name" LIKE 'S%'
ORDER BY "Name"
GO

-- 13
SELECT "Name", ListPrice
FROM Production.Product
WHERE "Name" LIKE 'SPO[^k]%'
ORDER BY "Name"
GO

-- 14
SELECT DISTINCT Color
FROM Production.Product
--WHERE Color is NOT NULL
ORDER BY Color DESC
GO

-- 15
SELECT DISTINCT ProductSubcategoryId, Color
FROM Production.Product
WHERE ProductSubcategoryId IS NOT NULL AND Color IS NOT NULL
GO

-- 16
SELECT ProductSubCategoryID
      , LEFT([Name],35) AS [Name]
      , Color, ListPrice 
FROM Production.Product
WHERE (Color IN ('Red','Black') 
      OR ListPrice BETWEEN 1000 AND 2000) 
      AND ProductSubCategoryID = 1
ORDER BY ProductID
