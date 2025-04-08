# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_project_p1`

This project showcases core SQL skills for cleaning, exploring, and analyzing retail sales data. The dataset captures transaction-level details such as customer demographics, product categories, and sales figures. The project is ideal for beginners looking to build a foundational understanding of SQL for business analytics.

---

## Objectives

1. **Database Setup**: Work within an existing database and inspect the table structure.
2. **Data Cleaning**: Standardize column types and remove null or incomplete records.
3. **Exploratory Data Analysis (EDA)**: Get a general sense of the data via descriptive queries.
4. **Business Analysis**: Extract insights using analytical queries to answer real-world business questions.

---

## Project Structure

### 1. Database Setup

- **Database Used**: `sql_project_p1`
- **Table**: `retail_sales`

Initial exploration and schema correction:

```sql
USE sql_project_p1;

SELECT * FROM retail_sales;

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
```

---

### 2. Data Cleaning

Records with `NULL` values were removed to ensure consistency:

```sql
SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE transactions_id IS NULL 
   OR sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantiy IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL 
   OR total_sale IS NULL;
```

---

### 3. Exploratory Data Analysis

Some foundational questions:

- **Total sales transactions**:
  ```sql
  SELECT COUNT(*) AS total_sale FROM retail_sales;
  ```

- **Unique customers**:
  ```sql
  SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;
  ```

- **Categories available**:
  ```sql
  SELECT COUNT(DISTINCT category) FROM retail_sales;
  SELECT DISTINCT category FROM retail_sales;
  ```

---

### 4. Business Questions & Analysis

**Q1. Sales on 2022-11-05**
```sql
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
```

**Q2. Clothing category, quantity > 4, in Nov 2022**
```sql
SELECT COUNT(*) 
FROM retail_sales 
WHERE category = 'Clothing' AND quantiy >= 4 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
```

**Q3. Total sales per category**
```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

**Q4. Average age of customers who purchased Beauty products**
```sql
SELECT ROUND(AVG(age), 2) AS avg_age 
FROM retail_sales 
WHERE category = 'Beauty';
```

**Q5. Transactions with total sale > 1000**
```sql
SELECT * FROM retail_sales 
WHERE total_sale > 1000;
```

**Q6. Transaction count by gender and category**
```sql
SELECT category, gender, COUNT(*) 
FROM retail_sales 
GROUP BY category, gender 
ORDER BY category;
```

**Q7. Best-selling month per year (avg sale)**
```sql
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
```

**Q8. Top 5 customers by total sales**
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

**Q9. Unique customers per category**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY category;
```

**Q10. Shift-wise order distribution**
```sql
WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN HOUR(sale_time) < 12 THEN 'Morning'
               WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Evening'
           END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

## Key Findings

- **Customer Distribution**: Balanced gender mix across categories.
- **High-Spending Users**: Several repeat buyers contributing significantly to revenue.
- **Category Trends**: Clothing and Beauty show strong volume and engagement.
- **Time-based Patterns**: Sales are highest during the Afternoon and Evening shifts.
- **Peak Months**: Certain months outperform others, guiding promotional planning.

---

## Conclusion

This project covered essential SQL techniques—from data cleanup to complex analytical queries. It highlights the power of SQL for answering actionable business questions and reinforces foundational skills in data analysis. Ideal for those starting their data journey or preparing for data analyst roles.

---

## Next Steps

- Visualize monthly sales trends with a BI tool (e.g., Tableau or Power BI)
- Extend the schema to include store-level or regional data
- Perform cohort analysis or customer segmentation using SQL