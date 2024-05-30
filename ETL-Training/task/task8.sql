--stored proc....
--1 Create a stored procedure to get the total sales amount for a specific customer within a given date range.
	create procedure toatl_sales_for_customer
		@CustomerID varchar(10),
		@fromdate date,
		@todate date
	as
	select sum(od.UnitPrice * od.Quantity) as totalsalesamt
	from [Order Details] od
	join orders o on od.OrderID = o.OrderID
	where o.CustomerID = @CustomerID and O.OrderDate between @fromdate AND @todate
	go

	exec toatl_sales_for_customer @CustomerID='VINET',@fromdate='1996-01-01',@todate='1997-01-01'

--2 Write a stored procedure that updates the unit price of a product and logs the change into a history table.
	create procedure updateunitprice 
		@UnitPrice float,
		@ProductID int
	as
	update Products
	set UnitPrice = @UnitPrice
	where ProductID = @ProductID
	go
	exec updateunitprice @UnitPrice=23.8,@ProductID=1
--3 Create a stored procedure to insert a new order with its order details.
	--1)
		create procedure insertorder_orderdetails
			@CustomerID varchar(5),
			@EmployeeID int,
			@OrderDate datetime ,
			@RequiredDate datetime ,
			@ShippedDate datetime ,
			@ShipVia int ,
			@Freight float ,
			@ShipName varchar(40) ,
			@ShipAddress varchar(60) ,
			@ShipCity varchar(15) ,
			@ShipRegion varchar(15) ,
			@ShipPostalCode varchar(10) ,
			@ShipCountry varchar(15),
			@ProductID int,
			@UnitPrice float,
			@Quantity int,
			@Discount float
		as
		insert into Orders(CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate,ShipVia
		,Freight,ShipName,ShipAddress,ShipCity,ShipRegion,ShipPostalCode,ShipCountry)
		values(@CustomerID,@EmployeeID,@OrderDate,@RequiredDate,@ShippedDate,@ShipVia
		,@Freight,@ShipName,@ShipAddress,@ShipCity,@ShipRegion,@ShipPostalCode,@ShipCountry)

		insert into [Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
		select o.OrderID, @ProductID, @UnitPrice, @Quantity, @Discount
		from Orders o
		left join [Order Details] od on o.OrderID = od.OrderID
		where od.OrderID is null
		go
	--2)
		create procedure insertorder_orderdetails_useingscope
			@CustomerID varchar(5),
			@EmployeeID int,
			@OrderDate datetime ,
			@RequiredDate datetime ,
			@ShippedDate datetime ,
			@ShipVia int ,
			@Freight float ,
			@ShipName varchar(40) ,
			@ShipAddress varchar(60) ,
			@ShipCity varchar(15) ,
			@ShipRegion varchar(15) ,
			@ShipPostalCode varchar(10) ,
			@ShipCountry varchar(15),
			@ProductID int,
			@UnitPrice float,
			@Quantity int,
			@Discount float
		as
		declare @OrderID int;
		insert into Orders(CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate,ShipVia
		,Freight,ShipName,ShipAddress,ShipCity,ShipRegion,ShipPostalCode,ShipCountry)
		values(@CustomerID,@EmployeeID,@OrderDate,@RequiredDate,@ShippedDate,@ShipVia
		,@Freight,@ShipName,@ShipAddress,@ShipCity,@ShipRegion,@ShipPostalCode,@ShipCountry)

		SET @OrderID = SCOPE_IDENTITY();
		insert into [Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
		values(@OrderID,@ProductID,@UnitPrice, @Quantity, @Discount)
		go

	exec insertorder_orderdetails_useingscope @CustomerID = 'LILAS' ,@EmployeeID = 9 ,@OrderDate = '1999-09-09',@RequiredDate = '1999-09-09',@ShippedDate ='1999-09-09' ,
	@ShipVia = 1 ,@Freight = 99.99 ,@ShipName ='XXXXX' ,@ShipAddress = 'XXXXX',@ShipCity = 'XXXXX',@ShipRegion ='XXXXX' ,@ShipPostalCode = 'XXXXX',@ShipCountry = 'XXXXX',
	@ProductID =1 ,@UnitPrice = 99.99,@Quantity = 9,@Discount = 0

--4 Write a stored procedure to get the top N products by sales.
	create procedure topproducts @n int
	as 
	select top(@n) p.ProductName,count(od.OrderID) as salescount
	from Products p 
	join Order Details od on p.ProductID = od.ProductID
	group by p.ProductName
	go

	exec topproducts @n=5

--function...
-- 1 Create a function to get the total number of orders for a given customer.
	create function to_no_orders(@CustomerID varchar(50))
		returns int
	as
	begin
		return (select count(orderID) from Orders where CustomerID = @CustomerID)
	end
	go

	select dbo.to_no_orders('TOMSP') as t1
-- 2 Write a function that calculates the discount amount for a given order detail.
	create function discount(@OrderID int,@ProductID int)
	returns float
	as
	begin
		return(select UnitPrice * Quantity -Discount as discount_amount
				from [Order Details]
				where OrderID = @OrderID and ProductID = @ProductID)
	end 
	go
	select dbo.discount(10250,51) as t1

-- 3 Create a scalar function to get the full name of an employee given their EmployeeID.
	create function get_name(@EmployeeID int)
		returns varchar(50)
	as
	begin
		return (select FirstName+' '+LastName from Employees where EmployeeID = @EmployeeID)
	end
	go

	select dbo.get_name(1) as t1

--error handle...
--1 Modify the InsertOrder stored procedure to include error handling.
	create procedure insertorder_orderdetails_error_handle
		@CustomerID varchar(5),
		@EmployeeID int,
		@OrderDate datetime ,
		@RequiredDate datetime ,
		@ShippedDate datetime ,
		@ShipVia int ,
		@Freight float ,
		@ShipName varchar(40) ,
		@ShipAddress varchar(60) ,
		@ShipCity varchar(15) ,
		@ShipRegion varchar(15) ,
		@ShipPostalCode varchar(10) ,
		@ShipCountry varchar(15),
		@ProductID int,
		@UnitPrice float,
		@Quantity int,
		@Discount float
	as
	begin
		begin try 
			insert into Orders(CustomerID,EmployeeID,OrderDate,RequiredDate,ShippedDate,ShipVia
			,Freight,ShipName,ShipAddress,ShipCity,ShipRegion,ShipPostalCode,ShipCountry)
			values(@CustomerID,@EmployeeID,@OrderDate,@RequiredDate,@ShippedDate,@ShipVia
			,@Freight,@ShipName,@ShipAddress,@ShipCity,@ShipRegion,@ShipPostalCode,@ShipCountry)

			insert into [Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
			select o.OrderID, @ProductID, @UnitPrice, @Quantity, @Discount
			from Orders o
			left join [Order Details] od on o.OrderID = od.OrderID
			where od.OrderID is null
		end try
		begin catch
			select ERROR_LINE (),ERROR_MESSAGE() as error
		end catch
	end
	go

	exec insertorder_orderdetails_error_handle @CustomerID = 'LILAS' ,@EmployeeID = 're' ,@OrderDate = '1999-09-09',@RequiredDate = '1999-09-09',@ShippedDate ='1999-09-09' ,
	@ShipVia = 1 ,@Freight = 99.99 ,@ShipName ='XXXXX' ,@ShipAddress = 'XXXXX',@ShipCity = 'XXXXX',@ShipRegion ='XXXXX' ,@ShipPostalCode = 'XXXXX',@ShipCountry = 'XXXXX',
	@ProductID =1 ,@UnitPrice = 99.99,@Quantity = 9,@Discount = 0
--2 Create a stored procedure to delete an order and its details, with error handling to ensure both are deleted or none.
	create procedure deleteorder 
		@OrderID int
	as
		begin try
			begin transaction
				delete from [Order Details] where OrderID = @OrderID
				delete from Orders where OrderID = @OrderID
			commit transaction
		end try
		begin catch
			rollback transaction
			select ERROR_LINE (),ERROR_MESSAGE() as error
		end catch
	go
	exec deleteorder @OrderID = 11090
--ERROR--
	create procedure deleteorder_error 
		@OrderID int
	as
		begin try
			begin transaction
				delete from Orders where OrderID = @OrderID
				delete from [Order Details] where OrderID = @OrderID
			commit transaction
		end try
		begin catch
			rollback transaction
			select ERROR_LINE (),ERROR_MESSAGE() as error
		end catch
	go
	exec deleteorder_error @OrderID = 11089
--3 Create a stored procedure to transfer stock from one product to another with error handling.
	 create procedure transfer_stock @stock_to_transfer float,@from_ProductID int,@to_ProductID int
	 as
	 begin
		begin try
		 update Products set UnitsInStock = UnitsInStock - @stock_to_transfer where ProductID = @from_ProductID
		 update Products set UnitsInStock = UnitsInStock + @stock_to_transfer where ProductID = @to_ProductID
		end try
		begin catch
			select ERROR_LINE (),ERROR_MESSAGE() as error
		end catch
	end 
	go

	exec transfer_stock @stock_to_transfer = 1,@from_ProductID = 1,@to_ProductID = 2
