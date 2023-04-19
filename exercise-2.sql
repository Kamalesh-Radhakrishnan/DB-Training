-- Write a SQL query to remove the details of an employee whose first name ends in ‘even’
select * from employees where lower(first_name) like '%even';
delete from employees where lower(first_name) like '%even';
select * from employees;

-- Write a query in SQL to show the three minimum values of the salary from the tabl
select salary from employees order by salary limit 3;

-- Write a SQL query to remove the employees table from the database
drop table employees;


-- Write a SQL query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table
create table employee as select * from employees;        
select * from employee;

-- Write a SQL query to remove the column Age from the table
alter table employee add column age INT;
alter table employee drop column age;

-- Obtain the list of employees (their full name, email, hire_year) where they have joined the firm before 2000
select CONCAT(first_name,' ',last_name) as full_name,email,year(hire_date) as hire_year from employees where year(hire_date) < 2000;

-- Fetch the employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999
select * from employees;
select employee_id,job_id from employees where year(hire_date) between 1990 and 1999;

-- Find the first occurrence of the letter 'A' in each employees Email ID Return the employee_id, email id and the letter position **
select employee_id,email,charindex('a',lower(email)) as position from employees;

-- Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
select employee_id,concat(first_name,' ',last_name) as fullname,email from employees where length(concat(first_name,last_name)) < 12;

-- Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID Return the employee_id, and their corresponding UNQ_ID;
select employee_id,concat_ws('-',first_name,last_name,email) as unq_id from employees;

-- Write a SQL query to update the size of email column to 30
alter table employees modify column email varchar(30);

-- Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)
-- Info : this mean you need to separate phone into 2 parts
-- select first_name,email,
select split_part(phone_number , '.' , -1) as extension , replace(phone_number ,concat('.',extension),'') from employees; 

-- Write a SQL query to find the employee with second and third maximum salary. **
select * from employees order by salary desc;
select employee_id,concat(first_name,' ',last_name) as employee_name,salary from employees order by salary desc limit 2 offset 1;

-- Fetch all details of top 3 highly paid employees who are in department Shipping and IT
select * from departments;
select top 3 employee_id,salary,department_id from employees where department_id in (select department_id from departments where department_name = 'Shipping') 
union
select top 3 employee_id,salary,department_id from employees where department_id in (select department_id from departments where department_name = 'IT') order by department_id,salary desc;

select department_id from departments where department_name = 'IT' or department_name = 'Shipping';

select *,rank() over(partition by department_id order by salary) as rank from employees
order by department_id, salary;

select *, rank() over(partition by department_id order by salary) as ranking from employees order by department_id,salary;

select *, rank() over(partition by department_id order by salary desc) as ranking from employees order by department_id,salary;

select * from (select *, rank() over(partition by department_id order by salary desc) as ranking from employees order by department_id,salary desc) where department_id in (select department_id from departments d where department_name = 'IT' or department_name = 'Shipping');

-- Display employee id and the positions(jobs) held by that employee (including the current position)
select employee_id,job_id from employees
union
select employee_id,job_id from job_history;

-- Display Employee first name and date joined as WeekDay, Month Day, Year
-- Eg :
-- Emp ID Date Joined
-- 1 Monday, June 21st, 1999
select employee_id, concat(decode(dayname(hire_date),'Mon','Monday', 'Tue','Tuesday','Wed','Wednesday','Thu','Thursday','Fri','Friday','Sat','Saturday','Sun','Sunday'),', ',
decode(extract(month from hire_date), 1,'January',2,'February',3,'March',4,'April',5,'May',6,'June',7,'August',9,'September',10,'October',11,'November',12,'December'),' ',dayofmonth(hire_date), ', ',year(hire_date)) as date_joined from employees;

-- The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 . The job position might be removed based on market trends (so, save the changes) . - Later, update the maximum salary to 40,000 . - Save the entries as well.
-- - Now, revert back the changes to the initial state, where the salary was 30,000

alter session set autocommit=false;
start transactions;
savepoint ins;
insert into jobs values('DT_ENGG','Data Engineer',12000,30000);
commit;
select * from jobs;
savepoint upd1;
update jobs set max_salary=50000 WHERE job_id='DT_ENGG';
commit;
select * from jobs;

savepoint upd2;
update jobs set max_salary=60000 WHERE job_id='DT_ENGG';
commit;
select * from jobs;

rollback upd1;

alter session set autocommit=TRUE;
select * from jobs;


-- Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
select round(avg(salary),2) as avg_salary from employees where hire_date between '1996-01-08' and '2000-01-01';

-- Display Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
-- A. Display all the regions
-- B. Display all the unique regions
select region_name from regions
union all select 'Australia'
union all select 'Asia'
union all select 'Antartica'
union all select 'Europe';

select distinct(region_name) from (
select region_name from regions
union all select 'Australia'
union all select 'Asia'
union all select 'Antartica'
union all select 'Europe'
);
