package com.kivustay.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import javax.servlet.ServletContext;

import com.kivustay.model.User;
import com.kivustay.util.DBConnection;
import com.kivustay.util.PasswordUtil;

public class UserDAO {

    private final ServletContext context;

    public UserDAO(ServletContext context) {
        this.context = context;
    }

    // Find a user using their email address
    public User findByEmail(String email) throws SQLException {

        String sql = "SELECT user_id, full_name, email, role "
                   + "FROM users WHERE email = ?";

        try (
            Connection connection = DBConnection.getConnection(context);
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, email);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {

                    User user = new User();

                    user.setUserId(result.getInt("user_id"));
                    user.setFullName(result.getString("full_name"));
                    user.setEmail(result.getString("email"));
                    user.setRole(result.getString("role"));

                    return user;
                }
            }
        }

        return null;
    }

    // Authenticate a user using email and password
    public User authenticate(String email, String password)
            throws SQLException,
                   NoSuchAlgorithmException,
                   InvalidKeySpecException {

        String sql = "SELECT user_id, full_name, email, role, password_hash "
                   + "FROM users WHERE email = ?";

        try (
            Connection connection = DBConnection.getConnection(context);
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, email);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {

                    String storedHash =
                            result.getString("password_hash");

                    boolean validPassword =
                            PasswordUtil.verifyPassword(
                                    password, storedHash
                            );

                    if (validPassword) {

                        User user = new User();

                        user.setUserId(result.getInt("user_id"));
                        user.setFullName(result.getString("full_name"));
                        user.setEmail(result.getString("email"));
                        user.setRole(result.getString("role"));

                        return user;
                    }
                }
            }
        }

        return null;
    }

    // Register a new guest account
    public boolean register(String fullName, String email, String password)
            throws SQLException,
                   NoSuchAlgorithmException,
                   InvalidKeySpecException {

        String sql = "INSERT INTO users "
                   + "(full_name, email, password_hash, role) "
                   + "VALUES (?, ?, ?, 'GUEST')";

        String passwordHash =
                PasswordUtil.hashPassword(password);

        try (
            Connection connection = DBConnection.getConnection(context);
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {

            statement.setString(1, fullName);
            statement.setString(2, email);
            statement.setString(3, passwordHash);

            return statement.executeUpdate() == 1;
        }
    }
}