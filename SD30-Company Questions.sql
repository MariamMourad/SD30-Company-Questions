--Use SD30-Company: 
--1 Create trigger to handle any delete operation on the Employee table to be “Soft Delete” not “Hard Delete”.

--a In Employee table add new column of type bit with name “IsDeleted” and make default for it to be “False”.
ALTER TABLE [dbo].[Employee]
ADD IsDeleted bit NOT NULL DEFAULT(0)
GO

--b When any user tries to delete Employee, don’t allow the delete Operation, and instead of it update the “IsDeleted” to be “True” for the  deleted employee (s).
Create Trigger PreventDelete
on [dbo].[Employee] Instead Of Delete
as
Begin
	Update [dbo].[Employee]
	set IsDeleted=1
	where [EmpNo] in (select [EmpNo] from deleted);
End

--c Make a view Name “vActiveEmployee” to return all not deleted employees (Return all employee data without the “IsDeleted” column).
Create view vActiveEmpInfo
As
	Select [EmpNo],[FName],[LName],[DeptNo],[salary]  From [dbo].[Employee]
	Where IsDeleted=0;

--d Delete some employees from the table.
Select * From [dbo].[Employee];
Delete From [dbo].[Employee] where [EmpNo]= 10102;

--e Try to select from the view, and select all data from the table to see the differences.
Select * From vActiveEmpInfo;

--2 Create a table named “BudgetChangeAudit”
--This table will be used to audit the update trials on the Budget column (Project table)
--Example:
--If a user updated the budget column the project number, user name who made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column

Create table BudgetChangeAudit (ID int primary key identity(1,1),
ProjectNo varchar(2) not null, UserName Nvarchar (20), ModifiedDate date, Budget_Old int, Budget_New int)

Create Trigger TrgBudgetChange
On [dbo].[Project] after Update
As
Begin
	If update(Budjet)

		Insert into BudgetChangeAudit ([ProjectNo], [UserName], [ModifiedDate], [Budget_Old], [Budget_New]) 
		Select i.[ProjectNo],SUSER_SNAME(),getdate(),d.[Budjet],i.[Budjet]
		From inserted i Inner Join deleted d
		On i.[ProjectNo] = d.[ProjectNo]
End

update [dbo].[Project]
set [Budjet] = 111999
Ehere [Budjet] = 120000

Select * From BudgetChangeAudit

--3 Create a stored procedure for inserts in the employee table, it takes columns values as parameters, and convert name to capital letters and insert the data into table (Note that ID column in Employee table is identity).
Create type dbo.EmpType As table
(
		EmpNo int not null
		,FName nvarchar(30)
		,LName nvarchar(30)
		,DeptNo varchar(2)
		,salary int
		,IsDeleted bit NOT NULL DEFAULT(0)
)
Go

Create procedure InsertEmp
		(@Emp EmpType READONLY)
As
Begin 
		Insert into [dbo].[Employee]
		Select * From @Emp
End

Declare @e1 EmpType
Insert into @e1 values (999, 'Mary', 'Kamel', 'd1', 5001, 0)
Exec InsertEmp @e1 

Select * From [dbo].[Employee]

--4 Change the previous procedure to take the Department Name, and inside the proc, select the ID of the sent department name and use it for inserting in Employee.
Create Procedure InsertEmpD (@EmpNo int , @Fname nvarchar(30),@Lname nvarchar(30),
@DepName nvarchar(30) , @salary int , @IsDeleted bit)
As
Begin
Declare @DNum varchar(2)
Select @DNum = [DeptNo] From [company].[department] Where [DepatName]= @DepName
Insert into [dbo].[Employee] values(@EmpNo  , @Fname ,@Lname , @DNum  , @salary , @IsDeleted )
End
Exec InsertEmpD 000 , 'Farah' , 'Wleed', 'Research' ,8001,0
Select * From [dbo].[Employee]

--5 On previous procedure:
--a Make it return the following status return:
--i (-1) if the employee fname less than 3 letters (do this check before insert opearation).
--ii (-2) if the employee lname less than 3 letters(do this check before insert opearation).
--iii (-3) if the DeptNo FK sent to the procedure, isn’t  exist in the dept table (do this check before insert opearation, and you may use if (exixts())).
--iv (error No) if any other error occurred when doing insert operation (use @@error).
--v. (0) if the operation is successfully done.
--b. Call the procedure and print the value returned from it.

Create Procedure InsertEmpErr (@EmpNo int , @Fname nvarchar(30),@Lname nvarchar(30),
@DeptNo varchar(2) , @salary int , @IsDeleted bit)
As
Begin
	If (len(@Fname)<3)
	Return -1
	Else If (len(@Lname)<3)
	Return -2
	Else If (@DeptNo not in (select [DeptNo] from [Company].[Department]))
	Return -3
	
	Begin Try
		Insert into [dbo].[Employee] values (@EmpNo, @Fname, @Lname, @DeptNo, @salary, @IsDeleted)
	End Try
	Begin Catch
	Return @@ERROR
	End Catch
End

Declare @Err int
Exec @Err = InsertEmpErr 777, 'Hasan', 'Mo', 'd3', 3333, 0
select @Err

Declare @Err int
Exec @Err = InsertEmpErr 2929, 'Dr', 'Mohsen', 'd3', 2222, 0
Select @Err

Declare @Err int
Exec @Err = InsertEmpErr 5050, 'Hala', 'Mouneer', 'd9', 6666, 0
Select @Err

Declare @Err int
Exec @Err = InsertEmpErr 654, 'H', 'Mo', 'd3', 3333, 0
Select @Err

--6 In the previous procedure, add an output parameter that returns the ID of the employee which was inserted (in case of the operation done successfully, and 0 in case of not executed).


Alter Procedure InsertEmpErr6 (@EmpNo int , @Fname nvarchar(30),@Lname nvarchar(30),
@DeptNo varchar(2) , @salary int , @IsDeleted bit, @n int out)
As
Begin
	If (len(@Fname)<3)
	Return -1
	Else If (len(@Lname)<3)
	Return -2
	Else If (@DeptNo not in (select [DeptNo] from [Company].[Department]))
	Return -3
	
	Begin try
		Insert into [dbo].[Employee] values (@EmpNo, @Fname, @Lname, @DeptNo, @salary, @IsDeleted)
		set @n = ident_current('[dbo].[Employee]') --@EmpNo
	End Try
	Begin Catch
	set @n=5
	End Catch
End

Select * From Employee

declare @n int
exec InsertEmpErr6 9009, 'Nour', 'Mohamed', 'd3', 3499, 0, @n output
select @n

select * from [dbo].[Employee]