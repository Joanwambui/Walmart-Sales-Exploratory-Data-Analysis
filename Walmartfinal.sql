---When do the stores open
SELECT MAX(Time) as max,MIN(Time) as min
FROM sql_workbench.supermarket_sales;

SELECT *
FROM sql_workbench.supermarket_sales;
SELECT  STR_TO_DATE(Date, '%m-%d-%Y')
FROM sql_workbench.supermarket_sales;

SELECT COUNT(*) FROM sql_workbench.supermarket_sales WHERE Date IS NULL;

ALTER TABLE supermarket_sales MODIFY Date DATE;
UPDATE supermarket_sales SET Date = STR_TO_DATE(Date, '%Y-%m-%d');

---DESCRIBE supermarket_sales;
ALTER TABLE supermarket_sales ADD mo INT;
UPDATE supermarket_sales SET mo = MONTH(Date);
ALTER TABLE supermarket_sales DROP COLUMN Month, DROP COLUMN Day, DROP COLUMN Year;
---Total number of orders received in the last 3 months (Jan, Feb, Mar)
SELECT COUNT(invoiceid)
FROM supermarket_sales
WHERE mo IN (1,2,3);
--ALTER TABLE supermarket_sales CHANGE Invoice ID 'invoice_id' VARCHAR(30);
ALTER TABLE supermarket_sales RENAME COLUMN `Invoice ID` TO invoiceid;
---How many quantities of product do we sell in the last 3 months
SELECT *
FROM supermarket_sales;
SELECT SUM(Quantity)
FROM supermarket_sales
WHERE mo IN (1,2,3);

--Total revenue in the last 3 months
SELECT SUM(`Unit price`)
FROM supermarket_sales
WHERE mo IN (1,2,3);

---In which month have we achieved the highest and lowest revenue(total revenue in each month)
SELECT SUM(`Unit price`),mo as month
FROM supermarket_sales
GROUP BY mo 
ORDER BY 1 DESC

---Which day of the week has the highest and lowest sales;
ALTER TABLE supermarket_sales ADD day_ varchar(20);
UPDATE supermarket_sales SET day_ = DAYNAME(Date);
SELECT SUM(`Unit price`),day_ as dayoftheweek
FROM supermarket_sales
GROUP BY dayoftheweek
ORDER BY 1 DESC;
--Which customer type buy more?
SELECT SUM(Total),`Customer type`
FROM supermarket_sales
GROUP BY 2
ORDER BY 1 DESC;
---Quantity of goods sold in each product line
SELECT SUM(Quantity),`Product line`
FROM supermarket_sales
GROUP BY 2
ORDER BY 1 DESC;
---What is the total revenue generated by each product line and payment method?
SELECT SUM(Total),`Product line`,Payment
FROM supermarket_sales
GROUP BY 2,3
ORDER BY 1 DESC;
--What is the average rating for each city?
SELECT AVG(Rating),City
FROM supermarket_sales
GROUP BY 2;
--Which gender is our target market?
SELECT SUM(Total),Gender
FROM supermarket_sales
GROUP BY 2;
--Which period of the day has the highest sales?
ALTER TABLE supermarket_sales ADD time_ varchar(20);
UPDATE supermarket_sales SET time_ = STR_TO_DATE(Time, '%H:%i:%s');
SELECT Time, STR_TO_DATE(Time, '%H:%i:%s') AS time_new
FROM supermarket_sales;
SELECT HOUR(time_) AS hour, SUM(Total) AS total_revenue
FROM supermarket_sales
GROUP BY HOUR(time_)
ORDER BY 2 DESC;
---Add a new column named day_period to give insight of sales in the Morning, Afternoon and Evening
ALTER TABLE supermarket_sales ADD COLUMN day_period VARCHAR(10);

UPDATE supermarket_sales SET day_period = 
  CASE 
    WHEN HOUR(time_) >= 5 AND HOUR(time_) < 12 THEN 'Morning'
    WHEN HOUR(time_) >= 12 AND HOUR(time_) < 17 THEN 'Afternoon'
    ELSE 'Evening'
  END;
