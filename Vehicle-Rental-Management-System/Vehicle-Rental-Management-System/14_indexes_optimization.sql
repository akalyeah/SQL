USE vehicle_rental_management;

-- Check execution plan before optimization
EXPLAIN
SELECT *
FROM bookings
WHERE vehicle_id = 3
  AND planned_pickup_date >= '2026-06-01'
  AND planned_pickup_date < '2026-07-01';

-- The composite index idx_booking_vehicle_dates supports this filter.

-- Another indexed query
EXPLAIN
SELECT *
FROM rentals
WHERE vehicle_id = 3
  AND rental_status = 'RETURNED';

-- Avoid SELECT * when only a few columns are needed
SELECT rental_id, customer_id, vehicle_id, total_amount
FROM rentals
WHERE vehicle_id = 3
  AND rental_status = 'RETURNED';

-- Useful metadata checks
SHOW INDEX FROM bookings;
SHOW INDEX FROM rentals;

-- General optimization principles demonstrated:
-- 1. Index columns used frequently in WHERE/JOIN/ORDER BY.
-- 2. Use composite indexes for common multi-column filters.
-- 3. Select only required columns.
-- 4. Use EXPLAIN to inspect query plans.
-- 5. Avoid functions on indexed columns in WHERE where possible.
