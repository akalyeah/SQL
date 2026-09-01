USE vehicle_rental_management;

DELIMITER $$

CREATE TRIGGER trg_rental_insert_update_vehicle
AFTER INSERT ON rentals
FOR EACH ROW
BEGIN
    IF NEW.rental_status = 'ACTIVE' THEN
        UPDATE vehicles
        SET status = 'RENTED'
        WHERE vehicle_id = NEW.vehicle_id;
    END IF;
END$$

CREATE TRIGGER trg_rental_return_update_vehicle
AFTER UPDATE ON rentals
FOR EACH ROW
BEGIN
    IF NEW.rental_status = 'RETURNED'
       AND OLD.rental_status <> 'RETURNED' THEN
        UPDATE vehicles
        SET status = 'AVAILABLE',
            odometer_km = NEW.end_odometer_km
        WHERE vehicle_id = NEW.vehicle_id;
    END IF;
END$$

DELIMITER ;
