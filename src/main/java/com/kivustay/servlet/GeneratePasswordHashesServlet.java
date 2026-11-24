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

@WebServlet("/generate-hashes")
public class GeneratePasswordHashesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        String[][] accounts = {
            {"jean.manager@kivustay.com", "Manager@123"},
            {"marie.manager@kivustay.com", "Manager@123"},
            {"patrick.manager@kivustay.com", "Manager@123"},
            {"david.guest@kivustay.com", "Guest@123"},
            {"sarah.guest@kivustay.com", "Guest@123"},
            {"emmanuel.guest@kivustay.com", "Guest@123"}
        };

        try (PrintWriter out = response.getWriter()) {

            out.println("Generated password hashes");
            out.println("==========================");

            for (String[] account : accounts) {

                String hash = PasswordUtil.hashPassword(account[1]);

                out.println();
                out.println("Email: " + account[0]);
                out.println("Hash: " + hash);
            }

        } catch (NoSuchAlgorithmException |
                 InvalidKeySpecException e) {

            throw new ServletException(
                    "Could not generate password hashes.", e
            );
        }
    }
}