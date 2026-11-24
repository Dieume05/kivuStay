package com.kivustay.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kivustay.dao.QuoteDAO;

@WebServlet("/quote")
public class QuoteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private QuoteDAO quoteDAO;

    private int maxStayDays;
    private BigDecimal taxRate;

    @Override
    public void init() throws ServletException {

        quoteDAO = new QuoteDAO();

        String maxStay = getServletContext()
                .getInitParameter("booking.maxStayDays");

        String configuredTax = getServletContext()
                .getInitParameter("booking.taxRate");

        try {
            maxStayDays = Integer.parseInt(maxStay);
            taxRate = new BigDecimal(configuredTax);

            if (maxStayDays <= 0 ||
                    taxRate.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException(
                        "Invalid booking configuration.");
            }

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to initialize quote configuration.", e);
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        response.setHeader("Cache-Control",
                "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");

        try {

            int roomId = Integer.parseInt(
                    request.getParameter("roomId"));

            LocalDate checkIn = LocalDate.parse(
                    request.getParameter("checkIn"));

            LocalDate checkOut = LocalDate.parse(
                    request.getParameter("checkOut"));

            if (roomId <= 0 ||
                    !checkOut.isAfter(checkIn)) {

                sendError(response, 400,
                        "Please provide valid room and travel dates.");
                return;
            }

            long nights = ChronoUnit.DAYS.between(
                    checkIn, checkOut);

            if (nights > maxStayDays) {
                sendError(response, 400,
                        "Maximum stay is " + maxStayDays + " days.");
                return;
            }

            BigDecimal pricePerNight =
                    quoteDAO.findPricePerNight(
                            getServletContext(), roomId);

            if (pricePerNight == null) {
                sendError(response, 404,
                        "The selected room could not be found.");
                return;
            }

            BigDecimal subtotal = pricePerNight
                    .multiply(BigDecimal.valueOf(nights));

            BigDecimal tax = subtotal
                    .multiply(taxRate)
                    .setScale(2, RoundingMode.HALF_UP);

            BigDecimal total = subtotal
                    .add(tax)
                    .setScale(2, RoundingMode.HALF_UP);

            response.setStatus(HttpServletResponse.SC_OK);

            response.getWriter().write(
                    "{"
                    + "\"success\":true,"
                    + "\"nights\":" + nights + ","
                    + "\"subtotal\":" + subtotal.toPlainString() + ","
                    + "\"tax\":" + tax.toPlainString() + ","
                    + "\"total\":" + total.toPlainString()
                    + "}"
            );

        } catch (NumberFormatException |
                 java.time.format.DateTimeParseException e) {

            sendError(response, 400,
                    "Invalid room ID or date format.");

        } catch (SQLException e) {

            log("Error calculating booking quote.", e);

            sendError(response, 500,
                    "Unable to calculate the quote right now.");

        } catch (Exception e) {

            log("Unexpected quote error.", e);

            sendError(response, 500,
                    "An unexpected error occurred.");
        }
    }

    private void sendError(
            HttpServletResponse response,
            int status,
            String message) throws IOException {

        response.setStatus(status);

        response.getWriter().write(
                "{"
                + "\"success\":false,"
                + "\"message\":\"" + escapeJson(message) + "\""
                + "}"
        );
    }

    private String escapeJson(String value) {

        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"");
    }
}