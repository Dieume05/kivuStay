package com.kivustay.servlet;

import com.kivustay.dao.BookingDAO;
import com.kivustay.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/guest/booking-details")
public class BookingDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        if (!"GUEST".equals(role)) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String bookingIdParam = request.getParameter("id");

        int bookingId;

        try {
            bookingId = Integer.parseInt(bookingIdParam);

            if (bookingId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        try {
            BookingDAO bookingDAO =
                new BookingDAO(getServletContext());

            Booking booking =
                bookingDAO.findByIdAndUserId(bookingId, userId);

            if (booking == null) {
                response.sendError(
                    HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Load all guest bookings for the dashboard overview.
            request.setAttribute(
                "bookings",
                bookingDAO.findByUserId(userId));

            // Supply the selected booking to the same dashboard JSP.
            request.setAttribute("selectedBooking", booking);

            request.getRequestDispatcher(
                "/WEB-INF/views/guest-dashboard.jsp")
                .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException(
                "Unable to retrieve booking details.", e);
        }
    }
}