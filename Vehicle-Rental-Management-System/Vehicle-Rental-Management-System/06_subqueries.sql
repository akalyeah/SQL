USE vehicle_rental_management;

-- 1. Customers whose total rental spend is above average customer spend
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    SUM(r.total_amount) AS total_spend
FROM customers c
JOIN rentals r ON c.customer_id = r.customer_id
WHERE r.rental_status = 'RETURNED'
GROUP BY c.customer_id, customer_name
HAVING SUM(r.total_amount) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT SUM(total_amount) AS customer_total
        FROM rentals
        WHERE rental_status = 'RETURNED'
        GROUP BY customer_id
    ) x
)
ORDER BY total_spend DESC;

-- 2. Vehicles rented more times than the average rental count
SELECT v.vehicle_id, v.registration_no, v.make, v.model, COUNT(r.rental_id) AS rental_count
FROM vehicles v
JOIN rentals r ON v.vehicle_id = r.vehicle_id
GROUP BY v.vehicle_id, v.registration_no, v.make, v.model
HAVING COUNT(r.rental_id) > (
    SELECT AVG(rental_count)
    FROM (
        SELECT COUNT(*) AS rental_count
        FROM rentals
        GROUP BY vehicle_id
    ) x
);

-- 3. Highest-value returned rental
SELECT *
FROM rentals
WHERE total_amount = (
    SELECT MAX(total_amount)
    FROM rentals
    WHERE rental_status = 'RETURNED'
);

-- 4. Customers who have never made a rental
SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM rentals r
    WHERE r.customer_id = c.customer_id
);
