-- windows functions........
--1 Determine the rank of each order by order date for each customer
select CustomerID,OrderDate,
rank() over(order by OrderDate) as ranks
from Orders
group by CustomerID,OrderDate

--altr
SELECT 
    c.CustomerID,
    c.ContactName,
    o.OrderID,
    o.OrderDate,
    RANK() OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS OrderRank
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;


--2 Compute the average order amount for each customer and find the orders that exceed this average.
select o.CustomerID,
avg(od.UnitPrice) over(partition by o.CustomerID) as avarage
from Orders o
join [Order Details] od on od.OrderID = o.OrderID
--altr
--cte-operation

with AvgOrderAmount as (
    select o.CustomerID,
        avg(od.UnitPrice * od.Quantity) as average_order_amount
    from Orders o
    inner join [Order Details] od on o.OrderID = od.OrderID
    group by o.CustomerID)
select o.OrderID,o.CustomerID,od.UnitPrice * od.Quantity as order_amount
from Orders o
inner join [Order Details] od on o.OrderID = od.OrderID
inner join AvgOrderAmount aoa on o.CustomerID = aoa.CustomerID
where od.UnitPrice * od.Quantity > aoa.average_order_amount;




--3 Find the top 3 highest sales orders for each employee
select *
from (
	select o.EmployeeID,od.UnitPrice,
	ROW_NUMBER() over(partition by o.EmployeeID order by od.UnitPrice desc) as highsales
	from Orders o
	join [Order Details] od on od.OrderID=o.OrderID) as datas
where highsales<=3

--altr
--cte-operation
with t1 (emaployee_name,orderid,total) as 
(select e.FirstName+''+e.LastName as emaployee_name,o.OrderID as orderid,od.Quantity * od.UnitPrice as total
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
join [Order Details] od on o.OrderID = o.OrderID)

select emaployee_name,orderid,total
from(select *,
row_number () over (partition by emaployee_name order by total desc) as ranking
from t1 ) as t2
where ranking <= 3;


--4 Calculate the average order amount for each month and the order amount for each order with respect to this monthly average.
select month(o.OrderDate),o.OrderID,od.UnitPrice,
avg(od.UnitPrice) over (partition by month(o.OrderDate))
FROM Orders o
JOIN [Order Details] od on o.OrderID = od.OrderID;

-altr
SELECT 
    o.OrderID,
    o.OrderDate,
    SUM(od.Quantity * od.UnitPrice) AS OrderAmount,
    AVG(SUM(od.Quantity * od.UnitPrice)) OVER (PARTITION BY YEAR(o.OrderDate), MONTH(o.OrderDate)) AS MonthlyAvgOrderAmount
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID, o.OrderDate;


--5 Find the percentage of the total sales each employee contributed
select EmployeeID,count(OrderID) as total_sales,
(count(OrderID)*100)/sum(count(OrderID)) over() as percentage_of_total_sales
from Orders
group by EmployeeID

--altr
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    SUM(od.Quantity * od.UnitPrice) AS EmployeeSales,
    SUM(SUM(od.Quantity * od.UnitPrice)) OVER () AS TotalSales,
    (SUM(od.Quantity * od.UnitPrice) * 100.0 / SUM(SUM(od.Quantity * od.UnitPrice)) OVER ()) AS SalesPercentage
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;


--6 Rank the products based on the total sales amount and include ties in ranking.
select ProductID,sumofprice,
rank() over(order by sumofprice desc) as totalsales
from (select ProductID,sum(UnitPrice) as sumofprice
	from [Order Details]
	group by ProductID) as t1
order by totalsales 

--altr
SELECT 
    p.ProductID,
    p.ProductName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales,
    DENSE_RANK() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS SalesRank
FROM Products p
JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName;


--7 Get the average order amount for each customer and the difference of each order amount from the customer's average order amount.
select c.CustomerID,avg(od.UnitPrice) as AvgOrderAmount,
(od.UnitPrice) - avg(od.UnitPrice) over (partition by c.CustomerID) as OrderAmountDifference
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
group by c.CustomerID, od.UnitPrice

--altr
SELECT 
    c.CustomerID,
    c.ContactName,
    o.OrderID,
    SUM(od.Quantity * od.UnitPrice) AS OrderAmount,
    AVG(SUM(od.Quantity * od.UnitPrice)) OVER (PARTITION BY c.CustomerID) AS AvgOrderAmount,
    SUM(od.Quantity * od.UnitPrice) - AVG(SUM(od.Quantity * od.UnitPrice)) OVER (PARTITION BY c.CustomerID) AS DifferenceFromAvg
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.ContactName, o.OrderID;


--8 Find the total number of orders each customer has placed and the ranking of each customer based on this total
select CustomerID,total,
rank() over(order by total desc) as ranking
from (
	select CustomerID,
	count(OrderID) over(partition by CustomerID) as total
	from Orders) as t1
group by CustomerID,total
order by ranking

--altr
SELECT 
    c.CustomerID,
    c.ContactName,
    COUNT(o.OrderID) OVER (PARTITION BY c.CustomerID) AS TotalOrders,
    RANK() OVER (ORDER BY COUNT(o.OrderID) DESC) AS CustomerRank
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName;

--9 Calculate the cumulative sales amount for each employee by order date
select o.EmployeeID,o.OrderDate,
sum(od.UnitPrice) over(partition by o.EmployeeID order by OrderDate) as sumss
from Orders o
join [Order Details] od on od.OrderID=o.OrderID

--altr
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    o.OrderID,
    o.OrderDate,
    SUM(od.Quantity * od.UnitPrice) OVER (PARTITION BY e.EmployeeID ORDER BY o.OrderDate) AS CumulativeSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, o.OrderID, o.OrderDate;

