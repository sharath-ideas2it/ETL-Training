-- windows functions........
--1 Determine the rank of each order by order date for each customer
select CustomerID,OrderDate,
rank() over(order by OrderDate) as ranks
from Orders
group by CustomerID,OrderDate

--2 Compute the average order amount for each customer and find the orders that exceed this average.
select o.CustomerID,od.OrderID,
avg(od.UnitPrice) over(partition by o.CustomerID) as avarage
from Orders o
join [Order Details] od on od.OrderID = o.OrderID

--3 Find the top 3 highest sales orders for each employee
select *
from (
	select o.EmployeeID,od.UnitPrice,
	ROW_NUMBER() over(partition by o.EmployeeID order by od.UnitPrice desc) as highsales
	from Orders o
	join [Order Details] od on od.OrderID=o.OrderID) as datas
where highsales<=3

--4 Calculate the average order amount for each month and the order amount for each order with respect to this monthly average.
select month(o.OrderDate),o.OrderID,od.UnitPrice,
avg(od.UnitPrice) over (partition by month(o.OrderDate))
FROM Orders o
JOIN [Order Details] od on o.OrderID = od.OrderID;

--5 Find the percentage of the total sales each employee contributed
select EmployeeID,count(OrderID) as total_sales,
(count(OrderID)*100)/sum(count(OrderID)) over() as percentage_of_total_sales
from Orders
group by EmployeeID

--6 Rank the products based on the total sales amount and include ties in ranking.
select ProductID,sumofprice,
rank() over(order by sumofprice desc) as totalsales
from (select ProductID,sum(UnitPrice) as sumofprice
	from [Order Details]
	group by ProductID) as t1
order by totalsales 

--7 Get the average order amount for each customer and the difference of each order amount from the customer's average order amount.
select c.CustomerID,avg(od.UnitPrice) as AvgOrderAmount,
(od.UnitPrice) - avg(od.UnitPrice) over (partition by c.CustomerID) as OrderAmountDifference
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
group by c.CustomerID, od.UnitPrice

--8 Find the total number of orders each customer has placed and the ranking of each customer based on this total
select CustomerID,total,
rank() over(order by total desc) as ranking
from (
	select CustomerID,
	count(OrderID) over(partition by CustomerID) as total
	from Orders) as t1
group by CustomerID,total
order by ranking

--9 Calculate the cumulative sales amount for each employee by order date
select o.EmployeeID,o.OrderDate,
sum(od.UnitPrice) over(partition by o.EmployeeID order by OrderDate) as sumss
from Orders o
join [Order Details] od on od.OrderID=o.OrderID
