USE kivustay;

-- =========================================
-- 1. USERS
-- =========================================

INSERT INTO users (full_name, email, password_hash, role)
VALUES
('Jean Pierre', 'jean.manager@kivustay.com', 'TEMP_HASH_MANAGER_1', 'MANAGER'),
('Marie Claire', 'marie.manager@kivustay.com', 'TEMP_HASH_MANAGER_2', 'MANAGER'),
('Patrick', 'patrick.manager@kivustay.com', 'TEMP_HASH_MANAGER_3', 'MANAGER'),
('David', 'david.guest@kivustay.com', 'TEMP_HASH_GUEST_1', 'GUEST'),
('Sarah', 'sarah.guest@kivustay.com', 'TEMP_HASH_GUEST_2', 'GUEST'),
('Emmanuel', 'emmanuel.guest@kivustay.com', 'TEMP_HASH_GUEST_3', 'GUEST');


-- =========================================
-- 2. HOTELS
-- =========================================

INSERT INTO hotels (manager_id, hotel_name, location, rating)
VALUES
(1, 'Lake View Resort', 'Goma', 4.5),
(1, 'Kivu Paradise Hotel', 'Gisenyi', 4.2),
(2, 'Serenity Lakeside Lodge', 'Kibuye', 4.7),
(2, 'Mountain Breeze Hotel', 'Rubavu', 4.0),
(3, 'Sunset Beach Resort', 'Sake', 4.3),
(3, 'Green Hills Retreat', 'Kibuye', 4.6);


-- =========================================
-- 3. AMENITIES
-- =========================================

INSERT INTO amenities (amenity_name)
VALUES
('Free Wi-Fi'),
('Swimming Pool'),
('Restaurant'),
('Free Parking'),
('Lake View'),
('Airport Shuttle'),
('Spa'),
('Room Service');


-- =========================================
-- 4. HOTEL AMENITIES
-- =========================================

INSERT INTO hotel_amenities (hotel_id, amenity_id)
VALUES
(1,1), (1,2), (1,3), (1,5),
(2,1), (2,3), (2,4), (2,6),
(3,1), (3,2), (3,5), (3,7),
(4,1), (4,3), (4,4), (4,8),
(5,1), (5,2), (5,3), (5,5),
(6,1), (6,4), (6,5), (6,7);


-- =========================================
-- 5. ROOM TYPES
-- =========================================

INSERT INTO room_types
(hotel_id, room_name, description, capacity, price_per_night)
VALUES

-- Hotel 1
(1, 'STANDARD', 'Comfortable standard room', 2, 45.00),
(1, 'DELUXE', 'Deluxe room with lake views', 2, 75.00),
(1, 'SUITE', 'Luxury suite with a private balcony', 4, 120.00),

-- Hotel 2
(2, 'STANDARD', 'Simple and comfortable room', 2, 40.00),
(2, 'DELUXE', 'Spacious room with modern facilities', 3, 70.00),
(2, 'FAMILY', 'Family room for a relaxing stay', 5, 110.00),

-- Hotel 3
(3, 'STANDARD', 'Cozy room near the lake', 2, 50.00),
(3, 'DELUXE', 'Premium room with lake views', 3, 85.00),
(3, 'SUITE', 'Luxury lakeside suite', 4, 140.00),

-- Hotel 4
(4, 'STANDARD', 'Affordable mountain-view room', 2, 35.00),
(4, 'DELUXE', 'Deluxe room with mountain views', 3, 65.00),
(4, 'FAMILY', 'Spacious family accommodation', 5, 100.00),

-- Hotel 5
(5, 'STANDARD', 'Comfortable beachside room', 2, 45.00),
(5, 'DELUXE', 'Deluxe room near the beach', 3, 80.00),
(5, 'SUITE', 'Premium suite with beach views', 4, 130.00),

-- Hotel 6
(6, 'STANDARD', 'Peaceful standard room', 2, 42.00),
(6, 'DELUXE', 'Deluxe room surrounded by nature', 3, 78.00),
(6, 'FAMILY', 'Large room suitable for families', 5, 115.00);


-- =========================================
-- 6. PHYSICAL ROOMS
-- =========================================

INSERT INTO rooms (room_type_id, room_number, room_status)
VALUES
-- Hotel 1
(1,'101','AVAILABLE'),
(1,'102','AVAILABLE'),
(2,'201','AVAILABLE'),
(2,'202','AVAILABLE'),
(3,'301','AVAILABLE'),

-- Hotel 2
(4,'101','AVAILABLE'),
(4,'102','AVAILABLE'),
(5,'201','AVAILABLE'),
(5,'202','AVAILABLE'),
(6,'301','AVAILABLE'),

-- Hotel 3
(7,'101','AVAILABLE'),
(7,'102','AVAILABLE'),
(8,'201','AVAILABLE'),
(8,'202','AVAILABLE'),
(9,'301','AVAILABLE'),

-- Hotel 4
(10,'101','AVAILABLE'),
(10,'102','AVAILABLE'),
(11,'201','AVAILABLE'),
(11,'202','AVAILABLE'),
(12,'301','AVAILABLE'),

-- Hotel 5
(13,'101','AVAILABLE'),
(13,'102','AVAILABLE'),
(14,'201','AVAILABLE'),
(14,'202','AVAILABLE'),
(15,'301','AVAILABLE'),

-- Hotel 6
(16,'101','AVAILABLE'),
(16,'102','AVAILABLE'),
(17,'201','AVAILABLE'),
(17,'202','AVAILABLE'),
(18,'301','AVAILABLE');


-- =========================================
-- 7. SAMPLE BOOKINGS
-- =========================================

INSERT INTO bookings
(user_id, room_id, check_in, check_out,
 number_of_guests, total_amount, booking_status)
VALUES

-- Booking 1
(
 (SELECT user_id FROM users WHERE email='david.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Lake View Resort' AND r.room_number='101'),
 '2026-12-01','2026-12-03',2,90.00,'CONFIRMED'
),

-- Booking 2
(
 (SELECT user_id FROM users WHERE email='sarah.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Lake View Resort' AND r.room_number='102'),
 '2026-12-05','2026-12-08',2,135.00,'CONFIRMED'
),

-- Booking 3
(
 (SELECT user_id FROM users WHERE email='emmanuel.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Lake View Resort' AND r.room_number='201'),
 '2026-12-10','2026-12-12',2,150.00,'PENDING'
),

-- Booking 4
(
 (SELECT user_id FROM users WHERE email='david.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Lake View Resort' AND r.room_number='202'),
 '2026-12-15','2026-12-18',2,225.00,'CONFIRMED'
),

-- Booking 5
(
 (SELECT user_id FROM users WHERE email='sarah.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Lake View Resort' AND r.room_number='301'),
 '2026-12-02','2026-12-04',4,240.00,'CONFIRMED'
),

-- Booking 6
(
 (SELECT user_id FROM users WHERE email='emmanuel.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Kivu Paradise Hotel' AND r.room_number='101'),
 '2026-12-06','2026-12-09',2,120.00,'CONFIRMED'
),

-- Booking 7
(
 (SELECT user_id FROM users WHERE email='david.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Kivu Paradise Hotel' AND r.room_number='102'),
 '2026-12-12','2026-12-14',2,80.00,'PENDING'
),

-- Booking 8
(
 (SELECT user_id FROM users WHERE email='sarah.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Kivu Paradise Hotel' AND r.room_number='201'),
 '2026-12-16','2026-12-19',3,210.00,'CONFIRMED'
),

-- Booking 9
(
 (SELECT user_id FROM users WHERE email='emmanuel.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Kivu Paradise Hotel' AND r.room_number='202'),
 '2026-12-03','2026-12-05',2,140.00,'CONFIRMED'
),

-- Booking 10
(
 (SELECT user_id FROM users WHERE email='david.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Kivu Paradise Hotel' AND r.room_number='301'),
 '2026-12-07','2026-12-10',5,330.00,'CONFIRMED'
),

-- Booking 11
(
 (SELECT user_id FROM users WHERE email='sarah.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Serenity Lakeside Lodge' AND r.room_number='101'),
 '2026-12-11','2026-12-13',2,100.00,'PENDING'
),

-- Booking 12
(
 (SELECT user_id FROM users WHERE email='emmanuel.guest@kivustay.com'),
 (SELECT r.room_id FROM rooms r
  JOIN room_types rt ON r.room_type_id=rt.room_type_id
  JOIN hotels h ON rt.hotel_id=h.hotel_id
  WHERE h.hotel_name='Serenity Lakeside Lodge' AND r.room_number='102'),
 '2026-12-20','2026-12-23',2,150.00,'CONFIRMED'
);