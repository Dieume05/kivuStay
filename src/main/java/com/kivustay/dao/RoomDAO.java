package com.kivustay.dao;

import com.kivustay.model.Room;
import com.kivustay.util.DBConnection;

import javax.servlet.ServletContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    private final ServletContext context;

    public RoomDAO(ServletContext context) {
        this.context = context;
    }

    // =========================================
    // 1. FIND ALL ROOMS BELONGING TO A MANAGER
    // =========================================

    public List<Room> findByManagerId(int managerId)
            throws SQLException {

        List<Room> rooms = new ArrayList<>();

        String sql =
            "SELECT r.room_id, r.room_type_id, " +
            "r.room_number, r.room_status, " +
            "rt.room_name, rt.capacity, " +
            "rt.price_per_night, " +
            "h.hotel_id, h.hotel_name " +
            "FROM rooms r " +
            "JOIN room_types rt " +
            "ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h " +
            "ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "ORDER BY h.hotel_name, rt.room_name, r.room_number";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Room room = mapRoom(result);
                    rooms.add(room);
                }
            }
        }

        return rooms;
    }


    // =========================================
    // 2. FIND ONE ROOM BELONGING TO A MANAGER
    // =========================================

    public Room findByIdAndManagerId(
            int roomId, int managerId)
            throws SQLException {

        String sql =
            "SELECT r.room_id, r.room_type_id, " +
            "r.room_number, r.room_status, " +
            "rt.room_name, rt.capacity, " +
            "rt.price_per_night, " +
            "h.hotel_id, h.hotel_name " +
            "FROM rooms r " +
            "JOIN room_types rt " +
            "ON r.room_type_id = rt.room_type_id " +
            "JOIN hotels h " +
            "ON rt.hotel_id = h.hotel_id " +
            "WHERE r.room_id = ? " +
            "AND h.manager_id = ?";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, roomId);
            statement.setInt(2, managerId);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    return mapRoom(result);
                }
            }
        }

        return null;
    }


    // =========================================
    // 3. MAP RESULT TO ROOM OBJECT
    // =========================================

    private Room mapRoom(ResultSet result)
            throws SQLException {

        Room room = new Room();

        room.setRoomId(result.getInt("room_id"));
        room.setRoomTypeId(result.getInt("room_type_id"));
        room.setRoomNumber(result.getString("room_number"));
        room.setRoomStatus(result.getString("room_status"));

        room.setRoomName(result.getString("room_name"));
        room.setCapacity(result.getInt("capacity"));
        room.setPricePerNight(
            result.getBigDecimal("price_per_night"));

        room.setHotelId(result.getInt("hotel_id"));
        room.setHotelName(result.getString("hotel_name"));

        return room;
    }
 // =========================================
    // 3. FIND ROOM TYPES BELONGING TO A MANAGER
    // =========================================

    public List<Room> findRoomTypesByManagerId(int managerId)
            throws SQLException {

        List<Room> roomTypes = new ArrayList<>();

        String sql =
            "SELECT rt.room_type_id, rt.room_name, " +
            "rt.capacity, rt.price_per_night, " +
            "h.hotel_id, h.hotel_name " +
            "FROM room_types rt " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE h.manager_id = ? " +
            "ORDER BY h.hotel_name, rt.room_name";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, managerId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Room room = new Room();

                    room.setRoomTypeId(
                        result.getInt("room_type_id"));

                    room.setRoomName(
                        result.getString("room_name"));

                    room.setCapacity(
                        result.getInt("capacity"));

                    room.setPricePerNight(
                        result.getBigDecimal("price_per_night"));

                    room.setHotelId(
                        result.getInt("hotel_id"));

                    room.setHotelName(
                        result.getString("hotel_name"));

                    roomTypes.add(room);
                }
            }
        }

        return roomTypes;
    }
 // =========================================
    // 4. ADD A NEW ROOM
    // =========================================

    public boolean addRoom(
            int roomTypeId,
            String roomNumber,
            String roomStatus,
            int managerId)
            throws SQLException {

        if (roomTypeId <= 0 ||
                roomNumber == null ||
                roomNumber.trim().isEmpty()) {

            throw new IllegalArgumentException(
                "Please provide valid room information.");
        }

        if (!isValidRoomStatus(roomStatus)) {
            throw new IllegalArgumentException(
                "Invalid room status.");
        }

        String sql =
            "INSERT INTO rooms " +
            "(room_type_id, room_number, room_status) " +
            "SELECT rt.room_type_id, ?, ? " +
            "FROM room_types rt " +
            "JOIN hotels h ON rt.hotel_id = h.hotel_id " +
            "WHERE rt.room_type_id = ? " +
            "AND h.manager_id = ?";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setString(1, roomNumber.trim());
            statement.setString(2, roomStatus);
            statement.setInt(3, roomTypeId);
            statement.setInt(4, managerId);

            return statement.executeUpdate() == 1;
        }
    }


    // =========================================
    // 5. EDIT AN EXISTING ROOM
    // =========================================

    public boolean updateRoom(
            int roomId,
            int roomTypeId,
            String roomNumber,
            String roomStatus,
            int managerId)
            throws SQLException {

        if (roomId <= 0 ||
                roomTypeId <= 0 ||
                roomNumber == null ||
                roomNumber.trim().isEmpty()) {

            throw new IllegalArgumentException(
                "Please provide valid room information.");
        }

        if (!isValidRoomStatus(roomStatus)) {
            throw new IllegalArgumentException(
                "Invalid room status.");
        }

        String sql =
            "UPDATE rooms r " +
            "JOIN room_types old_rt " +
            "ON r.room_type_id = old_rt.room_type_id " +
            "JOIN hotels old_h " +
            "ON old_rt.hotel_id = old_h.hotel_id " +
            "JOIN room_types new_rt " +
            "ON new_rt.room_type_id = ? " +
            "JOIN hotels new_h " +
            "ON new_rt.hotel_id = new_h.hotel_id " +
            "SET r.room_type_id = new_rt.room_type_id, " +
            "r.room_number = ?, " +
            "r.room_status = ? " +
            "WHERE r.room_id = ? " +
            "AND old_h.manager_id = ? " +
            "AND new_h.manager_id = ?";

        try (Connection connection =
                 DBConnection.getConnection(context);
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, roomTypeId);
            statement.setString(2, roomNumber.trim());
            statement.setString(3, roomStatus);
            statement.setInt(4, roomId);
            statement.setInt(5, managerId);
            statement.setInt(6, managerId);

            return statement.executeUpdate() == 1;
        }
    }


    // =========================================
    // 6. VALIDATE ROOM STATUS
    // =========================================

    private boolean isValidRoomStatus(String status) {

        return "AVAILABLE".equals(status) ||
               "MAINTENANCE".equals(status) ||
               "INACTIVE".equals(status);
    }

//DELETE A ROOM
//Only if it has no booking history
public boolean deleteRoom(int roomId, int managerId)
     throws SQLException {

 if (roomId <= 0 || managerId <= 0) {
     throw new IllegalArgumentException(
         "Invalid room information.");
 }

 String sql =
     "DELETE r " +
     "FROM rooms r " +
     "JOIN room_types rt " +
     "ON r.room_type_id = rt.room_type_id " +
     "JOIN hotels h " +
     "ON rt.hotel_id = h.hotel_id " +
     "WHERE r.room_id = ? " +
     "AND h.manager_id = ? " +
     "AND NOT EXISTS (" +
         "SELECT 1 FROM bookings b " +
         "WHERE b.room_id = r.room_id" +
     ")";

 try (Connection connection =
          DBConnection.getConnection(context);
      PreparedStatement statement =
          connection.prepareStatement(sql)) {

     statement.setInt(1, roomId);
     statement.setInt(2, managerId);

     return statement.executeUpdate() == 1;
 }
}
}