package com.kivustay.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletContext;

public class DBConnection {

    private static final String DRIVER =
            "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection(
            ServletContext context) throws SQLException {

        String url = context.getInitParameter("db.url");
        String username = context.getInitParameter("db.username");
        String password = context.getInitParameter("db.password");

        if (url == null || username == null || password == null) {
            throw new SQLException(
                    "Database configuration is missing in web.xml"
            );
        }

        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL JDBC Driver not found.", e
            );
        }

        return DriverManager.getConnection(
                url, username, password
        );
    }
}