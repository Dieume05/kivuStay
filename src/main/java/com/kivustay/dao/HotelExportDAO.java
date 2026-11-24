package com.kivustay.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import com.kivustay.util.DBConnection;

public class HotelExportDAO {

    private final ServletContext context;

    public HotelExportDAO(ServletContext context) {
        this.context = context;
    }

    public List<Map<String, Object>> getHotelsForExport()
            throws SQLException {

        List<Map<String, Object>> hotels = new ArrayList<>();

        String sql =
            "SELECT hotel_id, hotel_name, location, description, " +
            "rating, image_url " +
            "FROM hotels " +
            "ORDER BY location, hotel_name";

        try (Connection connection =
                    DBConnection.getConnection(context);
             PreparedStatement statement =
                    connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Map<String, Object> hotel =
                        new LinkedHashMap<>();

                hotel.put("hotelId", result.getInt("hotel_id"));
                hotel.put("hotelName", result.getString("hotel_name"));
                hotel.put("location", result.getString("location"));
                hotel.put("description", result.getString("description"));
                hotel.put("rating", result.getBigDecimal("rating"));
                hotel.put("imageUrl", result.getString("image_url"));

                int hotelId = result.getInt("hotel_id");

                hotel.put("amenities", getAmenities(connection, hotelId));
                hotel.put("rooms", getRooms(connection, hotelId));

                hotels.add(hotel);
            }
        }

        return hotels;
    }
    private List<String> getAmenities(
            Connection connection, int hotelId)
            throws SQLException {

        List<String> amenities = new ArrayList<>();

        String sql =
            "SELECT a.amenity_name " +
            "FROM amenities a " +
            "JOIN hotel_amenities ha " +
            "ON a.amenity_id = ha.amenity_id " +
            "WHERE ha.hotel_id = ? " +
            "ORDER BY a.amenity_name";

        try (PreparedStatement statement =
                    connection.prepareStatement(sql)) {

            statement.setInt(1, hotelId);

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    amenities.add(result.getString("amenity_name"));
                }
            }
        }

        return amenities;
    }

    private List<Map<String, Object>> getRooms(
            Connection connection, int hotelId)
            throws SQLException {

        List<Map<String, Object>> rooms = new ArrayList<>();

        String sql =
            "SELECT r.room_id, r.room_number, r.room_status, " +
            "rt.room_name, rt.capacity, rt.price_per_night " +
            "FROM rooms r " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "WHERE rt.hotel_id = ? " +
            "ORDER BY rt.room_name, r.room_number";

        try (PreparedStatement statement =
                    connection.prepareStatement(sql)) {

            statement.setInt(1, hotelId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Map<String, Object> room =
                            new LinkedHashMap<>();

                    int roomId = result.getInt("room_id");

                    room.put("roomId", roomId);
                    room.put("roomNumber", result.getString("room_number"));
                    room.put("roomStatus", result.getString("room_status"));
                    room.put("roomType", result.getString("room_name"));
                    room.put("capacity", result.getInt("capacity"));
                    room.put("pricePerNight",
                            result.getBigDecimal("price_per_night"));

                    room.put("bookings",
                            getBookings(connection, roomId));

                    rooms.add(room);
                }
            }
        }

        return rooms;
    }

    private List<Map<String, Object>> getBookings(
            Connection connection, int roomId)
            throws SQLException {

        List<Map<String, Object>> bookings = new ArrayList<>();

        String sql =
            "SELECT booking_id, check_in, check_out, " +
            "number_of_guests, booking_status " +
            "FROM bookings " +
            "WHERE room_id = ? " +
            "ORDER BY check_in";

        try (PreparedStatement statement =
                    connection.prepareStatement(sql)) {

            statement.setInt(1, roomId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Map<String, Object> booking =
                            new LinkedHashMap<>();

                    booking.put("bookingId",
                            result.getInt("booking_id"));

                    booking.put("checkIn",
                            result.getDate("check_in"));

                    booking.put("checkOut",
                            result.getDate("check_out"));

                    booking.put("numberOfGuests",
                            result.getInt("number_of_guests"));

                    booking.put("status",
                            result.getString("booking_status"));

                    bookings.add(booking);
                }
            }
        }

        return bookings;
    }
}