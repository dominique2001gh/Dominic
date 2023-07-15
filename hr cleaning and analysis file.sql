create database first_project;

use first_project;

select * from hr;

describe hr;
set sql_safe_updates =0;
select * from hr;

-- Data Cleaning
-- 1 Rename ID column to employee_id
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id varchar(20) null;

-- 2 Change datatypes for columns thats needs to change
select birthdate from hr;

ALTER TABLE hr
modify column birthdate date;

ALTER TABLE hr
modify column hire_date date;

ALTER TABLE hr
modify column term_date date;

ALTER TABLE hr
modify column termdate date;

describe hr

ALTER TABLE hr
modify column termdate date;

ALTER table hr add column age int;


update hr
set age = timestampdiff(YEAR,birthdate,curdate());
select birthdate, age from hr;

select
  min(age) as youngest,
  max(age) as oldest
from hr;

select count(*) from hr where age < 18;

-- QUESTIONS TO ANSWER
-- 1. What is the gender breakdown of hr employee table

select gender, count(*) as count
from hr
where age >=18 and term_date >= '2023-07-13'
group by gender;

-- 2.What is the race/ ethnicity breakdown of employees

select race, count(*) as count
from hr
where age > 18 and term_date >= '2023-07-13'
group by race
order by count(*) desc;

-- 3 Age distribuiton

select
   min(age) as youngest,
   max(age) as oldest
from hr
where age >= 18 and term_date >= '2023-07-13';

select
 case 
  when age >=18 and age <=24 then '18-24'
    when age >=25 and age <=34 then '25-34'
      when age >=35 and age <=44 then '35-44'
        when age >=45 and age <=54 then '45-54'
          when age >=55 and age <=64 then '55-64'
          else '65+'
		end as age_group,
        count(*) as count
from hr
where age >= 18 and term_date = '2023-07-13'
group by age_group
order by age_group;   

-- 4 Gender distribution in age group
select
 case 
  when age >=18 and age <=24 then '18-24'
    when age >=25 and age <=34 then '25-34'
      when age >=35 and age <=44 then '35-44'
        when age >=45 and age <=54 then '45-54'
          when age >=55 and age <=64 then '55-64'
          else '65+'
		end as age_group,gender,
        count(*) as count
from hr
where age >= 18 and term_date = '2023-07-13'
group by age_group,gender
order by age_group,gender; 

-- 5 How many work at headquarters compared to remote

select location, count(*) as count
from hr
where age >= 18 and term_date = '2023-07-13'
group by location;

SELECT round(avg(DATEDIFF(term_date, hire_date))/365,0) AS average_length_employment
FROM hr
WHERE term_date <= curdate()and term_date <>'2023-07-13' and age >=18;

-- How does gender vary accross departments and job titles

select department,gender, count(*) as count
from hr
where age >= 18 and term_date >= '2023-07-13'
group by department, gender
order by department;

-- What is the distribution of job titles across company

select jobtitle, count(*) as count
from hr
where age >= 18 and term_date >= '2023-07-13'
group by jobtitle
order by jobtitle desc;

SELECT department, 
       COUNT(*) AS total_employees,
       SUM(CASE WHEN term_date <> '2023-07-13' and term_date <=curdate() THEN 1 ELSE 0 END) AS terminated_employees,
       (SUM(CASE WHEN term_date <> '2023-07-13' and term_date <=curdate() THEN 1 ELSE 0 END) / COUNT(*))  AS turnover_rate
FROM hr
GROUP BY department
ORDER BY turnover_rate DESC;

-- Location of employees by city and state

select location_state, count(*) as count
from hr
where age>=18 and term_date ='2023-07-13'
group by location_state
order by count desc;

-- How has the employee count changed over time based on hire and term dates

select
   year,
   hires,
   terminations,
   hires - terminations as net_change,
   round((hires-terminations)/hires * 100,2) as net_change_percent
from(
     select year(hire_date) as year,
     count(*) as hires,
     sum(case when term_date <> '2023-07-13' and term_date <= curdate()then 1 else 0 end) as terminations
     from hr
     where age > 18
     group by year(hire_date)
     )as subquery
order by year ASC;

-- 12 What is the employee tenure for each department

select department, round(avg(datediff(term_date,hire_date)/365),0) as ave_tenure
from hr
where term_date <= curdate() and term_date <> '2023-07-13' and age >=18
group by department;
