-- TODO: This query will return a table with two columns; customer_state, and
-- Revenue. The first one will have the letters that identify the top 10 states
-- with most revenue and the second one the total revenue of each.
SELECT customer_state, SUM(payment_value) as Revenue
FROM (
	SELECT customer_id,
	customer_state,
    order_id,
    order_status,
	payment_value
	FROM olist_customers oc
	JOIN olist_orders oo USING(customer_id)
	JOIN olist_order_payments opp USING(order_id)
	WHERE order_status = 'delivered' AND order_delivered_customer_date NOTNULL
    )
GROUP BY customer_state
ORDER BY Revenue DESC LIMIT 10
