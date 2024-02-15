
--1. Write a query that displays Full name of an employee who has more than
--3 letters in his/her First Name.{1 Point}
select CONCAT(E.Fname,' ',E.Lname) as [Full Name]
from Employee E
where len(E.Fname)>3


--2. Write a query to display the total number of Programming books
--available in the library with alias name ‘NO OF PROGRAMMING
--BOOKS’ {1 Point}
select COUNT(B.Id) as [NO OF PROGRAMMING BOOKS]
from Book B join Category C
on C.Id=B.Cat_id
where C.Cat_name='Programming'


--3. Write a query to display the number of books published by
--(HarperCollins) with the alias name 'NO_OF_BOOKS'. {1 Point}
select COUNT(B.ID) as [NO_OF_BOOKS]
from Book B join Publisher P
on B.Publisher_id=P.Id
where P.Name='HarperCollins'


--4. Write a query to display the User SSN and name, date of borrowing and
--due date of the User whose due date is before July 2022. {1 Point}
select U.SSN,U.User_Name,BO.Borrow_date,BO.Due_date
from Borrowing BO join Users U
on BO.User_ssn=U.SSN
where cast(BO.Due_date As nvarchar(30))< '2022-07-01'


--5. Write a query to display book title, author name and display in the
--following format,
--' [Book Title] is written by [Author Name]. {2 Points}
select concat(B.Title,' is written by ',A.[Name])
from Book B join Book_Author BA
on B.Id=BA.Book_id join Author A
on A.Id=BA.Author_id


--6. Write a query to display the name of users who have letter 'A' in their
--names. {1 Point}
select User_Name
from Users
where User_Name like'%A%'


--7. Write a query that display user SSN who makes the most borrowing{2 Points}
select top(1) B.User_ssn
from Borrowing B
group by B.User_ssn
order by COUNT(B.User_ssn) DESC


--8. Write a query that displays the total amount of money that each user paid
--for borrowing books. {2 Points}
select B.User_ssn,SUM(B.Amount) as [Total Of Money]
from Borrowing B
group by B.User_ssn


--9. write a query that displays the category which has the book that has the
--minimum amount of money for borrowing. {2 Points}
select C.Cat_name
from Book B join Category C
on B.Cat_id=C.Id
where B.Id=(select top(1) B.Book_id
            from Borrowing B
            order by B.Amount
			)


--10.write a query that displays the email of an employee if it's not found,
--display address if it's not found, display date of birthday. {1 Point}
select coalesce(Email,Address,cast(DOB as nvarchar(30)),' ')
from Employee 


--11. Write a query to list the category and number of books in each category
--with the alias name 'Count Of Books'. {1 Point}
select Cat_id,COUNT(Id) as[Count Of Books]
from Book 
group by Cat_id


--12. Write a query that display books id which is not found in floor num = 1
--and shelf-code = A1.{2 Points}
select B.Id
from Shelf S join Book B
on S.Code=B.Shelf_code
where S.Floor_num!=1 and S.Code!='A1'


/*
13.Write a query that displays the floor number , Number of Blocks and
number of employees working on that floor.{2 Points}
*/
select F.Number,F.Num_blocks,new.number_of_employees
from Floor F join (select COUNT(id)as [number_of_employees],Floor_no
                   from Employee
                   group by floor_no
				   )as new
on F.Number=new.Floor_no


/* 
14.Display Book Title and User Name to designate Borrowing that occurred
within the period ‘3/1/2022’ and ‘10/1/2022’.{2 Points}
*/
select B.Title,U.User_Name
from Book B join Borrowing BO
on B.Id=BO.Book_id join Users U 
on U.SSN=BO.User_ssn
where BO.Borrow_date between '3/1/2022' and '10/1/2022'


/*
15.Display Employee Full Name and Name Of his/her Supervisor as
Supervisor Name.{2 Points}
*/
select concat(Emp.Fname,' ',Emp.Lname) as [FullName],concat(Super.Fname,' ',Super.Lname) as[SuperName]
from Employee Emp join Employee Super
on Emp.Super_id=Super.Id


/*
16.Select Employee name and his/her salary but if there is no salary display
Employee bonus. {2 Points}
*/
select concat(Fname,' ',Lname)as [FullName],coalesce(Salary,Bouns)
from Employee


/*
17.Display max and min salary for Employees {2 Points}
*/
select MAX(Salary)as[Max],MIN(salary)as[Min]
from Employee


/*
18.Write a function that take Number and display if it is even or odd {2 Points}
*/
create or alter function check_Parity (@num int)
returns nvarchar(10)
with encryption
begin
	declare @ans nvarchar(10)
	if @num%2=1
	 set @ans='Odd'
	else
	 set @ans='Even'
	return @ans
end
select dbo.check_parity(9)


/*
19.write a function that take category name and display Title of books in that
category {2 Points}
*/
create or alter function display_title(@cat nvarchar(30))
returns table 
with encryption
as return
(
select title
from Book 
where Cat_id=(select Id from Category where @cat=Cat_name)
)
declare @catnum nvarchar(30);
set @catnum='Programming';
select * from dbo.display_title(@catnum);


/*
20. write a function that takes the phone of the user and displays Book Title ,
user-name, amount of money and due-date. {2 Points}
*/
create or alter function TakePhoneDisplayDATA(@phon nvarchar(30))
returns table
with encryption
as return
(
select B.Title,U.User_Name,BO.Amount,BO.Due_date
from Users U join Borrowing BO
on U.SSN=BO.User_ssn join Book B
on B.Id=BO.Book_id
where U.SSN=(select User_ssn from User_phones where @phon=Phone_num)
)
select * from dbo.TakePhoneDisplayDATA('0123654122')


/*
21.Write a function that take user name and check if it's duplicated
return Message in the following format ([User Name] is Repeated
[Count] times) if it's not duplicated display msg with this format [user
name] is not duplicated,if it's not Found Return [User Name] is Not
Found {2 Points}
*/
create or alter function checkDuplicate(@user nvarchar(100))
returns  nvarchar(100)
with encryption
begin
declare @count int=0,@res nvarchar(100);
select @count=COUNT(*)
from Users
where User_Name=@user

if @count>1
 begin
   set @res=concat(@user,' is Repeated ',cast(@count as nvarchar(10)),' times');
 end
else if @count=1
  begin
  set @res=concat(@user,' is not Duplicate');
  end
else
  begin
  set @res=concat(@user,' is not found');
  end
return @res
end

select dbo.checkDuplicate('Amr Ahmed');


/*
22.Create a scalar function that takes date and Format to return Date With
That Format. {2 Points}
*/
create or alter function DateWithFormate(@date date,@format int)
returns nvarchar(30)
with encryption
begin
declare @res nvarchar(30)
set @res=convert(nvarchar(30) ,@date,@format)
return @res
end	

select dbo.DateWithFormate('3-14-2020',102)


/*
23.Create a stored procedure to show the number of books per Category.{2
Points}
*/
create proc NumOfBooks
with encryption
as
select Cat_id,COUNT(id)
from Book 
group by cat_id

exec NumOfBooks


/*
24.Create a stored procedure that will be used in case there is an old manager
who has left the floor and a new one becomes his replacement. The
procedure should take 3 parameters (old Emp.id, new Emp.id and the
floor number) and it will be used to update the floor table. {3 Points}
*/
create or alter proc UpdateOld @old int,@new int,@num int
with encryption
as
begin
update [Floor] set MG_ID=@new
where Number=@num and MG_ID=@old
end

exec UpdateOld 3,1,1


/*
25.Create a view AlexAndCairoEmp that displays Employee data for users
who live in Alex or Cairo. {2 Points}
*/
create or alter view AlexAndCairoEmp
with encryption
as
select *
from Employee
where [Address] in ('Cairo','Alex')
select * from AlexAndCairoEmp


/*
26.create a view "V2" That displays number of books per shelf {2 Points}
*/
create or alter view V2(shelf_Code,NumberOfBooks)
as
select Shelf_code,COUNT(*)
from Book
group by Shelf_code
select * from V2


/*
27.create a view "V3" That display the shelf code that have maximum
number of books using the previous view "V2" {2 Points}
*/
create or alter view V3 
with encryption
as
select top(1) shelf_Code
from V2 
order by NumberOfBooks desc
select * from V3


/*
-------------------------------------------------------------------------------
28.Create a table named ‘ReturnedBooks’ With the Following Structure :
User SSN    Book Id    Due Date   Return Date   fees
*/
 create table ReturnedBooks
 (
   SSN int,
   Book_ID int,
   Due_Date date,
   Return_Date date,
   Fees money
 )
/*
then create A trigger that instead of inserting the data of returned book
checks if the return date is the due date or not if not so the user must pay
a fee and it will be 20% of the amount that was paid before. {3 Points}
*/
create or alter trigger inserting 
on ReturnedBooks
instead of insert
as
begin

	Declare @ssn int,@bookid int,@retdat date,@Deuration date,@userDeu date

	select @ssn=SSN,@bookid=Book_ID,@retdat=Return_Date ,@userDeu=Due_Date
	from inserted

	select @Deuration=Due_date
	from Borrowing
	where @ssn=User_ssn and @bookid=Book_id and @userDeu=Due_date

	if @retdat<=@Deuration
		begin
			insert into ReturnedBooks
			select * from inserted
		end
	else
		begin
			insert into ReturnedBooks
			select I.SSN,I.Book_ID,I.Due_Date,I.Return_Date,I.Fees-I.Fees*0.2
			from inserted I
		end
end
insert into ReturnedBooks(SSN,Book_ID,Due_Date,Return_Date,Fees)
 values(1,3,'2021-02-27','2021-02-26',100)

 select * from ReturnedBooks


---------------------------------------------------
/*29.In the Floor table insert new Floor With Number of blocks 2 , employee
with SSN = 20 as a manager for this Floor,The start date for this manager
is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5)
moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
Mohamed(his SSN =12) His position . {3 Points}
*/
insert into Floor (Number,Num_blocks,MG_ID,Hiring_Date)
            values(7,2,20,GETDATE())
update Floor set MG_ID=12
where MG_ID=5

update Floor set MG_ID=5
where Number=6


/*
30.Create view name (v_2006_check) that will display Manager id, Floor
Number where he/she works , Number of Blocks and the Hiring Date
which must be from the first of March and the May of December
2022.this view will be used to insert data so make sure that the coming
new data must match the condition then try to insert this 2 rows and
Mention What will happen {3 Point}
Employee Id Floor Number Number of Blocks Hiring Date
2 6 2 7-8-2023
4 7 1 4-8-2022
*/
select * from v_2006_chek

create or alter view v_2006_chek -- manage ID,Floor Num,Num of blooks,Hiring Date
with encryption
as
select MG_ID,Number,Num_blocks,Hiring_Date
from Floor
WHERE Hiring_Date between '2022-03-01' and '2022-12-31'
with check option

select * from v_2006_chek

insert into v_2006_chek(MG_ID,Number,Num_blocks,Hiring_Date)
values (2 ,6 ,2 ,'7-8-2023')
--->give error because Floor num dubliated and hiering date is out of range

insert into v_2006_chek(MG_ID,Number,Num_blocks,Hiring_Date)
values (4 ,7 ,1 ,'4-8-2022')
-->give error because floor num duplicated in floor table

-------------------------------------------------
/*31.Create a trigger to prevent anyone from Modifying or Delete or Insert in
the Employee table ( Display a message for user to tell him that he can’t
take any action with this Table) {3 Point}*/
create or alter trigger Prevent
on Employee
instead of update,delete,insert
as
begin
print 'You cant take any action with table Employee'
end

insert into Employee(Fname,Lname)
values('Sharawy','Mohamed')
-------------------------------------------
/*32.Testing Referential Integrity , Mention What Will Happen When:

A. Add a new User Phone Number with User_SSN = 50 in
User_Phones Table {1 Point}*/
insert into User_phones(User_ssn,Phone_num)
values('50','01123432454')
--------> will give us error because foreign key constariant and there is no user with SSN=50 
/*
B. Modify the employee id 20 in the employee table to 21 {1 Point}
*/
update Employee set Id=21 where Id=20
-------->give Message "you cant take any action with tabel" because  trigger which prevent update ,delete and insert to this table and not update 
/*
C. Delete the employee with id 1 {1 Point}
*/
Delete from Employee where id=1
-------->give Message "you cant take any action with tabel" because  trigger which prevent update ,delete and insert to this table and not Delete 
/*
D. Delete the employee with id 12 {1 Point}
*/
Delete from Employee where Id=12
-------->give Message "you cant take any action with tabel" because  trigger which prevent update ,delete and insert to this table and not Delete 
------> will give error because it work in table floor as manager
/*
E. Create an index on column (Salary) that allows you to cluster the
*/
create clustered index C_Salary on Employee (Salary)
------------> give error because Employee table have default clusterd in ID and cannot more than one clasutered index on one table 
*/


/*
33.Try to Create Login With Your Name And give yourself access Only to
Employee and Floor tables then allow this login to select and insert data
into tables and deny Delete and update (Don't Forget To take screenshot
to every step) {5 Points}
*/

-- to give permission on Tb Floor and employee 
create schema for_me
alter schema for_me transfer Employee
alter schema for_me transfer [Floor]

