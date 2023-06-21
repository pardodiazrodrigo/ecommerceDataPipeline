-- TODO: This query will return a table with the top 10 least revenue categories
-- in English, the number of orders and their total revenue. The first column
-- will be Category, that will contain the top 10 least revenue categories; the
-- second one will be Num_order, with the total amount of orders of each
-- category; and the last one will be Revenue, with the total revenue of each
-- catgory.
SELECT
	product_category_name_english as Category,
	COUNT(DISTINCT order_id) as Num_order,
	ROUND(SUM(payment_value),2) as Revenue
FROM
	(
	SELECT
		product_id,
		order_id,
		payment_value,
		order_delivered_customer_date,
		order_status,
		product_category_name,
		product_category_name_english
	FROM olist_order_items ooi
	INNER JOIN olist_order_payments oop USING(order_id)
	INNER JOIN olist_orders oo USING(order_id)
	JOIN olist_products op USING(product_id)
	JOIN product_category_name_translation pcnt USING(product_category_name)
	WHERE order_status = 'delivered' AND order_delivered_customer_date NOTNULL
	)
GROUP BY product_category_name_english
ORDER BY Revenue ASC
LIMIT 10