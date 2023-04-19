-- 1) Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
select sum(salary) from (select e.first_name,e.salary,e.department_id,d.location_id from employees as e inner join departments as d on e.department_id = d.department_id inner join locations as l on d.location_id = l.location_id where l.city = 'Seattle' and lower(e.first_name) != 'nancy');

-- 2) Fetch all details of employees who has salary more than the avg salary by each department.
select * from employees e inner join departments d on e.department_id = d.department_id where e.salary > (select avg(salary) from employees where department_id = e.department_id);

-- 3) Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000
select l.location_id,count(*) from employees e inner join departments d on e.department_id = d.department_id inner join locations l on d.location_id = l.location_id group by l.location_id;


-- 4) Fetch max salary, min salary and avg salary by job and department. 
--    Info:  grouped by department id and job id ordered by department id and max salary
select d.department_name,e.job_id,max(e.salary) as max_salary,min(e.salary) as min_salary,avg(e.salary) as avg_salary from employees e inner join departments d on e.department_id = e.department_id group by e.job_id,d.department_name order by d.department_name,max_salary; 

-- 5) Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy  
select l.country_id,sum(e.salary) as total_salary from employees e inner join departments d on e.department_id = d.department_id inner join locations l on d.location_id = l.location_id where l.country_id = 'US' and e.first_name != 'Nancy' group by l.country_id;


-- 6) Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
select d.department_name,e.job_id,max(e.salary) as max_salary,min(e.salary) as min_salary,avg(e.salary) as avg_salary from employees e inner join departments d on e.department_id = e.department_id inner join job_history j on e.employee_id=j.employee_id group by e.job_id,d.department_name order by d.department_name,max_salary; 

select max(salary) , min(salary) , avg(salary), e.department_id from employees e inner join  job_history j on e.employee_id = j.employee_id group by e.department_id, e.job_id;


-- 7) Display the employee count in each department and also in the same result.  
select ifnull(d.department_name,'-')as Department_Name,count(*) as Total from employees e inner join departments d on e.department_id = d.department_id group by d.department_name order by Total;


-- 8)  Display the jobs held and the employee count. 
--     Hint: every employee is part of at least 1 job 
--     Hint: use the previous questions answer
--     Sample
--     JobsHeld EmpCount
--     1	    100
--     2	    4

select m.jobs_held , count(emp_id) as emp_count from(select e.employee_id as emp_id , count(*) as jobs_held from(select employee_id,job_id from employee union all select employee_id ,job_id from job_history order by employee_id) as e group by e.employee_id) as m group by jobs_held order by jobs_held;

-- 9) Display average salary by department and country.
select d.department_id,l.country_id,avg(e.salary) from employees e inner join departments d on e.department_id = d.department_id inner join locations l on d.location_id = l.location_id group by d.department_id,l.country_id order by d.department_id,l.country_id;

-- 10)	Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)
select d.manager_id,l.country_id,count(*) from employees e inner join departments d on e.department_id=d.department_id inner join 
locations l on l.location_id=d.location_id group by d.manager_id,l.country_id;

-- 11) Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg : 
-- DEPT ID 0-10000 10000-20000
-- 50          2               10
-- 60          6                5
select department_id,
  count(case when SALARY between 0 and 10000 then 1 end) as "0-10000",
  count(case when SALARY between 10001 and 20000 then 1 end) as "10001 - 20000",
  count(case when SALARY between 20001 and 30000 then 1 end) as "20001 - 30000"
from employees
group by department_id;


-- 12) Display employee count by country and the avg salary 
--     Eg : 
--     Emp Count       Country        Avg Salary
--     10                     Germany      34242.8
select count(*),c.country_name,avg(e.salary) as avg_salary from employees e inner join departments d on e.department_id = d.department_id inner join locations l on d.location_id = l.location_id inner join countries c on l.country_id = c.country_id group by c.country_name;

-- 13) Display region and the number off employees by department
-- Eg : 
-- Dept ID   America   Europe  Asia
-- 10            22               -            -
-- 40             -                 34         -
-- (Please put "-" instead of leaving it NULL or Empty)
select em.department_id as "Dept_ID",
       sum(case when lower(r.region_name) = 'americas' then count_of else 0 end) as America,
       sum(case when lower(r.region_name) = 'europe' then  count_of else 0 end) as Europe,
       sum(case when lower(r.region_name)  = 'asia' then count_of else 0 end) as Asia
from (select e.department_id,r.region_name, count(c.region_id) as count_of from employees e inner join departments d on e.department_id=d.department_id inner join locations l on l.location_id=d.location_id inner join countries c on c.country_id=l.country_id inner join regions r on r.region_id=c.region_id group by e.department_id , r.region_name) as em group by em.region_name,em.department_id,em.count_of;

-- 14) Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department
select * from employee inner join departments on employee.department_id=departments.department_id;

-- 15)	write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers
select e.first_name,e.last_name,concat_ws(' ',m.first_name,m.last_name) as manager from employees e,employees m where e.manager_id = m.employee_id;

-- 16)	write a SQL query to display the department name, city, and state province for each department.
select d.department_name,l.city,l.state_province from departments d inner join locations l on d.location_id = l.location_id;

-- 17) write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't
select e.first_name,e.last_name,e.department_id,iff(e.department_id = null,'-',d.department_name) as belongs_too,iff(e.department_id = null,'-','Yes') as not_in_a_department from employees e left join departments d on e.department_id = d.department_id;

-- 18) The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department.  List the above along with the department id, department name
select e.department_id,d.department_name,round(avg(salary),2) as avg_salary,count(*) as number_of_employees from employees e inner join (select department_id,department_name from departments) as d on e.department_id = d.department_id group by e.department_id,d.department_name order by e.department_id;

-- 19) Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation.
select * from employees cross join jobs;

-- 20) Write a query to display first_name, last_name, and email of employees who are from Europe and Asia
select e.first_name,e.last_name,e.email,c.country_name from employees e inner join departments d on e.department_id = d.department_id inner join locations l on d.location_id = l.location_id inner join countries c on l.country_id = c.country_id where lower(c.country_name) = 'canada' or lower(c.country_name) = 'germany';

-- 21) Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.
select concat_ws(' ',e.first_name, e.last_name) as full_name,d.department_name,l.city from employees e inner join departments d on e.department_id = d.department_id inner join locations l on d.location_id = l.location_id where lower(l.city) = 'seattle'and lower(e.last_name) like '%e_'and lower(d.department_name) in (select lower(department_name) from departments where lower(department_name) = 'finance' or lower(department_name) = 'shipping');

-- 22) Display the first name and phone number of employees who have less than 50 months of experience
select first_name,phone_number from employees where datediff('year',hire_date,current_date()) < 25;


-- 23) Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023,  and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).
select employee_id,first_name,last_name,year(hire_date),salary from employees inner join
(select year(e.hire_date) as year,max(salary) as max_salary from employees e group by year) on year(employees.hire_date) = year and employees.salary = max_salary;
