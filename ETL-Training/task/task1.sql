-- 1)Get the names and quantities of products ordered by "QUICK-Stop".
select o.OrderID,sum(od.Quantity) total_quantities
from [Order Details] od
join Orders o on o.OrderID = od.OrderID
join Customers c on c.CustomerID= o.CustomerID
where c.CompanyName = 'QUICK-Stop'
group by o.OrderID

-- 2)List the employees who have supervised more than 3 other employees.
select concat(FirstName,' ',LastName)
from Employees
where EmployeeID in (select ReportsTo
from Employees
group by ReportsTo
having count(EmployeeID)>3)

select * from Employees

-- 3)Find the employees who have managed more than one territory.
select EmployeeID,count(TerritoryID)
from EmployeeTerritories
group by EmployeeID
having count(TerritoryID)>1

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
