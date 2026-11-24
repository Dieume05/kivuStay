package com.kivustay.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;

import javax.servlet.ServletContext;

import com.kivustay.util.DBConnection;

public class AvailabilityDAO {

    public boolean isRoomAvailable(
            ServletContext context,
            int roomId,
            Date checkIn,
            Date checkOut,
            int guests) throws SQLException {

        String sql =
            "SELECT COUNT(*) " +
            "FROM rooms r " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "WHERE r.room_id = ? " +
            "AND r.room_status = 'AVAILABLE' " +
            "AND rt.capacity >= ? " +
            "AND NOT EXISTS ( " +
            "SELECT 1 FROM bookings b " +
            "WHERE b.room_id = r.room_id " +
            "AND b.booking_status IN ('PENDING', 'CONFIRMED') " +
            "AND b.check_in < ? " +
            "AND b.check_out > ? " +
            ")";

        try (Connection connection =
                    DBConnection.getConnection(context);

             PreparedStatement statement =
                    connection.prepareStatement(sql)) {

            statement.setInt(1, roomId);
            statement.setInt(2, guests);
            statement.setDate(3, checkOut);
            statement.setDate(4, checkIn);

            try (ResultSet rs = statement.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }
}