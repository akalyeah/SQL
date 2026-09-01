USE vehicle_rental_management;

INSERT INTO vehicle_types (type_name, daily_rate, seats) VALUES
('Hatchback', 1500.00, 5),
('Sedan', 2200.00, 5),
('SUV', 3200.00, 7),
('Luxury', 5500.00, 5);

INSERT INTO branches (branch_name, city, phone) VALUES
('Central Branch','Chennai','04440010001'),
('Airport Branch','Chennai','04440010002'),
('Gandhipuram Branch','Coimbatore','04224001001'),
('RS Puram Branch','Coimbatore','04224001002');

INSERT INTO customers (first_name,last_name,email,phone,driving_license_no,registration_date,status) VALUES
('Arun','Kumar','arun.kumar@example.com','9000000001','TN01DL1001','2026-01-10','ACTIVE'),
('Priya','Sharma','priya.sharma@example.com','9000000002','TN02DL1002','2026-01-15','ACTIVE'),
('Rahul','Menon','rahul.menon@example.com','9000000003','TN03DL1003','2026-02-02','ACTIVE'),
('Meena','Ravi','meena.ravi@example.com','9000000004','TN04DL1004','2026-02-18','ACTIVE'),
('Karthik','S','karthik.s@example.com','9000000005','TN05DL1005','2026-03-01','SUSPENDED'),
('Divya','Raj','divya.raj@example.com','9000000006','TN06DL1006','2026-03-12','ACTIVE'),
('Vikram','Das','vikram.das@example.com','9000000007','TN07DL1007','2026-03-22','ACTIVE'),
('Nisha','Thomas','nisha.thomas@example.com','9000000008','TN08DL1008','2026-04-05','ACTIVE');

INSERT INTO employees (branch_id,first_name,last_name,role_name,email) VALUES
(1,'Anand','K','Branch Manager','anand.k@example.com'),
(1,'Sowmya','P','Rental Executive','sowmya.p@example.com'),
(2,'Hari','M','Rental Executive','hari.m@example.com'),
(3,'Ramesh','V','Branch Manager','ramesh.v@example.com'),
(3,'Keerthi','N','Rental Executive','keerthi.n@example.com'),
(4,'Sanjay','R','Rental Executive','sanjay.r@example.com');

INSERT INTO vehicles (vehicle_type_id,branch_id,registration_no,make,model,model_year,color,status,odometer_km) VALUES
(1,1,'TN01AB1001','Maruti','Swift',2024,'White','AVAILABLE',18200),
(1,1,'TN01AB1002','Hyundai','i20',2023,'Blue','AVAILABLE',23100),
(2,1,'TN01CD2001','Honda','City',2024,'Grey','AVAILABLE',14500),
(2,2,'TN02CD2002','Hyundai','Verna',2025,'Black','AVAILABLE',9800),
(3,2,'TN02EF3001','Toyota','Innova',2024,'White','AVAILABLE',19800),
(3,3,'TN37EF3002','Kia','Carens',2025,'Silver','AVAILABLE',7600),
(4,3,'TN37GH4001','BMW','3 Series',2023,'Black','MAINTENANCE',31200),
(2,4,'TN38CD2003','Skoda','Slavia',2024,'Red','AVAILABLE',11200),
(3,4,'TN38EF3003','Mahindra','XUV700',2025,'Blue','AVAILABLE',6400),
(1,2,'TN02AB1003','Tata','Altroz',2024,'Grey','AVAILABLE',15400);

INSERT INTO bookings (customer_id,vehicle_id,pickup_branch_id,return_branch_id,booking_date,planned_pickup_date,planned_return_date,status,quoted_amount) VALUES
(1,1,1,1,'2026-05-01 10:00:00','2026-05-03','2026-05-06','COMPLETED',4500),
(2,3,1,2,'2026-05-04 11:30:00','2026-05-07','2026-05-10','COMPLETED',6600),
(3,5,2,2,'2026-05-09 09:00:00','2026-05-12','2026-05-15','COMPLETED',9600),
(4,6,3,4,'2026-05-12 14:00:00','2026-05-16','2026-05-20','COMPLETED',12800),
(6,8,4,4,'2026-05-15 16:00:00','2026-05-18','2026-05-21','COMPLETED',6600),
(7,10,2,1,'2026-05-20 12:00:00','2026-05-24','2026-05-26','COMPLETED',3000),
(8,2,1,1,'2026-06-01 09:00:00','2026-06-04','2026-06-07','COMPLETED',4500),
(1,4,2,2,'2026-06-05 13:00:00','2026-06-08','2026-06-11','COMPLETED',6600),
(2,9,4,3,'2026-06-10 10:00:00','2026-06-13','2026-06-17','COMPLETED',12800),
(3,3,1,1,'2026-06-14 15:00:00','2026-06-20','2026-06-22','CONFIRMED',4400),
(4,5,2,2,'2026-06-16 10:30:00','2026-06-24','2026-06-27','CONFIRMED',9600),
(6,8,4,4,'2026-06-20 09:15:00','2026-07-01','2026-07-04','PENDING',6600);

INSERT INTO rentals
(booking_id,customer_id,vehicle_id,employee_id,pickup_datetime,expected_return_datetime,actual_return_datetime,start_odometer_km,end_odometer_km,rental_status,base_amount,late_fee,damage_fee,discount_amount,total_amount)
VALUES
(1,1,1,2,'2026-05-03 09:00:00','2026-05-06 09:00:00','2026-05-06 08:30:00',17000,17350,'RETURNED',4500,0,0,0,4500),
(2,2,3,2,'2026-05-07 10:00:00','2026-05-10 10:00:00','2026-05-10 12:00:00',13000,13420,'RETURNED',6600,500,0,300,6800),
(3,3,5,3,'2026-05-12 08:00:00','2026-05-15 08:00:00','2026-05-15 07:45:00',18300,18780,'RETURNED',9600,0,0,500,9100),
(4,4,6,5,'2026-05-16 11:00:00','2026-05-20 11:00:00','2026-05-20 12:30:00',7000,7580,'RETURNED',12800,700,1200,0,14700),
(5,6,8,6,'2026-05-18 09:30:00','2026-05-21 09:30:00','2026-05-21 09:00:00',10100,10450,'RETURNED',6600,0,0,600,6000),
(6,7,10,3,'2026-05-24 10:00:00','2026-05-26 10:00:00','2026-05-26 10:00:00',14900,15180,'RETURNED',3000,0,0,0,3000),
(7,8,2,2,'2026-06-04 09:00:00','2026-06-07 09:00:00','2026-06-07 09:15:00',22100,22460,'RETURNED',4500,200,0,0,4700),
(8,1,4,3,'2026-06-08 10:00:00','2026-06-11 10:00:00','2026-06-11 09:50:00',9000,9380,'RETURNED',6600,0,0,300,6300),
(9,2,9,6,'2026-06-13 08:30:00','2026-06-17 08:30:00','2026-06-17 11:00:00',6000,6580,'RETURNED',12800,900,0,800,12900),
(10,3,3,2,'2026-06-20 09:00:00','2026-06-22 09:00:00',NULL,13420,NULL,'ACTIVE',4400,0,0,0,4400);

INSERT INTO payments (rental_id,payment_date,amount,payment_method,payment_status,transaction_reference) VALUES
(1,'2026-05-03 08:50:00',4500,'UPI','SUCCESS','TXN10001'),
(2,'2026-05-07 09:50:00',6800,'CARD','SUCCESS','TXN10002'),
(3,'2026-05-12 07:50:00',9100,'CARD','SUCCESS','TXN10003'),
(4,'2026-05-16 10:45:00',10000,'BANK_TRANSFER','SUCCESS','TXN10004'),
(4,'2026-05-20 13:00:00',4700,'UPI','SUCCESS','TXN10005'),
(5,'2026-05-18 09:15:00',6000,'UPI','SUCCESS','TXN10006'),
(6,'2026-05-24 09:45:00',3000,'CASH','SUCCESS','TXN10007'),
(7,'2026-06-04 08:50:00',4700,'CARD','SUCCESS','TXN10008'),
(8,'2026-06-08 09:45:00',6300,'UPI','SUCCESS','TXN10009'),
(9,'2026-06-13 08:00:00',12900,'CARD','SUCCESS','TXN10010'),
(10,'2026-06-20 08:30:00',2000,'UPI','SUCCESS','TXN10011');

INSERT INTO maintenance (vehicle_id,maintenance_type,start_date,end_date,description,cost,status) VALUES
(7,'SERVICE','2026-05-02','2026-05-04','Scheduled annual service',8500,'COMPLETED'),
(3,'INSPECTION','2026-05-11','2026-05-11','Pre-rental inspection',500,'COMPLETED'),
(6,'TYRE','2026-05-22','2026-05-23','Replacement of two tyres',12000,'COMPLETED'),
(5,'SERVICE','2026-06-02','2026-06-03','Engine and brake service',7200,'COMPLETED'),
(4,'INSPECTION','2026-06-07','2026-06-07','Pre-rental inspection',500,'COMPLETED'),
(9,'REPAIR','2026-06-18',NULL,'Body panel repair',15000,'OPEN');
