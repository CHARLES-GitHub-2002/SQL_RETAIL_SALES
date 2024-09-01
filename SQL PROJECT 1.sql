-- Create table 
DROP TABLE IF EXISTS retail_sales;
create table retail_sales (
    transactions_id INT,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR (15),
	age	INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT *
FROM retail_sales
limit 10;

SELECT  
COUNT (*)
FROM retail_sales;

-- DATA CLEANING

SELECT *
FROM retail_sales
WHERE transactions_id is NULL;


SELECT *
FROM retail_sales
WHERE sale_date is NULL;

SELECT *
FROM retail_sales
WHERE sale_time is NULL;

SELECT *
FROM retail_sales
WHERE 
	transactions_id is NULL
	OR 
	sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    customer_id IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

DELETE FROM retail_sales 
WHERE 
      transactions_id is NULL
	OR 
	sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    customer_id IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;


-- DATA EXPLORATION 

--How many sales we have ?
SELECT COUNT (*) AS total_sale 
FROM retail_sales;

-- How many unique customers we have ?
SELECT COUNT (DISTINCT customer_id) AS total_sale 
FROM retail_sales;
-- How many category we have ?
SELECT COUNT (DISTINCT category ) AS total_sale 
FROM retail_sales;
	
SELECT DISTINCT category
FROM retail_sales;	


--DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.
-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
-- 8.Write a SQL query to find the top 5 customers based on the highest total sales.
-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.
-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).




-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05.

SELECT *
FROM retail_sales
WHERE 
sale_date = '2022-11-05'

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.

SELECT
	category,
	SUM( quantiy)
FROM retail_sales
WHERE 
     category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
GROUP BY 1


SELECT
	*
FROM retail_sales
WHERE 
     category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND 
  quantiy >= 4

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM (total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
  ROUND(AVG (age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT *
FROM retail_sales
WHERE 
      total_sale > 1000

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,
	gender
ORDER BY 1

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select*
from
	(
SELECT
     EXTRACT (YEAR FROM sale_date) as 	year ,   
     EXTRACT (MONTH FROM sale_date) as  month ,  	
     AVG (total_sale) as avg_sale,
   	RANK () OVER (PARTITION BY  EXTRACT (YEAR FROM sale_date) order by AVG (total_sale) desc) as rank
	
FROM retail_sales
group by 1,2
	) as t1
where rank =1
--order by 1,3 desc

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales.

select 
	   customer_id,
	   sum (total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc 
limit 5

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	 category,
	count ( distinct customer_id) as count_unique_customers
from retail_sales
group by category 

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

	
select *,
	case 
	     when extract (hour from sale_time) < 12 then 'morning'
	     when extract (hour from sale_time) between 12 and 17 then  'afternoon'
	     else  'evening'
	  end as shift 
from retail_sales



with hourly_sale
as
	(
select *,
	case 
	     when extract (hour from sale_time) < 12 then 'morning'
	     when extract (hour from sale_time) between 12 and 17 then  'afternoon'
	     else  'evening'
	  end as shift 
from retail_sales
)
select 
shift ,
count (*) as total_orders
from  hourly_sale
group by shift 

                                  --- END OF PROJECT---
