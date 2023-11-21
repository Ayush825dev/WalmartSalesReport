create database if not exists Walmartsalesdata;
use  Walmartsalesdata ;
CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6 , 4 ) NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT(11 , 9 ),
    gross_income DECIMAL(12 , 4 ) NOT NULL,
    rating FLOAT(2 , 1 )
);

SELECT 
    *
FROM
    walmartsalesdata.sales;

-- ------------------------------------------------------------------------------------------------
/* part 1: DATA WRANGLING: To make sure that there are no null values*/

SELECT 
    time,
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_date
FROM
    sales;

ALTER table sales add column time_of_day VARCHAR(20) ;

UPDATE sales 
SET 
    time_of_day = CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
;


-- (b.) day_name
-- Add a new column named day_name that contains the extracted days of the week on which the given transaction took place
-- 		(Mon, Tue, Wed, Thur, Fri). 
-- 		This will help answer the question on which week of the day each branch is busiest.


SELECT 
    date, DAYNAME(date) AS day_name
FROM
    sales;
    
ALTER TABLE sales add column day_name VARCHAR(10);

UPDATE sales 
SET 
    day_name = DAYNAME(date);
 
 -- (c.)month_name
SELECT 
    date, MONTHNAME(date)
FROM
    sales;
  
  ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
  
UPDATE sales 
SET 
    month_name = MONTHNAME(date);
  
  
-- ------------------------------------------------------------------------------------------------


SELECT DISTINCT
    city
FROM
    sales;

-- Q2.In which city is each branch?

SELECT DISTINCT
    city, branch
FROM
    sales;

-- part (b.)Questions based on Product

SELECT 
    COUNT(DISTINCT product_line)
FROM
    sales;

-- Q2.What is the most common payment method?

SELECT 
    payment_method, COUNT(payment_method) AS times
FROM
    sales
GROUP BY payment_method
ORDER BY times DESC
LIMIT 1
;

-- Q3.What is the most selling product line?

SELECT 
    product_line, COUNT(product_line) AS times
FROM
    sales
GROUP BY product_line
ORDER BY times DESC
LIMIT 1;

-- Q4.What is the total revenue by month?

SELECT 
    month_name AS Month, SUM(total) AS Revenue
FROM
    sales
GROUP BY Month
ORDER BY Revenue DESC
;

-- Q5.What month had the largest COGS?

SELECT 
    month_name AS Month, MAX(cogs) AS COGS
FROM
    sales
GROUP BY Month
ORDER BY COGS DESC
;

-- Q6.What product line had the largest revenue?

SELECT 
    product_line AS PLine, SUM(total) AS Revenue
FROM
    sales
GROUP BY Pline
ORDER BY Revenue DESC
;

-- Q7.What is the city with the largest revenue?

SELECT 
    branch, city AS CITY, SUM(total) AS Revenue
FROM
    sales
GROUP BY CITY , branch
ORDER BY Revenue DESC
LIMIT 1
;
-- Q8.What product line had the largest VAT?

SELECT 
    product_line AS Pline, AVG(VAT) AS Avg_VAT
FROM
    sales
GROUP BY Pline
ORDER BY Avg_VAT DESC
LIMIT 1
;
-- Q9.Fetch each product line and add a column to those product line showing 
-- "Good", "Bad".
--  Good if its greater than average sales


SELECT 
    product_line,
    CASE
        WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM
    sales
GROUP BY product_line;

-- Q10.Which branch sold more products than average product sold?

SELECT 
    branch, SUM(quantity) AS Qty
FROM
    sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales)
ORDER BY Qty DESC
LIMIT 1;


-- Q11.What is the most common product line by gender?

SELECT 
    gender, product_line, COUNT(product_line) AS times
FROM
    sales
GROUP BY product_line , gender
ORDER BY times DESC
LIMIT 1;

-- Q12.What is the average rating of each product line?

SELECT 
    product_line, AVG(rating) AS Rating
FROM
    sales
GROUP BY product_line
ORDER BY Rating DESC
LIMIT 1
;

-- ------------------------------------------------------------------------------------------------

SELECT 
    COUNT(*) AS Sales, time_of_day, day_name
FROM
    SALES
GROUP BY time_of_day , day_name
ORDER BY Sales DESC
;

-- Q2.Which of the customer types brings the most revenue?

SELECT 
    customer_type, SUM(total) AS Revenue
FROM
    sales
GROUP BY customer_type
ORDER BY Revenue DESC
LIMIT 1;

-- Q3.Which city has the largest tax percent/ VAT (Value Added Tax)?


SELECT 
    city, AVG(VAT) AS tax_percent
FROM
    sales
GROUP BY city
ORDER BY tax_percent DESC
LIMIT 1;

-- Q4.Which customer type pays the most in VAT?


SELECT 
    customer_type, AVG(VAT) AS VAT_payed
FROM
    sales
GROUP BY customer_type
ORDER BY VAT_payed DESC
LIMIT 1;

-- ------------------------------------------------------------------------------------------------
-- Q1.How many unique customer types does the data have?

SELECT DISTINCT
    customer_type
FROM
    SALES;

-- Q2. How many unique payment methods does the data have?

SELECT DISTINCT
    payment_method
FROM
    SALES;

-- Q3. What is the most common customer type?

SELECT DISTINCT
    customer_type, COUNT(*) AS Times
FROM
    SALES
GROUP BY customer_type
ORDER BY Times DESC
LIMIT 1;

-- Q4. Which customer type buys the most?

SELECT DISTINCT
    customer_type, SUM(total) AS Times
FROM
    SALES
GROUP BY customer_type
ORDER BY Times DESC
LIMIT 1;

-- Q5. What is the gender of most of the customers?

SELECT 
    gender, COUNT(*) AS Times
FROM
    sales
GROUP BY gender
ORDER BY Times DESC
LIMIT 1;

-- Q6. What is the gender distribution per branch?

SELECT DISTINCT
    gender, COUNT(*) AS times
FROM
    sales
WHERE
    branch = 'A'
GROUP BY gender
ORDER BY times DESC

;

-- Q7. Which time of the day do customers give most ratings?

SELECT 
    time_of_day, AVG(rating) AS AvgRating
FROM
    SALES
GROUP BY time_of_day
ORDER BY AvgRating DESC
LIMIT 1
;

-- Q8. Which time of the day do customers give most ratings per branch?

SELECT 
    time_of_day, AVG(rating) AS AvgRating, branch
FROM
    sales
WHERE
    branch = 'A'
GROUP BY time_of_day
ORDER BY AvgRating DESC
LIMIT 1
;

-- Q9. Which day of the week has the best avg ratings?

SELECT 
    day_name, AVG(rating) AS AvgRating
FROM
    sales
GROUP BY day_name
ORDER BY AvgRating DESC
LIMIT 1
;

-- Q10.Which day of the week has the best average ratings per branch?

SELECT 
    day_name, AVG(rating) AS AvgRating, branch
FROM
    sales
WHERE
    branch = 'A'
GROUP BY day_name
ORDER BY AvgRating DESC
LIMIT 1
;
/*
Revenue And Profit Calculations------------------------------------------------------------------------------


--------------------------------------CALCULATIONS------------------------------------------------------------
-- Below are the calculations and formulas utilised in the EXCEL sheet :-

1. Cost of Goods Sold (COGS) = unitPrice * quantity

2. Value Added Tax (VAT) = 5% * COGS
   - VAT is added to the COGS and is billed to the customer.

3. Total (gross_sales) = VAT + COGS

4. Gross Profit (grossIncome) = Total (gross_sales) - COGS

5. Gross Margin is the gross profit expressed as a percentage of the total (gross profit / total revenue).

   Gross Margin = (Gross Income / Total Revenue)



Example with the first row in our DB:----------------------------------------------

Data given: We are taking the values from the second row (invoice_id=101-81-4070) of our data sample.

1. Cost of Goods Sold (COGS) = unitPrice * quantity
sol.
	COGS = 62.82 * 2 
		 = 125.64. 

2. Value Added Tax (VAT) = 5% * COGS
sol.
	VAT = 5% * 125.64
		= 6.2820.
        
   - VAT is added to the COGS and is billed to the customer.

3. Total (gross_sales) = VAT + COGS
sol.
	Total = 6.2820 + 125.64
		  = 131.9220.

4. Gross Profit (grossIncome) = Total (gross_sales) - COGS
sol.
	Gross Profit = 131.9220 - 125.64
				 = 6.2820.

5. Gross Margin is the gross profit expressed as a percentage of the total (gross profit / total revenue).

   Gross Margin = (Gross Income) / (Total Revenue)
   
sol.
	Total = (6.2820 / 131.9220) * 100
		  = 4.80 %.

