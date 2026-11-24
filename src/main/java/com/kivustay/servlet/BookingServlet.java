package com.kivustay.servlet;

import com.kivustay.dao.BookingDAO;
import com.kivustay.exception.BookingConflictException;
import com.kivustay.exception.InvalidDateRangeException;
import com.kivustay.exception.CapacityExceededException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

@WebServlet("/guest/book")
public class BookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO(getServletContext());
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader(
            "Cache-Control",
            "no-store, no-cache, must-revalidate, private"
        );
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        request.setCharacterEncoding("UTF-8");

        String contextPath = request.getContextPath();
        boolean ajax = isAjaxRequest(request);

        HttpSession session = request.getSession(false);

        // =========================================
        // 1. AUTHENTICATION
        // =========================================

        if (session == null ||
                session.getAttribute("userId") == null) {

            if (ajax) {
                sendJson(response, 401,
                    false, "Please sign in to make a booking.", null);
            } else {
                response.sendRedirect(contextPath + "/login.jsp");
            }
            return;
        }

        // =========================================
        // 2. AUTHORIZATION
        // =========================================

        String role = (String) session.getAttribute("role");

        if (!"GUEST".equals(role)) {

            if (ajax) {
                sendJson(response, 403,
                    false, "Only guests can make bookings.", null);
            } else {
                response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only guests can make bookings."
                );
            }
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {

            if (ajax) {
                sendJson(response, 401,
                    false, "Invalid user session.", null);
            } else {
                response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Invalid user session."
                );
            }
            return;
        }

        int userId = (Integer) userIdObject;

        // =========================================
        // 3. PROCESS BOOKING
        // =========================================

        try {

            int roomId = Integer.parseInt(
                request.getParameter("roomId"));

            int guests = Integer.parseInt(
                request.getParameter("guests"));

            LocalDate checkIn = LocalDate.parse(
                request.getParameter("checkIn"));

            LocalDate checkOut = LocalDate.parse(
                request.getParameter("checkOut"));

            String maxStayValue =
                getServletContext().getInitParameter(
                    "booking.maxStayDays");

            String taxRateValue =
                getServletContext().getInitParameter(
                    "booking.taxRate");

            if (maxStayValue == null ||
                    taxRateValue == null) {

                throw new ServletException(
                    "Booking configuration is missing.");
            }

            int maxStayDays = Integer.parseInt(maxStayValue);

            BigDecimal taxRate = new BigDecimal(taxRateValue);

            // DIAGNOSTIC LOGGING
            getServletContext().log(
                "BOOKING DEBUG: userId=" + userId +
                ", roomId=" + roomId +
                ", guests=" + guests +
                ", checkIn=" + checkIn +
                ", checkOut=" + checkOut +
                ", maxStayDays=" + maxStayDays +
                ", taxRate=" + taxRate
            );

            int bookingId = bookingDAO.createBooking(
                userId,
                roomId,
                checkIn,
                checkOut,
                guests,
                maxStayDays,
                taxRate
            );

            String redirectUrl =
                contextPath +
                "/guest/booking-details?id=" + bookingId;

            if (ajax) {

                sendJson(response, 200, true,
                    "Your booking was successfully created.",
                    redirectUrl);

            } else {

                response.sendRedirect(redirectUrl);
            }

        // =========================================
        // 4. INVALID INPUT
        // =========================================

        } catch (NumberFormatException |
                 DateTimeParseException |
                 NullPointerException exception) {

            getServletContext().log(
                "BOOKING DEBUG: Invalid booking input.",
                exception
            );

            handleError(response, ajax, 400,
                "Invalid booking information.");

        // =========================================
        // 5. BOOKING CONFLICT
        // HTTP 409
        // =========================================

        } catch (BookingConflictException exception) {

            getServletContext().log(
                "BOOKING DEBUG: Booking conflict: "
                + exception.getMessage()
            );

            handleError(response, ajax, 409,
                exception.getMessage());

        // =========================================
        // 6. INVALID DATE RANGE
        // HTTP 400
        // =========================================

        } catch (InvalidDateRangeException exception) {

            getServletContext().log(
                "BOOKING DEBUG: Invalid date range: "
                + exception.getMessage()
            );

            handleError(response, ajax, 400,
                exception.getMessage());

        // =========================================
        // 7. ROOM CAPACITY EXCEEDED
        // HTTP 400
        // =========================================

        } catch (CapacityExceededException exception) {

            getServletContext().log(
                "BOOKING DEBUG: Capacity exceeded: "
                + exception.getMessage()
            );

            handleError(response, ajax, 400,
                exception.getMessage());

        // =========================================
        // 8. OTHER VALIDATION ERRORS
        // =========================================

        } catch (IllegalArgumentException exception) {

            getServletContext().log(
                "BOOKING DEBUG: Booking validation failed.",
                exception
            );

            handleError(response, ajax, 400,
                exception.getMessage());

        // =========================================
        // 9. DATABASE ERRORS
        // HTTP 500
        // =========================================

        } catch (SQLException exception) {

            getServletContext().log(
                "Unable to create booking.", exception
            );

            if (ajax) {
                handleError(response, true, 500,
                    "A database error occurred. Please try again.");
            } else {
                throw new ServletException(
                    "Unable to create booking.", exception);
            }
        }
    }

    // =========================================
    // 10. DETECT AJAX REQUEST
    // =========================================

    private boolean isAjaxRequest(HttpServletRequest request) {

        String accept = request.getHeader("Accept");

        String requestedWith =
            request.getHeader("X-Requested-With");

        return (accept != null &&
                accept.contains("application/json"))
                || "XMLHttpRequest".equalsIgnoreCase(requestedWith);
    }

    // =========================================
    // 11. HANDLE ERRORS
    // =========================================

    private void handleError(
            HttpServletResponse response,
            boolean ajax,
            int status,
            String message) throws IOException {

        if (ajax) {
            sendJson(response, status, false, message, null);
        } else {
            response.sendError(status, message);
        }
    }

    // =========================================
    // 12. SEND JSON RESPONSE
    // =========================================

    private void sendJson(
            HttpServletResponse response,
            int status,
            boolean success,
            String message,
            String redirectUrl) throws IOException {

        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String json =
            "{\"success\":" + success +
            ",\"message\":\"" + escapeJson(message) + "\"";

        if (redirectUrl != null) {
            json += ",\"redirectUrl\":\"" +
                    escapeJson(redirectUrl) + "\"";
        }

        json += "}";

        response.getWriter().write(json);
    }

    // =========================================
    // 13. JSON ESCAPING
    // =========================================

    private String escapeJson(String value) {

        if (value == null) {
            return "";
        }

        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r");
    }
}