-- Vehicle Rental Management System
-- Database: MySQL 8.0+
-- Purpose: Portfolio project demonstrating relational database development.

CREATE DATABASE IF NOT EXISTS vehicle_rental_management;
USE vehicle_rental_management;

-- Drop objects in dependency order for repeatable setup
DROP VIEW IF EXISTS vw_customer_rental_summary;
DROP VIEW IF EXISTS vw_vehicle_availability;
DROP VIEW IF EXISTS vw_branch_revenue;

DROP TRIGGER IF EXISTS trg_rental_return_update_vehicle;
DROP TRIGGER IF EXISTS trg_rental_insert_update_vehicle;

DROP PROCEDURE IF EXISTS sp_create_rental;
DROP PROCEDURE IF EXISTS sp_return_vehicle;

DROP FUNCTION IF EXISTS fn_rental_days;
DROP FUNCTION IF EXISTS fn_calculate_rental_amount;
