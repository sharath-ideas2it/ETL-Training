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

-- 9) Retrieve the names of customers who have placed orders in 1997.
select OrderID,OrderDate
from Orders
where year(OrderDate) = 1997

-- 10)Find the customer who has made the highest total purchase amount
select OrderID,(UnitPrice*Quantity-Discount) as highest_total_purchase_amount
from [Order Details]                                                                        --need to work
group by OrderID

-- 11)Find the average unit price of products for each category
select CategoryID,avg(UnitPrice) as average_unit_price
from Products
group by CategoryID

-- 12)List the names of suppliers who supply products in the "Beverages" category
select SupplierID
from Products p 
join Categories c on c.CategoryID=p.CategoryID
where c.CategoryName like 'Beverages';