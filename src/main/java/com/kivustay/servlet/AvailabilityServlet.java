package com.kivustay.servlet;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kivustay.dao.AvailabilityDAO;

@WebServlet("/availability")
public class AvailabilityServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AvailabilityDAO availabilityDAO =
            new AvailabilityDAO();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.setHeader(
            "Cache-Control",
            "no-store, no-cache, must-revalidate, private"
        );
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        try {
            int roomId = Integer.parseInt(
                request.getParameter("roomId")
            );

            int guests = Integer.parseInt(
                request.getParameter("guests")
            );

            LocalDate checkIn = LocalDate.parse(
                request.getParameter("checkIn")
            );

            LocalDate checkOut = LocalDate.parse(
                request.getParameter("checkOut")
            );

            if (roomId <= 0 || guests <= 0) {
                sendError(response, 400,
                    "Invalid room or guest information.");
                return;
            }

            if (!checkOut.isAfter(checkIn)) {
                sendError(response, 400,
                    "Check-out must be after check-in.");
                return;
            }

            boolean available = availabilityDAO.isRoomAvailable(
                getServletContext(),
                roomId,
                Date.valueOf(checkIn),
                Date.valueOf(checkOut),
                guests
            );

            response.setStatus(HttpServletResponse.SC_OK);

            if (available) {
                response.getWriter().write(
                    "{\"available\":true,"
                    + "\"message\":\"This room is available.\"}"
                );
            } else {
                response.getWriter().write(
                    "{\"available\":false,"
                    + "\"message\":\"This room is no longer available "
                    + "for the selected dates or guest count.\"}"
                );
            }

        } catch (NumberFormatException
                | DateTimeParseException
                | NullPointerException e) {

            sendError(response, 400,
                "Please provide valid room, date and guest information.");

        } catch (SQLException e) {

            throw new ServletException(
                "Unable to check room availability.", e
            );
        }
    }

    private void sendError(
            HttpServletResponse response,
            int status,
            String message) throws IOException {

        response.setStatus(status);

        response.getWriter().write(
            "{\"available\":false,"
            + "\"message\":\"" + message + "\"}"
        );
    }
}