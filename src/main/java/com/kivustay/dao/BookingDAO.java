package com.kivustay.dao;

import com.kivustay.exception.BookingConflictException;
import com.kivustay.exception.InvalidDateRangeException;
import com.kivustay.exception.CapacityExceededException;
import com.kivustay.model.Booking;
import com.kivustay.util.DBConnection;

import javax.servlet.ServletContext;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    private final ServletContext context;

    public BookingDAO(ServletContext context) {
        this.context = context;
    }

    // =========================================
    // 1. FIND ALL BOOKINGS FOR A GUEST
    // =========================================

    public List<Booking> findByUserId(int userId)
            throws SQLException {

        List<Booking> bookings = new ArrayList<>();

        String sql =
            "SELECT b.booking_id, b.user_id, " +
            "h.hotel_name, h.location, h.image_url, " +
            "r.room_number, rt.room_name, " +
            "b.check_in, b.check_out, " +
            "b.number_of_guests, b.total_amount, " +
            "b.booking_status " +
            "FROM bookings b " +
            "JOIN rooms r ON b.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE b.user_id = ? " +
            "ORDER BY b.check_in ASC, b.booking_id DESC";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {
                    bookings.add(mapBooking(result));
                }
            }
        }

        return bookings;
    }


    // =========================================
    // 2. FIND ONE BOOKING BELONGING TO A GUEST
    // =========================================

    public Booking findByIdAndUserId(int bookingId, int userId)
            throws SQLException {

        String sql =
            "SELECT b.booking_id, b.user_id, " +
            "h.hotel_name, h.location, h.image_url, " +
            "r.room_number, rt.room_name, " +
            "b.check_in, b.check_out, " +
            "b.number_of_guests, b.total_amount, " +
            "b.booking_status " +
            "FROM bookings b " +
            "JOIN rooms r ON b.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE b.booking_id = ? AND b.user_id = ?";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, bookingId);
            statement.setInt(2, userId);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    return mapBooking(result);
                }
            }
        }

        return null;
    }


    // =========================================
    // 3. CREATE A BOOKING
    // Transactional booking operation
    // =========================================

    public int createBooking(
            int userId,
            int roomId,
            LocalDate checkIn,
            LocalDate checkOut,
            int guests,
            int maxStayDays,
            BigDecimal taxRate)
            throws SQLException,
                   BookingConflictException,
                   InvalidDateRangeException,
                   CapacityExceededException {

        // STEP 1: Validate input.
        if (userId <= 0 || roomId <= 0 ||
                checkIn == null || checkOut == null) {

            throw new IllegalArgumentException(
                "Invalid booking information.");
        }

        LocalDate today = LocalDate.now();

        if (checkIn.isBefore(today) ||
                !checkOut.isAfter(checkIn)) {

            throw new InvalidDateRangeException(
                "Please select valid booking dates.");
        }

        long nights = ChronoUnit.DAYS.between(
            checkIn, checkOut);

        if (maxStayDays < 1) {

            throw new IllegalArgumentException(
                "Invalid maximum stay configuration.");
        }

        if (nights > maxStayDays) {

            throw new InvalidDateRangeException(
                "The maximum permitted stay is "
                + maxStayDays + " days.");
        }

        if (guests < 1) {

            throw new IllegalArgumentException(
                "At least one guest is required.");
        }

        if (taxRate == null ||
                taxRate.compareTo(BigDecimal.ZERO) < 0 ||
                taxRate.compareTo(BigDecimal.ONE) > 0) {

            throw new IllegalArgumentException(
                "Invalid tax configuration.");
        }


        // SQL statements.
        String roomSql =
            "SELECT r.room_status, rt.capacity, " +
            "rt.price_per_night " +
            "FROM rooms r " +
            "JOIN room_types rt " +
            "ON r.room_type_id = rt.room_type_id " +
            "WHERE r.room_id = ? FOR UPDATE";

        String conflictSql =
            "SELECT booking_id FROM bookings " +
            "WHERE room_id = ? " +
            "AND booking_status IN ('PENDING', 'CONFIRMED') " +
            "AND check_in < ? " +
            "AND check_out > ? " +
            "LIMIT 1";

        String insertSql =
            "INSERT INTO bookings " +
            "(user_id, room_id, check_in, check_out, " +
            "number_of_guests, total_amount) " +
            "VALUES (?, ?, ?, ?, ?, ?)";


        try (Connection connection =
                 DBConnection.getConnection(context)) {

            connection.setAutoCommit(false);

            try {

                // STEP 2: Lock the selected room.
                BigDecimal pricePerNight;
                int capacity;
                String roomStatus;

                try (PreparedStatement statement =
                         connection.prepareStatement(roomSql)) {

                    statement.setInt(1, roomId);

                    try (ResultSet result =
                             statement.executeQuery()) {

                        if (!result.next()) {

                            throw new BookingConflictException(
                                "The selected room no longer exists.");
                        }

                        roomStatus =
                            result.getString("room_status");

                        capacity =
                            result.getInt("capacity");

                        pricePerNight =
                            result.getBigDecimal("price_per_night");
                    }
                }


                // STEP 3: Verify room availability.
                if (!"AVAILABLE".equals(roomStatus)) {

                    throw new BookingConflictException(
                        "This room is currently unavailable.");
                }

                if (guests > capacity) {

                    throw new CapacityExceededException(
                        "This room can accommodate only "
                        + capacity + " guests.");
                }

                if (pricePerNight == null ||
                        pricePerNight.compareTo(BigDecimal.ZERO) < 0) {

                    throw new SQLException(
                        "Invalid room price configuration.");
                }


                // STEP 4: Check overlapping bookings.
                try (PreparedStatement statement =
                         connection.prepareStatement(conflictSql)) {

                    statement.setInt(1, roomId);

                    statement.setDate(
                        2, java.sql.Date.valueOf(checkOut));

                    statement.setDate(
                        3, java.sql.Date.valueOf(checkIn));

                    try (ResultSet result =
                             statement.executeQuery()) {

                        if (result.next()) {

                            throw new BookingConflictException(
                                "This room has already been booked "
                                + "for the selected dates.");
                        }
                    }
                }


                // STEP 5: Calculate the total amount.
                BigDecimal subtotal =
                    pricePerNight.multiply(
                        BigDecimal.valueOf(nights));

                BigDecimal taxAmount =
                    subtotal.multiply(taxRate);

                BigDecimal totalAmount =
                    subtotal.add(taxAmount)
                            .setScale(2, RoundingMode.HALF_UP);


                // STEP 6: Insert the booking.
                int bookingId;

                try (PreparedStatement statement =
                         connection.prepareStatement(
                             insertSql,
                             Statement.RETURN_GENERATED_KEYS)) {

                    statement.setInt(1, userId);
                    statement.setInt(2, roomId);

                    statement.setDate(
                        3, java.sql.Date.valueOf(checkIn));

                    statement.setDate(
                        4, java.sql.Date.valueOf(checkOut));

                    statement.setInt(5, guests);

                    statement.setBigDecimal(
                        6, totalAmount);

                    int affectedRows =
                        statement.executeUpdate();

                    if (affectedRows != 1) {

                        throw new SQLException(
                            "Booking could not be created.");
                    }

                    try (ResultSet keys =
                             statement.getGeneratedKeys()) {

                        if (!keys.next()) {

                            throw new SQLException(
                                "Booking ID was not generated.");
                        }

                        bookingId = keys.getInt(1);
                    }
                }


                // STEP 7: Commit transaction.
                connection.commit();

                return bookingId;
            } catch (SQLException |
                    BookingConflictException |
                    CapacityExceededException |
                    RuntimeException exception) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    exception.addSuppressed(rollbackError);
                }

                throw exception;
            }
        }
    }


    // =========================================
    // 4. MAP DATABASE RESULT TO BOOKING OBJECT
    // =========================================

    private Booking mapBooking(ResultSet result)
            throws SQLException {

        Booking booking = new Booking();

        booking.setBookingId(
            result.getInt("booking_id"));

        booking.setUserId(
            result.getInt("user_id"));

        booking.setHotelName(
            result.getString("hotel_name"));

        booking.setLocation(
            result.getString("location"));

        booking.setImageUrl(
            result.getString("image_url"));

        booking.setRoomNumber(
            result.getString("room_number"));

        booking.setRoomName(
            result.getString("room_name"));

        booking.setCheckIn(
            result.getDate("check_in"));

        booking.setCheckOut(
            result.getDate("check_out"));

        booking.setNumberOfGuests(
            result.getInt("number_of_guests"));

        booking.setTotalAmount(
            result.getBigDecimal("total_amount"));

        booking.setBookingStatus(
            result.getString("booking_status"));

        return booking;
    }
}