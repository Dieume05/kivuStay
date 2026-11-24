package com.kivustay.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import com.kivustay.model.SearchResult;
import com.kivustay.util.DBConnection;

import javax.servlet.ServletContext;

public class SearchDAO {

    public List<SearchResult> searchAvailableRooms(
            ServletContext context,
            String location,
            Date checkIn,
            Date checkOut,
            int guests) throws SQLException {

        List<SearchResult> results = new ArrayList<>();

        String sql =
            "SELECT h.hotel_id, h.hotel_name, h.location, " +
            "h.description, h.image_url, h.rating, " +
            "rt.room_type_id, rt.room_name, rt.capacity, " +
            "rt.price_per_night, " +
            "r.room_id, r.room_number " +
            "FROM hotels h " +
            "JOIN room_types rt ON h.hotel_id = rt.hotel_id " +
            "JOIN rooms r ON rt.room_type_id = r.room_type_id " +
            "WHERE r.room_status = 'AVAILABLE' " +
            "AND rt.capacity >= ? " +
            "AND (? IS NULL OR h.location LIKE ?) " +
            "AND NOT EXISTS ( " +
            "SELECT 1 FROM bookings b " +
            "WHERE b.room_id = r.room_id " +
            "AND b.booking_status IN ('PENDING', 'CONFIRMED') " +
            "AND b.check_in < ? " +
            "AND b.check_out > ? " +
            ") " +
            "ORDER BY h.rating DESC, rt.price_per_night ASC";

        try (Connection connection =
                    DBConnection.getConnection(context);

             PreparedStatement statement =
                    connection.prepareStatement(sql)) {

            statement.setInt(1, guests);

            if (location == null || location.trim().isEmpty()) {
                statement.setNull(2, java.sql.Types.VARCHAR);
                statement.setNull(3, java.sql.Types.VARCHAR);
            } else {
                statement.setString(2, location.trim());
                statement.setString(
                    3, "%" + location.trim() + "%"
                );
            }

            statement.setDate(4, checkOut);
            statement.setDate(5, checkIn);

            try (ResultSet rs = statement.executeQuery()) {

                while (rs.next()) {

                    SearchResult result = new SearchResult();

                    result.setHotelId(rs.getInt("hotel_id"));
                    result.setHotelName(rs.getString("hotel_name"));
                    result.setLocation(rs.getString("location"));
                    result.setDescription(rs.getString("description"));
                    result.setImageUrl(rs.getString("image_url"));
                    result.setRating(rs.getDouble("rating"));

                    result.setRoomId(rs.getInt("room_id"));
                    result.setRoomNumber(rs.getString("room_number"));
                    result.setRoomName(rs.getString("room_name"));
                    result.setCapacity(rs.getInt("capacity"));
                    result.setPricePerNight(
                        rs.getBigDecimal("price_per_night")
                    );

                    results.add(result);
                }
            }
        }

        return results;
    }
}