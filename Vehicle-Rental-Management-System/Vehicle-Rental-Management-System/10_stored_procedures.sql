USE vehicle_rental_management;

DELIMITER $$

CREATE PROCEDURE sp_create_rental(
    IN p_booking_id INT,
    IN p_employee_id INT,
    IN p_pickup_datetime DATETIME,
    IN p_expected_return_datetime DATETIME,
    IN p_start_odometer_km INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_vehicle_id INT;
    DECLARE v_status VARCHAR(20);
    DECLARE v_daily_rate DECIMAL(10,2);
    DECLARE v_days INT;
    DECLARE v_total DECIMAL(10,2);

    START TRANSACTION;

    SELECT customer_id, vehicle_id
    INTO v_customer_id, v_vehicle_id
    FROM bookings
    WHERE booking_id = p_booking_id
    FOR UPDATE;

    SELECT status
    INTO v_status
    FROM vehicles
    WHERE vehicle_id = v_vehicle_id
    FOR UPDATE;

    IF v_status <> 'AVAILABLE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vehicle is not available for rental';
    END IF;

    SELECT vt.daily_rate
    INTO v_daily_rate
    FROM vehicles v
    JOIN vehicle_types vt ON v.vehicle_type_id = vt.vehicle_type_id
    WHERE v.vehicle_id = v_vehicle_id;

    SET v_days = GREATEST(1, DATEDIFF(DATE(p_expected_return_datetime), DATE(p_pickup_datetime)));
    SET v_total = v_days * v_daily_rate;

    INSERT INTO rentals (
        booking_id, customer_id, vehicle_id, employee_id,
        pickup_datetime, expected_return_datetime,
        start_odometer_km, rental_status,
        base_amount, total_amount
    )
    VALUES (
        p_booking_id, v_customer_id, v_vehicle_id, p_employee_id,
        p_pickup_datetime, p_expected_return_datetime,
        p_start_odometer_km, 'ACTIVE',
        v_total, v_total
    );

    UPDATE bookings
    SET status = 'COMPLETED'
    WHERE booking_id = p_booking_id;

    COMMIT;
END$$

CREATE PROCEDURE sp_return_vehicle(
    IN p_rental_id INT,
    IN p_actual_return_datetime DATETIME,
    IN p_end_odometer_km INT,
    IN p_damage_fee DECIMAL(10,2)
)
BEGIN
    DECLARE v_vehicle_id INT;
    DECLARE v_expected DATETIME;
    DECLARE v_base DECIMAL(10,2);
    DECLARE v_late_fee DECIMAL(10,2) DEFAULT 0;
    DECLARE v_late_days INT DEFAULT 0;

    START TRANSACTION;

    SELECT vehicle_id, expected_return_datetime, base_amount
    INTO v_vehicle_id, v_expected, v_base
    FROM rentals
    WHERE rental_id = p_rental_id
    FOR UPDATE;

    SET v_late_days = GREATEST(0, DATEDIFF(DATE(p_actual_return_datetime), DATE(v_expected)));
    SET v_late_fee = v_late_days * 500;

    UPDATE rentals
    SET actual_return_datetime = p_actual_return_datetime,
        end_odometer_km = p_end_odometer_km,
        rental_status = 'RETURNED',
        late_fee = v_late_fee,
        damage_fee = p_damage_fee,
        total_amount = v_base + v_late_fee + p_damage_fee - discount_amount
    WHERE rental_id = p_rental_id;

    UPDATE vehicles
    SET status = 'AVAILABLE',
        odometer_km = p_end_odometer_km
    WHERE vehicle_id = v_vehicle_id;

    COMMIT;
END$$

DELIMITER ;

-- Example:
-- CALL sp_create_rental(10, 2, '2026-06-20 09:00:00', '2026-06-22 09:00:00', 13420);
-- CALL sp_return_vehicle(10, '2026-06-22 09:30:00', 13750, 0);
