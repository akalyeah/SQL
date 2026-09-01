USE vehicle_rental_management;

DELIMITER $$

CREATE FUNCTION fn_rental_days(
    p_pickup DATETIME,
    p_return DATETIME
)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN GREATEST(1, DATEDIFF(DATE(p_return), DATE(p_pickup)));
END$$

CREATE FUNCTION fn_calculate_rental_amount(
    p_daily_rate DECIMAL(10,2),
    p_pickup DATETIME,
    p_return DATETIME,
    p_discount DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN GREATEST(
        0,
        (fn_rental_days(p_pickup, p_return) * p_daily_rate) - p_discount
    );
END$$

DELIMITER ;

-- Example:
-- SELECT fn_rental_days('2026-06-01 10:00:00','2026-06-04 10:00:00');
-- SELECT fn_calculate_rental_amount(2200,'2026-06-01 10:00:00','2026-06-04 10:00:00',500);
