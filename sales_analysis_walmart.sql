--cleaning the data set
--adding two columns time_of_day and day_of_week

--adding a column time_of_day
alter table sales
add column time_of_day varchar(255)
--adding values in the column
update sales
set time_of_day=(
	case 
	when time between '00:00:00' and '12:00:00' then 'Morning'
	when time between '12:01:00' and '16:00:00' then 'Afternoon'
	else 'Evening'
	end
)

--adding column day_of_week
alter table sales
add column day_of_week varchar(255)
--adding values to column
UPDATE sales
SET day_of_week = 
    CASE EXTRACT(DOW FROM date)
        WHEN 0 THEN 'Sunday'
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
    END;

--Analysing data

-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------

-- How many unique cities does the data have?
select distinct city from sales

-- In which city is each branch?
select city, branch 
from sales
group by 1,2

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- How many unique product lines does the data have?
select distinct productline
from sales

-- What is the most selling product line
select productline, sum(quantity) as qty
from sales
group by 1
order by 2 desc

--What is the most common payment method?
select payment, count(invoiceid) as total
from sales
group by 1
order by 2 desc

--What is the total revenue by month?
select (case extract(month from date )
	   when 1 then 'JANUARY'
		when 2 then 'FEBRUARY'
		when 3 then 'MARCH'
		end
	   ) as month, sum(total) as total_amount
from sales
group by 1
order by 2 desc

--What month had the largest COGS?
select (case extract(month from date )
	when 1 then 'JANUARY'
	when 2 then 'FEBRUARY'
	when 3 then 'MARCH'
	end
	   ) as month, sum(cogs) as total_cogs
from sales
group by 1
order by 2 desc

--What product line had the largest revenue?
select productline, sum(total) as total_revenue
from sales
group by 1
order by 2 desc

--What is the city with the largest revenue?
select city, sum(total) as total_rev
from sales
group by 1
order by 2 desc

--What product line had the largest VAT?
select productline, avg(tax5) as avg_tax
from sales
group by 1
order by 2 desc

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
--Find the average sales
select avg(quantity) as avg_quan from sales

--Filter the data with good and bad remark
select productline, case
						when sum(quantity)>6 then 'Good'
						else 'Bad'
						end as remark
from sales
group by 1

--Which branch sold more products than average product sold?
select branch, sum(quantity) as qty
from sales
group by 1
having sum(quantity)>(select avg(quantity) from sales)

--What is the most common product line by gender?
select productline, gender, count(gender) as total
from sales
group by 1,2
order by 3 desc

--What is the average rating of each product line?
select productline, ROUND(avg(rating),1) as avg_rating
from sales
group by 1
order by 2 desc

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

--How many unique customer types does the data have?
select distinct customertype from sales

--How many unique payment methods does the data have?
select distinct payment from sales

--What is the most common customer type?
select customertype, count(customertype) as count
from sales
group by 1
order by 2 desc

--What is the gender of most of the customers?
select gender, count(*) as gender_count
from sales
group by 1

--What is the gender distribution per branch?
select branch, gender, count(gender) as gender_count
from sales
group by 1,2
order by 1 asc, 3 desc

--Which time of the day do customers give most ratings?
select time_of_day, round(avg(rating),1) as avg_rating
from sales
group by 1

--Which time of the day do customers give most ratings per branch?
select branch, time_of_day, round(avg(rating),1) as avg_rating
from sales
group by 1,2
order by 1 asc

--Which day fo the week has the best avg ratings?
select day_of_week, round(avg(rating),1) as avg_rating
from sales
group by 1

--Which day of the week has the best average ratings per branch?
select branch, day_of_week, round(avg(rating),1) as avg_rating
from sales
group by 1,2
order by 1 asc, 3 desc

-- --------------------------------------------------------------------
-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

--Number of sales made in each time of the day per weekday
select day_of_week, time_of_day, count(quantity) as total_sales
from sales
group by 1,2
order by 1 asc, 3 desc

--Which of the customer types brings the most revenue?
select customertype, sum(total) as total_revenue
from sales
group by 1
order by 2 desc

--Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, sum(tax5) as tax_per
from sales
group by 1
order by 2 desc

--Which customer type pays the most in VAT?
select customertype, sum(tax5) as tax_per
from sales
group by 1
order by 2 desc

