-- TODO: This query will return a table with the differences between the real
-- and estimated delivery times by month and year. It will have different
-- columns: month_no, with the month numbers going from 01 to 12; month, with
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with
-- the average delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if
-- it doesn't exist); Year2018_real_time, with the average delivery time per
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist);
-- Year2017_estimated_time, with the average estimated delivery time per month
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).

SELECT
	a.month_no,
	CASE
		WHEN a.month_no = '01' THEN 'Jan'
		WHEN a.month_no = '02' THEN 'Feb'
		WHEN a.month_no = '03' THEN 'Mar'
		WHEN a.month_no = '04' THEN 'Apr'
		WHEN a.month_no = '05' THEN 'May'
		WHEN a.month_no = '06' THEN 'Jun'
		WHEN a.month_no = '07' THEN 'Jul'
		WHEN a.month_no = '08' THEN 'Aug'
		WHEN a.month_no = '09' THEN 'Sep'
		WHEN a.month_no = '10'THEN 'Oct'
		WHEN a.month_no = '11' THEN 'Nov'
		WHEN a.month_no = '12' THEN 'Dec'
	END AS month,
	COALESCE (AVG(
		CASE
			WHEN a.year = '2016' THEN ABS((JULIANDAY(order_purchase_timestamp)) - (JULIANDAY(order_delivered_customer_date)))
		END), NULL)
	 as Year2016_real_time,
	 COALESCE (AVG(
		CASE
			WHEN a.year = '2017' THEN ABS((JULIANDAY(order_purchase_timestamp)) - (JULIANDAY(order_delivered_customer_date)))
		END), NULL)
	 as Year2017_real_time,
	 COALESCE (AVG(
		CASE
			WHEN a.year = '2018' THEN ABS((JULIANDAY(order_purchase_timestamp)) - (JULIANDAY(order_delivered_customer_date)))
		END), NULL)
	 as Year2018_real_time,
	 COALESCE (AVG(
		CASE
			WHEN a.year = '2016' THEN ABS((JULIANDAY(order_purchase_timestamp)) - (JULIANDAY(order_estimated_delivery_date)))
		END), NULL)
	 as Year2016_estimated_time,
	 COALESCE (AVG(
		CASE
			WHEN a.year = '2017' THEN ABS((JULIANDAY(order_purchase_timestamp)) - (JULIANDAY(order_estimated_delivery_date)))
		END), NULL)
	 as Year2017_estimated_time,
	 COALESCE (AVG(
		CASE
			WHEN a.year = '2018' THEN ABS((JULIANDAY(order_purchase_timestamp)) - (JULIANDAY(order_estimated_delivery_date)))
		END), NULL)
	 as Year2018_estimated_time
FROM
	(
	SELECT
		STRFTIME('%Y', order_purchase_timestamp) as Year,
		STRFTIME('%m', order_purchase_timestamp) as month_no,
		order_delivered_customer_date,
		order_estimated_delivery_date,
		order_purchase_timestamp,
		order_status
	FROM olist_orders oo
	WHERE order_delivered_customer_date NOTNULL AND order_estimated_delivery_date NOTNULL AND order_status = 'delivered'
		AND order_purchase_timestamp NOTNULL
	) as a
GROUP BY month_no
