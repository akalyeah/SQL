USE vehicle_rental_management;

-- 1. Rental details across multiple related tables
SELECT
    r.rental_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    CONCAT(v.make,' ',v.model) AS vehicle,
    b.branch_name,
    r.pickup_datetime,
    r.actual_return_datetime,
    r.total_amount
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
JOIN vehicles v ON r.vehicle_id = v.vehicle_id
JOIN employees e ON r.employee_id = e.employee_id
JOIN branches b ON e.branch_id = b.branch_id
ORDER BY r.pickup_datetime;

-- 2. Vehicles and their type/branch
SELECT v.registration_no, v.make, v.model, vt.type_name, vt.daily_rate, b.branch_name
FROM vehicles v
JOIN vehicle_types vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN branches b ON v.branch_id = b.branch_id;

-- 3. Customers with their bookings, including customers with no bookings
SELECT c.customer_id,
       CONCAT(c.first_name,' ',c.last_name) AS customer_name,
       COUNT(b.booking_id) AS booking_count
FROM customers c
LEFT JOIN bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY booking_count DESC;

-- 4. Branches with vehicles, including branches with no vehicles
SELECT b.branch_name, b.city, COUNT(v.vehicle_id) AS vehicle_count
FROM branches b
LEFT JOIN vehicles v ON b.branch_id = v.branch_id
GROUP BY b.branch_id, b.branch_name, b.city;
