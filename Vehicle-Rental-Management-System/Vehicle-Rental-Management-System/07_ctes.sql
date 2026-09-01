USE vehicle_rental_management;

-- 1. Monthly revenue using a CTE
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(p.payment_date,'%Y-%m') AS revenue_month,
        SUM(p.amount) AS revenue
    FROM payments p
    WHERE p.payment_status = 'SUCCESS'
    GROUP BY DATE_FORMAT(p.payment_date,'%Y-%m')
)
SELECT revenue_month, revenue
FROM monthly_revenue
ORDER BY revenue_month;

-- 2. Customer rental summary using multiple CTEs
WITH rental_summary AS (
    SELECT customer_id,
           COUNT(*) AS rental_count,
           SUM(total_amount) AS total_spend,
           AVG(total_amount) AS avg_rental_value
    FROM rentals
    WHERE rental_status <> 'CANCELLED'
    GROUP BY customer_id
),
customer_segment AS (
    SELECT *,
           CASE
               WHEN total_spend >= 20000 THEN 'HIGH VALUE'
               WHEN total_spend >= 10000 THEN 'MEDIUM VALUE'
               ELSE 'STANDARD'
           END AS segment
    FROM rental_summary
)
SELECT c.customer_id,
       CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       cs.rental_count,
       cs.total_spend,
       ROUND(cs.avg_rental_value,2) AS avg_rental_value,
       cs.segment
FROM customer_segment cs
JOIN customers c ON cs.customer_id = c.customer_id
ORDER BY cs.total_spend DESC;

-- 3. Vehicles with maintenance cost compared to rental revenue
WITH maintenance_cost AS (
    SELECT vehicle_id, SUM(cost) AS total_maintenance_cost
    FROM maintenance
    GROUP BY vehicle_id
),
rental_revenue AS (
    SELECT vehicle_id, SUM(total_amount) AS total_rental_revenue
    FROM rentals
    WHERE rental_status = 'RETURNED'
    GROUP BY vehicle_id
)
SELECT v.registration_no,
       v.make,
       v.model,
       COALESCE(mc.total_maintenance_cost,0) AS maintenance_cost,
       COALESCE(rr.total_rental_revenue,0) AS rental_revenue,
       COALESCE(rr.total_rental_revenue,0) - COALESCE(mc.total_maintenance_cost,0) AS contribution
FROM vehicles v
LEFT JOIN maintenance_cost mc ON v.vehicle_id = mc.vehicle_id
LEFT JOIN rental_revenue rr ON v.vehicle_id = rr.vehicle_id
ORDER BY contribution DESC;
