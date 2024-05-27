-- 13)Find the products that have never been ordered
select p.ProductID ,count(od.OrderID)
from Products p
join [Order Details] as od on od.ProductID = p.ProductID
group by p.ProductID
having count(od.OrderID) =0

--altr
SELECT ProductName
FROM Products p
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL;


-- 14)Find the names of employees and the names of the regions they manage, and concatenate the employee's first name with the region description.
select e.FirstName,e.Region,CONCAT(e.FirstName,',',r.RegionDescription) as firstname_description
from Employees e
join EmployeeTerritories et on et.EmployeeID=e.EmployeeID
join Territories t on t.TerritoryID = et.TerritoryID
join Region r on r.RegionID = t.RegionID

-- 15)Retrieve the product names and the total quantities ordered for products ordered more than 50 times, and pad the product names to a total length of 20 characters
select p.ProductID,SUBSTRING(p.ProductName, 1, 20),sum(od.Quantity) as sum_of_Quantity
from Products p
join [Order Details] as od on od.ProductID = p.ProductID
group by p.ProductID,p.ProductName
having sum(od.Quantity)>50


-- 16)Get the customer names and their countries for customers not located in 'USA', and replace any occurrence of 'Ltd' in the company name with 'Limited'.
select CustomerID,Country,CompanyName,REPLACE(CompanyName, 'Ltd', 'Limited' ) AS Website_Name
from Customers
where Country != 'USA'

-- 17)List the order IDs and the corresponding shipper names, and trim any leading or trailing spaces from the shipper names
select  Orders.OrderID, TRIM(Shippers.CompanyName) AS ShipperName
from Orders
join Shippers on Orders.ShipVia = Shippers.ShipperID  
group by Orders.OrderID, TRIM(Shippers.CompanyName)

--altr
SELECT o.OrderID, TRIM(s.CompanyName) AS ShipperName
FROM Orders o
JOIN Shippers s ON o.ShipVia = s.ShipperID;


-- 18)Get the names and quantities of products ordered by "QUICK-Stop".
select o.OrderID,sum(od.Quantity) total_quantities
from [Order Details] od
join Orders o on o.OrderID = od.OrderID
join Customers c on c.CustomerID= o.CustomerID
where c.CompanyName = 'QUICK-Stop'
group by o.OrderID