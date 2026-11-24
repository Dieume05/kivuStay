package com.kivustay.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kivustay.util.DBConnection;

@WebServlet("/test-db")
public class DatabaseTestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try (Connection connection =
                     DBConnection.getConnection(getServletContext())) {

            response.getWriter().println(
                "<h2>Database connection successful!</h2>"
            );

        } catch (SQLException e) {

            throw new ServletException(
                "Database connection failed.", e
            );
        }
    }
}