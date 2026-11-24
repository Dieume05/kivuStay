<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.kivustay.model.SearchResult" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

<%!
    private String escapeHtml(Object value) {
        if (value == null) return "";

        String text = String.valueOf(value);

        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
%>

<%
    List<SearchResult> results =
        (List<SearchResult>) request.getAttribute("searchResults");

    String location = (String) request.getAttribute("location");
    String checkIn = (String) request.getAttribute("checkIn");
    String checkOut = (String) request.getAttribute("checkOut");

    Integer guests = (Integer) request.getAttribute("guests");

    if (results == null) {
        results = new java.util.ArrayList<>();
    }

    String contextPath = request.getContextPath();

    boolean guestLoggedIn =
        session.getAttribute("userId") != null &&
        "GUEST".equals(session.getAttribute("role"));

    // Read the saved currency preference.
    String preferredCurrency = "USD";

    if (request.getCookies() != null) {
        for (javax.servlet.http.Cookie cookie : request.getCookies()) {
            if ("preferredCurrency".equals(cookie.getName())) {
                String value = cookie.getValue();

                if ("USD".equals(value) || "EUR".equals(value)
                        || "CDF".equals(value) || "RWF".equals(value)) {
                    preferredCurrency = value;
                }
            }
        }
    }

    // Exchange rates: base currency is USD.
    // Rates retrieved on 23 November 2026.
    BigDecimal exchangeRate = BigDecimal.ONE;
    String currencySymbol = "$";
    int currencyDecimals = 2;

    if ("EUR".equals(preferredCurrency)) {
        exchangeRate = new BigDecimal("0.91755");
        currencySymbol = "€";
    } else if ("CDF".equals(preferredCurrency)) {
        exchangeRate = new BigDecimal("2316.57");
        currencySymbol = "FC";
        currencyDecimals = 0;
    } else if ("RWF".equals(preferredCurrency)) {
        exchangeRate = new BigDecimal("1473.99");
        currencySymbol = "RF";
        currencyDecimals = 0;
    }

    DecimalFormat priceFormat = currencyDecimals == 0
        ? new DecimalFormat("#,##0")
        : new DecimalFormat("#,##0.00");

    priceFormat.setRoundingMode(RoundingMode.HALF_UP);
 // Preserve all search criteria when changing currency.
    String safeLocation = location == null ? "" : location;

    String returnTo = contextPath + "/search"
            + "?location=" + URLEncoder.encode(
                    safeLocation, StandardCharsets.UTF_8.name())
            + "&checkIn=" + URLEncoder.encode(
                    checkIn == null ? "" : checkIn,
                    StandardCharsets.UTF_8.name())
            + "&checkOut=" + URLEncoder.encode(
                    checkOut == null ? "" : checkOut,
                    StandardCharsets.UTF_8.name())
            + "&guests=" + (guests == null ? 1 : guests);
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Available Stays | KivuStay</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:wght@400;500;600&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/search-results.css">

    <style>
        .booking-action {
            margin-top: 20px;
        }

        .book-room-button {
            display: block;
            width: 100%;
            padding: 14px 18px;
            border: none;
            border-radius: 5px;
            background: #267C78;
            color: #FFFFFF;
            font-family: "DM Sans", sans-serif;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
            cursor: pointer;
            transition: background 0.25s ease,
                        transform 0.25s ease;
        }

        .book-room-button:hover {
            background: #142D3B;
            transform: translateY(-2px);
        }

        .booking-login-link {
            display: block;
            width: 100%;
            padding: 14px 18px;
            border-radius: 5px;
            background: #142D3B;
            color: #FFFFFF;
            text-align: center;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            box-sizing: border-box;
            transition: background 0.25s ease;
        }

        .booking-login-link:hover {
            background: #267C78;
        }

        .booking-note {
            margin-top: 9px;
            color: #68777D;
            font-size: 12px;
            text-align: center;
        }

        .quote-box {
            margin-top: 18px;
            padding: 16px;
            background: #F4F7F6;
            border: 1px solid #E1E9E6;
            border-radius: 5px;
            font-family: "DM Sans", sans-serif;
        }

        .quote-title {
            margin: 0 0 13px;
            color: #267C78;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 1.3px;
        }

        .quote-line,
        .quote-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 9px;
            color: #68777D;
            font-size: 12px;
        }

        .quote-line strong {
            color: #142D3B;
            font-weight: 600;
        }

        .quote-total {
            margin-top: 14px;
            padding-top: 13px;
            border-top: 1px solid #D8E2DE;
            color: #142D3B;
            font-weight: 700;
        }

        .quote-total strong {
            color: #267C78;
            font-size: 18px;
        }

        .quote-status {
            margin: 0;
            color: #68777D;
            font-size: 12px;
        }

        .planner-action {
            margin-top: 12px;
        }

        .add-to-planner-button {
            display: block;
            width: 100%;
            padding: 13px 16px;
            border: 1px solid #267C78;
            border-radius: 5px;
            background: #FFFFFF;
            color: #267C78;
            font-family: "DM Sans", sans-serif;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .add-to-planner-button:hover {
            background: #267C78;
            color: #FFFFFF;
        }

        .planner-feedback {
            min-height: 16px;
            margin-top: 7px;
            color: #267C78;
            font-size: 12px;
            text-align: center;
        }

        .header-planner-link {
            color: #267C78;
            font-weight: 700;
            text-decoration: none;
        }

        .header-planner-link:hover {
            color: #142D3B;
        }

        .currency-form {
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .currency-form label {
            color: #68777D;
            font-size: 11px;
            font-weight: 700;
        }

        .currency-select {
            padding: 8px 10px;
            border: 1px solid #D8E2DE;
            border-radius: 4px;
            background: #FFFFFF;
            color: #142D3B;
            font-family: "DM Sans", sans-serif;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }
    </style>
</head>

<body>

<!-- HEADER -->

<header class="results-header">

    <a href="<%= contextPath %>/index.html" class="brand">
        <span class="brand-symbol">K</span>
        <span>KivuStay</span>
    </a>

    <nav class="header-navigation">

        <a href="<%= contextPath %>/index.html">
            Home
        </a>

        <a href="<%= contextPath %>/index.html#destinations">
            Explore destinations
        </a>

        <a href="<%= contextPath %>/trip-planner.jsp"
           class="header-planner-link">
            My Trip Planner
        </a>

        <!-- CURRENCY SELECTOR -->

        <form action="<%= contextPath %>/preferences/currency"
              method="POST"
              class="currency-form">

            <input type="hidden"
                   name="returnTo"
                   value="<%= escapeHtml(returnTo) %>">

            <label for="preferredCurrency">Currency</label>

            <select id="preferredCurrency"
                    name="currency"
                    class="currency-select"
                    onchange="this.form.submit()">

                <option value="USD"
                    <%= "USD".equals(preferredCurrency) ? "selected" : "" %>>
                    USD
                </option>

                <option value="EUR"
                    <%= "EUR".equals(preferredCurrency) ? "selected" : "" %>>
                    EUR
                </option>

                <option value="CDF"
                    <%= "CDF".equals(preferredCurrency) ? "selected" : "" %>>
                    CDF
                </option>

                <option value="RWF"
                    <%= "RWF".equals(preferredCurrency) ? "selected" : "" %>>
                    RWF
                </option>

            </select>
        </form>

        <% if (guestLoggedIn) { %>

            <a href="<%= contextPath %>/guest/dashboard"
               class="header-signin">
                My dashboard
            </a>

        <% } else { %>

            <a href="<%= contextPath %>/login.jsp"
               class="header-signin">
                Sign in
            </a>

        <% } %>

    </nav>

</header>


<!-- MAIN CONTENT -->

<main class="page-container">

    <section class="results-intro">

        <div class="intro-text">

            <p class="eyebrow">
                <span></span>
                YOUR LAKE KIVU JOURNEY BEGINS HERE
            </p>

            <h1>
                Find your place<br>
                <em>by the lake.</em>
            </h1>

            <p class="intro-description">
                Thoughtfully selected stays, beautiful surroundings
                and memorable experiences await you.
            </p>

        </div>

        <div class="intro-side">
            <span class="side-line"></span>
            <p>Discover. Stay. Experience.</p>
        </div>

    </section>


    <!-- SEARCH SUMMARY -->

    <section class="search-summary">

        <div class="summary-item">
            <span class="summary-label">DESTINATION</span>

            <strong>
                <%= location == null || location.trim().isEmpty()
                    ? "All destinations" : escapeHtml(location) %>
            </strong>
        </div>

        <div class="summary-divider"></div>

        <div class="summary-item">
            <span class="summary-label">CHECK-IN</span>
            <strong><%= escapeHtml(checkIn) %></strong>
        </div>

        <div class="summary-divider"></div>

        <div class="summary-item">
            <span class="summary-label">CHECK-OUT</span>
            <strong><%= escapeHtml(checkOut) %></strong>
        </div>

        <div class="summary-divider"></div>

        <div class="summary-item">
            <span class="summary-label">GUESTS</span>

            <strong>
                <%= guests == null ? "Not specified" : guests %>
            </strong>
        </div>

        <a href="<%= contextPath %>/index.html#staySearchSection"
           class="modify-search">
            Modify search
        </a>

    </section>


    <!-- ACCOMMODATION RESULTS -->

    <section class="results-section">

        <div class="results-heading">

            <div>
                <p class="eyebrow">EXPLORE OUR COLLECTION</p>

                <h2>Places to stay</h2>

                <p class="results-subtitle">
                    Find the right room for your next getaway.
                </p>
            </div>

            <div class="results-total">
                <strong><%= results.size() %></strong>
                <span>available rooms</span>
            </div>

        </div>


        <% if (results.isEmpty()) { %>

            <div class="empty-results">

                <div class="empty-icon">⌕</div>

                <p class="eyebrow">A LITTLE CHANGE CAN HELP</p>

                <h2>No rooms available just yet.</h2>

                <p>
                    We couldn't find accommodation matching these
                    travel details. Try another destination or
                    adjust your dates.
                </p>

                <a href="<%= contextPath %>/index.html#staySearchSection">
                    Explore other stays
                </a>

            </div>

        <% } else { %>

            <div class="results-grid">

                <% for (SearchResult room : results) {

                    String imageUrl = room.getImageUrl();

                    if (imageUrl != null && !imageUrl.trim().isEmpty()) {

                        imageUrl = imageUrl.trim();

                        if (!imageUrl.startsWith("http://")
                                && !imageUrl.startsWith("https://")) {

                            while (imageUrl.startsWith("/")) {
                                imageUrl = imageUrl.substring(1);
                            }

                            imageUrl = contextPath + "/" + imageUrl;
                        }
                    }

                    BigDecimal basePrice = room.getPricePerNight() == null
                        ? BigDecimal.ZERO : room.getPricePerNight();

                    BigDecimal convertedPrice =
                        basePrice.multiply(exchangeRate);

                %>

                    <article class="result-card">

                        <div class="result-image">

                            <% if (imageUrl != null && !imageUrl.isEmpty()) { %>

                                <img
                                    src="<%= escapeHtml(imageUrl) %>"
                                    alt="<%= escapeHtml(room.getHotelName()) %>"
                                    loading="lazy">

                            <% } else { %>

                                <div class="image-placeholder">
                                    <span>K</span>
                                    <p>KivuStay</p>
                                </div>

                            <% } %>

                            <span class="image-badge">
                                AVAILABLE
                            </span>

                        </div>


                        <div class="result-content">

                            <p class="hotel-location">
                                <span class="location-dot"></span>
                                <%= escapeHtml(room.getLocation()) %>
                            </p>

                            <h3>
                                <%= escapeHtml(room.getHotelName()) %>
                            </h3>

                            <p class="room-name">
                                <%= escapeHtml(room.getRoomName()) %>
                            </p>

                            <% if (room.getDescription() != null
                                    && !room.getDescription().trim().isEmpty()) { %>

                                <p class="hotel-description">
                                    <%= escapeHtml(room.getDescription()) %>
                                </p>

                            <% } %>


                            <div class="room-information">

                                <div class="room-info-item">
                                    <span class="info-icon">⌂</span>

                                    <span>
                                        Room <%= escapeHtml(room.getRoomNumber()) %>
                                    </span>
                                </div>

                                <div class="room-info-item">
                                    <span class="info-icon">♙</span>

                                    <span>
                                        Up to <%= room.getCapacity() %> guests
                                    </span>
                                </div>

                            </div>


                            <div class="card-bottom">

                                <div class="price">

                                    <span class="price-label">
                                        STARTING FROM
                                    </span>

                                    <strong class="converted-price"
                                            data-base-usd="<%= basePrice.toPlainString() %>">

                                        <%= currencySymbol %><%= priceFormat.format(convertedPrice) %>

                                    </strong>

                                    <span class="price-period">
                                        per night
                                    </span>

                                </div>

                                <span class="availability">
                                    Available
                                </span>

                            </div>


                            <!-- ADD TO TRIP PLANNER -->

                            <div class="planner-action">

                                <button
                                    type="button"
                                    class="add-to-planner-button"
                                    data-room-id="<%= room.getRoomId() %>"
                                    data-hotel-name="<%= escapeHtml(room.getHotelName()) %>"
                                    data-room-name="<%= escapeHtml(room.getRoomName()) %>"
                                    data-location="<%= escapeHtml(room.getLocation()) %>"
                                    data-check-in="<%= escapeHtml(checkIn) %>"
                                    data-check-out="<%= escapeHtml(checkOut) %>"
                                    data-price="<%= basePrice.toPlainString() %>">

                                    + Add to Trip Planner

                                </button>

                                <p class="planner-feedback"
                                   aria-live="polite"></p>

                            </div>


                            <!-- BOOKING ACTION -->

                            <div class="booking-action">

                                <% if (guestLoggedIn) { %>

                                    <form
                                        action="<%= contextPath %>/guest/book"
                                        method="POST">

                                        <input
                                            type="hidden"
                                            name="roomId"
                                            value="<%= room.getRoomId() %>">

                                        <input
                                            type="hidden"
                                            name="checkIn"
                                            value="<%= escapeHtml(checkIn) %>">

                                        <input
                                            type="hidden"
                                            name="checkOut"
                                            value="<%= escapeHtml(checkOut) %>">

                                        <input
                                            type="hidden"
                                            name="guests"
                                            value="<%= guests == null ? 1 : guests %>">

                                        <button
                                            type="submit"
                                            class="book-room-button">

                                            Book this room →

                                        </button>

                                    </form>

                                    <p class="booking-note">
                                        Your reservation will be checked before confirmation.
                                    </p>

                                <% } else { %>

                                    <a
                                        href="<%= contextPath %>/login.jsp"
                                        class="booking-login-link">

                                        Sign in to book →

                                    </a>

                                    <p class="booking-note">
                                        A guest account is required to make a reservation.
                                    </p>

                                <% } %>

                            </div>

                        </div>

                    </article>

                <% } %>

            </div>

        <% } %>

    </section>

</main>


<!-- FOOTER -->

<footer class="results-footer">

    <div class="footer-brand">
        KivuStay
    </div>

    <p>
        Discover the beauty of Lake Kivu.
    </p>

    <span>
        © 2026 KivuStay. All rights reserved.
    </span>

</footer>


<!-- EXISTING FUNCTIONALITY -->

<script src="<%= contextPath %>/js/availability-check.js" defer></script>
<script src="<%= contextPath %>/js/booking-ajax.js" defer></script>


<!-- TRIP PLANNER MVC -->

<script src="<%= contextPath %>/trip-planner/TripPlannerCalculations.js"></script>
<script src="<%= contextPath %>/trip-planner/TripPlannerModel.js"></script>
<script src="<%= contextPath %>/trip-planner/TripPlannerView.js"></script>
<script src="<%= contextPath %>/trip-planner/TripPlannerController.js"></script>


<!-- PRICE QUOTATION AND TRIP PLANNER -->

<script>
document.addEventListener("DOMContentLoaded", function () {

    // Selected currency and exchange rates.
    var selectedCurrency = "<%= preferredCurrency %>";

    var exchangeRates = {
        USD: 1,
        EUR: 0.91755,
        CDF: 2316.57,
        RWF: 1473.99
    };

    var currencySymbols = {
        USD: "$",
        EUR: "€",
        CDF: "FC",
        RWF: "RF"
    };

    var decimalPlaces = {
        USD: 2,
        EUR: 2,
        CDF: 0,
        RWF: 0
    };

    function formatMoney(usdAmount) {

        var rate = exchangeRates[selectedCurrency] || 1;
        var convertedAmount = Number(usdAmount) * rate;

        var formattedAmount = new Intl.NumberFormat("en-US", {
            minimumFractionDigits: decimalPlaces[selectedCurrency],
            maximumFractionDigits: decimalPlaces[selectedCurrency]
        }).format(convertedAmount);

        return currencySymbols[selectedCurrency] + formattedAmount;
    }


    // Update displayed room prices.
    document.querySelectorAll(".converted-price").forEach(function (element) {

        var baseUsd = Number(element.dataset.baseUsd);

        if (Number.isFinite(baseUsd)) {
            element.textContent = formatMoney(baseUsd);
        }
    });


    // PRICE QUOTATION

    document.querySelectorAll(".result-card").forEach(function (card) {

        var form = card.querySelector('form[action*="/guest/book"]');

        if (!form) return;

        var roomId = form.querySelector('[name="roomId"]').value;
        var checkIn = form.querySelector('[name="checkIn"]').value;
        var checkOut = form.querySelector('[name="checkOut"]').value;

        var box = document.createElement("div");

        box.className = "quote-box";

        box.innerHTML =
            '<p class="quote-title">YOUR PRICE QUOTE</p>' +
            '<p class="quote-status">Calculating your stay...</p>';

        card.querySelector(".booking-action").before(box);

        var url = "<%= contextPath %>/quote"
            + "?roomId=" + encodeURIComponent(roomId)
            + "&checkIn=" + encodeURIComponent(checkIn)
            + "&checkOut=" + encodeURIComponent(checkOut);

        var xhr = new XMLHttpRequest();

        xhr.open("GET", url, true);
        xhr.setRequestHeader("Accept", "application/json");

        xhr.onload = function () {

            var data;

            try {
                data = JSON.parse(xhr.responseText);
            } catch (e) {
                box.querySelector(".quote-status").textContent =
                    "Unable to read quote.";
                return;
            }

            if (xhr.status !== 200 || !data.success) {

                box.querySelector(".quote-status").textContent =
                    data.message || "Unable to calculate quote.";

                return;
            }

            box.innerHTML =
                '<p class="quote-title">YOUR PRICE QUOTE</p>' +

                '<div class="quote-line"><span>Duration</span><strong>' +
                data.nights + ' nights</strong></div>' +

                '<div class="quote-line"><span>Subtotal</span><strong>' +
                formatMoney(data.subtotal) + '</strong></div>' +

                '<div class="quote-line"><span>Tax (10%)</span><strong>' +
                formatMoney(data.tax) + '</strong></div>' +

                '<div class="quote-total"><span>Total price</span><strong>' +
                formatMoney(data.total) + '</strong></div>';
        };

        xhr.onerror = function () {

            box.querySelector(".quote-status").textContent =
                "Network error. Please try again.";
        };

        xhr.send();
    });


    // TRIP PLANNER

    document.querySelectorAll(".add-to-planner-button")
    .forEach(function (button) {

        button.addEventListener("click", function () {

            var stay = {
                roomId: button.dataset.roomId,
                hotelName: button.dataset.hotelName,
                roomName: button.dataset.roomName,
                location: button.dataset.location,
                checkIn: button.dataset.checkIn,
                checkOut: button.dataset.checkOut,

                // Keep the original USD amount in Trip Planner data.
                pricePerNight: Number(button.dataset.price)
            };

            var result = TripPlannerController.addStay(stay);

            var feedback = button.parentElement.querySelector(
                ".planner-feedback"
            );

            if (feedback) {

                feedback.textContent = result.message;

                feedback.classList.toggle(
                    "success-message",
                    result.success
                );

                feedback.classList.toggle(
                    "error-message",
                    !result.success
                );
            }
        });
    });

});
</script>

</body>
</html>