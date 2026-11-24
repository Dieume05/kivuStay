package com.kivustay.servlet;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.kivustay.dao.UserDAO;
import com.kivustay.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(getServletContext());
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate submitted information
        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            showLoginError(
                    request,
                    response,
                    "Please enter both your email address and password.",
                    email
            );

            return;
        }

        email = email.trim();

        try {

            // Authenticate user through UserDAO
            User user = userDAO.authenticate(email, password);

            // Reject invalid credentials
            if (user == null) {

                showLoginError(
                        request,
                        response,
                        "Invalid email address or password.",
                        email
                );

                return;
            }

            // Invalidate any previous session
            HttpSession oldSession = request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Create a new authenticated session
            HttpSession session = request.getSession(true);

            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());

            // Session expires after 30 minutes of inactivity
            session.setMaxInactiveInterval(30 * 60);

            // Redirect according to the authenticated user's role
            String role = user.getRole();

            if ("MANAGER".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath() + "/manager/dashboard"
                );

            } else if ("GUEST".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath() + "/guest/dashboard"
                );

            } else {

                session.invalidate();

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Your account role is not recognized."
                );
            }

        } catch (
                SQLException
                | NoSuchAlgorithmException
                | InvalidKeySpecException e) {

            throw new ServletException(
                    "An error occurred during authentication.",
                    e
            );
        }
    }

    // Display login errors without losing the email address
    private void showLoginError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message,
            String email)
            throws ServletException, IOException {

        request.setAttribute("loginError", message);
        request.setAttribute("email", email);

        request.getRequestDispatcher("/login.jsp")
               .forward(request, response);
    }
}