package com.kivustay.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.kivustay.dao.ManagerDashboardDAO;

@WebServlet("/manager/dashboard")
public class ManagerDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Prevent dashboard caching.
        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Check login session.
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Check manager role.
        String role = (String) session.getAttribute("role");

        if (!"MANAGER".equalsIgnoreCase(
                role == null ? "" : role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to access the manager dashboard."
            );

            return;
        }

        // Retrieve the logged-in manager ID.
        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Number)) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        int managerId =
                ((Number) userIdObject).intValue();

        if (managerId <= 0) {
            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        try {

            // Initialize the dashboard DAO.
            ManagerDashboardDAO dashboardDAO =
                    new ManagerDashboardDAO(
                            getServletContext()
                    );

            // Retrieve dashboard summary.
            request.setAttribute(
                    "dashboardSummary",
                    dashboardDAO.getDashboardSummary(managerId)
            );

            // Existing chart datasets.
            request.setAttribute(
                    "bookingStatusData",
                    dashboardDAO.getBookingStatusData(managerId)
            );

            request.setAttribute(
                    "monthlyRevenueData",
                    dashboardDAO.getMonthlyRevenueData(managerId)
            );

            request.setAttribute(
                    "roomStatusData",
                    dashboardDAO.getRoomStatusData(managerId)
            );

            // New required analytics datasets.
            request.setAttribute(
                    "occupancyPerHotelData",
                    dashboardDAO.getOccupancyPerHotelData(managerId)
            );

            request.setAttribute(
                    "bookingsPerMonthData",
                    dashboardDAO.getBookingsPerMonthData(managerId)
            );

            request.setAttribute(
                    "roomTypeShareData",
                    dashboardDAO.getRoomTypeShareData(managerId)
            );

            // Retrieve the ten most recent bookings.
            request.setAttribute(
                    "recentBookings",
                    dashboardDAO.getRecentBookings(managerId, 10)
            );

            // Forward to dashboard view.
            request.getRequestDispatcher(
                    "/WEB-INF/views/manager-dashboard.jsp"
            ).forward(request, response);

        } catch (SQLException exception) {

            throw new ServletException(
                    "Unable to load manager dashboard data.",
                    exception
            );
        }
    }
}