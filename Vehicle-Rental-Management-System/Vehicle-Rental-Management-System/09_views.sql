USE vehicle_rental_management;

CREATE OR REPLACE VIEW vw_vehicle_availability AS
SELECT
    v.vehicle_id,
    v.registration_no,
    CONCAT(v.make,' ',v.model) AS vehicle,
    vt.type_name,
    vt.daily_rate,
    b.branch_name,
    b.city,
    v.status
FROM vehicles v
JOIN vehicle_types vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN branches b ON v.branch_id = b.branch_id;

CREATE OR REPLACE VIEW vw_customer_rental_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    COUNT(r.rental_id) AS total_rentals,
    COALESCE(SUM(r.total_amount),0) AS total_spend,
    COALESCE(AVG(r.total_amount),0) AS average_rental_value
FROM customers c
LEFT JOIN rentals r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, customer_name;

CREATE OR REPLACE VIEW vw_branch_revenue AS
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    COUNT(DISTINCT r.rental_id) AS rental_count,
    COALESCE(SUM(r.total_amount),0) AS rental_revenue
FROM branches b
LEFT JOIN employees e ON b.branch_id = e.branch_id
LEFT JOIN rentals r ON e.employee_id = r.employee_id
GROUP BY b.branch_id, b.branch_name, b.city;

-- Example use
SELECT * FROM vw_vehicle_availability WHERE status = 'AVAILABLE';
SELECT * FROM vw_customer_rental_summary ORDER BY total_spend DESC;
SELECT * FROM vw_branch_revenue ORDER BY rental_revenue DESC;
