package com.kivustay.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

import com.kivustay.model.Hotel;
import com.kivustay.util.DBConnection;

import javax.servlet.ServletContext;

public class HotelDAO {

    private final ServletContext context;

    public HotelDAO(ServletContext context) {
        this.context = context;
    }

    // =========================================
    // 1. FIND ALL HOTELS BELONGING TO A MANAGER
    // =========================================

    public List<Hotel> findByManagerId(int managerId)
            throws SQLException {

        List<Hotel> hotels = new ArrayList<>();

        String sql =
                "SELECT " +
                "h.hotel_id, " +
                "h.manager_id, " +
                "h.hotel_name, " +
                "h.location, " +
                "h.description, " +
                "h.rating, " +
                "h.image_url, " +

                "COUNT(DISTINCT rt.room_type_id) AS total_room_types, " +

                "COUNT(DISTINCT r.room_id) AS total_rooms, " +

                "MIN(rt.price_per_night) AS minimum_price " +

                "FROM hotels h " +

                "LEFT JOIN room_types rt " +
                "ON h.hotel_id = rt.hotel_id " +

                "LEFT JOIN rooms r " +
                "ON rt.room_type_id = r.room_type_id " +

                "WHERE h.manager_id = ? " +

                "GROUP BY " +
                "h.hotel_id, " +
                "h.manager_id, " +
                "h.hotel_name, " +
                "h.location, " +
                "h.description, " +
                "h.rating, " +
                "h.image_url " +

                "ORDER BY h.hotel_name ASC";

        try (
            Connection connection =
                    DBConnection.getConnection(context);

            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setInt(1, managerId);

            try (ResultSet resultSet =
                    statement.executeQuery()) {

                while (resultSet.next()) {

                    Hotel hotel = mapHotel(resultSet);

                    hotels.add(hotel);
                }
            }
        }

        return hotels;
    }
 // =========================================
    // 2. MAP DATABASE RESULTS TO HOTEL MODEL
    // =========================================

    private Hotel mapHotel(ResultSet resultSet)
            throws SQLException {

        Hotel hotel = new Hotel();

        hotel.setHotelId(
                resultSet.getInt("hotel_id")
        );

        hotel.setManagerId(
                resultSet.getInt("manager_id")
        );

        hotel.setHotelName(
                resultSet.getString("hotel_name")
        );

        hotel.setLocation(
                resultSet.getString("location")
        );

        hotel.setDescription(
                resultSet.getString("description")
        );

        hotel.setRating(
                resultSet.getInt("rating")
        );

        hotel.setImageUrl(
                resultSet.getString("image_url")
        );

        hotel.setTotalRoomTypes(
                resultSet.getInt("total_room_types")
        );

        hotel.setTotalRooms(
                resultSet.getInt("total_rooms")
        );

        hotel.setMinimumPrice(
                resultSet.getBigDecimal("minimum_price")
        );

        return hotel;
    }

}