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
import java.util.List;

@WebServlet("/guest/dashboard")
public class GuestDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check whether the user is logged in.
        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        // Verify that the logged-in user is a guest.
        String role = (String) session.getAttribute("role");

        if (!"GUEST".equals(role)) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Access denied.");
            return;
        }

        // Retrieve the logged-in guest's ID.
        Integer userId = (Integer) session.getAttribute("userId");

        try {

            BookingDAO bookingDAO =
                new BookingDAO(getServletContext());

            // Retrieve only this guest's bookings.
            List<Booking> bookings =
                bookingDAO.findByUserId(userId);

            // Pass bookings to the JSP.
            request.setAttribute("bookings", bookings);

            // Useful dashboard statistics.
            request.setAttribute(
                "totalBookings", bookings.size());

            request.getRequestDispatcher(
                "/WEB-INF/views/guest-dashboard.jsp")
                .forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                "Unable to load guest dashboard bookings.", e);
        }
    }
}