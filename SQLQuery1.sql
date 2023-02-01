Create Database P22901022023

Use P22901022023

Create Table Employees
(
	Id int identity primary key,
	Name nvarchar(100),
	SurName nvarchar(100)
)

Alter Table Employees
Add DepartmentId int Foreign Key References Departments(Id)

Create Table Departments
(
	Id int identity primary key,
	Name nvarchar(100)
)

Insert Into Departments
Values
('Maliyye'),
('Hr'),
('Marketing'),
('Academik')

Insert Into Employees
Values
('Hamid','Zeynalov'),
('Zaur','Abdullaye'),
('Rashad','Ismayilov'),
('Mahmud','Aliyev'),
('Farid','Garayev'),
('Farid','Mansurov')

Select Count(*) From Employees

--Distinct
Select COUNT(distinct Name) From Employees

--Group By Having
Select Name, COUNT(*) 'Count' From Employees
Group By Name 

Select Name, COUNT(*) 'Count' From Employees
Group By Name 
Having COUNT(*) > 1

--Order By Asc(default) / Desc
Select * From Employees
Order By Id Desc

--Like
Select * From Employees
Where Name Like '%i%'

Select * From Employees e
Join Departments d
On e.DepartmentId = d.Id
Where d.Name Like '%a%'

--Exists
Select * From Employees 
where 
Exists(Select * From Departments where Id = Employees.DepartmentId AND Name Like '%a%')

--Union / Union All 
Select SurName From Employees 
Where SurName Like '%a%'
Union
Select Name  From Departments
Where Name Like '%a%'

Select * From 
(
Select SurName From 
(
	Select SurName From Employees 
	Union all
	Select Name  From Departments
) as sq1
Union
Select SurName From 
(
	Select SurName From Employees 
	Union all
	Select Name  From Departments
) as sq1
)  mq where mq.SurName like '%a%'

CREATE TABLE Brands
(
	Id INT CONSTRAINT PK_Brands_Id PRIMARY KEY Identity,
	Name nvarchar(50) NOT NULL CONSTRAINT CK_Brands_Name CHECK(LEN(Name) > 1)
)

INSERT INTO Brands
VALUES
('Apple'),
('Hp'),
('Samsung'),
('Xiaomi'),
('Huawei'),
('Asus'),
('Dell')


CREATE TABLE Notebooks
(
	 Id INT CONSTRAINT PK_Notebooks_Id PRIMARY KEY Identity,
	 Name nvarchar(50) NOT NULL CONSTRAINT CK_Notebooks_Name CHECK(LEN(Name) > 1), 
	 Price Money NOT NULL CONSTRAINT CK_Notebooks_Price CHECK(Price > 100),
	 BrandId INT CONSTRAINT FK_Notebooks_BrandId FOREIGN KEY REFERENCES Brands(Id)
)

INSERT INTO Notebooks
VALUES
('250 G5', 943, 2),
('250 G6', 1158, 2),
('250 G7', 1251, 2),
('Air', 2363, 1),
('Pro 13', 2975, 1),
('Pro 15', 3439, 1),
('ROG', 2928, 6),
('ROG PRO', 3968, 6),
('VIVOBOOK 15', 1536, 6),
('VIVOBOOK 14', 1325, 6),
('Mate X', 1600, 5),
('Mate X PRO', 1900, 5),
('Mate XL PRO', 1864, 5),
('Mate XXL PRO', 1253, 5),
('Mi Notebook Air', 1753, 4),
('Mi Notebook Pro', 2153, 4),
('Lustrous Grey', 4681, 4),
('Galaxy Book', 1874, 3),
('Galaxy Book PRO', 3274, 3),
('Galaxy Book AIR', 2574, 3),
('Galaxy Book AIR PRO', 3367, 3)


CREATE TABLE Phones
(
	Id INT CONSTRAINT PK_Phones_Id PRIMARY KEY Identity,
	Name nvarchar(50) NOT NULL CONSTRAINT CK_Phones_Name CHECK(LEN(Name) > 1), 
	Price Money NOT NULL CONSTRAINT CK_Phones_Price CHECK(Price > 100),
	BrandId INT CONSTRAINT FK_Phones_BrandId FOREIGN KEY REFERENCES Brands(Id)
)

INSERT INTO Phones
VALUES
('Galaxy Book AIR PRO', 3367, 3),
('13', 2463, 1),
('13 Pro', 3075, 1),
('13 Pro Max', 3339, 1),
('Mate Pad', 1600, 5),
('Mate Xs', 1900, 5),
('Nova 9 SE', 1864, 5),
('P50E', 1853, 5),	
('Poco 5', 1753, 4),
('Poco 4', 2153, 4),
('Poco 6', 4681, 4),
('A11', 275, 3),
('A21', 285, 3),
('A31', 374, 3),
('A41', 467, 3),
('A51', 567, 3),
('A61', 667, 3),
('A71', 767, 3),
('A81', 867, 3),
('A91', 967, 3)

Select BrandId, Name From Notebooks
Union All
Select BrandId, Name From Phones

Select b.Name, Count(*), SUM(p.Price) From Brands b
Join Phones p
On b.Id = p.BrandId
Group By b.Name

--View
--View-nun Yaradilmasi
Create View usv_GetBrandsStatistics
as
Select b.Name, Count(*) 'Count', SUM(p.Price) 'TotalPrice' From Brands b
Join Phones p
On b.Id = p.BrandId
Group By b.Name

--View-nun Editlenmesi
Alter View usv_GetBrandsStatistics
as
Select b.Name 'BrandName', Count(*) 'Count', SUM(p.Price) 'TotalPrice' From Brands b
Join Phones p
On b.Id = p.BrandId
Group By b.Name

--View-nun Isdifade Olunmasi
select * from usv_GetBrandsStatistics 

select * from usv_GetBrandsStatistics where ProductCount > 3

--Procedure
--Create Procedure
Create Procedure usp_GetBrandsStatisticsByPrice
@price money
as
Begin
	Select b.Name 'BrandName', Count(*) 'Count', SUM(p.Price) 'TotalPrice' From Brands b
	Join Phones p
	On b.Id = p.BrandId
	Where p.Price > @price
	Group By b.Name
End

--Edit Procedure
Alter Procedure usp_GetBrandsStatisticsByPrice
@price money,
@brandId int
as
Begin
	Select b.Name 'BrandName', Count(*) 'Count', SUM(p.Price) 'TotalPrice' From Brands b
	Join Phones p
	On b.Id = p.BrandId
	Where p.Price > @price And p.BrandId = @brandId
	Group By b.Name
End

--Use Procedure
exec usp_GetBrandsStatisticsByPrice 1000,3

exec sp_rename 'Employees','Isciler'

exec sp_rename 'Isciler.Name','Ad'

--Function

Create Function usf_GetCountByPrice
(@price money)
returns int
as
begin
	declare @count int

	Select @count = COUNT(*) From Brands b
	Join Phones p
	On b.Id = p.BrandId
	where p.Price > @price

	return @count
end

Alter Function usf_GetCountByPrice
(@price money,
@brandId int)
returns int
as
begin
	declare @count int

	Select @count = COUNT(*) From Brands b
	Join Phones p
	On b.Id = p.BrandId
	where p.Price > @price And p.BrandId = @brandId

	return @count
end

Select dbo.usf_GetCountByPrice(3000,2)

Create Table ArchiveNotebooks
(
	Id Int,
	Name nvarchar(50),
	Price money,
	BrandId int,
	Date DateTime2,
	StatementType nvarchar(50)
)

Create Trigger NotebooksChanged
on Notebooks
after insert
As
Begin
	declare @id int
	declare @name nvarchar(50)
	declare @price money
	declare @brandId int
	declare @date DateTime2
	declare @statementType nvarchar(50)

	Select @id = test.Id From inserted test
	Select @name = test.Name From inserted test
	Select @price = test.Price From inserted test
	Select @brandId = test.BrandId From inserted test
	Select @date = GETUTCDATE() From inserted test
	Select @statementType = 'Inserted' From inserted test

	Insert Into ArchiveNotebooks
	Values
	(@id,@name,@price,@brandId,@date,@statementType)
End

Alter Trigger NotebooksChanged
on Notebooks
after insert,delete
As
Begin
	declare @id int
	declare @name nvarchar(50)
	declare @price money
	declare @brandId int
	declare @date DateTime2
	declare @statementType nvarchar(50)

	Select @id = test.Id From inserted test
	Select @name = test.Name From inserted test
	Select @price = test.Price From inserted test
	Select @brandId = test.BrandId From inserted test
	Select @date = GETUTCDATE() From inserted test
	Select @statementType = 'Inserted' From inserted test

	Select @id = test.Id From deleted test
	Select @name = test.Name From deleted test
	Select @price = test.Price From deleted test
	Select @brandId = test.BrandId From deleted test
	Select @date = GETUTCDATE() From deleted test
	Select @statementType = 'Deleted' From deleted test

	Insert Into ArchiveNotebooks
	Values
	(@id,@name,@price,@brandId,@date,@statementType)
End

Create Trigger NotebooksChangedByUpdate
on Notebooks
after update
As
Begin
	declare @id int
	declare @name nvarchar(50)
	declare @price money
	declare @brandId int
	declare @date DateTime2
	declare @statementType nvarchar(50)

	Select @id = test.Id From inserted test
	Select @name = test.Name From inserted test
	Select @price = test.Price From inserted test
	Select @brandId = test.BrandId From inserted test
	Select @date = GETUTCDATE() From inserted test
	Select @statementType = 'Inserted' From inserted test

	Insert Into ArchiveNotebooks
	Values
	(@id,@name,@price,@brandId,@date,@statementType)
End

Alter Trigger NotebooksChangedByUpdate
on Notebooks
after update
As
Begin
	declare @id int
	declare @name nvarchar(50)
	declare @price money
	declare @brandId int
	declare @date DateTime2
	declare @statementType nvarchar(50)

	Select @id = test.Id From inserted test
	Select @name = test.Name From inserted test
	Select @price = test.Price From inserted test
	Select @brandId = test.BrandId From inserted test
	Select @date = GETUTCDATE() From inserted test
	Select @statementType = 'Updated' From inserted test

	Insert Into ArchiveNotebooks
	Values
	(@id,@name,@price,@brandId,@date,@statementType)
End

Insert Into Notebooks
Values
('MacBook',3500,1)