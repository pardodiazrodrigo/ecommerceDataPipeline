-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
WITH t1 AS (
    SELECT
        oo.order_id,
        oo.customer_id,
        STRFTIME('%m', oo.order_delivered_customer_date) AS month_no,
        STRFTIME('%m', oo.order_delivered_customer_date) AS month,
        STRFTIME('%Y', oo.order_delivered_customer_date) AS year,
        order_delivered_customer_date,
        order_status,
        STRFTIME('%Y', order_delivered_customer_date) as Year,
        STRFTIME('%m', order_delivered_customer_date) as month_no,
        opp.payment_value
    FROM olist_orders oo
    INNER JOIN olist_order_payments opp USING(order_id)
    WHERE order_status = 'delivered' AND order_delivered_customer_date NOTNULL
    GROUP BY order_id
    ORDER BY order_delivered_customer_date ASC
    )
SELECT
    t1.month_no,
    CASE
        WHEN t1.month = '01' THEN 'Jan'
        WHEN t1.month = '02' THEN 'Feb'
        WHEN t1.month = '03' THEN 'Mar'
        WHEN t1.month = '04' THEN 'Apr'
        WHEN t1.month = '05' THEN 'May'
        WHEN t1.month = '06' THEN 'Jun'
        WHEN t1.month = '07' THEN 'Jul'
        WHEN t1.month = '08' THEN 'Aug'
        WHEN t1.month = '09' THEN 'Sep'
        WHEN t1.month = '10' THEN 'Oct'
        WHEN t1.month = '11' THEN 'Nov'
        WHEN t1.month = '12' THEN 'Dec'
    END AS month,

    ROUND(SUM(CASE
    WHEN t1.year = '2016' THEN payment_value ELSE 0.00
    END),2) as Year2016,

    ROUND(SUM(CASE
    WHEN t1.Year = '2017' THEN payment_value ELSE 0.00
    END),2) as Year2017,

    ROUND(SUM(CASE
    WHEN t1.Year = '2018' THEN payment_value ELSE 0.00
    END),2) as Year2018

FROM t1
GROUP BY t1.month_no, t1.month