-- TODO: This query will return a table with two columns; State, and
-- Delivery_Difference. The first one will have the letters that identify the
-- states, and the second one the average difference between the estimate
-- delivery date and the date when the items were actually delivered to the
-- customer.

SELECT State, cast (AVG(days) as integer) AS Delivery_Difference
FROM
(
SELECT JULIANDAY(DATE(oo.order_estimated_delivery_date)) - JULIANDAY(DATE(oo.order_delivered_customer_date)) as days, oc.customer_state as State
FROM olist_orders AS oo, olist_customers AS oc
WHERE oo.order_delivered_customer_date NOTNULL  and oo.customer_id = oc.customer_id
)
GROUP BY State
ORDER BY Delivery_Difference ASC
