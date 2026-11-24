package com.kivustay.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.kivustay.dao.HotelDAO;

@WebServlet("/manager/hotels")
public class ManagerHotelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================
    // 1. DISPLAY MANAGER'S HOTELS
    // =========================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        setNoCacheHeaders(response);

        Integer managerId =
                getAuthorizedManagerId(request, response);

        if (managerId == null) {
            return;
        }

        try {

            HotelDAO hotelDAO =
                    new HotelDAO(getServletContext());

            request.setAttribute(
                    "hotels",
                    hotelDAO.findByManagerId(managerId)
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/manager-hotels.jsp"
            ).forward(request, response);

        } catch (SQLException exception) {

            throw new ServletException(
                    "Unable to load manager hotels.",
                    exception
            );
        }
    }

    // =========================================
    // 2. VERIFY MANAGER AUTHORIZATION
    // =========================================

    private Integer getAuthorizedManagerId(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return null;
        }

        String role =
                (String) session.getAttribute("role");

        if (!"MANAGER".equalsIgnoreCase(
                role == null ? "" : role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to view these hotels."
            );

            return null;
        }

        Object userIdObject =
                session.getAttribute("userId");

        if (!(userIdObject instanceof Number)) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return null;
        }

        int managerId =
                ((Number) userIdObject).intValue();

        if (managerId <= 0) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return null;
        }

        return managerId;
    }

    // =========================================
    // 3. PREVENT PAGE CACHING
    // =========================================

    private void setNoCacheHeaders(
            HttpServletResponse response) {

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate"
        );

        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}