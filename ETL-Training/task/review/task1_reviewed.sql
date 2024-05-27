-- 1)Get the names and quantities of products ordered by "QUICK-Stop".
select o.OrderID,sum(od.Quantity) total_quantities
from [Order Details] od
join Orders o on o.OrderID = od.OrderID
join Customers c on c.CustomerID= o.CustomerID
where c.CompanyName = 'QUICK-Stop'
group by o.OrderID  

--altr
SELECT p.ProductName, od.Quantity
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.CompanyName = 'QUICK-Stop';


-- 2)List the employees who have supervised more than 3 other employees.
select concat(FirstName,' ',LastName)
from Employees
where EmployeeID in (select ReportsTo
from Employees
group by ReportsTo
having count(EmployeeID)>3)

select * from Employees

--altr
SELECT e1.FirstName, e1.LastName, COUNT(e2.EmployeeID) AS NumberOfSubordinates
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.FirstName, e1.LastName
HAVING COUNT(e2.EmployeeID) > 3;


-- 3)Find the employees who have managed more than one territory.
select EmployeeID,count(TerritoryID)
from EmployeeTerritories
group by EmployeeID
having count(TerritoryID)>1

--altr
SELECT e.FirstName, e.LastName
FROM Employees e
JOIN EmployeeTerritories et ON e.EmployeeID = et.EmployeeID
GROUP BY e.FirstName, e.LastName
HAVING COUNT(DISTINCT et.TerritoryID) > 1;


-- 4) Find the orders placed between '1997-01-01' and '1997-12-31'.
select OrderID
from Orders
where OrderDate between '1997-01-01' and '1997-12-31'

-- 5) Get the names of employees whose titles contain the word 'Sales'
select FirstName,LastName
From Employees
where Title like '%Sales%'

-- 6)Find the customers who are not from 'USA', 'UK', or 'Canada'
select CustomerID
from Customers
where Country not in ('USA','UK','Canada')
