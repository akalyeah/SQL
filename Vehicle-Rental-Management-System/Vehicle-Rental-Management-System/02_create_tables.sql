USE vehicle_rental_management;

CREATE TABLE vehicle_types (
    vehicle_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    daily_rate DECIMAL(10,2) NOT NULL,
    seats TINYINT UNSIGNED NOT NULL,
    CHECK (daily_rate > 0),
    CHECK (seats > 0)
);

CREATE TABLE branches (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(80) NOT NULL,
    phone VARCHAR(20) UNIQUE
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    driving_license_no VARCHAR(40) NOT NULL UNIQUE,
    registration_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    status ENUM('ACTIVE','SUSPENDED','INACTIVE') NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);

CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_type_id INT NOT NULL,
    branch_id INT NOT NULL,
    registration_no VARCHAR(20) NOT NULL UNIQUE,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    model_year YEAR NOT NULL,
    color VARCHAR(30),
    status ENUM('AVAILABLE','RESERVED','RENTED','MAINTENANCE','INACTIVE') NOT NULL DEFAULT 'AVAILABLE',
    odometer_km INT UNSIGNED NOT NULL DEFAULT 0,
    FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(vehicle_type_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    CHECK (odometer_km >= 0)
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    pickup_branch_id INT NOT NULL,
    return_branch_id INT NOT NULL,
    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    planned_pickup_date DATE NOT NULL,
    planned_return_date DATE NOT NULL,
    status ENUM('PENDING','CONFIRMED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
    quoted_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (pickup_branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (return_branch_id) REFERENCES branches(branch_id),
    CHECK (planned_return_date >= planned_pickup_date),
    CHECK (quoted_amount >= 0)
);

CREATE TABLE rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NULL UNIQUE,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    employee_id INT NOT NULL,
    pickup_datetime DATETIME NOT NULL,
    expected_return_datetime DATETIME NOT NULL,
    actual_return_datetime DATETIME NULL,
    start_odometer_km INT UNSIGNED NOT NULL,
    end_odometer_km INT UNSIGNED NULL,
    rental_status ENUM('ACTIVE','RETURNED','OVERDUE','CANCELLED') NOT NULL DEFAULT 'ACTIVE',
    base_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    late_fee DECIMAL(10,2) NOT NULL DEFAULT 0,
    damage_fee DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CHECK (expected_return_datetime > pickup_datetime),
    CHECK (end_odometer_km IS NULL OR end_odometer_km >= start_odometer_km),
    CHECK (base_amount >= 0 AND late_fee >= 0 AND damage_fee >= 0 AND discount_amount >= 0 AND total_amount >= 0)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CARD','UPI','CASH','BANK_TRANSFER') NOT NULL,
    payment_status ENUM('SUCCESS','PENDING','REFUNDED','FAILED') NOT NULL DEFAULT 'SUCCESS',
    transaction_reference VARCHAR(80) UNIQUE,
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id),
    CHECK (amount > 0)
);

CREATE TABLE maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    maintenance_type ENUM('SERVICE','REPAIR','INSPECTION','TYRE','ACCIDENT') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    description VARCHAR(255),
    cost DECIMAL(10,2) NOT NULL DEFAULT 0,
    status ENUM('OPEN','COMPLETED') NOT NULL DEFAULT 'OPEN',
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    CHECK (cost >= 0),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE INDEX idx_vehicle_branch_status ON vehicles(branch_id, status);
CREATE INDEX idx_booking_vehicle_dates ON bookings(vehicle_id, planned_pickup_date, planned_return_date);
CREATE INDEX idx_booking_customer ON bookings(customer_id);
CREATE INDEX idx_rental_customer ON rentals(customer_id);
CREATE INDEX idx_rental_vehicle_status ON rentals(vehicle_id, rental_status);
CREATE INDEX idx_payment_rental_date ON payments(rental_id, payment_date);
CREATE INDEX idx_maintenance_vehicle_date ON maintenance(vehicle_id, start_date);
