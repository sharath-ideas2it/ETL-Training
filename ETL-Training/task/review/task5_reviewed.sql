--1 Retrieve the names of customers, products they ordered, and the supplier names. Include customers who have not placed any orders and suppliers who have not supplied any products.
select Customers.CompanyName AS CustomerName, Products.ProductName, Suppliers.CompanyName AS SupplierName
from Customers
left join Orders on Customers.CustomerID = Orders.CustomerID
left join [Order Details] on Orders.OrderID = [Order Details].OrderID
left join Products on [Order Details].ProductID = Products.ProductID
left join Suppliers on Products.SupplierID = Suppliers.SupplierID;

--2 List the names of all employees, the territories they manage, and the regions of those territories. Include employees without territories and regions without territories assigned to any employee.
select Employees.LastName, Employees.FirstName, Territories.TerritoryDescription, Region.RegionDescription
from Employees
left join EmployeeTerritories on Employees.EmployeeID = EmployeeTerritories.EmployeeID
left join Territories on EmployeeTerritories.TerritoryID = Territories.TerritoryID
left join Region on Territories.RegionID = Region.RegionID
ORDER BY Employees.LastName, Employees.FirstName;

--altr
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName, 
    t.TerritoryDescription, 
    r.RegionDescription
FROM Employees e
LEFT JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
FULL OUTER JOIN Territories t ON et.TerritoryID = t.TerritoryID
LEFT JOIN Region r ON t.RegionID = r.RegionID;

--3 Retrieve the order IDs, customer names, employee names, and shipper names for all orders. Include orders that may not have an associated customer, employee, or shipper.
select Orders.OrderID, Customers.CompanyName AS CustomerName, Employees.FirstName, Shippers.CompanyName AS ShipperName
from Orders
left join Customers on Orders.CustomerID = Customers.CustomerID
left join Employees on Orders.EmployeeID = Employees.EmployeeID
left join Shippers on Orders.ShipVia = Shippers.ShipperID;

--4 Retrieve the names of customers and the total quantities of products they have ordered. Include customers who have not placed any orders and products that have not been ordered.
select Customers.CompanyName, sum([Order Details].Quantity) as quantities
from Customers
left join Orders on Customers.CustomerID = Orders.CustomerID
left join [Order Details] on Orders.OrderID = [Order Details].OrderID
group by Customers.CompanyName;

--altr
SELECT 
    c.ContactName AS CustomerName, 
    SUM(od.Quantity) AS TotalQuantity
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.ContactName;


--5 Find the names of employees and the orders they have processed along with the product names. Include employees who have not processed any orders and products that have not been ordered.
select Employees.FirstName,Orders.OrderID, Products.ProductName
from Employees
left join Orders on Employees.EmployeeID = Orders.EmployeeID
left join [Order Details] on Orders.OrderID = [Order Details].OrderID
left join Products on [Order Details].ProductID = Products.ProductID;

--altr
SELECT 
    e.FirstName + ' ' + e.LastName AS EmployeeName, 
    o.OrderID, 
    p.ProductName
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
LEFT JOIN [Order Details] od ON o.OrderID = od.OrderID
RIGHT JOIN Products p ON od.ProductID = p.ProductID;


--6 List all products, their suppliers, and the regions where these products are supplied. Include products without suppliers and regions without suppliers.
select Products.ProductName,Suppliers.CompanyName,Suppliers.Region
from Products
left join Suppliers on Products.SupplierID = Suppliers.SupplierID

--altr
SELECT 
    p.ProductName, 
    s.CompanyName AS SupplierName, 
    r.RegionDescription
FROM Products p
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
CROSS JOIN Region r;


--7 List all products, their categories, and the quantities ordered by each customer. Include products without categories and customers without orders.
select Products.ProductName, Categories.CategoryName, Customers.CompanyName AS CustomerName, SUM([Order Details].Quantity) AS TotalQuantityOrdered
from Products
left join Categories on Products.CategoryID = Categories.CategoryID
left join [Order Details] on Products.ProductID = [Order Details].ProductID
left join Orders on [Order Details].OrderID = Orders.OrderID
left join Customers on Orders.CustomerID = Customers.CustomerID
group by Products.ProductName, Categories.CategoryName, Customers.CompanyName;

--altr
SELECT 
    p.ProductName, 
    c.CategoryName, 
    SUM(od.Quantity) AS TotalQuantity
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
RIGHT JOIN Customers cu ON o.CustomerID = cu.CustomerID
GROUP BY p.ProductName, c.CategoryName, cu.ContactName;


--8 Find the names of employees who have sold more than 100 units of any product.
select Employees.FirstName
from Employees
join Orders on Employees.EmployeeID = Orders.EmployeeID
join [Order Details] on Orders.OrderID = [Order Details].OrderID
group by Employees.EmployeeID, Employees.FirstName, Employees.LastName
HAVING SUM([Order Details].Quantity) > 100;


--9 List the customers who have ordered products supplied by "Tokyo Traders" and the total amount they spent.
select Customers.CompanyName AS CustomerName, SUM([Order Details].Quantity * [Order Details].UnitPrice) AS TotalAmountSpent
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join [Order Details] on Orders.OrderID = [Order Details].OrderID
join Products on [Order Details].ProductID = Products.ProductID
join Suppliers on Products.SupplierID = Suppliers.SupplierID
where Suppliers.CompanyName = 'Tokyo Traders'
group by Customers.CompanyName;

--10 Find the most frequently ordered product in each category. 

select t2.productname,t2.cat
from (
    select productname, cat, countoforder,rank() over(partition by cat order by countoforder desc) as ranking
    from (
        select Products.ProductName as productname, Products.CategoryID as cat,count([Order Details].OrderID) as countoforder
        from Products
        join [Order Details] on Products.ProductID = [Order Details].ProductID
        group by Products.ProductName, Products.CategoryID
    ) as t1
) as t2
where t2.ranking = 1

--altr
SELECT c.CategoryName, p.ProductName, MAX(total_quantity) AS MaxQuantity
FROM (
    SELECT p.ProductID, p.ProductName, p.CategoryID, SUM(od.Quantity) AS total_quantity
    FROM Products p
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    GROUP BY p.ProductID, p.ProductName, p.CategoryID
) sub
JOIN Categories c ON sub.CategoryID = c.CategoryID
GROUP BY c.CategoryName, p.ProductName;

