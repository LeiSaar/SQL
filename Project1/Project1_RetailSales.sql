USE sql_project_p1;

SELECT * 
FROM retail_sales;

SELECT COUNT(*)
FROM retail_sales;

DESCRIBE retail_sales;

ALTER TABLE retail_sales
MODIFY transactions_id INT PRIMARY KEY,
MODIFY sale_date DATE,
MODIFY sale_time TIME,
MODIFY customer_id INT,
MODIFY gender VARCHAR(15),
MODIFY age INT,
MODIFY category VARCHAR(15),
MODIFY quantiy INT,
MODIFY price_per_unit FLOAT,
MODIFY cogs FLOAT,
MODIFY total_sale FLOAT;

DESCRIBE retail_sales;
     
SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE transactions_id IS NULL 
     OR  
     sale_date IS NULL 
     OR sale_time IS NULL 
     OR customer_id IS NULL 
     OR gender IS NULL 
     OR age IS NULL 
     OR category IS NULL 
     OR quantiy IS NULL 
     OR price_per_unit IS NULL 
     OR cogs IS NULL 
     OR total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*)  as total_sale
FROM retail_sales;

-- How many unique customers we have?  Use DISTINCT to avoid duplication
SELECT COUNT(DISTINCT customer_id) as total_customers
FROM retail_sales;

-- How many product categories do we have?
-- get the category number
SELECT COUNT(DISTINCT category)
FROM retail_sales;
-- get the unique categories namesd
SELECT DISTINCT category
FROM retail_sales;

-- Data Analysis
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of NOV-22
SELECT COUNT(*)
FROM retail_sales
WHERE category = 'Clothing' AND quantiy >= 4 AND sale_date LIKE '2022-11-%';
-- Method 2
SELECT COUNT(*)
FROM retail_sales
WHERE category = 'Clothing' AND quantiy >= 4 AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
-- Method 3 if sale_date is of type DATE, we should not use LIKE, because it's inefficient and non-standard. Cast the DATE to CHAR or VARCAHR first
SELECT COUNT(*)
FROM retail_sales
WHERE category = 'Clothing' AND quantiy >= 4 AND CAST(sale_date AS CHAR) LIKE '2022-11-%';
-- Method 4
SELECT COUNT(*)
FROM retail_sales
WHERE category = 'Clothing' AND quantiy >= 4 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category
SELECT 
   category,
   SUM(total_sale) as net_sale,
   COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average  age of customers who purchsed items form the 'Beauty' Category
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT  category, gender, COUNT(*)
FROM retail_sales
GROUP BY category, gender  
ORDER BY 1 ; -- Otherwise, the category won't be shown in a random order.


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year 
-- average sale for each month in each year

WITH monthly_avg AS (
    SELECT 
        YEAR(sale_date) AS year, 
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT *
FROM monthly_avg
WHERE (year, avg_sale) IN (
    SELECT year, MAX(avg_sale)
    FROM monthly_avg
    GROUP BY year
)
ORDER BY year;

-- Method 2:
-- Step 1: Aggregate data to get avg_sale per month
-- Step 2: Use RANK() in an outer query
SELECT *
FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rnk
    FROM (
        SELECT 
            YEAR(sale_date) AS year,
            MONTH(sale_date) AS month,
            AVG(total_sale) AS avg_sale
        FROM retail_sales
        GROUP BY YEAR(sale_date), MONTH(sale_date)
    ) AS monthly_avg
) AS ranked_months
WHERE rnk = 1
ORDER BY year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT * FROM (     
    SELECT 
        customer_id, 
        SUM(total_sale) AS sum_total_sale, 
        RANK() OVER (ORDER BY SUM(total_sale) DESC) AS rk 
    FROM retail_sales 
    GROUP BY customer_id 
) AS ranked_sum 
WHERE rk IN (1, 2, 3, 4, 5) 
ORDER BY rk;

SELECT *
FROM (
  SELECT 
       customer_id,
       sum_total_sale,
       RANK() OVER (ORDER BY sum_total_sale DESC) as rnk
  FROM
  (SELECT 
      customer_id,
      SUM(total_sale) as sum_total_sale
 FROM  retail_sales
 GROUP BY customer_id) as total_sum
)AS ranked_sum
WHERE RNK IN (1, 2, 3, 4, 5);

-- method 2:
SELECT 
   customer_id,
   SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items form each category
SELECT *
FROM retail_sales;

SELECT
   category,
   COUNT( DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category
ORDER BY category;
 
   

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)
SELECT
     shift,
     COUNT(shift) as number_of_orders
from(
SELECT *,
  CASE
      WHEN HOUR(sale_time) < 12 THEN 'Morning'
      WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
 END AS shift
FROM retail_sales ) as shift_categories
GROUP BY shift;

-- method 2:

WITH hourly_sale 
AS(
SELECT *,
     CASE
          WHEN HOUR(sale_time) < 12 THEN 'Morning'
          WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
          ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT shift,
COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;









