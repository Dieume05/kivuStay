<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.kivustay.model.Booking" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }

    private String getHotelImage(
            Booking booking, String contextPath) {

        if (booking.getImageUrl() != null &&
            !booking.getImageUrl().trim().isEmpty()) {
            return booking.getImageUrl();
        }

        String hotelName = booking.getHotelName();

        if (hotelName != null) {
            if (hotelName.equalsIgnoreCase("Lake View Resort")) {
                return contextPath + "/images/hotel-kibuye.jpeg";
            }

            if (hotelName.equalsIgnoreCase("Kivu Paradise Hotel")) {
                return contextPath + "/images/hotel-goma2.jpeg";
            }

            if (hotelName.equalsIgnoreCase("Serenity Lakeside Lodge")) {
                return contextPath + "/images/hotel-karongi.jpeg";
            }
        }

        return contextPath + "/images/hotel-goma.jpeg";
    }

    private String getStatusClass(String status) {
        if ("CONFIRMED".equalsIgnoreCase(status)) {
            return "confirmed";
        }

        if ("CANCELLED".equalsIgnoreCase(status)) {
            return "cancelled";
        }

        return "pending";
    }

    private boolean canCancelBooking(
            Booking booking, LocalDate today) {

        String status = booking.getBookingStatus();

        boolean validStatus =
            "PENDING".equalsIgnoreCase(status) ||
            "CONFIRMED".equalsIgnoreCase(status);

        boolean validDate =
            booking.getCheckIn() != null &&
            !booking.getCheckIn().toLocalDate().isBefore(today);

        return validStatus && validDate;
    }
%>

<%
    String fullName = (String) session.getAttribute("fullName");

    if (fullName == null || fullName.trim().isEmpty()) {
        fullName = "Traveller";
    }

    String firstName = fullName.split("\\s+")[0];

    String initials = "";
    String[] nameParts = fullName.trim().split("\\s+");

    for (String part : nameParts) {
        if (!part.isEmpty()) {
            initials += part.substring(0, 1).toUpperCase();
        }
    }

    if (initials.length() > 2) {
        initials = initials.substring(0, 2);
    }

    List<Booking> bookings =
        (List<Booking>) request.getAttribute("bookings");

    if (bookings == null) {
        bookings = new java.util.ArrayList<>();
    }

    Booking selectedBooking =
        (Booking) request.getAttribute("selectedBooking");

    boolean detailsView = selectedBooking != null;

    int totalBookings = bookings.size();
    int upcomingTrips = 0;

    LocalDate today = LocalDate.now();

    DateTimeFormatter dateFormatter =
        DateTimeFormatter.ofPattern("dd MMM yyyy");

    SimpleDateFormat detailDateFormatter =
        new SimpleDateFormat("dd MMMM yyyy");

    for (Booking booking : bookings) {
        if (booking.getCheckOut() != null &&
            !booking.getCheckOut().toLocalDate().isBefore(today) &&
            !"CANCELLED".equalsIgnoreCase(
                booking.getBookingStatus())) {

            upcomingTrips++;
        }
    }

    String selectedStatus = detailsView
        ? selectedBooking.getBookingStatus()
        : "";

    String selectedImage = detailsView
        ? getHotelImage(selectedBooking, request.getContextPath())
        : "";

    String selectedCheckIn =
        detailsView && selectedBooking.getCheckIn() != null
        ? detailDateFormatter.format(selectedBooking.getCheckIn())
        : "Not available";

    String selectedCheckOut =
        detailsView && selectedBooking.getCheckOut() != null
        ? detailDateFormatter.format(selectedBooking.getCheckOut())
        : "Not available";

    String cancelMessage = request.getParameter("cancel");

    boolean cancelSuccess = "success".equals(cancelMessage);
    boolean cancelFailed = "failed".equals(cancelMessage);

    boolean selectedCanCancel =
        detailsView && canCancelBooking(selectedBooking, today);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>
        <%= detailsView ? "Booking Details" : "My Dashboard" %>
        | KivuStay
    </title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/dashboard.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/bookings-details.css">

    <!-- Styles only for the new cancellation feature -->
    <style>
        .cancellation-notice {
            padding: 14px 18px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-size: 14px;
        }

        .cancellation-notice.success {
            background: #e9f7ef;
            color: #176b40;
            border: 1px solid #b9e4cb;
        }

        .cancellation-notice.error {
            background: #fff0ee;
            color: #a9362a;
            border: 1px solid #f0c4bd;
        }

        .cancel-booking-button {
            background: #fff0ee;
            color: #a9362a;
            border: 1px solid #e5b8b2;
            border-radius: 6px;
            padding: 9px 13px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .cancel-booking-button:hover {
            background: #a9362a;
            color: #fff;
        }

        .cancelled-note {
            color: #8a5250;
            font-size: 13px;
            font-weight: 600;
        }
    </style>
</head>

<body>

<div class="dashboard-layout">

    <!-- SIDEBAR -->
   <aside class="sidebar">

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/index.html"
       class="sidebar-brand">
        <span class="brand-icon">K</span>
        <span class="brand-name">KivuStay</span>
    </a>

    <!-- Main navigation -->
    <div class="sidebar-section">

        <span class="sidebar-label">WORKSPACE</span>

        <nav class="sidebar-nav">

            <a href="${pageContext.request.contextPath}/guest/dashboard"
               class="nav-link <%= detailsView ? "" : "active" %>">
                <span class="nav-icon">⌂</span>
                <span class="nav-text">Overview</span>
                <% if (!detailsView) { %>
                    <span class="active-indicator"></span>
                <% } %>
            </a>

            <a href="${pageContext.request.contextPath}/guest/dashboard#my-trips"
               class="nav-link <%= detailsView ? "active" : "" %>">
                <span class="nav-icon">▣</span>
                <span class="nav-text">My trips</span>
                <% if (detailsView) { %>
                    <span class="active-indicator"></span>
                <% } %>
            </a>

            <a href="${pageContext.request.contextPath}/index.html#staySearchForm"
               class="nav-link">
                <span class="nav-icon">⌕</span>
                <span class="nav-text">Explore stays</span>
            </a>

            <a href="${pageContext.request.contextPath}/guest/dashboard#trip-planner"
               class="nav-link">
                <span class="nav-icon">✧</span>
                <span class="nav-text">Trip planner</span>
            </a>

        </nav>
    </div>

    <!-- Bottom section -->
    <div class="sidebar-bottom">

        <div class="sidebar-help">
            <div class="help-icon">?</div>

            <div class="help-content">
                <strong>Need assistance?</strong>
                <p>We're always here to help.</p>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/logout"
              method="POST">

            <button type="submit" class="logout-button">
                <span class="logout-icon">↪</span>
                <span>Sign out</span>
            </button>

        </form>

        <div class="sidebar-version">
            KIVUSTAY · YOUR LAKE KIVU EXPERIENCE
        </div>

    </div>

</aside>

    <!-- MAIN CONTENT -->
    <main class="dashboard-main">

        <!-- TOP BAR -->
        <header class="dashboard-topbar">

            <div class="breadcrumb">
                <span>Workspace</span>
                <span class="breadcrumb-separator">/</span>

                <% if (detailsView) { %>
                    <a href="${pageContext.request.contextPath}/guest/dashboard">
                        Dashboard
                    </a>
                    <span class="breadcrumb-separator">/</span>
                    <strong>Booking details</strong>
                <% } else { %>
                    <strong>Dashboard</strong>
                <% } %>
            </div>

            <div class="topbar-profile">

                <div class="profile-details">
                    <strong><%= escapeHtml(fullName) %></strong>
                    <span>Guest account</span>
                </div>

                <div class="profile-avatar">
                    <%= escapeHtml(initials) %>
                </div>

            </div>

        </header>

        <!-- PAGE CONTENT -->
        <div class="dashboard-content">

            <% if (cancelSuccess) { %>
                <div class="cancellation-notice success" role="status">
                    Your booking has been successfully cancelled.
                </div>
            <% } else if (cancelFailed) { %>
                <div class="cancellation-notice error" role="alert">
                    We couldn't cancel this booking. It may already be
                    cancelled, belong to another account, or have passed
                    its check-in date.
                </div>
            <% } %>

            <% if (detailsView) { %>

                <!-- BOOKING DETAILS VIEW -->

                <section class="booking-detail-page">

                    <div class="booking-detail-heading">

                        <div>
                            <span class="section-eyebrow">
                                YOUR RESERVATION
                            </span>

                            <h1>Booking details</h1>

                            <p>
                                Review the information about your
                                accommodation and upcoming stay.
                            </p>
                        </div>

                        <a href="${pageContext.request.contextPath}/guest/dashboard#my-trips"
                           class="detail-back-button">
                            ← Back to My trips
                        </a>

                    </div>

                    <!-- HOTEL INFORMATION -->
                    <section class="detail-hotel-card">

                        <div class="detail-hotel-image">
                            <img src="<%= escapeHtml(selectedImage) %>"
                                 alt="Hotel accommodation"
                                 onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/images/hotel-gisenyi2.jpeg';">
                        </div>

                        <div class="detail-hotel-information">

                            <span class="section-eyebrow">
                                YOUR ACCOMMODATION
                            </span>

                            <h2>
                                <%= escapeHtml(
                                    selectedBooking.getHotelName()) %>
                            </h2>

                            <p class="detail-location">
                                ⌖
                                <%= escapeHtml(
                                    selectedBooking.getLocation()) %>
                            </p>

                            <span class="booking-status <%= getStatusClass(selectedStatus) %>">
                                <%= escapeHtml(selectedStatus) %>
                            </span>

                        </div>

                    </section>

                    <!-- BOOKING REFERENCE -->
                    <div class="detail-reference-bar">

                        <div>
                            <span>BOOKING REFERENCE</span>
                            <strong>
                                #<%= selectedBooking.getBookingId() %>
                            </strong>
                        </div>

                        <div>
                            <span>RESERVATION STATUS</span>
                            <strong>
                                <%= escapeHtml(selectedStatus) %>
                            </strong>
                        </div>

                    </div>

                    <!-- INFORMATION GRID -->
                    <div class="detail-information-grid">

                        <section class="detail-information-card">

                            <div class="detail-card-heading">
                                <span class="detail-card-icon">⌂</span>
                                <div>
                                    <h3>Accommodation</h3>
                                    <p>Room information</p>
                                </div>
                            </div>

                            <div class="detail-information-row">
                                <span>Room type</span>
                                <strong>
                                    <%= escapeHtml(
                                        selectedBooking.getRoomName()) %>
                                </strong>
                            </div>

                            <div class="detail-information-row">
                                <span>Room number</span>
                                <strong>
                                    <%= escapeHtml(
                                        selectedBooking.getRoomNumber()) %>
                                </strong>
                            </div>

                            <div class="detail-information-row">
                                <span>Number of guests</span>
                                <strong>
                                    <%= selectedBooking.getNumberOfGuests() %>
                                </strong>
                            </div>

                        </section>

                        <section class="detail-information-card">

                            <div class="detail-card-heading">
                                <span class="detail-card-icon">▦</span>
                                <div>
                                    <h3>Stay schedule</h3>
                                    <p>Your reservation dates</p>
                                </div>
                            </div>

                            <div class="detail-date-box">
                                <span>CHECK-IN</span>
                                <strong><%= selectedCheckIn %></strong>
                            </div>

                            <div class="detail-date-box">
                                <span>CHECK-OUT</span>
                                <strong><%= selectedCheckOut %></strong>
                            </div>

                        </section>

                    </div>

                    <!-- PAYMENT SUMMARY -->
                    <section class="detail-payment-card">

                        <div>
                            <span>RESERVATION SUMMARY</span>
                            <h3>Total booking amount</h3>
                            <p>
                                Amount recorded for this reservation.
                            </p>
                        </div>

                        <strong>
                            <%= selectedBooking.getTotalAmount() == null
                                ? "N/A"
                                : escapeHtml(
                                    selectedBooking.getTotalAmount().toPlainString()) %>
                        </strong>

                    </section>
                    <!-- CANCELLATION OPTION -->
                    <% if (selectedCanCancel) { %>

                        <div class="detail-footer-action">

                            <form action="${pageContext.request.contextPath}/guest/cancel-booking"
                                  method="POST"
                                  onsubmit="return confirm('Are you sure you want to cancel this booking? This action cannot be undone.');">

                                <input type="hidden"
                                       name="bookingId"
                                       value="<%= selectedBooking.getBookingId() %>">

                                <button type="submit"
                                        class="cancel-booking-button">
                                    Cancel this booking
                                </button>

                            </form>

                        </div>

                    <% } else if ("CANCELLED".equalsIgnoreCase(selectedStatus)) { %>

                        <div class="detail-footer-action">
                            <span class="cancelled-note">
                                This booking has been cancelled.
                            </span>
                        </div>

                    <% } %>

                </section>

            <% } else { %>

                <!-- DASHBOARD OVERVIEW -->

                <section class="welcome-section">

                    <div class="welcome-copy">

                        <span class="section-eyebrow">
                            YOUR TRAVEL SPACE
                        </span>

                        <h1>
                            Welcome back, <%= escapeHtml(firstName) %>!
                        </h1>

                        <p>
                            Your next Lake Kivu experience starts here.
                            Manage your bookings and discover beautiful
                            places to stay.
                        </p>

                    </div>

                    <a href="${pageContext.request.contextPath}/index.html#staySearchForm"
                       class="nav-link">
                        <span class="nav-icon">⌕</span>
                        <span class="nav-text">Explore stays</span>
                    </a>

                </section>

                <!-- OVERVIEW CARDS -->

                <section class="overview-grid">

                    <article class="overview-card">

                        <div class="overview-card-top">
                            <span class="overview-icon teal-icon">▣</span>
                            <span class="card-caption">ALL RESERVATIONS</span>
                        </div>

                        <h2><%= totalBookings %></h2>

                        <a href="#my-trips" class="card-link">
                            View your bookings →
                        </a>

                    </article>

                    <article class="overview-card">

                        <div class="overview-card-top">
                            <span class="overview-icon gold-icon">✧</span>
                            <span class="card-caption">UPCOMING TRIPS</span>
                        </div>

                        <h2><%= upcomingTrips %></h2>

                        <a href="#my-trips" class="card-link">
                            View upcoming trips →
                        </a>

                    </article>

                    <article class="overview-card">

                        <div class="overview-card-top">
                            <span class="overview-icon navy-icon">⌂</span>
                            <span class="card-caption">TRAVEL DESTINATION</span>
                        </div>

                        <h2>Lake Kivu</h2>

                        <a href="${pageContext.request.contextPath}/index.html"
                           class="card-link">
                            Discover more →
                        </a>

                    </article>

                </section>

                <!-- MY BOOKINGS -->

                <section class="dashboard-panel" id="my-trips">

                    <div class="panel-heading">

                        <div>
                            <span class="section-eyebrow">
                                YOUR RESERVATIONS
                            </span>

                            <h2>My trips</h2>

                            <p>
                                Keep track of your accommodation bookings.
                            </p>
                        </div>

                        <a href="${pageContext.request.contextPath}/index.html#staySearchForm"
                           class="text-link">
                            Find accommodation →
                        </a>

                    </div>

                    <% if (bookings.isEmpty()) { %>

                        <div class="empty-state">

                            <div class="empty-state-icon">⌂</div>

                            <h3>No bookings yet</h3>

                            <p>
                                You haven't booked an accommodation yet.
                                Discover a place around Lake Kivu and
                                start planning your next trip.
                            </p>

                            <a href="${pageContext.request.contextPath}/index.html#staySearchForm"
                               class="secondary-button">
                                Explore accommodations
                            </a>

                        </div>

                    <% } else { %>

                        <div class="booking-list">

                            <% for (Booking booking : bookings) {

                                String status = booking.getBookingStatus();

                                String statusClass = getStatusClass(status);

                                String hotelImage =
                                    getHotelImage(booking, request.getContextPath());

                                String checkIn =
                                    booking.getCheckIn() != null
                                    ? booking.getCheckIn().toLocalDate()
                                        .format(dateFormatter)
                                    : "Not available";

                                String checkOut =
                                    booking.getCheckOut() != null
                                    ? booking.getCheckOut().toLocalDate()
                                        .format(dateFormatter)
                                    : "Not available";

                                boolean bookingCanCancel =
                                    canCancelBooking(booking, today);
                            %>

                                <article class="booking-card">

                                    <div class="booking-image">
                                        <img src="<%= escapeHtml(hotelImage) %>"
                                             alt="<%= escapeHtml(booking.getHotelName()) %>"
                                             onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/images/hotel-gisenyi.jpeg';">
                                    </div>

                                    <div class="booking-details">

                                        <div class="booking-card-heading">

                                            <div>
                                                <span class="section-eyebrow">
                                                    BOOKING #<%= booking.getBookingId() %>
                                                </span>

                                                <h3>
                                                    <%= escapeHtml(booking.getHotelName()) %>
                                                </h3>

                                                <p>
                                                    <%= escapeHtml(booking.getLocation()) %>
                                                </p>
                                            </div>

                                            <span class="booking-status <%= statusClass %>">
                                                <%= escapeHtml(status) %>
                                            </span>

                                        </div>

                                        <div class="booking-card-information">

                                            <div>
                                                <span>CHECK-IN</span>
                                                <strong><%= checkIn %></strong>
                                            </div>

                                            <div>
                                                <span>CHECK-OUT</span>
                                                <strong><%= checkOut %></strong>
                                            </div>

                                            <div>
                                                <span>ROOM</span>
                                                <strong>
                                                    <%= escapeHtml(booking.getRoomName()) %>
                                                </strong>
                                            </div>

                                        </div>

                                        <div class="booking-price">
                                            <span>Total amount</span>

                                            <strong>
                                                <%= booking.getTotalAmount() == null
                                                    ? "N/A"
                                                    : escapeHtml(
                                                        booking.getTotalAmount().toPlainString()) %>
                                            </strong>
                                        </div>

                                        <div class="booking-card-footer">

                                            <a href="${pageContext.request.contextPath}/guest/booking-details?id=<%= booking.getBookingId() %>"
                                               class="booking-details-link">
                                                View booking details →
                                            </a>

                                            <% if (bookingCanCancel) { %>

                                                <form action="${pageContext.request.contextPath}/guest/cancel-booking"
                                                      method="POST"
                                                      onsubmit="return confirm('Are you sure you want to cancel this booking? This action cannot be undone.');">

                                                    <input type="hidden"
                                                           name="bookingId"
                                                           value="<%= booking.getBookingId() %>">

                                                    <button type="submit"
                                                            class="cancel-booking-button">
                                                        Cancel booking
                                                    </button>

                                                </form>

                                            <% } else if ("CANCELLED".equalsIgnoreCase(status)) { %>

                                                <span class="cancelled-note">
                                                    Booking cancelled
                                                </span>

                                            <% } %>

                                        </div>

                                    </div>

                                </article>

                            <% } %>

                        </div>

                    <% } %>

                </section>

                <!-- TRIP PLANNER -->

                <section class="trip-planner-section" id="trip-planner">

                    <div class="planner-heading">

                        <div>
                            <span class="section-eyebrow">
                                PLAN AHEAD
                            </span>

                            <h2>Your trip planner</h2>

                            <p>
                                Organize the places you want to visit
                                during your Lake Kivu experience.
                            </p>
                        </div>

                        <span class="planner-badge">
                            YOUR PERSONAL ITINERARY
                        </span>

                    </div>

                    <div class="planner-layout">

                        <!-- PLANNER FORM -->

                        <div class="planner-form-card">

                            <div class="planner-card-heading">
                                <span class="planner-icon">✧</span>

                                <div>
                                    <h3>Add a destination</h3>
                                    <p>Make a plan for your next adventure.</p>
                                </div>
                            </div>

                            <form id="tripPlannerForm">

                                <div class="planner-field">
                                    <label for="tripDestination">
                                        Destination
                                    </label>

                                    <input type="text"
                                           id="tripDestination"
                                           name="destination"
                                           placeholder="Where would you like to go?"
                                           required>
                                </div>

                                <div class="planner-field">
                                    <label for="tripDate">
                                        Planned date
                                    </label>

                                    <input type="date"
                                           id="tripDate"
                                           name="tripDate"
                                           required>
                                </div>

                                <div class="planner-field">
                                    <label for="tripNotes">
                                        Notes
                                    </label>

                                    <textarea id="tripNotes"
                                              name="notes"
                                              rows="3"
                                              placeholder="Add details about your plan..."></textarea>
                                </div>

                                <button type="submit"
                                        class="planner-add-button">
                                    + Add to itinerary
                                </button>

                                <p id="planner-message"
                                   class="planner-message"></p>

                            </form>

                        </div>

                        <!-- ITINERARY -->

                        <div class="planner-itinerary-card">

                            <div class="itinerary-heading">

                                <div>
                                    <span class="section-eyebrow">
                                        YOUR PLANS
                                    </span>

                                    <h3>My itinerary</h3>
                                </div>

                                <span id="tripCount" class="trip-count">
                                    0 trips
                                </span>

                            </div>

                            <div id="tripEmptystate"
                                 class="trip-empty-state">

                                <div class="empty-trip-icon">✧</div>

                                <h3>Your itinerary is empty</h3>

                                <p>
                                    Add destinations to start organizing
                                    your next adventure.
                                </p>

                            </div>

                            <div id="tripList"></div>

                        </div>

                    </div>

                </section>

            <% } %>

        </div>

    </main>

</div>

<script src="${pageContext.request.contextPath}/js/trip-planner.js"
        defer></script>

</body>
</html>