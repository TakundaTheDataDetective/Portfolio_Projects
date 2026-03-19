-- CLEANING E-COMMERCE ORDERS

-- FIRSTLY JOIN THE TWO DATASETS
SELECT *
FROM orders_dataset o
JOIN products_dataset p
ON o.product_id = p.product_id ;

CREATE TABLE clean_orders AS
SELECT o.order_id,
o.customer_id,
o.price,
o.order_date,
o.shipping_date,
o.order_status,
p.product_name,
p.product_category,
p.manufacturing_city,
p.size,
p.color
FROM orders_dataset o
JOIN products_dataset p
ON o.product_id = p.product_id
WHERE o.order_status != 'Cancelled';

SELECT *
FROM clean_orders;


SELECT *,
COALESCE(NULLIF(shipping_date,''),'Unknown') AS shipping_date_clean
FROM clean_orders;

UPDATE clean_orders
SET shipping_date = COALESCE(NULLIF(shipping_date,''),'Unknown');

SELECT order_id, COUNT(*)
FROM clean_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM clean_orders;

