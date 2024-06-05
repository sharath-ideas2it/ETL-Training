--Type 1
--dimension table creation
CREATE TABLE dim1_Employees (
	EmployeeID int,
    FirstName varchar(30),
    LastName varchar(30),
    Country varchar(30)
);
--Insert query is the new data appears in the stagging table
INSERT INTO dim1_Employees (EmployeeID, FirstName, LastName, Country)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Country
FROM Employees e
left join dim1_Employees dm on dm.EmployeeID = e.EmployeeID
where dm.Country is null
--Update query for excution
Update Employees
set Country = 'USA'
Where EmployeeID = 1
--SCD Update Query
Update dim1_Employees
set dim1_Employees.Country = e.Country
from dim1_Employees dm
join Employees e on e.EmployeeID = dm.EmployeeID
where e.EmployeeID=dm.EmployeeID
and e.Country <> dm.Country

--Type 2
--dimension table creation
CREATE TABLE dim2_Employees (
	EmployeeID int,
    FirstName varchar(30),
    LastName varchar(30),
    Country varchar(30),
	isActive int
);
ALTER TABLE TableName ADD COLUMN this_date DATE DEFAULT CURRENT_DATE;
--Insert query is the new data appears in the stagging table
INSERT INTO dim2_Employees (EmployeeID, FirstName, LastName, Country,isActive)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Country,1
FROM Employees e
left join dim2_Employees dm on dm.EmployeeID = e.EmployeeID
where dm.Country is null
--Update query for excution
Update Employees
set Country = 'UK'
Where EmployeeID = 1
--SCD Update Query
Update dim2_Employees
set dim2_Employees.isActive = 0,
from dim2_Employees
where EmployeeID in (select e.EmployeeID
		from Employees e
		join dim2_Employees dm on dm.EmployeeID=e.EmployeeID
		where dm.EmployeeID=e.EmployeeID
		and e.Country<>dm.Country)

INSERT INTO dim2_Employees (EmployeeID, FirstName, LastName, Country,isActive)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Country,1
FROM Employees e
join dim2_Employees dm on dm.EmployeeID = e.EmployeeID
where dm.Country <> e.Country 

--Type 3
Select *
from Employees
--dimension table creation
CREATE TABLE dim3_Employees (
	EmployeeID int,
    FirstName varchar(30),
    LastName varchar(30),
    Country varchar(30),
	prv_Country varchar(30)
);
--Insert query is the new data appears in the stagging table
INSERT INTO dim3_Employees (EmployeeID, FirstName, LastName, Country)
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Country
FROM Employees e
left join dim3_Employees dm on dm.EmployeeID = e.EmployeeID
where dm.Country is null
--Update query for excution
Update Employees
set Country = 'USA'
Where EmployeeID = 1
--SCD Update Query
Update dim3_Employees
set dim3_Employees.prv_Country = dm.Country,dim3_Employees.Country = e.Country
from dim3_Employees dm
join Employees e on e.EmployeeID = dm.EmployeeID
where e.EmployeeID=dm.EmployeeID
and e.Country <> dm.Country

