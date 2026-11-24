package com.kivustay.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kivustay.dao.UserDAO;
import com.kivustay.model.User;

@WebServlet("/test-authentication")
public class AuthenticationTestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            UserDAO userDAO = new UserDAO(getServletContext());

            // Test correct password
            User validUser = userDAO.authenticate(
                    "jean.manager@kivustay.com",
                    "Manager@123"
            );

            // Test incorrect password
            User invalidUser = userDAO.authenticate(
                    "jean.manager@kivustay.com",
                    "WrongPassword"
            );

            out.println("Authentication test");
            out.println("====================");

            out.println("Correct password accepted: "
                    + (validUser != null));

            out.println("Wrong password rejected: "
                    + (invalidUser == null));

            if (validUser != null) {
                out.println("Authenticated user: "
                        + validUser.getFullName());

                out.println("User role: "
                        + validUser.getRole());
            }

        } catch (SQLException |
                 NoSuchAlgorithmException |
                 InvalidKeySpecException e) {

            throw new ServletException(
                    "Authentication test failed.", e
            );
        }
    }
}