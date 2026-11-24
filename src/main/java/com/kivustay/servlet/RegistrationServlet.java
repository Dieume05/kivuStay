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

import com.kivustay.dao.UserDAO;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(getServletContext());
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/register.jsp"
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String contextPath = request.getContextPath();

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        // Basic validation
        if (fullName == null || email == null ||
                password == null || confirmPassword == null) {

            response.sendRedirect(
                    contextPath + "/register.jsp?error=missing"
            );
            return;
        }

        fullName = fullName.trim();
        email = email.trim().toLowerCase();

        if (fullName.isEmpty() || email.isEmpty() ||
                password.isEmpty() || confirmPassword.isEmpty()) {

            response.sendRedirect(
                    contextPath + "/register.jsp?error=missing"
            );
            return;
        }

        if (fullName.length() > 100 || email.length() > 150) {
            response.sendRedirect(
                    contextPath + "/register.jsp?error=invalid"
            );
            return;
        }

        if (!email.matches(
                "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {

            response.sendRedirect(
                    contextPath + "/register.jsp?error=email"
            );
            return;
        }

        if (password.length() < 8 || password.length() > 128) {
            response.sendRedirect(
                    contextPath + "/register.jsp?error=password"
            );
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect(
                    contextPath + "/register.jsp?error=mismatch"
            );
            return;
        }

        try {

            // Check whether email already exists
            if (userDAO.findByEmail(email) != null) {

                response.sendRedirect(
                        contextPath + "/register.jsp?error=exists"
                );
                return;
            }

            // Create a new guest account
            boolean registered =
                    userDAO.register(fullName, email, password);

            if (registered) {

                response.sendRedirect(
                        contextPath + "/login.jsp?registered=success"
                );

            } else {

                response.sendRedirect(
                        contextPath + "/register.jsp?error=failed"
                );
            }

        } catch (SQLException exception) {

            throw new ServletException(
                    "Unable to register the user.", exception
            );

        } catch (NoSuchAlgorithmException |
                 InvalidKeySpecException exception) {

            throw new ServletException(
                    "Unable to securely process the password.",
                    exception
            );
        }
    }
}