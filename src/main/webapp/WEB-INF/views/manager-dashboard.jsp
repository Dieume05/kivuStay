<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String textValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private int intValue(Object value) {
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        return 0;
    }

    private double doubleValue(Object value) {
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        return 0.0;
    }

    private String moneyValue(Object value) {
        NumberFormat formatter =
            NumberFormat.getNumberInstance(Locale.US);

        formatter.setMinimumFractionDigits(2);
        formatter.setMaximumFractionDigits(2);

        return formatter.format(doubleValue(value));
    }

    private String initials(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "M";
        }

        String[] parts = name.trim().split("\\s+");

        if (parts.length == 1) {
            return parts[0].substring(0, 1).toUpperCase();
        }

        return (parts[0].substring(0, 1)
                + parts[parts.length - 1].substring(0, 1))
                .toUpperCase();
    }

    private String dateValue(Object value) {
        if (value == null) return "—";

        if (value instanceof java.util.Date) {
            return new SimpleDateFormat("dd MMM yyyy")
                    .format((java.util.Date) value);
        }

        return escapeHtml(String.valueOf(value));
    }
%>

<%
    Map<String, Object> summary =
        (Map<String, Object>) request.getAttribute("dashboardSummary");

    if (summary == null) {
        summary = new HashMap<String, Object>();
    }

    List<Map<String, Object>> recentBookings =
        (List<Map<String, Object>>) request.getAttribute("recentBookings");

    if (recentBookings == null) {
        recentBookings = new ArrayList<>();
    }

    String managerName =
        textValue(session.getAttribute("fullName"));

    if (managerName.trim().isEmpty()) {
        managerName = "Manager";
    }

    String managerInitials = initials(managerName);

    int totalHotels = intValue(summary.get("totalHotels"));
    int totalRooms = intValue(summary.get("totalRooms"));
    int totalBookings = intValue(summary.get("totalBookings"));
    int availableRooms = intValue(summary.get("availableRooms"));
    int pendingBookings = intValue(summary.get("pendingBookings"));

    Object totalRevenue = summary.get("totalRevenue");

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Manager Dashboard | KivuStay</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:wght@500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= contextPath %>/css/manager-dashboard.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

<div class="dashboard-layout">

    <!-- SIDEBAR -->

    <aside class="sidebar">

        <div class="sidebar-brand">
            <a href="<%= contextPath %>/manager/dashboard"
               class="brand-name">
                Kivu<span>Stay</span>
            </a>

            <p class="brand-caption">
                HOSPITALITY MANAGEMENT
            </p>
        </div>

        <div class="sidebar-section-label">
            WORKSPACE
        </div>

        <nav class="sidebar-nav">

            <a href="<%= contextPath %>/manager/dashboard"
               class="nav-item active">
                <span class="nav-icon">⌂</span>
                <span>Overview</span>
            </a>

            <a href="<%= contextPath %>/manager/hotels"
               class="nav-item">
                <span class="nav-icon">▦</span>
                <span>My Hotels</span>
            </a>

            <a href="<%= contextPath %>/manager/rooms"
               class="nav-item">
                <span class="nav-icon">▤</span>
                <span>Room Management</span>
            </a>

            <a href="<%= contextPath %>/manager/bookings"
               class="nav-item">
                <span class="nav-icon">▧</span>
                <span>Reservations</span>
            </a>

        </nav>

        <div class="sidebar-section-label">
            BUSINESS
        </div>

        <nav class="sidebar-nav">

            <a href="<%= contextPath %>/manager/dashboard#analytics"
               class="nav-item">
                <span class="nav-icon">◫</span>
                <span>Analytics</span>
            </a>

        </nav>

        <div class="sidebar-bottom">

            <div class="sidebar-help">
                <div class="help-icon">✦</div>

                <div>
                    <strong>Need assistance?</strong>
                    <p>Manage your property with confidence.</p>
                </div>
            </div>

            <a href="<%= contextPath %>/logout"
               class="logout-link">
                <span>↗</span>
                Sign out
            </a>

            <div class="sidebar-copyright">
                © 2026 KivuStay
            </div>

        </div>

    </aside>

    <!-- MAIN CONTENT -->

    <main class="main-content">

        <!-- TOP HEADER -->

        <header class="top-header">

            <div class="header-heading">
                <p class="eyebrow">
                    YOUR HOSPITALITY, YOUR BUSINESS
                </p>

                <h1>Dashboard Overview</h1>

                <p class="header-description">
                    Welcome back, <%= escapeHtml(managerName) %>.
                    Here's what's happening with your properties.
                </p>
            </div>

            <div class="header-profile">

                <div class="profile-avatar">
                    <%= escapeHtml(managerInitials) %>
                </div>

                <div class="profile-information">
                    <strong>
                        <%= escapeHtml(managerName) %>
                    </strong>

                    <span>Property Manager</span>
                </div>

            </div>

        </header>

        <!-- DASHBOARD INTRODUCTION -->

        <section class="welcome-banner">

            <div class="welcome-content">

                <span class="welcome-label">
                    KIVUSTAY MANAGEMENT
                </span>

                <h2>
                    Every stay begins<br>
                    with a great experience.
                </h2>

                <p>
                    Your properties, guests and reservations,
                    all in one place.
                </p>

            </div>

            <div class="welcome-decoration">
                <span class="decoration-circle circle-one"></span>
                <span class="decoration-circle circle-two"></span>
                <span class="decoration-circle circle-three"></span>
                <span class="decoration-text">KIVU</span>
            </div>

        </section>

        <!-- KEY BUSINESS STATISTICS -->

        <section class="statistics-section">

            <div class="section-heading">
                <div>
                    <p class="eyebrow">AT A GLANCE</p>
                    <h2>Business Overview</h2>
                </div>

                <span class="section-caption">
                    Your business summary
                </span>
            </div>

            <div class="statistics-grid">

                <article class="stat-card">

                    <div class="stat-top">
                        <span class="stat-label">Total Properties</span>
                        <span class="stat-icon icon-navy">⌂</span>
                    </div>

                    <div class="stat-number">
                        <%= totalHotels %>
                    </div>

                    <p class="stat-description">
                        Hotels under your management
                    </p>

                </article>

                <article class="stat-card">

                    <div class="stat-top">
                        <span class="stat-label">Total Rooms</span>
                        <span class="stat-icon icon-teal">▤</span>
                    </div>

                    <div class="stat-number">
                        <%= totalRooms %>
                    </div>

                    <p class="stat-description">
                        <%= availableRooms %> currently available
                    </p>

                </article>

                <article class="stat-card">

                    <div class="stat-top">
                        <span class="stat-label">Total Reservations</span>
                        <span class="stat-icon icon-sand">▧</span>
                    </div>

                    <div class="stat-number">
                        <%= totalBookings %>
                    </div>

                    <p class="stat-description">
                        <%= pendingBookings %> awaiting confirmation
                    </p>

                </article>

                <article class="stat-card revenue-card">

                    <div class="stat-top">
                        <span class="stat-label">Confirmed Revenue</span>
                        <span class="stat-icon icon-revenue">◆</span>
                    </div>

                    <div class="stat-number revenue-number">
                        $<%= moneyValue(totalRevenue) %>
                    </div>

                    <p class="stat-description">
                        From confirmed reservations
                    </p>

                </article>

            </div>

        </section>

        <!-- ANALYTICS SECTION -->

        <section class="analytics-section" id="analytics">

            <div class="section-heading">
                <div>
                    <p class="eyebrow">PERFORMANCE INSIGHTS</p>
                    <h2>Business Analytics</h2>
                </div>

                <span class="section-caption">
                    Based on your reservation data
                </span>
            </div>

            <div class="analytics-grid">

                <!-- OCCUPANCY PER HOTEL - BAR CHART -->

                <article class="analytics-card">

                    <div class="card-heading">
                        <div>
                            <h3>Occupancy per Hotel</h3>
                            <p>Percentage of occupied rooms by property</p>
                        </div>

                        <span class="chart-icon">▥</span>
                    </div>

                    <div class="chart-area chart-revenue">
                        <canvas id="occupancyPerHotelChart"></canvas>
                    </div>

                    <div class="chart-footer">
                        <span>
                            <i class="legend-dot dot-confirmed"></i>
                            Occupancy rate (%)
                        </span>
                    </div>

                </article>

                <!-- BOOKINGS PER MONTH - LINE CHART -->

                <article class="analytics-card">

                    <div class="card-heading">
                        <div>
                            <h3>Bookings per Month</h3>
                            <p>Monthly reservation activity</p>
                        </div>

                        <span class="chart-icon">⌁</span>
                    </div>

                    <div class="chart-area chart-revenue">
                        <canvas id="bookingsPerMonthChart"></canvas>
                    </div>

                    <div class="chart-footer">
                        <span>
                            <i class="legend-dot dot-confirmed"></i>
                            Total bookings
                        </span>
                    </div>

                </article>

                <!-- ROOM TYPE SHARE - PIE CHART -->

                <article class="analytics-card revenue-analytics">

                    <div class="card-heading">
                        <div>
                            <h3>Room Type Share</h3>
                            <p>Distribution of rooms across your room categories</p>
                        </div>

                        <span class="chart-icon">◉</span>
                    </div>

                    <div class="chart-area chart-doughnut">
                        <canvas id="roomTypeShareChart"></canvas>
                    </div>

                </article>

            </div>

        </section>

        <!-- RECENT RESERVATIONS -->

        <section class="reservations-section">

            <div class="section-heading">
                <div>
                    <p class="eyebrow">GUEST ACTIVITY</p>
                    <h2>Recent Reservations</h2>
                </div>

                <a href="<%= contextPath %>/manager/bookings"
                   class="view-all-link">
                    View all reservations
                    <span>→</span>
                </a>
            </div>

            <div class="reservations-card">

                <div class="reservations-card-header">

                    <div>
                        <h3>Latest bookings</h3>
                        <p>
                            The most recent reservations
                            made at your properties.
                        </p>
                    </div>

                    <span class="reservation-count">
                        <%= recentBookings.size() %> records
                    </span>

                </div>

                <div class="table-responsive">

                    <table class="reservations-table">

                        <thead>
                            <tr>
                                <th>GUEST</th>
                                <th>PROPERTY</th>
                                <th>ROOM</th>
                                <th>STAY</th>
                                <th>AMOUNT</th>
                                <th>STATUS</th>
                            </tr>
                        </thead>

                        <tbody>

                        <%
                            if (recentBookings.isEmpty()) {
                        %>

                            <tr>
                                <td colspan="6">
                                    <div class="empty-reservations">
                                        <span class="empty-icon">▧</span>

                                        <strong>No reservations yet</strong>

                                        <p>
                                            New guest reservations
                                            will appear here.
                                        </p>
                                    </div>
                                </td>
                            </tr>

                        <%
                            } else {
                                for (Map<String, Object> booking : recentBookings) {

                                    String guestName =
                                        textValue(booking.get("guestName"));

                                    String guestEmail =
                                        textValue(booking.get("guestEmail"));

                                    String hotelName =
                                        textValue(booking.get("hotelName"));

                                    String roomNumber =
                                        textValue(booking.get("roomNumber"));

                                    String roomName =
                                        textValue(booking.get("roomName"));

                                    String status =
                                        textValue(booking.get("bookingStatus"))
                                        .toUpperCase(Locale.ROOT);

                                    String checkIn =
                                        dateValue(booking.get("checkIn"));

                                    String checkOut =
                                        dateValue(booking.get("checkOut"));

                                    String amount =
                                        moneyValue(booking.get("totalAmount"));

                                    String statusClass =
                                        status.matches("PENDING|CONFIRMED|CANCELLED")
                                        ? status : "PENDING";
                        %>

                            <tr>

                                <td>
                                    <div class="guest-cell">

                                        <div class="guest-avatar">
                                            <%= escapeHtml(initials(guestName)) %>
                                        </div>

                                        <div class="guest-details">

                                            <strong>
                                                <%= escapeHtml(guestName) %>
                                            </strong>

                                            <span>
                                                <%= escapeHtml(guestEmail) %>
                                            </span>

                                        </div>

                                    </div>
                                </td>

                                <td>
                                    <span class="property-name">
                                        <%= escapeHtml(hotelName) %>
                                    </span>
                                </td>

                                <td>
                                    <div class="room-details">

                                        <strong>
                                            <%= escapeHtml(roomNumber) %>
                                        </strong>

                                        <span>
                                            <%= escapeHtml(roomName) %>
                                        </span>

                                    </div>
                                </td>

                                <td>
                                    <div class="stay-details">
                                        <strong>
                                            <%= escapeHtml(checkIn) %>
                                        </strong>

                                        <span>
                                            to <%= escapeHtml(checkOut) %>
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <strong class="booking-amount">
                                        $<%= escapeHtml(amount) %>
                                    </strong>
                                </td>

                                <td>
                                    <span class="status-badge status-<%= statusClass %>">
                                        <%= escapeHtml(status) %>
                                    </span>
                                </td>

                            </tr>

                        <%
                                }
                            }
                        %>

                        </tbody>

                    </table>

                </div>

                <div class="reservations-card-footer">
                    Showing up to 10 most recent reservations
                </div>

            </div>

        </section>

        <!-- DASHBOARD FOOTER -->

        <footer class="dashboard-footer">

            <div>
                <strong>KivuStay</strong>
                <span>Hospitality Management Platform</span>
            </div>

            <p>
                © 2026 KivuStay. All rights reserved.
            </p>

            <span class="footer-tagline">
                Made for memorable stays.
            </span>

        </footer>

    </main>

</div>

<!-- DYNAMIC CHARTS -->

<script src="<%= contextPath %>/js/manager-dashboard.js"></script>

</body>
</html>