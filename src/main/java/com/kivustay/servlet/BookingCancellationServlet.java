package com.kivustay.servlet;

import com.kivustay.dao.BookingCancellationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/guest/cancel-booking")
public class BookingCancellationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BookingCancellationDAO cancellationDAO;

    @Override
    public void init() throws ServletException {
        cancellationDAO =
            new BookingCancellationDAO(getServletContext());
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("userId") == null) {

            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        if (!"GUEST".equals(session.getAttribute("role"))) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Only guests can cancel bookings."
            );
            return;
        }

        Object userIdObject = session.getAttribute("userId");

        if (!(userIdObject instanceof Integer)) {
            response.sendError(
                HttpServletResponse.SC_UNAUTHORIZED,
                "Invalid user session."
            );
            return;
        }

        try {
            int bookingId = Integer.parseInt(
                request.getParameter("bookingId")
            );

            if (bookingId <= 0) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid booking ID."
                );
                return;
            }

            int userId = (Integer) userIdObject;

            boolean cancelled =
                cancellationDAO.cancelBooking(bookingId, userId);

            if (cancelled) {
                response.sendRedirect(
                    contextPath +
                    "/guest/dashboard?cancel=success"
                );
            } else {
                response.sendRedirect(
                    contextPath +
                    "/guest/dashboard?cancel=failed"
                );
            }

        } catch (NumberFormatException exception) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid booking ID."
            );

        } catch (SQLException exception) {
            throw new ServletException(
                "Unable to cancel booking.",
                exception
            );
        }
    }
}