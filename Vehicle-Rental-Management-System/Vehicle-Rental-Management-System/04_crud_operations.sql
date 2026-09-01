USE vehicle_rental_management;

-- CREATE
INSERT INTO customers (first_name,last_name,email,phone,driving_license_no)
VALUES ('Test','Customer','test.customer@example.com','9000000099','TN09DL1099');

-- READ
SELECT customer_id, first_name, last_name, email, status
FROM customers
WHERE status = 'ACTIVE';

-- UPDATE
UPDATE customers
SET status = 'INACTIVE'
WHERE email = 'test.customer@example.com';

-- DELETE (demonstration only; customer has no dependent records)
DELETE FROM customers
WHERE email = 'test.customer@example.com';
