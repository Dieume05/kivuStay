package com.kivustay.servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Base64;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kivustay.dao.SearchDAO;
import com.kivustay.model.SearchResult;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final int COOKIE_MAX_AGE = 60 * 60 * 24 * 30;

    private SearchDAO searchDAO;
    @Override
    public void init() throws ServletException {
        searchDAO = new SearchDAO();
        getServletContext().log("SearchServlet initialized.");
    }

    @Override
    public void destroy() {
        getServletContext().log("SearchServlet destroyed.");
    }
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String location = request.getParameter("location");
        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String guests = request.getParameter("guests");

        // Restore the previous search if search details are missing.
        if (checkIn == null || checkIn.isEmpty()
                || checkOut == null || checkOut.isEmpty()
                || guests == null || guests.isEmpty()) {

            String savedSearch = getCookieValue(
                    request, "lastSearch"
            );

            if (savedSearch != null) {
                try {
                    String decoded = new String(
                            Base64.getUrlDecoder().decode(savedSearch),
                            StandardCharsets.UTF_8
                    );

                    String[] values = decoded.split("\\|", -1);

                    if (values.length == 4) {

                        String savedLocation =
                                URLDecoder.decode(
                                        values[0],
                                        StandardCharsets.UTF_8.name()
                                );

                        String savedCheckIn = values[1];
                        String savedCheckOut = values[2];
                        String savedGuests = values[3];

                        LocalDate.parse(savedCheckIn);
                        LocalDate.parse(savedCheckOut);

                        int savedGuestCount =
                                Integer.parseInt(savedGuests);

                        if (savedGuestCount >= 1
                                && savedGuestCount <= 5) {

                            String redirectUrl =
                                    request.getContextPath()
                                    + "/search?location="
                                    + URLEncoder.encode(
                                            savedLocation,
                                            StandardCharsets.UTF_8.name()
                                    )
                                    + "&checkIn=" + savedCheckIn
                                    + "&checkOut=" + savedCheckOut
                                    + "&guests=" + savedGuestCount;

                            response.sendRedirect(
                                    response.encodeRedirectURL(redirectUrl)
                            );
                            return;
                        }
                    }

                } catch (Exception ignored) {
                    // Invalid or expired search data is ignored.
                }
            }
        }

        try {

            if (checkIn == null || checkIn.isEmpty()
                    || checkOut == null || checkOut.isEmpty()) {

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Check-in and check-out dates are required."
                );
                return;
            }

            LocalDate arrival = LocalDate.parse(checkIn);
            LocalDate departure = LocalDate.parse(checkOut);

            if (arrival.isBefore(LocalDate.now())) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Check-in cannot be in the past."
                );
                return;
            }

            if (!departure.isAfter(arrival)) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Check-out must be after check-in."
                );
                return;
            }

            int guestCount = Integer.parseInt(guests);

            if (guestCount < 1 || guestCount > 5) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid number of guests."
                );
                return;
            }

            // Remember the successful search for 30 days.
            String encodedLocation = URLEncoder.encode(
                    location == null ? "" : location,
                    StandardCharsets.UTF_8.name()
            );

            String searchData = encodedLocation
                    + "|" + checkIn
                    + "|" + checkOut
                    + "|" + guestCount;

            String encodedSearch = Base64.getUrlEncoder()
                    .withoutPadding()
                    .encodeToString(
                            searchData.getBytes(StandardCharsets.UTF_8)
                    );

            String cookiePath = request.getContextPath().isEmpty()
                    ? "/"
                    : request.getContextPath();

            String cookieHeader =
                    "lastSearch=" + encodedSearch
                    + "; Max-Age=" + COOKIE_MAX_AGE
                    + "; Path=" + cookiePath
                    + "; HttpOnly; SameSite=Lax"
                    + (request.isSecure() ? "; Secure" : "");

            response.addHeader("Set-Cookie", cookieHeader);

            // Hotel search results are cacheable for five minutes.
            response.setHeader(
                    "Cache-Control", "private, max-age=300"
            );

            response.setDateHeader(
                    "Expires",
                    System.currentTimeMillis() + 300000
            );

            Date arrivalDate = Date.valueOf(arrival);
            Date departureDate = Date.valueOf(departure);

            List<SearchResult> results =
                searchDAO.searchAvailableRooms(
                    getServletContext(),
                    location,
                    arrivalDate,
                    departureDate,
                    guestCount
                );

            request.setAttribute("searchResults", results);
            request.setAttribute("location", location);
            request.setAttribute("checkIn", checkIn);
            request.setAttribute("checkOut", checkOut);
            request.setAttribute("guests", guestCount);

            request.getRequestDispatcher(
                "/search-results.jsp"
            ).forward(request, response);

        } catch (DateTimeParseException | NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid search information."
            );

        } catch (java.sql.SQLException e) {

            throw new ServletException(
                "Unable to search available rooms.", e
            );
        }
    }

    private String getCookieValue(
            HttpServletRequest request, String name) {

        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (name.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }

        return null;
    }
}