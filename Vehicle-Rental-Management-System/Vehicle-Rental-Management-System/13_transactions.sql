USE vehicle_rental_management;

-- Transaction example: payment + rental update.
-- Both changes should succeed together; otherwise rollback.

START TRANSACTION;

UPDATE rentals
SET total_amount = total_amount + 250
WHERE rental_id = 10;

INSERT INTO payments
    (rental_id, amount, payment_method, payment_status, transaction_reference)
VALUES
    (10, 250, 'UPI', 'SUCCESS', 'TXN10012');

COMMIT;

-- Rollback pattern:
-- START TRANSACTION;
-- UPDATE rentals SET total_amount = total_amount + 1000 WHERE rental_id = 10;
-- ROLLBACK;
