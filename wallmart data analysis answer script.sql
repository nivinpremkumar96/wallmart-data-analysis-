-- 1. Build a database 
-- 2. Create table and insert the data.
-- 3. Select columns with null values in them. There are no null values in our database as in creating the tables, we set **NOT NULL** for each field, hence null values are filtered out.


create table if not exists sales (
invoice_id varchar(30) not null primary key,
branch	varchar(5) not null,
city varchar (30) not null,
customer_type varchar(30) not null,	
gender varchar(10) not null,
product_line varchar(100) not null,	
unit_price	decimal (10, 2) not null,
quantity int not null,
vat float (6, 4) not null,
total decimal(12, 2) not null,
date DATETIME not null, 
time TIME not null,	
payment_method varchar(15) not null,
cogs decimal(10, 2) not null,	
gross_margin_pct float (11, 9),
gross_income decimal(12, 4) not null,
rating float (2, 1)


)	;

-- 1. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.
-- 2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
-- 3. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

-- Feature engineering

select time , (case
when `time` between "00:00:00" and "12:00:00" then "Morning"
when `time` between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end ) as time_of_date
from sales 

-- CREATED COLUMN ---
ALTER TABLE sales ADD COLUMN time_of_day varchar(20) ;

-------------------------------------------------------------------


UPDATE SALES
SET TIME_OF_DAY = (
case
when `time` between "00:00:00" and "12:00:00" then "Morning"
when `time` between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end )
; 




ALTER TABLE sales
add column day_name varchar(10) ;

update sales
set day_name = dayname(date) ;


alter table sales 
add column month_name varchar(10);

update sales
set month_name = monthname(date) ;

-- ### Generic Question

-- 1. How many unique cities does the data have?
-- 2. In which city is each branch?


select distinct(city) from sales ;

select distinct(city),branch
from sales;

-- 1. How many unique product lines does the data have?

select distinct(product_line) from sales; 

-- 2. What is the most common payment method?

select payment_method,count(payment_method)
from sales
group by payment_method
order by count(payment_method)  desc ;

-- 3. What is the most selling product line?

select product_line ,count(quantity)
from sales
group by product_line
order by (2) desc;

-- 4. What is the total revenue by month?

select sum(total) as total_revenue, month_name
from sales 
group by (2)
order by (1) desc;

-- 116292.11	January
-- 108867.38	March
-- 95727.58	    February

-- 5. What month had the largest COGS?

select max(cogs) ,month_name
from sales 
group by (2)
order by(1) desc
limit 1;

-- february = 993.00

-- 6. What product line had the largest revenue?
select product_line ,sum(total) 
from sales 
group by product_line
order by (2) desc ;

-- food and beverages

-- 7. What is the city with the largest revenue?

select city, sum(total)
from sales
group by city
order by (2) desc;

-- Naypyitaw

-- 8.What product line had the largest VAT?

select product_line,avg(vat)
from sales
group by (1)
order by 2 desc ; 

-- home and lifestyle

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 
  select product_line,avg(total) as avg_sales ,(case 
  when product_line > avg(total) then  "Good"
  else "Bad"
  end) as Product_condition
  from sales 
  group by product_line;
  
-- 10.Which branch sold more products than average product sold?

 select branch,sum(quantity)
 from sales
  group by 1
  having sum(quantity) > avg(quantity)
  ;
  -- branch a
  
  -- 11.What is the most common product line by gender? 
  select product_line,gender,count(gender)
  from sales
  group by 1,2
  order by 3 desc;
  
 --  12. What is the average rating of each product line? ---
 
 select avg(rating), product_line 
 from sales
 group by 2
  

