package com.kivustay.dao;

import com.kivustay.util.DBConnection;

import javax.servlet.ServletContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ManagerDashboardDAO {

    private final ServletContext context;

    public ManagerDashboardDAO(ServletContext context) {
        this.context = context;
    }

    // =========================================
    // 1. DASHBOARD SUMMARY
    // =========================================

    public Map<String, Object> getDashboardSummary(int managerId)
            throws SQLException {

        Map<String, Object> summary = new LinkedHashMap<>();

        String sql =
            "SELECT " +
            "(SELECT COUNT(*) FROM hotels " +
            " WHERE manager_id = ?) AS total_hotels, " +

            "(SELECT COUNT(*) FROM room_types rt " +
            " JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            " WHERE h.manager_id = ?) AS total_room_types, " +

            "(SELECT COUNT(*) FROM rooms r " +
            " JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            " JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            " WHERE h.manager_id = ?) AS total_rooms, " +

            "(SELECT COUNT(*) FROM rooms r " +
            " JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            " JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            " WHERE h.manager_id = ? " +
            " AND r.room_status = 'AVAILABLE') AS available_rooms, " +

            "(SELECT COUNT(*) FROM bookings b " +
            " JOIN rooms r ON b.room_id = r.room_id " +
            " JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            " JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            " WHERE h.manager_id = ?) AS total_bookings, " +

            "(SELECT COUNT(*) FROM bookings b " +
            " JOIN rooms r ON b.room_id = r.room_id " +
            " JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            " JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            " WHERE h.manager_id = ? " +
            " AND b.booking_status = 'PENDING') AS pending_bookings, " +

            "(SELECT COUNT(*) FROM bookings b " +
            " JOIN rooms r ON b.room_id = r.room_id " +
            " JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            " JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            " WHERE h.manager_id = ? " +
            " AND b.booking_status = 'CONFIRMED') AS confirmed_bookings, " +

            "(SELECT COALESCE(SUM(b.total_amount), 0) " +
            " FROM bookings b " +
            " JOIN rooms r ON b.room_id = r.room_id " +
            " JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            " JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            " WHERE h.manager_id = ? " +
            " AND b.booking_status = 'CONFIRMED') AS total_revenue";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            for (int i = 1; i <= 8; i++) {
                statement.setInt(i, managerId);
            }

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    summary.put("totalHotels",
                            result.getInt("total_hotels"));

                    summary.put("totalRoomTypes",
                            result.getInt("total_room_types"));

                    summary.put("totalRooms",
                            result.getInt("total_rooms"));

                    summary.put("availableRooms",
                            result.getInt("available_rooms"));

                    summary.put("totalBookings",
                            result.getInt("total_bookings"));

                    summary.put("pendingBookings",
                            result.getInt("pending_bookings"));

                    summary.put("confirmedBookings",
                            result.getInt("confirmed_bookings"));

                    BigDecimal revenue =
                            result.getBigDecimal("total_revenue");

                    summary.put("totalRevenue",
                            revenue == null ? BigDecimal.ZERO : revenue);
                }
            }
        }

        return summary;
    }

    // =========================================
    // 2. BOOKING STATUS CHART
    // =========================================

    public List<Map<String, Object>> getBookingStatusData(int managerId)
            throws SQLException {

        List<Map<String, Object>> data = new ArrayList<>();

        String sql =
            "SELECT b.booking_status, COUNT(*) AS total " +
            "FROM bookings b " +
            "JOIN rooms r ON b.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "GROUP BY b.booking_status " +
            "ORDER BY b.booking_status";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {
                    Map<String, Object> item =
                            new LinkedHashMap<>();

                    item.put("status",
                            result.getString("booking_status"));

                    item.put("total",
                            result.getInt("total"));

                    data.add(item);
                }
            }
        }

        return data;
    }

    // =========================================
    // 3. MONTHLY REVENUE CHART
    // =========================================

    public List<Map<String, Object>> getMonthlyRevenueData(int managerId)
            throws SQLException {

        List<Map<String, Object>> data = new ArrayList<>();

        String sql =
            "SELECT DATE_FORMAT(b.created_at, '%Y-%m') AS month, " +
            "SUM(b.total_amount) AS revenue " +
            "FROM bookings b " +
            "JOIN rooms r ON b.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "AND b.booking_status = 'CONFIRMED' " +
            "AND b.created_at >= DATE_SUB(CURDATE(), INTERVAL 5 MONTH) " +
            "GROUP BY DATE_FORMAT(b.created_at, '%Y-%m') " +
            "ORDER BY month ASC";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {
                    Map<String, Object> item =
                            new LinkedHashMap<>();

                    item.put("month",
                            result.getString("month"));

                    item.put("revenue",
                            result.getBigDecimal("revenue"));

                    data.add(item);
                }
            }
        }

        return data;
    }

    // =========================================
    // 4. ROOM STATUS CHART
    // =========================================

    public List<Map<String, Object>> getRoomStatusData(int managerId)
            throws SQLException {

        List<Map<String, Object>> data = new ArrayList<>();

        String sql =
            "SELECT r.room_status, COUNT(*) AS total " +
            "FROM rooms r " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "GROUP BY r.room_status " +
            "ORDER BY r.room_status";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {
                    Map<String, Object> item =
                            new LinkedHashMap<>();

                    item.put("status",
                            result.getString("room_status"));

                    item.put("total",
                            result.getInt("total"));

                    data.add(item);
                }
            }
        }

        return data;
    }
 // =========================================
    // 5. OCCUPANCY PER HOTEL
    // =========================================

    public List<Map<String, Object>> getOccupancyPerHotelData(
            int managerId) throws SQLException {

        List<Map<String, Object>> data = new ArrayList<>();

        String sql =
            "SELECT h.hotel_name, " +
            "COUNT(DISTINCT CASE " +
            "WHEN r.room_status = 'AVAILABLE' " +
            "THEN r.room_id END) AS total_rooms, " +

            "COUNT(DISTINCT CASE " +
            "WHEN r.room_status = 'AVAILABLE' " +
            "AND EXISTS ( " +
            "SELECT 1 FROM bookings b " +
            "WHERE b.room_id = r.room_id " +
            "AND b.booking_status = 'CONFIRMED' " +
            "AND b.check_in <= CURDATE() " +
            "AND b.check_out > CURDATE() " +
            ") THEN r.room_id END) AS occupied_rooms, " +

            "ROUND( " +
            "100.0 * COUNT(DISTINCT CASE " +
            "WHEN r.room_status = 'AVAILABLE' " +
            "AND EXISTS ( " +
            "SELECT 1 FROM bookings b " +
            "WHERE b.room_id = r.room_id " +
            "AND b.booking_status = 'CONFIRMED' " +
            "AND b.check_in <= CURDATE() " +
            "AND b.check_out > CURDATE() " +
            ") THEN r.room_id END) " +
            "/ NULLIF(COUNT(DISTINCT CASE " +
            "WHEN r.room_status = 'AVAILABLE' " +
            "THEN r.room_id END), 0), 1 " +
            ") AS occupancy_rate " +

            "FROM hotels h " +
            "LEFT JOIN room_types rt ON h.hotel_id = rt.hotel_id " +
            "LEFT JOIN rooms r ON rt.room_type_id = r.room_type_id " +
            "WHERE h.manager_id = ? " +
            "GROUP BY h.hotel_id, h.hotel_name " +
            "ORDER BY h.hotel_name";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Map<String, Object> item =
                            new LinkedHashMap<>();

                    item.put("hotelName",
                            result.getString("hotel_name"));

                    item.put("totalRooms",
                            result.getInt("total_rooms"));

                    item.put("occupiedRooms",
                            result.getInt("occupied_rooms"));

                    item.put("occupancyRate",
                            result.getBigDecimal("occupancy_rate"));

                    data.add(item);
                }
            }
        }

        return data;
    }
 // =========================================
    // 6. BOOKINGS PER MONTH
    // =========================================

    public List<Map<String, Object>> getBookingsPerMonthData(
            int managerId) throws SQLException {

        List<Map<String, Object>> data = new ArrayList<>();

        String sql =
            "SELECT DATE_FORMAT(b.created_at, '%Y-%m') AS month, " +
            "COUNT(*) AS total_bookings " +
            "FROM bookings b " +
            "JOIN rooms r ON b.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "AND b.created_at >= DATE_FORMAT( " +
            "DATE_SUB(CURDATE(), INTERVAL 5 MONTH), '%Y-%m-01') " +
            "GROUP BY DATE_FORMAT(b.created_at, '%Y-%m') " +
            "ORDER BY month ASC";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Map<String, Object> item =
                            new LinkedHashMap<>();

                    item.put("month",
                            result.getString("month"));

                    item.put("totalBookings",
                            result.getInt("total_bookings"));

                    data.add(item);
                }
            }
        }

        return data;
    }
 // =========================================
    // 7. ROOM TYPE SHARE
    // =========================================

    public List<Map<String, Object>> getRoomTypeShareData(
            int managerId) throws SQLException {

        List<Map<String, Object>> data = new ArrayList<>();

        String sql =
            "SELECT rt.room_name, " +
            "COUNT(r.room_id) AS total_rooms " +
            "FROM room_types rt " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "LEFT JOIN rooms r ON rt.room_type_id = r.room_type_id " +
            "WHERE h.manager_id = ? " +
            "GROUP BY rt.room_name " +
            "ORDER BY total_rooms DESC, rt.room_name ASC";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Map<String, Object> item =
                            new LinkedHashMap<>();

                    item.put("roomName",
                            result.getString("room_name"));

                    item.put("totalRooms",
                            result.getInt("total_rooms"));

                    data.add(item);
                }
            }
        }

        return data;
    }

    // =========================================
    // 5. RECENT BOOKINGS
    // =========================================

    public List<Map<String, Object>> getRecentBookings(
            int managerId, int limit) throws SQLException {

        List<Map<String, Object>> bookings = new ArrayList<>();

        if (limit < 1 || limit > 100) {
            limit = 10;
        }

        String sql =
            "SELECT b.booking_id, u.full_name, u.email, " +
            "h.hotel_name, r.room_number, rt.room_name, " +
            "b.check_in, b.check_out, b.number_of_guests, " +
            "b.total_amount, b.booking_status, b.created_at " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.user_id " +
            "JOIN rooms r ON b.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "ORDER BY b.created_at DESC, b.booking_id DESC " +
            "LIMIT ?";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);
            statement.setInt(2, limit);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {
                    Map<String, Object> item =
                            new LinkedHashMap<>();

                    item.put("bookingId",
                            result.getInt("booking_id"));

                    item.put("guestName",
                            result.getString("full_name"));

                    item.put("guestEmail",
                            result.getString("email"));

                    item.put("hotelName",
                            result.getString("hotel_name"));

                    item.put("roomNumber",
                            result.getString("room_number"));

                    item.put("roomName",
                            result.getString("room_name"));

                    item.put("checkIn",
                            result.getDate("check_in"));

                    item.put("checkOut",
                            result.getDate("check_out"));

                    item.put("numberOfGuests",
                            result.getInt("number_of_guests"));

                    item.put("totalAmount",
                            result.getBigDecimal("total_amount"));

                    item.put("bookingStatus",
                            result.getString("booking_status"));

                    item.put("createdAt",
                            result.getTimestamp("created_at"));

                    bookings.add(item);
                }
            }
        }

        return bookings;
    }
    public List<Map<String, Object>> getAllBookings(
            int managerId) throws SQLException {

        List<Map<String, Object>> bookings = new ArrayList<>();

        String sql =
            "SELECT b.booking_id, u.full_name, u.email, " +
            "h.hotel_name, r.room_number, rt.room_name, " +
            "b.check_in, b.check_out, b.number_of_guests, " +
            "b.total_amount, b.booking_status, b.created_at " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.user_id " +
            "JOIN rooms r ON b.room_id = r.room_id " +
            "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "ORDER BY b.created_at DESC, b.booking_id DESC";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Map<String, Object> item = new LinkedHashMap<>();

                    item.put("bookingId",
                            result.getInt("booking_id"));

                    item.put("guestName",
                            result.getString("full_name"));

                    item.put("guestEmail",
                            result.getString("email"));

                    item.put("hotelName",
                            result.getString("hotel_name"));

                    item.put("roomNumber",
                            result.getString("room_number"));

                    item.put("roomName",
                            result.getString("room_name"));

                    item.put("checkIn",
                            result.getDate("check_in"));

                    item.put("checkOut",
                            result.getDate("check_out"));

                    item.put("numberOfGuests",
                            result.getInt("number_of_guests"));

                    item.put("totalAmount",
                            result.getBigDecimal("total_amount"));

                    item.put("bookingStatus",
                            result.getString("booking_status"));

                    item.put("createdAt",
                            result.getTimestamp("created_at"));

                    bookings.add(item);
                }
            }
        }

        return bookings;
    }
}