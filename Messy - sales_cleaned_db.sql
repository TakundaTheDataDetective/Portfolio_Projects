-- DATA CLEANING 

SELECT *
FROM messy_sales_dataset;

-- 1 STANDARDIZE DATA
-- 2 REMOVE BLANKS
-- 3 REMOVE DUPLICATES
-- 4 REMOVE UNNECESSARY COLUMNS

-- FIRST OF ALL CREATE A NEW TABLE SO AS NOT TO MESS WITH THE RAW DATA

CREATE TABLE messy_sales_dataset2
LIKE messy_sales_dataset;

SELECT *
FROM messy_sales_dataset2;

INSERT INTO messy_sales_dataset2
SELECT *
FROM messy_sales_dataset;

-- 1 STANDARDIZE THE DATA
-- DEALING WITH cutomer name column
SELECT DISTINCT(customer_name)
FROM messy_sales_dataset2
ORDER BY 1;

SELECT customer_name, (TRIM(customer_name))
FROM  messy_sales_dataset2;

UPDATE messy_sales_dataset2
SET customer_name = (TRIM(customer_name));

-- DEALING WITH city column
SELECT DISTINCT(city)
FROM messy_sales_dataset2;

SELECT (city), 
TRIM(CONCAT(UCASE(LEFT(city,1)), (LCASE(SUBSTRING(city,2))))) AS city_clean
FROM messy_sales_dataset2;

UPDATE messy_sales_dataset2
SET city = TRIM(CONCAT(UCASE(LEFT(city,1)), (LCASE(SUBSTRING(city,2)))));

SELECT DISTINCT(city)
FROM messy_sales_dataset2;

-- DEALING WITH product column
SELECT DISTINCT (product)
FROM messy_sales_dataset2;

SELECT *
FROM messy_sales_dataset2;

-- DEALING WITH order date column

ALTER TABLE messy_sales_dataset2
ADD clean_date DATE;

SELECT order_date,
	CASE
		WHEN order_date LIKE '____-__-__' 
        THEN STR_TO_DATE(order_date,'%Y-%m-%d')

		WHEN `order_date` LIKE '%/%/%' 
        THEN STR_TO_DATE(`order_date`,'%d/%m/%Y')

		WHEN `order_date` LIKE '__-__-____' 
        THEN STR_TO_DATE(`order_date`,'%m-%d-%Y')

		ELSE NULL
	END AS cleaned_date
FROM messy_sales_dataset2;

UPDATE messy_sales_dataset2
SET clean_date = CASE
		WHEN order_date LIKE '____-__-__' 
        THEN STR_TO_DATE(order_date,'%Y-%m-%d')

		WHEN `order_date` LIKE '%/%/%' 
        THEN STR_TO_DATE(`order_date`,'%d/%m/%Y')

		WHEN `order_date` LIKE '__-__-____' 
        THEN STR_TO_DATE(`order_date`,'%m-%d-%Y')

    ELSE NULL
	END ;

SELECT *
FROM messy_sales_dataset2;

 -- 2 REMOVE THE BLANKS
 
 SELECT *
FROM messy_sales_dataset2
WHERE quantity = '';

-- LEAVING THE BLANKS LIKE THAT

-- 3 REMOVE DUPLICATES

SELECT customer_name, city, product, quantity, price_usd, order_date
FROM messy_sales_dataset2
ORDER BY customer_name, city, product, price_usd;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_name, city, product, quantity, price_usd, order_date) AS row_num
FROM messy_sales_dataset2;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY customer_name, city, product, quantity, price_usd, order_date) AS row_num
FROM messy_sales_dataset2
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- THERE ARE NO DUPLICATES

-- 4 REMOVE UNNECESSARY COLUMNS

ALTER TABLE messy_sales_dataset2
DROP COLUMN order_date; 

SELECT * 
FROM messy_sales_dataset2;