package com.kivustay.servlet;

import java.io.IOException;
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

@WebServlet("/manager/bookings")
public class ManagerReservationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate");

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);

        if (session == null ||
                !"MANAGER".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");

            return;
        }

        Object userId = session.getAttribute("userId");

        if (!(userId instanceof Number)) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");

            return;
        }

        int managerId = ((Number) userId).intValue();

        try {

            ManagerDashboardDAO dao =
                    new ManagerDashboardDAO(getServletContext());

            List<Map<String, Object>> bookings =
                    dao.getAllBookings(managerId);

            request.setAttribute("bookings", bookings);
            int totalBookings = bookings.size();
            int pendingBookings = 0;
            int confirmedBookings = 0;
            int cancelledBookings = 0;

            for (Map<String, Object> booking : bookings) {

                String status =
                        (String) booking.get("bookingStatus");

                if ("PENDING".equals(status)) {
                    pendingBookings++;
                } else if ("CONFIRMED".equals(status)) {
                    confirmedBookings++;
                } else if ("CANCELLED".equals(status)) {
                    cancelledBookings++;
                }
            }

            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("confirmedBookings", confirmedBookings);
            request.setAttribute("cancelledBookings", cancelledBookings);

            request.getRequestDispatcher(
                    "/WEB-INF/views/manager-reservations.jsp")
                    .forward(request, response);

        } catch (SQLException e) {

            throw new ServletException(
                    "Unable to load manager reservations.", e);
        }
    }
}
