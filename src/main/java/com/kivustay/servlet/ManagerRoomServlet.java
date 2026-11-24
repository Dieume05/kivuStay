package com.kivustay.servlet;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.SQLException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.kivustay.dao.RoomDAO;

@WebServlet("/manager/rooms")
public class ManagerRoomServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // =========================================
    // 1. DISPLAY ROOM MANAGEMENT PAGE
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

            RoomDAO roomDAO =
                    new RoomDAO(getServletContext());

            request.setAttribute(
                    "rooms",
                    roomDAO.findByManagerId(managerId)
            );

            request.setAttribute(
                    "roomTypes",
                    roomDAO.findRoomTypesByManagerId(managerId)
            );

            HttpSession session = request.getSession();

            // Generate CSRF token if one does not exist.
            if (session.getAttribute("csrfToken") == null) {

                session.setAttribute(
                        "csrfToken",
                        UUID.randomUUID().toString()
                );
            }

            request.setAttribute(
                    "csrfToken",
                    session.getAttribute("csrfToken")
            );

            // Retrieve flash messages.
            request.setAttribute(
                    "roomSuccess",
                    session.getAttribute("roomSuccess")
            );

            request.setAttribute(
                    "roomError",
                    session.getAttribute("roomError")
            );

            session.removeAttribute("roomSuccess");
            session.removeAttribute("roomError");

            request.getRequestDispatcher(
                    "/WEB-INF/views/manager-rooms.jsp"
            ).forward(request, response);

        } catch (SQLException exception) {

            throw new ServletException(
                    "Unable to load room management data.",
                    exception
            );
        }
    }


    // =========================================
    // 2. HANDLE ADD, UPDATE AND DELETE
    // =========================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        setNoCacheHeaders(response);

        Integer managerId =
                getAuthorizedManagerId(request, response);

        if (managerId == null) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // =================================
        // VERIFY CSRF TOKEN
        // =================================

        HttpSession session = request.getSession(false);

        String submittedToken =
                request.getParameter("csrfToken");

        String sessionToken =
                (String) session.getAttribute("csrfToken");

        if (submittedToken == null
                || sessionToken == null
                || !MessageDigest.isEqual(
                        submittedToken.getBytes(StandardCharsets.UTF_8),
                        sessionToken.getBytes(StandardCharsets.UTF_8))) {

            setFlashMessage(
                    request,
                    "roomError",
                    "Your request could not be verified. "
                    + "Please refresh the page and try again."
            );

            response.sendRedirect(
                    request.getContextPath() + "/manager/rooms"
            );

            return;
        }

        String action = request.getParameter("action");

        try {

            RoomDAO roomDAO =
                    new RoomDAO(getServletContext());

            // =================================
            // ADD ROOM
            // =================================

            if ("add".equals(action)) {

                int roomTypeId = Integer.parseInt(
                        request.getParameter("roomTypeId")
                );

                String roomNumber =
                        request.getParameter("roomNumber");

                String roomStatus =
                        request.getParameter("roomStatus");

                boolean success = roomDAO.addRoom(
                        roomTypeId,
                        roomNumber,
                        roomStatus,
                        managerId
                );

                if (success) {

                    setFlashMessage(
                            request,
                            "roomSuccess",
                            "Room added successfully."
                    );

                } else {

                    setFlashMessage(
                            request,
                            "roomError",
                            "Room could not be added. "
                            + "Please check the selected room type."
                    );
                }

            }

            // =================================
            // UPDATE ROOM
            // =================================

            else if ("update".equals(action)) {

                int roomId = Integer.parseInt(
                        request.getParameter("roomId")
                );

                int roomTypeId = Integer.parseInt(
                        request.getParameter("roomTypeId")
                );

                String roomNumber =
                        request.getParameter("roomNumber");

                String roomStatus =
                        request.getParameter("roomStatus");

                boolean success = roomDAO.updateRoom(
                        roomId,
                        roomTypeId,
                        roomNumber,
                        roomStatus,
                        managerId
                );

                if (success) {

                    setFlashMessage(
                            request,
                            "roomSuccess",
                            "Room updated successfully."
                    );

                } else {

                    setFlashMessage(
                            request,
                            "roomError",
                            "Room could not be updated. "
                            + "It may not belong to your hotel."
                    );
                }

            }

            // =================================
            // DELETE ROOM
            // =================================

            else if ("delete".equals(action)) {

                int roomId = Integer.parseInt(
                        request.getParameter("roomId")
                );

                boolean success = roomDAO.deleteRoom(
                        roomId,
                        managerId
                );

                if (success) {

                    setFlashMessage(
                            request,
                            "roomSuccess",
                            "Room deleted successfully."
                    );

                } else {

                    setFlashMessage(
                            request,
                            "roomError",
                            "Room could not be deleted. "
                            + "It may not belong to your hotel "
                            + "or it may have booking history."
                    );
                }

            }

            // =================================
            // INVALID ACTION
            // =================================

            else {

                setFlashMessage(
                        request,
                        "roomError",
                        "Invalid room operation."
                );
            }

        } catch (NumberFormatException exception) {

            setFlashMessage(
                    request,
                    "roomError",
                    "Please provide valid room information."
            );

        } catch (IllegalArgumentException exception) {

            setFlashMessage(
                    request,
                    "roomError",
                    exception.getMessage()
            );

        } catch (SQLException exception) {

            // MySQL error 1062 means duplicate entry.
            if (exception.getErrorCode() == 1062) {

                setFlashMessage(
                        request,
                        "roomError",
                        "This room number is already in use. "
                        + "Please choose another number."
                );

            } else {

                throw new ServletException(
                        "Unable to process room operation.",
                        exception
                );
            }
        }

        response.sendRedirect(
                request.getContextPath() + "/manager/rooms"
        );
    }


    // =========================================
    // 3. VERIFY MANAGER AUTHORIZATION
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
                    "You are not authorized to manage rooms."
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
    // 4. PREVENT PAGE CACHING
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


    // =========================================
    // 5. STORE SUCCESS AND ERROR MESSAGES
    // =========================================

    private void setFlashMessage(
            HttpServletRequest request,
            String attribute,
            String message) {

        request.getSession().setAttribute(
                attribute,
                message
        );
    }
}