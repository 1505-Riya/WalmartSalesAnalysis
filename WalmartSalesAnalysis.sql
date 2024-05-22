create database walmart_db;
use walmart_db;
drop table sales;
CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);
select * from sales;

-- ========================ADD SOME COLUMNS==========================
-- TIME OF THE DAY -------------------------------------------------------
select time,(
CASE 
	WHEN `time` between "00:00:00" and "12:00:00" then "morning"
    WHEN `time` between "12:01:00" and "16:00:00" then "afternoon"
    ELSE "evening"
END) as time_of_date
from sales;

alter table sales add column time_of_day varchar(10);

set sql_safe_updates=0;
update sales set time_of_day = (
CASE 
	WHEN `time` between "00:00:00" and "12:00:00" then "morning"
    WHEN `time` between "12:01:00" and "16:00:00" then "afternoon"
    ELSE "evening"
END
);
set sql_safe_updates=1;

-- DAY NAME ---------------------------------------------------------------
select date, dayname(date) as day_name from sales;
alter table sales add column day_name varchar(10);

set sql_safe_updates=0;
update sales set day_name = dayname(date);
set sql_safe_updates=1;

-- MONTH NAME----------------------------------------------------------------
select date,monthname(date) as month_name from sales;
alter table sales add column month_name varchar(10);

set sql_safe_updates=0;
update sales set month_name = monthname(date);
set sql_safe_updates=1;

-- ============================ EXPLORATORY DATA ANALYSIS =========================

-- ................................................................................
-- .........................GENERIC ...............................................
-- ................................................................................

-- How many unique cities does the data have? --------------
select distinct city from sales;

-- In which city is each branch? ------------
select distinct city, branch from sales;

-- ................................................................................
-- .........................PRODUCT................................................
-- ................................................................................

-- How many unique product lines does the data have? ------------------
select distinct product_line from sales;

-- What is the most common payment method? -------------------
select payment_method, count(payment_method) as count 
from sales 
group by payment_method
order by count desc;

-- What is the most selling product line?-----------------------
select product_line, count(product_line) as count 
from sales 
group by product_line
order by count desc;

-- What is the total revenue by month? --------------------------
select 
	month_name as month,
	sum(total) as total_revenue 
from sales
group by month_name order by total_revenue desc;

-- What month had the largest COGS? -----------------------------
select month_name as month , sum(cogs) as cogs 
from sales
group by month_name order by cogs desc;

-- What product line had the largest revenue? --------------------
select product_line , sum(total) as revenue
from sales
group by product_line 
order by revenue desc;

-- What is the city with the largest revenue? ----------------
select city , sum(total) as revenue
from sales
group by city
order by revenue desc;

-- What product line had the largest VAT? ----------------------
select product_line , avg(tax_pct) as VAT
from sales
group by product_line
order by VAT desc;

-- Which branch sold more products than average product sold?
select branch ,sum(quantity) 
from sales
group by branch 
having sum(quantity)>(select avg(quantity) from sales);

-- What is the most common product line by gender? -------------------
select gender ,product_line,
count(gender)
from sales
group by gender,product_line
order by gender;

-- What is the average rating of each product line? --------------------
select product_line , avg(rating) as rate
from sales
group by product_line
order by rate desc;

-- ................................................................................
-- .....................................SALES .....................................
-- ................................................................................

-- Number of sales made in each time of the day per weekday
select time_of_day,count(*) as total_sales
from sales where day_name = "monday" 
group by time_of_day order by total_sales desc;

-- Which of the customer types brings the most revenue?
select customer_type, sum(total) as revenue
from sales 
group by customer_type
order by revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, avg(tax_pct) as vat
from sales 
group by city
order by vat desc;

-- Which customer type pays the most in VAT?
select customer_type, avg(tax_pct) as vat
from sales 
group by customer_type
order by vat desc;

-- ................................................................................
-- .............................CUSTOMER ..........................................
-- ................................................................................

-- How many unique customer types does the data have?
select distinct customer_type from sales;
-- How many unique payment methods does the data have?
select distinct payment_method from sales;

-- What is the most common customer type?
select customer_type,count(*) as count
from sales
group by customer_type order by count desc;

-- Which time of the day do customers give most ratings?
select time_of_day , avg(rating) as rating 
from sales
group by time_of_day
order by rating;

-- Which day of the week has the best average ratings per branch?
select day_name,count(day_name) as total_sales
from sales
where branch = "C"
group by day_name
order by total_sales desc;

-- ...............................................................................
-- ...............................................................................
select sum(total) from sales;
select sum(gross_income) from sales;

select * from sales;






