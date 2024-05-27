
-- 19)Find the names of customers whose contact name starts with 'M', and convert their names to uppercase.
select UPPER(CompanyName) AS CompanyName
from Customers
where ContactName LIKE 'M%';

-- 20)List the products supplied by suppliers from 'Germany' or 'Japan', and concatenate 'Product: ' with the product names.
select CONCAT('Product: ',p.ProductName)
from Products p
join Suppliers s on s.SupplierID=p.SupplierID
where s.Country in ('Germany', 'Japan')

-- 21) Get the names and phone numbers of customers whose phone number ends with '5', and mask the first three digits of their phone numbers with 'XXX'
select CustomerID,Phone,STUFF(Phone, 1, 3, '***') AS afterstuff
from Customers
where Phone like '%5'

-- 22)Retrieve the order IDs and customer names for orders placed by customers whose names contain 'Ana', and convert their names to lowercase.
select OrderID,LOWER(CompanyName) as CompanyName
from Orders o
join Customers c on c.CustomerID = o.CustomerID
where CompanyName LIKE '%ana%';

-- 23)Find the names of customers who have never placed an order, and replace any spaces in their names with underscores.
select CustomerID,REPLACE(CompanyName, ' ', '_')
from Customers        
where CustomerID NOT IN (
    select CustomerID
    from Orders
);

-- 24)Retrieve the customer names and order dates for orders placed in 1997, and format the order dates as 'YYYY-MM-DD'.
select CustomerID, CONVERT(varchar, OrderDate, 111) AS FormattedOrderDate
from Orders
where year(OrderDate) = 1997

-- 25)Get the names of employees who have processed orders, and reverse their first names.
select e.FirstName,count(o.OrderID),REVERSE(e.FirstName)
from Employees e
join Orders o on o.EmployeeID = e.EmployeeID
group by e.FirstName
having count(o.OrderID)>=1


