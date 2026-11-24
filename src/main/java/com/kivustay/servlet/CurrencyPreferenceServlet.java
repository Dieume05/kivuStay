package com.kivustay.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/preferences/currency")
public class CurrencyPreferenceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 30;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String currency = request.getParameter("currency");

        // Accept only supported currencies.
        if (currency == null ||
                !(currency.equals("USD")
                || currency.equals("EUR")
                || currency.equals("CDF")
                || currency.equals("RWF"))) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid currency preference."
            );
            return;
        }

        // Save the currency preference.
        Cookie cookie = new Cookie("preferredCurrency", currency);

        String contextPath = request.getContextPath();

        String cookiePath = contextPath.isEmpty()
                ? "/" : contextPath;

        cookie.setMaxAge(COOKIE_MAX_AGE);
        cookie.setPath(cookiePath);
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());

        String cookieHeader =
            "preferredCurrency=" + currency
            + "; Max-Age=" + COOKIE_MAX_AGE
            + "; Path=" + cookiePath
            + "; HttpOnly; SameSite=Lax"
            + (request.isSecure() ? "; Secure" : "");

        response.addHeader("Set-Cookie", cookieHeader);

        // Return to the previous page safely.
        String returnTo = request.getParameter("returnTo");

        String destination = contextPath + "/index.html";

        if (returnTo != null
                && !returnTo.isEmpty()
                && returnTo.startsWith(contextPath + "/")
                && !returnTo.startsWith("//")
                && !returnTo.contains("\\")
                && !returnTo.contains("\r")
                && !returnTo.contains("\n")) {

            destination = returnTo;
        }

        response.sendRedirect(
            response.encodeRedirectURL(destination)
        );
    }
}