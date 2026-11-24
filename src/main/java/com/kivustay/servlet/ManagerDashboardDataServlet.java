package com.kivustay.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.kivustay.dao.ManagerDashboardDAO;

@WebServlet("/manager/dashboard-data")
public class ManagerDashboardDataServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);

        if (session == null) {
            sendError(response, 401, "Authentication required.");
            return;
        }

        String role = (String) session.getAttribute("role");

        if (!"MANAGER".equalsIgnoreCase(
                role == null ? "" : role)) {

            sendError(response, 403, "Manager access required.");
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Number)) {
            sendError(response, 401, "Invalid user session.");
            return;
        }

        int managerId = ((Number) userIdObject).intValue();

        if (managerId <= 0) {
            sendError(response, 401, "Invalid user session.");
            return;
        }

        try {
            ManagerDashboardDAO dao =
                    new ManagerDashboardDAO(getServletContext());

            List<Map<String, Object>> occupancy =
                    dao.getOccupancyPerHotelData(managerId);

            List<Map<String, Object>> monthlyBookings =
                    dao.getBookingsPerMonthData(managerId);

            List<Map<String, Object>> roomTypes =
                    dao.getRoomTypeShareData(managerId);

            StringBuilder json = new StringBuilder();

            json.append("{");

            json.append("\"success\":true,");

            json.append("\"occupancyPerHotel\":");
            appendOccupancy(json, occupancy);

            json.append(",\"bookingsPerMonth\":");
            appendMonthlyBookings(json, monthlyBookings);

            json.append(",\"roomTypeShare\":");
            appendRoomTypes(json, roomTypes);

            json.append("}");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(json.toString());

        } catch (SQLException exception) {

            getServletContext().log(
                    "Unable to retrieve manager dashboard chart data.",
                    exception
            );

            sendError(
                    response,
                    500,
                    "Unable to load dashboard chart data."
            );
        }
    }

    private void appendOccupancy(
            StringBuilder json,
            List<Map<String, Object>> data) {

        json.append("[");

        for (int i = 0; i < data.size(); i++) {

            Map<String, Object> item = data.get(i);

            if (i > 0) {
                json.append(",");
            }

            json.append("{");

            json.append("\"hotelName\":");
            appendString(json, item.get("hotelName"));

            json.append(",\"totalRooms\":");
            appendNumber(json, item.get("totalRooms"));

            json.append(",\"occupiedRooms\":");
            appendNumber(json, item.get("occupiedRooms"));

            json.append(",\"occupancyRate\":");
            appendNumber(json, item.get("occupancyRate"));

            json.append("}");
        }

        json.append("]");
    }

    private void appendMonthlyBookings(
            StringBuilder json,
            List<Map<String, Object>> data) {

        json.append("[");

        for (int i = 0; i < data.size(); i++) {

            Map<String, Object> item = data.get(i);

            if (i > 0) {
                json.append(",");
            }

            json.append("{");

            json.append("\"month\":");
            appendString(json, item.get("month"));

            json.append(",\"totalBookings\":");
            appendNumber(json, item.get("totalBookings"));

            json.append("}");
        }

        json.append("]");
    }

    private void appendRoomTypes(
            StringBuilder json,
            List<Map<String, Object>> data) {

        json.append("[");

        for (int i = 0; i < data.size(); i++) {

            Map<String, Object> item = data.get(i);

            if (i > 0) {
                json.append(",");
            }

            json.append("{");

            json.append("\"roomName\":");
            appendString(json, item.get("roomName"));

            json.append(",\"totalRooms\":");
            appendNumber(json, item.get("totalRooms"));

            json.append("}");
        }

        json.append("]");
    }

    private void appendString(
            StringBuilder json,
            Object value) {

        if (value == null) {
            json.append("null");
            return;
        }

        json.append("\"");

        String text = value.toString();

        for (int i = 0; i < text.length(); i++) {

            char character = text.charAt(i);

            switch (character) {

                case '"':
                    json.append("\\\"");
                    break;

                case '\\':
                    json.append("\\\\");
                    break;

                case '\b':
                    json.append("\\b");
                    break;

                case '\f':
                    json.append("\\f");
                    break;

                case '\n':
                    json.append("\\n");
                    break;

                case '\r':
                    json.append("\\r");
                    break;

                case '\t':
                    json.append("\\t");
                    break;

                default:
                    if (character < 0x20) {
                        json.append(String.format(
                                "\\u%04x",
                                (int) character
                        ));
                    } else {
                        json.append(character);
                    }
            }
        }

        json.append("\"");
    }

    private void appendNumber(
            StringBuilder json,
            Object value) {

        if (value == null) {
            json.append("null");
            return;
        }

        try {
            BigDecimal number =
                    new BigDecimal(value.toString());

            json.append(number.toPlainString());

        } catch (NumberFormatException exception) {
            json.append("null");
        }
    }

    private void sendError(
            HttpServletResponse response,
            int status,
            String message) throws IOException {

        response.setStatus(status);

        StringBuilder json = new StringBuilder();

        json.append("{\"success\":false,\"message\":");

        appendString(json, message);

        json.append("}");

        response.getWriter().write(json.toString());
    }
}