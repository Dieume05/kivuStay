package com.kivustay.dao;

import com.kivustay.util.DBConnection;

import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookingCancellationDAO {

    private final ServletContext context;

    public BookingCancellationDAO(ServletContext context) {
        this.context = context;
    }

    public boolean cancelBooking(int bookingId, int userId)
            throws SQLException {

        String sql =
            "UPDATE bookings " +
            "SET booking_status = 'CANCELLED' " +
            "WHERE booking_id = ? " +
            "AND user_id = ? " +
            "AND booking_status IN ('PENDING', 'CONFIRMED') " +
            "AND check_in >= CURDATE()";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, bookingId);
            statement.setInt(2, userId);

            return statement.executeUpdate() == 1;
        }
    }
}