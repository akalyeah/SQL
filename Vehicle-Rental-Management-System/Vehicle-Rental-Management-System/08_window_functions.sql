USE vehicle_rental_management;

-- 1. Rank customers by total spend
WITH customer_spend AS (
    SELECT c.customer_id,
           CONCAT(c.first_name,' ',c.last_name) AS customer_name,
           SUM(r.total_amount) AS total_spend
    FROM customers c
    JOIN rentals r ON c.customer_id = r.customer_id
    WHERE r.rental_status <> 'CANCELLED'
    GROUP BY c.customer_id, customer_name
)
SELECT customer_name,
       total_spend,
       RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM customer_spend;

-- 2. Running revenue by payment date
SELECT
    DATE(payment_date) AS payment_day,
    SUM(amount) AS daily_revenue,
    SUM(SUM(amount)) OVER (ORDER BY DATE(payment_date)) AS running_revenue
FROM payments
WHERE payment_status = 'SUCCESS'
GROUP BY DATE(payment_date)
ORDER BY payment_day;

-- 3. Compare each rental with the previous rental for the same customer
SELECT
    rental_id,
    customer_id,
    pickup_datetime,
    total_amount,
    LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY pickup_datetime
    ) AS previous_rental_amount,
    total_amount - COALESCE(
        LAG(total_amount) OVER (
            PARTITION BY customer_id
            ORDER BY pickup_datetime
        ),0
    ) AS change_from_previous
FROM rentals
ORDER BY customer_id, pickup_datetime;

-- 4. Top 2 rentals by value for each branch
WITH branch_rentals AS (
    SELECT
        b.branch_name,
        r.rental_id,
        r.total_amount,
        ROW_NUMBER() OVER (
            PARTITION BY b.branch_id
            ORDER BY r.total_amount DESC
        ) AS rn
    FROM rentals r
    JOIN employees e ON r.employee_id = e.employee_id
    JOIN branches b ON e.branch_id = b.branch_id
)
SELECT branch_name, rental_id, total_amount
FROM branch_rentals
WHERE rn <= 2
ORDER BY branch_name, total_amount DESC;
