--21 Find the names of products that have been ordered by customers but are not supplied by suppliers from 'USA'.
select distinct Products.ProductName
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join [Order Details] on Orders.OrderID = [Order Details].OrderID
join Products on [Order Details].ProductID = Products.ProductID
join Suppliers on Products.SupplierID = Suppliers.SupplierID
where Suppliers.Country <> 'USA'

--22 List the names of customers who have placed an order but have not placed any orders in 1997.
select distinct Customers.CompanyName
from Customers
where Customers.CustomerID NOT IN (
    select distinct Orders.CustomerID
    from Orders
    where Year(Orders.OrderDate) = 1997
)

--23 Retrieve the names of products that have been both ordered and belong to the 'Beverages' category.
select distinct Products.ProductName
from Products
join [Order Details] on Products.ProductID = [Order Details].ProductID
join Categories on Products.CategoryID = Categories.CategoryID
where Categories.CategoryName = 'Beverages'

--24 List the names of suppliers who have supplied products ordered by customers but are not located in 'Germany'.
select distinct Suppliers.CompanyName
from Suppliers
join Products on Suppliers.SupplierID = Products.SupplierID
join [Order Details] on Products.ProductID = [Order Details].ProductID
join Orders on [Order Details].OrderID = Orders.OrderID
join Customers on Orders.CustomerID = Customers.CustomerID
where Customers.Country <> 'Germany'

--25 Retrieve the names of products that have been ordered but do not belong to the 'Confections' category.
select distinct Products.ProductName
from Products
join [Order Details] on Products.ProductID = [Order Details].ProductID
join Categories on Products.CategoryID = Categories.CategoryID
where Categories.CategoryName <> 'Confections'

--26 Retrieve the names of customers who have placed orders shipped by 'Speedy Express' and 'United Package'.
select distinct Customers.CompanyName
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
join Shippers on Orders.ShipVia = Shippers.ShipperID
where Shippers.CompanyName IN ('Speedy Express', 'United Package')
GROUP BY Customers.CompanyName

--27 List the names of products supplied by suppliers located in 'France' or 'Italy', but do not belong to the 'Seafood' category.
select distinct Products.ProductName
from Products
join Suppliers on Products.SupplierID = Suppliers.SupplierID
join Categories on Products.CategoryID = Categories.CategoryID
where (Suppliers.Country = 'France' OR Suppliers.Country = 'Italy')
AND Categories.CategoryName <> 'Seafood'

--28 List the names of products that have been ordered by customers in 'USA' and supplied by suppliers in 'UK'.
select distinct Products.ProductName
from Products
join [Order Details] on Products.ProductID = [Order Details].ProductID
join Orders on [Order Details].OrderID = Orders.OrderID
join Customers on Orders.CustomerID = Customers.CustomerID
join Suppliers on Products.SupplierID = Suppliers.SupplierID
where Customers.Country = 'USA'
AND Suppliers.Country = 'UK'

--29  Retrieve the names of products that have been ordered more than 10 times and have not been discontinued.
select distinct Products.ProductName
from Products
join [Order Details] on Products.ProductID = [Order Details].ProductID
where [Order Details].Quantity > 10
AND Products.Discontinued = 0

--30 Find the names of customers who have placed orders both in 1996 and 1997.
select Customers.CompanyName
from Customers
join Orders on Customers.CustomerID = Orders.CustomerID
where year(Orders.OrderDate) = 1996 or year(Orders.OrderDate) = 1997