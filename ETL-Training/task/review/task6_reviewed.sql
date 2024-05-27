-- 11 Retrieve the names and order dates of customers who placed more than five orders in 1997.
select Customers.CompanyName AS CustomerName, 
       Orders.OrderDate
from Customers
join Orders ON Customers.CustomerID = Orders.CustomerID
where YEAR(Orders.OrderDate) = 1997
group by Customers.CompanyName,Orders.OrderDate
having COUNT(Orders.OrderID) > 5;

-- 12 Find the products that have been ordered more than the average number of times all products have been ordered.
select ProductName
from [Order Details]
join Products on [Order Details].ProductID = Products.ProductID
group by [Order Details].ProductID, ProductName
having sum(Quantity) > (select avg(Quantity) from [Order Details])

-- 13 Get the names of customers who have ordered products from all categories.
select Customers.CompanyName AS CustomerName
from Customers
join Orders ON Customers.CustomerID = Orders.CustomerID
join [Order Details] ON Orders.OrderID = [Order Details].OrderID
join Products ON [Order Details].ProductID = Products.ProductID
group by Customers.CustomerID, Customers.CompanyName
having COUNT(DISTINCT Products.CategoryID) = (
    select COUNT(DISTINCT CategoryID) from Products
);

--altr
SELECT c.ContactName
FROM Customers c
WHERE NOT EXISTS (
    SELECT *
    FROM Categories cat
    WHERE NOT EXISTS (
        SELECT *
        FROM Orders o
        JOIN [Order Details] od ON o.OrderID = od.OrderID
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE o.CustomerID = c.CustomerID AND p.CategoryID = cat.CategoryID
    )
);


-- 14 Find the names of customers who have placed the highest number of orders in a single year.

select TOP 1 Customers.CompanyName,year(Orders.OrderDate),count(Orders.OrderID) as countof
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
group by Customers.CompanyName,year(Orders.OrderDate)
order by countof desc

--altr
SELECT c.ContactName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
HAVING COUNT(*) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM Orders
        GROUP BY CustomerID, YEAR(OrderDate)
    ) sub
);


-- 15 Retrieve the product names and total sales amount for products that have a total sales amount greater than $10,000.
select Products.ProductName, 
       SUM([Order Details].Quantity * [Order Details].UnitPrice) AS TotalSalesAmount
from Products
join [Order Details] ON Products.ProductID = [Order Details].ProductID
group by Products.ProductID, Products.ProductName
having SUM([Order Details].Quantity * [Order Details].UnitPrice) > 10000;

-- 16 Find the employees who have managed more than one territory.
select Employees.FirstName
from Employees
join EmployeeTerritories ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
group by Employees.EmployeeID, Employees.FirstName, Employees.LastName
having COUNT(EmployeeTerritories.TerritoryID) > 1;

-- 17 Find the names of employees and their respective territories, including employees who may not be assigned to any territory. Also, include territories that may not have any employees assigned.
select Employees.FirstName, Territories.TerritoryDescription
from Employees
left join EmployeeTerritories ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
left join Territories ON EmployeeTerritories.TerritoryID = Territories.TerritoryID;


--altr
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName, 
    t.TerritoryDescription
FROM Employees e
FULL OUTER JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
FULL OUTER JOIN Territories t ON et.TerritoryID = t.TerritoryID;


-- 18 Retrieve all products and the total quantities ordered for each product, along with the supplier's name. Include products that may not have been ordered.
select Products.ProductName, 
       Suppliers.CompanyName AS SupplierName, 
       SUM([Order Details].Quantity)AS TotalQuantityOrdered
from Products
left join [Order Details] ON Products.ProductID = [Order Details].ProductID
left join Suppliers ON Products.SupplierID = Suppliers.SupplierID
group by Products.ProductID, Products.ProductName, Suppliers.CompanyName;

--altr
SELECT 
    p.ProductName, 
    COALESCE(SUM(od.Quantity), 0) AS TotalQuantityOrdered, 
    s.CompanyName AS SupplierName
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
GROUP BY p.ProductName, s.CompanyName;


-- 19 List all customer names who have placed orders and all supplier names, without duplicate.
select Customers.CompanyName,Suppliers.CompanyName
from Customers
join Orders on Customers.CustomerID  =  Orders.CustomerID
join [Order Details] on Orders.OrderID =  [Order Details].OrderID
join Products on [Order Details].ProductID =  Products.ProductID
right join Suppliers on Products.SupplierID =  Suppliers.SupplierID
group by Customers.CompanyName,Suppliers.CompanyName

--altr
SELECT ContactName AS Name
FROM Customers
WHERE CustomerID IN (SELECT DISTINCT CustomerID FROM Orders)
UNION
SELECT CompanyName AS Name
FROM Suppliers;


-- 20 Retrieve the names of employees who have processed orders and those who have territories assigned to them, without duplicates.
select Employees.FirstName,Territories.TerritoryDescription
from Employees
join Orders on Orders.EmployeeID = Employees.EmployeeID
join EmployeeTerritories on Employees.EmployeeID  =  EmployeeTerritories.EmployeeID
join Territories on EmployeeTerritories.TerritoryID =  Territories.TerritoryID
group by Employees.FirstName,Territories.TerritoryDescription

--altr
set-opertaion
