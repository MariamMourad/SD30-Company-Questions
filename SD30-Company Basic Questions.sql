--1 Display all the employees Data.
SELECT *
FROM [dbo].[Employee]

--2 Display the employee First name, last name, Salary and Department number.
SELECT Fname, Lname, Salary, Dno
FROM [dbo].[Employee]

--3 Display all the projects names, locations and the department which is responsible about it.
SELECT p.Pname, p.Plocation, d.Dname
FROM [dbo].[Project] p JOIN [dbo].[Departments] d
on p.Dnum = d.Dnum

--4 If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
SELECT Fname+' '+Lname as Full_Name, salary*12*10/100 as Annual_Comm
FROM [dbo].[Employee]

--5 Display the employees Id, name who earns more than 1000 LE monthly.
SELECT SSN, Fname
FROM [dbo].[Employee]
WHERE Salary > 1000

--6 Display the employees Id, name who earns more than 10000 LE annually.
SELECT SSN, Fname
FROM [dbo].[Employee]
WHERE (Salary*12) > 10000

--7 Display the names and salaries of the female employees.
SELECT Fname, Salary
FROM [dbo].[Employee]
WHERE Sex = 'F' 

--8 Display each department id, name which managed by a manager with id equals 968574.
SELECT d.[Dnum], d.[Dname]
FROM [dbo].[Departments] d JOIN [dbo].[Employee] e
on e.Dno = d.Dnum
WHERE e.SSN = 968574

--9 Dispaly the ids, names and locations of  the pojects which controled with department 10.
SELECT p.Pnumber, p.Pname, p.Plocation
FROM [dbo].[Departments] d JOIN [dbo].[Project] p
on p.Dnum = d.Dnum
WHERE p.Dnum = 10

--10 Display the Department id, name and id and the name of its manager.
SELECT d.Dnum, d.Dname, d.MGRSSN, e.Fname
FROM [dbo].[Departments] d, [dbo].[Employee] e
WHERE d.MGRSSN = e.Superssn

--11 Display the name of the departments and the name of the projects under its control.
SELECT d.Dname, p.Pname
FROM [dbo].[Departments] d, [dbo].[Project] p
WHERE d.Dnum = p.Dnum

--12 Display the full data about all the dependence associated with the name of the employee they depend on him/her.
SELECT d.*, e.Fname
FROM [dbo].[Dependent] d, [dbo].[Employee] e
WHERE d.ESSN = e.SSN

--13 Display the Id, name and location of the projects in Cairo or Alex city.
SELECT Pnumber, Pname, Plocation 
FROM [dbo].[Project]
WHERE City IN ('Cairo' , 'Alex')

--14 Display the Projects full data of the projects with a name starts with "a" letter.
SELECT *
FROM [dbo].[Project]
WHERE Pname LIKE 'a%'

--15 Display all the employees in department 30 whose salary from 1000 to 2000 LE monthly.
SELECT e.Fname
FROM [dbo].[Departments] d, [dbo].[Employee] e
WHERE d.Dnum = e.Dno AND e.Salary BETWEEN 1000 AND 2000 AND d.Dnum = 30

--16 Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
SELECT e.Fname
FROM [dbo].[Employee] e, [dbo].[Project] p, [dbo].[Works_for] w
WHERE w.ESSn = e.SSN AND p.Pnumber = w.Pno 
       AND e.Dno = 10 AND w.Hours>=10 AND p.Pname = 'AL Rabwah'

--17 Find the names of the employees who directly supervised with Kamel Mohamed.
SELECT e.Fname
FROM [dbo].[Employee] e INNER JOIN [dbo].[Employee] s
on e.Superssn = s.SSN
WHERE s.Fname = 'Kamel' AND s.Lname = 'Mohamed'
--another way, right
SELECT fname
FROM [dbo].[Employee]
WHERE Superssn = (SELECT SSN
                   FROM [dbo].[Employee]
				   WHERE Fname = 'Kamel' AND Lname = 'Mohamed')

--18 Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
SELECT e.Fname, p.Pname
FROM [dbo].[Employee] e, [dbo].[Project] p, [dbo].[Departments] d
WHERE p.Dnum = d.Dnum AND e.Dno = d.Dnum
order by p.Pname

--19 For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
SELECT e.Lname, p.Pname, d.Dname, e.[Address], e.Bdate
FROM [dbo].[Employee] e, [dbo].[Project] p, [dbo].[Departments] d
WHERE p.Dnum = d.Dnum AND e.Dno = d.Dnum AND p.City = 'Cairo'

--20 Display All Data of the mangers.
SELECT e.*
FROM [dbo].[Employee] e, [dbo].[Departments] d 
WHERE e.SSN = d.MGRSSN

--21 Display All Employees data and the data of their dependents even if they have no dependents.
SELECT e.*, d.*
FROM [dbo].[Employee] e LEFT OUTER JOIN [dbo].[Dependent] d 
on e.SSN = d.ESSN

--22 Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
INSERT INTO [dbo].[Employee] (Fname, Lname, Sex, [Address], Bdate, SSN, Dno, Superssn, Salary)
VALUES ('Mary', 'Ali', 'F', 'New Cairo', '1995-08-01', 102672, 30, 112233, 3000)

--23 Insert another employee with personal data your friend as new employee in department number 30, SSN = 102660, but don’t enter any value for salary or manager number to him.
INSERT INTO [dbo].[Employee] (Fname, Lname, Sex, [Address], Bdate, SSN, Dno)
VALUES ('Mark', 'Adel', 'M', 'Alex', '1984-09-12', 102660, 30)
--to check
SELECT *
FROM [dbo].[Employee]

--24 Upgrade your salary by 20 % of its last value.
UPDATE [dbo].[Employee]
SET Salary+= Salary*20/100
WHERE [SSN] = 102672
 
--25. For each project, list the project name and the total hours per week (for all employees) spent on that project.
SELECT p.Pname, SUM(w.Hours) Total_Weekly_Hours
FROM [dbo].[Project] p, [dbo].[Works_for] w
WHERE p.Pnumber = w.Pno
GROUP BY p.Pname

--26. Display the data of the department which has the smallest employee ID over all employees' ID.
SELECT *
FROM [dbo].[Departments]
WHERE [Dnum] = (SELECT emp.Dno
                 FROM (SELECT MIN(SSN) Min_ID
                        FROM [dbo].[Employee]) SmallestID JOIN [dbo].[Employee] emp
                        ON SmallestID.Min_ID = emp.SSN)

--27. For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
SELECT d.Dname, MAX(e.Salary) Max_S, MIN(e.Salary) Min_S, AVG(e.Salary) Avg_S
FROM [dbo].[Employee] e, [dbo].[Departments] d
WHERE d.Dnum = e.Dno
GROUP BY d.Dname

--28. List the last name of all managers who have no dependents
SELECT e.Fname
FROM [dbo].[Employee] e, [dbo].[Departments] d
WHERE d.MGRSSN = e.SSN AND d.MGRSSN NOT IN (SELECT d.ESSN
                                             FROM [dbo].[Dependent] d
                                              WHERE d.ESSN IN (SELECT e.SSN
                                                               FROM [dbo].[Employee] e, [dbo].[Departments] d
            	                                               WHERE d.MGRSSN = e.SSN))

--29. For each department if its average salary is less than the average salary of all employees display its number, name and number of its employees.
SELECT d.[Dnum], d.[Dname], COUNT(e.SSN) Emp_Num
FROM [dbo].[Departments] d, [dbo].[Employee] e
WHERE e.Dno = d.Dnum AND d.Dnum = (SELECT AD.Dnum
                                   FROM (SELECT AVG(e.Salary) Avg_for_each_dep, d.Dnum
                                         FROM [dbo].[Employee] e, [dbo].[Departments] d
                                         WHERE e.Dno = d.Dnum
                                         GROUP BY d.[Dnum]) AD
                                         WHERE AD.Avg_for_each_dep < (SELECT AVG(Salary) Avg_for_all_epm
                                                                       FROM [dbo].[Employee]))
GROUP BY d.[Dnum], d.[Dname]

--30. Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.
SELECT e.Fname, e.Lname, p.Pname
FROM [dbo].[Employee] e, [dbo].[Project] p, [dbo].[Works_for] w
WHERE e.SSN = w.ESSn  AND p.Pnumber = w.Pno
order by p.Dnum, e.Lname, e.Fname

--31. Try to get the max 2 salaries using subquery.
SELECT (SELECT MAX(Salary)
         FROM [dbo].[Employee]) F_max, (SELECT MAX(Salary)
                                         FROM [dbo].[Employee]
                                         WHERE salary NOT IN (SELECT MAX(Salary) f_max
                                                               FROM [dbo].[Employee])) S_max

--32. Get the full name of employees that is similar to any dependent name.
SELECT e.Fname+' '+e.Lname full_name
FROM [dbo].[Dependent] d, [dbo].[Employee] e
WHERE SUBSTRING(e.Fname, 1, 3) = SUBSTRING(d.Dependent_name, 1, 3)

SELECT e.Fname+' '+e.Lname full_name, d.Dependent_name
FROM [dbo].[Employee] e, [dbo].[Dependent] d
WHERE e.SSN = d.ESSN AND  e.Fname LIKE d.Dependent_name + '*'

SELECT e.Fname+' '+e.Lname full_name, d.Dependent_name
FROM [dbo].[Employee] e, [dbo].[Dependent] d
WHERE e.SSN = d.ESSN AND  d.Dependent_name LIKE '*' + e.Fname + '*'

--33. Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%.
UPDATE [dbo].[Employee]
SET Salary += Salary*30/100
WHERE SSN = (SELECT e.SSN
FROM [dbo].[Project] p, [dbo].[Employee] e, [dbo].[Works_for] w
WHERE w.Pno = p.Pnumber AND e.SSN = w.ESSn AND p.Pname = 'Al Rabwah')

--34. In the department table insert new department called "DEPT IT" with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
insert into [dbo].[Departments] ([Dname], [Dnum], [MGRSSN], [MGRStart Date])
values ('DEPT IT',100,112233,'1-11-2006')

--35. Do what is required if you know that: Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100) and they give you(your SSN =102672) her position (Dept. 20 manager).
-- a. First try to update her record in the department table
UPDATE [dbo].[Departments]
SET MGRSSN = 968574
WHERE Dnum = 100
--b. Update your record to be department 20 manager.
UPDATE [dbo].[Departments]
SET MGRSSN = 968574
WHERE Dnum = 100
--c.Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
UPDATE [dbo].[Employee]
SET Superssn = 102672
WHERE Superssn = 102660

--36.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) So, try to delete his data from your database in case you know that you will be temporarily in his position.
--   Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handle these cases).
DELETE FROM [dbo].[Dependent]
WHERE ESSN = 223344

DELETE FROM [dbo].[Works_for]
WHERE ESSN = 223344

UPDATE [dbo].[Employee]
SET Superssn = 102672
WHERE Superssn = 223344

UPDATE [dbo].[Departments]
SET MGRSSN = 102672
WHERE MGRSSN = 223344

DELETE FROM [dbo].[Employee]
WHERE SSN = 223344
