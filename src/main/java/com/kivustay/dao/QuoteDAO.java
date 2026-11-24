package com.kivustay.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletContext;

import com.kivustay.util.DBConnection;

public class QuoteDAO {

    public BigDecimal findPricePerNight(
            ServletContext context, int roomId) throws SQLException {

        String sql =
            "SELECT rt.price_per_night " +
            "FROM rooms r " +
            "JOIN room_types rt " +
            "ON r.room_type_id = rt.room_type_id " +
            "WHERE r.room_id = ?";

        try (Connection connection =
                    DBConnection.getConnection(context);
             PreparedStatement statement =
                    connection.prepareStatement(sql)) {

            statement.setInt(1, roomId);

            try (ResultSet rs = statement.executeQuery()) {

                if (rs.next()) {
                    return rs.getBigDecimal("price_per_night");
                }
            }
        }

        return null;
    }
}