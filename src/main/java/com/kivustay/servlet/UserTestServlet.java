package com.kivustay.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kivustay.dao.UserDAO;
import com.kivustay.model.User;

@WebServlet("/test-user")
public class UserTestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try {
            UserDAO userDAO = new UserDAO(getServletContext());

            User user = userDAO.findByEmail(
                    "jean.manager@kivustay.com"
            );

            PrintWriter out = response.getWriter();

            if (user != null) {
                out.println("User found successfully!");
                out.println("ID: " + user.getUserId());
                out.println("Name: " + user.getFullName());
                out.println("Email: " + user.getEmail());
                out.println("Role: " + user.getRole());
            } else {
                out.println("User not found.");
            }

        } catch (SQLException e) {
            throw new ServletException(
                    "Could not retrieve user from database.", e
            );
        }
    }
}