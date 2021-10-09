
--------------------------------------------------------------------------------------------------------------------------

-- Creating Tables
Use PortfolioProject;


-- Drop TABLE IF EXISTS EmployeeDemographics;

Create Table EmployeeDemographics 
(
	EmployeeID int, 
	FirstName varchar(50), 
	LastName varchar(50), 
	Age int, 
	Gender varchar(50)
)

-- Drop TABLE IF EXISTS EmployeeDemographics;

Create Table EmployeeSalary
(
	EmployeeID int,
	JobTitle varchar(50), 
	Salary int
)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Tables With Data

Insert Into EmployeeDemographics 
Values
	(1001,'Huzaifa','Khan',20,'Male'),
	(1002, 'Pam', 'Beasley', 30, 'Female'),
	(1003, 'Dwight', 'Schrute', 29, 'Male'),
	(1004, 'Angela', 'Martin', 31, 'Female'),
	(1005, 'Toby', 'Flenderson', 32, 'Male'),
	(1006, 'Michael', 'Scott', 35, 'Male'),
	(1007, 'Meredith', 'Palmer', 32, 'Female'),
	(1008, 'Stanley', 'Hudson', 38, 'Male'),
	(1009, 'Kevin', 'Malone', 31, 'Male')

Insert Into EmployeeSalary 
Values
	(1001, 'Salesman', 45000),
	(1002, 'Receptionist', 36000),
	(1003, 'Salesman', 63000),
	(1004, 'Accountant', 47000),
	(1005, 'HR', 50000),
	(1006, 'Regional Manager', 65000),
	(1007, 'Supplier Relations', 41000),
	(1008, 'Salesman', 48000),
	(1009, 'Accountant', 42000)


-----------------------------------------------------------------------------

-- Select Data From Table And Conditional Selection

Select *
From EmployeeDemographics


Select Max(Salary) AS Minimum, Min(Salary) AS Maximum, Avg(Salary) AS Average
From EmployeeSalary

-- Where Conditions =, <>, !=, IN,BETWEEN,LIKE,REGEXP,AND,OR,NOT, IS NULL, IS NOT NULL, >=, >, <=, <, 

Select *
From EmployeeSalary
Where Salary = 45000


--------------------------------------------------------------------------------------------------------------------------

-- Order By | Group By(Rolls the records in a table for finding aggregated values Like Sum|Avg...)


Select *
From EmployeeDemographics

--- Average Salary Of Each Job Title Ordered By 2 Column(Average Salary)
Select JobTitle,Avg(Salary) 'Average Salary'
From EmployeeSalary
Where JobTitle = 'Salesman' 
Group By JobTitle
Order By 2 DESC

--------------------------------------------------------------------------------------------------------------------------

-- Inner Join | Outer Join ( Left Join | Right Join ) | Full Join 

Select * 
From EmployeeDemographics em
Join EmployeeSalary es
	On es.EmployeeID = em.EmployeeID

Select *
From EmployeeDemographics em
FULL Outer Join EmployeeSalary es
	On em.EmployeeID = es.EmployeeID

Select *
From EmployeeDemographics em
Right Outer Join EmployeeSalary es
	On em.EmployeeID = es.EmployeeID

Select *
From EmployeeDemographics em
Left Outer Join EmployeeSalary es
	On em.EmployeeID = es.EmployeeID


--------------------------------------------------------------------------------------------------------------------------

-- Unions

Select *
From EmployeeDemographics
Union
Select *
From WareHouseEmployeeDemographics

Select * 
From EmployeeDemographics
Union
Select * 
From WareHouseEmployeeDemographics





--------------------------------------------------------------------------------------------------------------------------

-- Temp Tables

Create Table #temp_Employee 
(
EmployeeID int,
JobTitle varchar(100),
Salary Int,
)

Select *
From #temp_Employee

Insert Into #temp_Employee Values
(
	1001, 'Salesman', 23000
)

Insert Into #temp_Employee
Select * 
From EmployeeSalary

Drop Table If Exists #Temp_Employee2;
Create Table #Temp_Employee2
(
	JobTitle varchar(50),
	EmployeesPerJob int,
	Avg_Age float,
	Avg_Salary float
)

Insert Into #Temp_Employee2
Select es.JobTitle, Count(es.JobTitle),Avg(ed.Age),Avg(es.Salary)
From EmployeeDemographics ed, EmployeeSalary es
Where ed.EmployeeID = es.EmployeeID
Group By es.JobTitle

Select *
From #Temp_Employee2


--------------------------------------------------------------------------------------------------------------------------

-- String Functions


--Drop Table if exists EmployeeErrors;
--CREATE TABLE EmployeeErrors (
--EmployeeID varchar(50)
--,FirstName varchar(50)
--,LastName varchar(50)
--)

--Insert into EmployeeErrors Values 
--('1001  ', 'Jimbo', 'Halbert')
--,('  1002', 'Pamela', 'Beasely')
--,('1005', 'TOby', 'Flenderson - Fired')


-- Using Trim, LTRIM, RTRIM

Select EmployeeID, Trim(EmployeeID) as IDTRIM
From EmployeeErrors

Select EmployeeID, RTrim(EmployeeID) as IDRTRIM
From EmployeeErrors

Select EmployeeID, LTrim(EmployeeID) as IDLTRIM
From EmployeeErrors

-- Using REPLACE

Select LastName, REPLACE(LastName, '- Fired','') as LastNameFixed 
From EmployeeErrors

-- Substring
-- Fuzzy Matching
Select er.FirstName, ed.FirstName
From EmployeeErrors er
Join EmployeeDemographics ed
	On SUBSTRING(er.FirstName,1,3) = SUBSTRING(ed.FirstName,1,3)

-- Using Upper And lower

Select FirstName, Replace(FirstName,SUBSTRING(FirstName,2,Len(FirstName)),Lower(SUBSTRING(FirstName,2,Len(FirstName))))
From PortfolioProject..EmployeeErrors


--------------------------------------------------------------------------------------------------------------------------

-- Subqueries (Select, From, Where, Insert, Update, Delete...)


-- 

Select *
From EmployeeSalary

-- In Select Statement

Select EmployeeID, (Select SUM(Salary) From EmployeeSalary)
From EmployeeSalary

-- In From Statement (A temp table is much prefered or CTE(temp table has priority))

Select e.employee_id, e.first_name, e.last_name, o.address, o.city, o.state, o.office_id
From (Select * From  sql_hr..offices) o
Join (Select * From sql_hr..employees) e
	On o.office_id = e.office_id

-- In Where Statement

Select *
From EmployeeSalary
Where EmployeeID IN (Select EmployeeID From EmployeeDemographics Where JobTitle Like '%S%')

-- In Insert Statment

Insert into #Temp_EmployeeSalary
Select EmployeeID, JobTitle, Salary
From EmployeeSalary

Select * 
From #Temp_EmployeeSalary

-- In Update Statment
Update #Temp_EmployeeSalary SET ID = 1014
Where JobTitle IN (Select JobTitle From EmployeeSalary Where JobTitle = 'Data Scientist')

Select*
From #Temp_EmployeeSalary

-- In Delete Statement 
Delete From #Temp_EmployeeSalary
Where ID IN ( Select EmployeeID From EmployeeSalary Where Salary Is Null)

Select*
From #Temp_EmployeeSalary


--------------------------------------------------------------------------------------------------------------------------

-- Partition By



Select FirstName, LastName, Salary , Avg(Salary) over ( Partition by Gender) AverageSalaryByGender
From EmployeeDemographics ed 
Join EmployeeSalary es 
	On es.EmployeeID = ed.EmployeeID


--------------------------------------------------------------------------------------------------------------------------

-- Case Statements


Select *, 
	CASE 
	WHEN Salary > 40000 THEN ':-)' 
	WHEN Salary < 40000 THEN ':-('
	END
From PortfolioProject..EmployeeSalary


Select *, 
	(CASE WHEN Salary > 40000 THEN ':-)' ElSE NULL END) As HappyEmployee, 
	(CASE WHEN Salary < 40000 THEN ':-(' ELSE NULL END) As SadEmployee
From PortfolioProject..EmployeeSalary

--------------------------------------------------------------------------------------------------------------------------

-- Having Clause

Select JobTitle, Count(JobTitle)
From PortfolioProject..EmployeeSalary
Group By JobTitle
Having COUNT(JobTitle) > 1


--------------------------------------------------------------------------------------------------------------------------

-- Stores Procedures

-- First Procedure

Drop Procedure If Exists dbo.spEmployeeSalary_getall;
Go
Create Procedure dbo.spEmployeeSalary_getall
As
Begin
	Set NoCount on;

	Select EmployeeID, JobTitle, Salary
	From PortfolioProject..EmployeeSalary
End

-- Executing
exec dbo.spEmployeeSalary_getall


-- Second Procedure


Drop Procedure If Exists dbo.spTemp_CreateTable;
GO
Create Procedure dbo.spTemp_CreateTable
	@JobTitle nvarchar(100)
As
Begin
	Set NoCount on;
Drop Table IF Exists #temp_Employee;
Create Table #temp_Employee 
(
	JobTitle varchar(100),
	EmployeePerJob int,
	AvgAge float,
	AvgSalary float,

)

Insert Into #temp_Employee
Select JobTitle, Count(JobTitle),Avg(Age),Avg(Salary)
From PortfolioProject..EmployeeDemographics ed 
Join PortfolioProject..EmployeeSalary es
	On ed.EmployeeID = es.EmployeeID
Where JobTitle = @JobTitle
Group By JobTitle

Select *
From #temp_Employee

End

-- Executing 

EXEC dbo.spTemp_CreateTable @JobTitle = 'Salesman'

--------------------------------------------------------------------------------------------------------------------------

-- Some PSQL Queries


--SELECT 
--      location ,lon , Split_part(TRIM(both '()' from location),',',2) as longitude, lat ,Split_part(TRIM(both '()' from location),',',1) as latitude
--From tutorial.sf_crime_incidents_2014_01



--Select
--      location , 
--      lon, 
--      TRIM(trailing ')' From Right(location, LENGTH(location) - POSITION(',' IN location) ) ) as longitude, 
--      lat,
--      TRIM(Leading '(' From LEFT(location, POSITION(',' IN location) + 1 ) ) as latitude
--From tutorial.sf_crime_incidents_2014_01


--SELECT location,
--       lon,
--       SUBSTR( location, Position(',' In location) + 1,LENGTH(location) - 2 ) AS longitude,
--       lat,
--       SUBSTR( location, 2, Position(',' In location) - 1) as latitude
--  FROM tutorial.sf_crime_incidents_2014_01
