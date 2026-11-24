<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
    String contextPath = request.getContextPath();

    List<Map<String, Object>> bookings =
        (List<Map<String, Object>>) request.getAttribute("bookings");

    int totalBookings =
        (Integer) request.getAttribute("totalBookings");

    int pendingBookings =
        (Integer) request.getAttribute("pendingBookings");

    int confirmedBookings =
        (Integer) request.getAttribute("confirmedBookings");

    int cancelledBookings =
        (Integer) request.getAttribute("cancelledBookings");

    NumberFormat currencyFormat =
        NumberFormat.getNumberInstance(Locale.US);

    currencyFormat.setMinimumFractionDigits(2);
    currencyFormat.setMaximumFractionDigits(2);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Reservations | KivuStay Manager</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager-dashboard.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager-reservations.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<div class="dashboard-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="sidebar-brand">
            <div class="brand-icon">
                <i class="fa-solid fa-water"></i>
            </div>

            <div class="brand-text">
                <h2>KivuStay</h2>
                <span>MANAGER PORTAL</span>
            </div>
        </div>

        <nav class="sidebar-nav">

            <span class="nav-section-title">WORKSPACE</span>

            <a href="<%= contextPath %>/manager/dashboard"
               class="nav-link">
                <i class="fa-solid fa-chart-pie"></i>
                <span>Overview</span>
            </a>

            <a href="<%= contextPath %>/manager/hotels"
               class="nav-link">
                <i class="fa-solid fa-hotel"></i>
                <span>My Hotels</span>
            </a>

            <a href="<%= contextPath %>/manager/rooms"
               class="nav-link">
                <i class="fa-solid fa-bed"></i>
                <span>Room Management</span>
            </a>

            <a href="<%= contextPath %>/manager/bookings"
               class="nav-link active">
                <i class="fa-solid fa-calendar-check"></i>
                <span>Reservations</span>
            </a>

            <a href="<%= contextPath %>/manager/dashboard#analytics"
               class="nav-link">
                <i class="fa-solid fa-chart-line"></i>
                <span>Analytics</span>
            </a>

        </nav>

        <div class="sidebar-bottom">
            <a href="<%= contextPath %>/logout"
               class="nav-link logout-link">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Sign Out</span>
            </a>
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <header class="topbar">

            <div class="topbar-left">

                <button type="button"
                        class="mobile-menu-btn"
                        id="mobileMenuBtn"
                        aria-label="Open navigation">
                    <i class="fa-solid fa-bars"></i>
                </button>

                <div>
                    <span class="breadcrumb">
                        Workspace / Reservations
                    </span>

                    <h1>Reservations</h1>
                </div>

            </div>

            <div class="topbar-right">

                <span class="manager-label">
                    <i class="fa-solid fa-user-shield"></i>
                    Hotel Manager
                </span>

            </div>

        </header>
        <!-- PAGE CONTENT -->
        <section class="page-content">

            <div class="page-heading">

                <div>
                    <span class="section-eyebrow">
                        BOOKING MANAGEMENT
                    </span>

                    <h2>All Reservations</h2>

                    <p>
                        Monitor guest reservations across your properties
                        and keep track of your accommodation activity.
                    </p>
                </div>

                <div class="reservation-date">
                    <i class="fa-regular fa-calendar"></i>
                    <span>Reservation Overview</span>
                </div>

            </div>


            <!-- STATISTICS -->
            <div class="reservation-stats">

                <div class="reservation-stat-card">

                    <div class="stat-card-top">
                        <span>Total Reservations</span>

                        <div class="stat-icon total-icon">
                            <i class="fa-solid fa-calendar-check"></i>
                        </div>
                    </div>

                    <h3><%= totalBookings %></h3>

                    <span class="stat-description">
                        All recorded bookings
                    </span>

                </div>


                <div class="reservation-stat-card">

                    <div class="stat-card-top">
                        <span>Pending</span>

                        <div class="stat-icon pending-icon">
                            <i class="fa-regular fa-clock"></i>
                        </div>
                    </div>

                    <h3><%= pendingBookings %></h3>

                    <span class="stat-description">
                        Awaiting confirmation
                    </span>

                </div>


                <div class="reservation-stat-card">

                    <div class="stat-card-top">
                        <span>Confirmed</span>

                        <div class="stat-icon confirmed-icon">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                    </div>

                    <h3><%= confirmedBookings %></h3>

                    <span class="stat-description">
                        Confirmed reservations
                    </span>

                </div>


                <div class="reservation-stat-card">

                    <div class="stat-card-top">
                        <span>Cancelled</span>

                        <div class="stat-icon cancelled-icon">
                            <i class="fa-solid fa-circle-xmark"></i>
                        </div>
                    </div>

                    <h3><%= cancelledBookings %></h3>

                    <span class="stat-description">
                        Cancelled reservations
                    </span>

                </div>

            </div>


            <!-- RESERVATIONS SECTION -->
            <section class="reservations-section">

                <div class="reservations-section-header">

                    <div>
                        <h3>Reservation Records</h3>

                        <p>
                            View and monitor bookings made by your guests.
                        </p>
                    </div>

                    <div class="reservation-count">
                        <span id="visibleReservationCount">
                            <%= totalBookings %>
                        </span>
                        <span>reservations</span>
                    </div>

                </div>
                <!-- TABLE TOOLBAR -->
                <div class="reservation-toolbar">

                    <div class="reservation-search">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <input type="search"
                               id="reservationSearch"
                               placeholder="Search guest, hotel, room or booking ID..."
                               autocomplete="off">

                    </div>

                    <div class="reservation-filter">

                        <i class="fa-solid fa-filter"></i>

                        <select id="statusFilter"
                                aria-label="Filter by booking status">

                            <option value="ALL">All Statuses</option>
                            <option value="PENDING">Pending</option>
                            <option value="CONFIRMED">Confirmed</option>
                            <option value="CANCELLED">Cancelled</option>

                        </select>

                    </div>

                </div>


                <!-- RESERVATIONS TABLE -->
                <div class="reservation-table-wrapper">

                    <table class="reservation-table">

                        <thead>
                            <tr>
                                <th>BOOKING</th>
                                <th>GUEST</th>
                                <th>ACCOMMODATION</th>
                                <th>STAY DATES</th>
                                <th>GUESTS</th>
                                <th>AMOUNT</th>
                                <th>STATUS</th>
                            </tr>
                        </thead>

                        <tbody id="reservationTableBody">

                        <% if (bookings != null && !bookings.isEmpty()) { %>

                            <% for (Map<String, Object> booking : bookings) {

                                int bookingId =
                                    (Integer) booking.get("bookingId");

                                String guestName =
                                    (String) booking.get("guestName");

                                String guestEmail =
                                    (String) booking.get("guestEmail");

                                String hotelName =
                                    (String) booking.get("hotelName");

                                String roomNumber =
                                    (String) booking.get("roomNumber");

                                String roomName =
                                    (String) booking.get("roomName");

                                Object checkIn =
                                    booking.get("checkIn");

                                Object checkOut =
                                    booking.get("checkOut");

                                int numberOfGuests =
                                    (Integer) booking.get("numberOfGuests");

                                BigDecimal amount =
                                    (BigDecimal) booking.get("totalAmount");

                                String status =
                                    (String) booking.get("bookingStatus");

                                String statusClass =
                                    "status-" + status.toLowerCase(Locale.ROOT);

                            %>

                            <tr class="reservation-row"
                                data-status="<%= status %>">

                                <td>
                                    <span class="booking-reference">
                                        #KS-<%= bookingId %>
                                    </span>
                                </td>

                                <td>
                                    <div class="guest-cell">
                                        <strong>
                                            <%= guestName %>
                                        </strong>

                                        <span>
                                            <%= guestEmail %>
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <div class="accommodation-cell">
                                        <strong>
                                            <%= hotelName %>
                                        </strong>

                                        <span>
                                            <%= roomName %> · Room
                                            <%= roomNumber %>
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <div class="stay-dates">
                                        <span>
                                            <%= checkIn %>
                                        </span>

                                        <i class="fa-solid fa-arrow-right"></i>

                                        <span>
                                            <%= checkOut %>
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <span class="guest-count">
                                        <i class="fa-solid fa-user"></i>
                                        <%= numberOfGuests %>
                                    </span>
                                </td>

                                <td>
                                    <strong class="booking-amount">
                                        $<%= currencyFormat.format(amount) %>
                                    </strong>
                                </td>

                                <td>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= status %>
                                    </span>
                                </td>

                            </tr>

                            <% } %>

                        <% } %>

                        </tbody>

                    </table>

                </div>
                <!-- EMPTY DATABASE STATE -->
                <% if (bookings == null || bookings.isEmpty()) { %>

                    <div class="reservation-empty-state">

                        <div class="empty-icon">
                            <i class="fa-regular fa-calendar-xmark"></i>
                        </div>

                        <h3>No reservations yet</h3>

                        <p>
                            When guests book rooms at your properties,
                            their reservations will appear here.
                        </p>

                    </div>

                <% } %>


                <!-- NO SEARCH RESULTS -->
                <div class="reservation-empty-state no-search-results"
                     id="noReservationResults"
                     style="display: none;">

                    <div class="empty-icon">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </div>

                    <h3>No matching reservations</h3>

                    <p>
                        Try changing your search term or reservation status filter.
                    </p>

                </div>


            </section>

        </section>

    </main>

</div>


<!-- PAGE JAVASCRIPT -->
<script src="<%= contextPath %>/js/manager-reservations.js"></script>

</body>
</html>