-- =====================================================
-- KivuStay Database Schema
-- CSE402 FAT Project
-- MySQL 8.x
-- =====================================================

CREATE DATABASE IF NOT EXISTS kivustay;
USE kivustay;

-- =====================================================
-- 1. USERS
-- =====================================================

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('GUEST', 'MANAGER') NOT NULL DEFAULT 'GUEST',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. HOTELS
-- =====================================================

CREATE TABLE hotels (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    manager_id INT NOT NULL,
    hotel_name VARCHAR(150) NOT NULL,
    description TEXT,
    location VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    rating DECIMAL(2,1) NOT NULL DEFAULT 1.0,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_hotel_rating
        CHECK (rating >= 1.0 AND rating <= 5.0),

    CONSTRAINT fk_hotel_manager
        FOREIGN KEY (manager_id)
        REFERENCES users(user_id)
);

-- =====================================================
-- 3. AMENITIES
-- =====================================================

CREATE TABLE amenities (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,
    amenity_name VARCHAR(100) NOT NULL UNIQUE
);

-- =====================================================
-- 4. HOTEL_AMENITIES
-- Many-to-many relationship
-- =====================================================

CREATE TABLE hotel_amenities (
    hotel_id INT NOT NULL,
    amenity_id INT NOT NULL,

    PRIMARY KEY (hotel_id, amenity_id),

    CONSTRAINT fk_ha_hotel
        FOREIGN KEY (hotel_id)
        REFERENCES hotels(hotel_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_ha_amenity
        FOREIGN KEY (amenity_id)
        REFERENCES amenities(amenity_id)
        ON DELETE CASCADE
);

-- =====================================================
-- 5. ROOM TYPES
-- =====================================================

CREATE TABLE room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    room_name VARCHAR(100) NOT NULL,
    description TEXT,
    capacity INT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_room_capacity
        CHECK (capacity > 0),

    CONSTRAINT chk_room_price
        CHECK (price_per_night >= 0),

    CONSTRAINT fk_room_type_hotel
        FOREIGN KEY (hotel_id)
        REFERENCES hotels(hotel_id)
        ON DELETE CASCADE
);

-- =====================================================
-- 6. ROOMS
-- Individual physical rooms in a hotel
-- =====================================================

CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type_id INT NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    room_status ENUM(
        'AVAILABLE',
        'MAINTENANCE',
        'INACTIVE'
    ) NOT NULL DEFAULT 'AVAILABLE',

    CONSTRAINT uq_room_number
        UNIQUE (room_type_id, room_number),

    CONSTRAINT fk_room_type
        FOREIGN KEY (room_type_id)
        REFERENCES room_types(room_type_id)
        ON DELETE CASCADE
);

-- =====================================================
-- 7. BOOKINGS
-- =====================================================

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    number_of_guests INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status ENUM(
        'PENDING',
        'CONFIRMED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_booking_dates
        CHECK (check_out > check_in),

    CONSTRAINT chk_booking_guests
        CHECK (number_of_guests > 0),

    CONSTRAINT chk_booking_amount
        CHECK (total_amount >= 0),

    CONSTRAINT fk_booking_user
        FOREIGN KEY (user_id)
        REFERENCES users(user_id),

    CONSTRAINT fk_booking_individual_room
        FOREIGN KEY (room_id)
        REFERENCES rooms(room_id)
);

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_booking_room_dates
ON bookings(room_id, check_in, check_out);

-- =====================================================
-- END OF KIVUSTAY SCHEMA
-- =====================================================