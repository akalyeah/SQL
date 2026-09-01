USE vehicle_rental_management;

-- TEST 1: Find currently unavailable vehicles
SELECT registration_no, make, model, status
FROM vehicles
WHERE status <> 'AVAILABLE';

-- TEST 2: Find active rentals
SELECT rental_id, vehicle_id, customer_id, expected_return_datetime
FROM rentals
WHERE rental_status = 'ACTIVE';

-- TEST 3: Detect overdue active rentals
SELECT rental_id, vehicle_id, expected_return_datetime
FROM rentals
WHERE rental_status = 'ACTIVE'
  AND expected_return_datetime < CURRENT_TIMESTAMP;

-- TEST 4: Customers with outstanding balances
SELECT
    r.rental_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    r.total_amount,
    COALESCE(SUM(CASE WHEN p.payment_status='SUCCESS' THEN p.amount ELSE 0 END),0) AS paid_amount,
    r.total_amount - COALESCE(SUM(CASE WHEN p.payment_status='SUCCESS' THEN p.amount ELSE 0 END),0) AS balance
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
LEFT JOIN payments p ON r.rental_id = p.rental_id
GROUP BY r.rental_id, customer_name, r.total_amount
HAVING balance > 0;

-- TEST 5: Vehicles with open maintenance
SELECT v.registration_no, v.make, v.model, m.description, m.start_date
FROM vehicles v
JOIN maintenance m ON v.vehicle_id = m.vehicle_id
WHERE m.status = 'OPEN';

-- TEST 6: Basic referential-integrity audit
SELECT COUNT(*) AS orphan_rentals
FROM rentals r
LEFT JOIN customers c ON r.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
