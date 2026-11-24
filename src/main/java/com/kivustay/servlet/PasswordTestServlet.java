package com.kivustay.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kivustay.util.PasswordUtil;

@WebServlet("/test-password")
public class PasswordTestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {

            String password = "KivuStay@2026";

            String hash = PasswordUtil.hashPassword(password);

            boolean correctPassword =
                    PasswordUtil.verifyPassword(password, hash);

            boolean wrongPassword =
                    PasswordUtil.verifyPassword("WrongPassword", hash);

            out.println("Password security test");
            out.println("----------------------");
            out.println("Hash generated: " + (hash != null));
            out.println("Correct password accepted: " + correctPassword);
            out.println("Wrong password rejected: " + !wrongPassword);

        } catch (NoSuchAlgorithmException |
                 InvalidKeySpecException e) {

            throw new ServletException(
                    "Password security test failed.", e
            );
        }
    }
}