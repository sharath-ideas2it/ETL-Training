-- 7)Get the names and hire dates of employees hired in the year 1993
select FirstName,LastName,HireDate
from Employees
where year(HireDate) = 1993

-- 8) Find the names of customers who have never placed an order
select c.CustomerID,count(o.OrderID) as order_count
from Customers c
left join Orders o on o.CustomerID = c.CustomerID
group by c.CustomerID
having COUNT(o.OrderID) = 0

--altr
SELECT ContactName
FROM Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM Orders
);

-- 9) Retrieve the names of customers who have placed orders in 1997.
select OrderID,OrderDate
from Orders
where year(OrderDate) = 1997

--altr
SELECT DISTINCT c.ContactName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 1997;


-- 10)Find the customer who has made the highest total purchase amount
select OrderID,(UnitPrice*Quantity-Discount) as highest_total_purchase_amount
from [Order Details]                                                                        
group by OrderID

--altr
SELECT TOP 1 o.CustomerID, SUM(od.UnitPrice * od.Quantity) AS TotalPurchase
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
ORDER BY TotalPurchase DESC;


-- 11)Find the average unit price of products for each category
select CategoryID,avg(UnitPrice) as average_unit_price
from Products
group by CategoryID

--altr
SELECT c.CategoryName, AVG(p.UnitPrice) AS AveragePrice
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName;

-- 12)List the names of suppliers who supply products in the "Beverages" category
select SupplierID
from Products p 
join Categories c on c.CategoryID=p.CategoryID
where c.CategoryName like 'Beverages';

--altr
SELECT DISTINCT s.CompanyName
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Beverages';
