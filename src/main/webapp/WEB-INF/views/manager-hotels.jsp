<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.kivustay.model.Hotel" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String formatPrice(BigDecimal price) {
        if (price == null) return "Price unavailable";

        return "$" + price.setScale(
                2,
                java.math.RoundingMode.HALF_UP
        ).toPlainString();
    }
%>

<%
    String contextPath = request.getContextPath();

    List<Hotel> hotels =
            (List<Hotel>) request.getAttribute("hotels");

    if (hotels == null) {
        hotels = new java.util.ArrayList<Hotel>();
    }

    int totalHotels = hotels.size();
    int totalRooms = 0;
    int totalRoomTypes = 0;

    for (Hotel hotel : hotels) {
        totalRooms += hotel.getTotalRooms();
        totalRoomTypes += hotel.getTotalRoomTypes();
    }

    String managerName =
            (String) session.getAttribute("fullName");

    if (managerName == null || managerName.trim().isEmpty()) {
        managerName = "Manager";
    }

    String firstName = managerName.split("\\s+")[0];

    String managerInitial =
            firstName.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <meta name="description"
          content="Manage your KivuStay hotel properties.">

    <title>My Hotels | KivuStay</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/manager-hotels.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<div class="dashboard-layout">

    <!-- SIDEBAR WILL BE ADDED IN PART 2 -->

    <main class="main-content">
    <!-- =====================================
             SIDEBAR
        ====================================== -->

        <aside class="sidebar">

            <div class="brand">
                <div class="brand-icon">
                    <i class="fa-solid fa-water"></i>
                </div>

                <div class="brand-text">
                    <h2>KivuStay</h2>
                    <span>HOSPITALITY MANAGEMENT</span>
                </div>
            </div>

            <div class="sidebar-label">
                WORKSPACE
            </div>

            <nav class="sidebar-nav">

                <a href="<%= contextPath %>/manager/dashboard"
                   class="nav-item">

                    <i class="fa-solid fa-chart-pie"></i>
                    <span>Overview</span>

                </a>

                <a href="<%= contextPath %>/manager/hotels"
                   class="nav-item active">

                    <i class="fa-solid fa-hotel"></i>
                    <span>My Hotels</span>

                </a>

                <a href="<%= contextPath %>/manager/rooms"
                   class="nav-item">

                    <i class="fa-solid fa-bed"></i>
                    <span>Room Management</span>

                </a>

                <a href="<%= contextPath %>/manager/bookings"
                   class="nav-item">

                    <i class="fa-solid fa-calendar-check"></i>
                    <span>Reservations</span>

                </a>

                <a href="<%= contextPath %>/manager/dashboard#analytics"
                   class="nav-item">

                    <i class="fa-solid fa-chart-line"></i>
                    <span>Analytics</span>

                </a>

            </nav>

            <div class="sidebar-bottom">

                <div class="sidebar-support">
                    <div class="support-icon">
                        <i class="fa-regular fa-circle-question"></i>
                    </div>

                    <div>
                        <strong>Need assistance?</strong>
                        <span>KivuStay Manager</span>
                    </div>
                </div>

                <a href="<%= contextPath %>/logout"
                   class="nav-item logout-link">

                    <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    <span>Logout</span>

                </a>

            </div>

        </aside>


        <!-- =====================================
             MAIN PAGE HEADER
        ====================================== -->

        <section class="content-area">

            <header class="topbar">

                <div class="topbar-left">

                    <button class="mobile-menu-btn"
                            id="mobileMenuBtn"
                            type="button"
                            aria-label="Toggle navigation">

                        <i class="fa-solid fa-bars"></i>

                    </button>

                    <div class="breadcrumb">
                        <span>Workspace</span>
                        <i class="fa-solid fa-chevron-right"></i>
                        <strong>My Hotels</strong>
                    </div>

                </div>

                <div class="topbar-right">

                    <div class="topbar-date">
                        <i class="fa-regular fa-calendar"></i>
                        <span>Property Management</span>
                    </div>

                    <div class="manager-profile">

                        <div class="profile-avatar">
                            <%= escapeHtml(managerInitial) %>
                        </div>

                        <div class="profile-details">
                            <strong>
                                <%= escapeHtml(managerName) %>
                            </strong>
                            <span>Hotel Manager</span>
                        </div>

                    </div>

                </div>

            </header>


            <!-- =================================
                 PAGE INTRODUCTION
            ================================== -->

            <div class="page-container">

                <section class="page-heading">

                    <div class="heading-text">

                        <div class="eyebrow">
                            <span></span>
                            PROPERTY PORTFOLIO
                        </div>

                        <h1>My Hotels</h1>

                        <p>
                            Every property in one place.
                            Monitor your hotels, room inventory
                            and accommodation performance.
                        </p>

                    </div>

                    <div class="heading-decoration">
                        <i class="fa-solid fa-hotel"></i>
                    </div>

                </section>
                <!-- =================================
                     PORTFOLIO STATISTICS
                ================================== -->

                <section class="portfolio-stats">

                    <div class="stat-card">

                        <div class="stat-icon hotels-icon">
                            <i class="fa-solid fa-hotel"></i>
                        </div>

                        <div class="stat-info">
                            <span>Total Properties</span>
                            <h2><%= totalHotels %></h2>
                            <small>Hotels under your management</small>
                        </div>

                        <div class="stat-decoration">
                            <i class="fa-solid fa-hotel"></i>
                        </div>

                    </div>


                    <div class="stat-card">

                        <div class="stat-icon types-icon">
                            <i class="fa-solid fa-layer-group"></i>
                        </div>

                        <div class="stat-info">
                            <span>Room Categories</span>
                            <h2><%= totalRoomTypes %></h2>
                            <small>Across all your properties</small>
                        </div>

                        <div class="stat-decoration">
                            <i class="fa-solid fa-layer-group"></i>
                        </div>

                    </div>


                    <div class="stat-card">

                        <div class="stat-icon rooms-icon">
                            <i class="fa-solid fa-bed"></i>
                        </div>

                        <div class="stat-info">
                            <span>Physical Rooms</span>
                            <h2><%= totalRooms %></h2>
                            <small>Total registered room inventory</small>
                        </div>

                        <div class="stat-decoration">
                            <i class="fa-solid fa-bed"></i>
                        </div>

                    </div>

                </section>


                <!-- =================================
                     HOTEL PORTFOLIO HEADER
                ================================== -->

                <section class="portfolio-section">

                    <div class="portfolio-header">

                        <div>
                            <div class="section-eyebrow">
                                YOUR COLLECTION
                            </div>

                            <h2>Property Portfolio</h2>

                            <p>
                                Explore and monitor your accommodation properties.
                            </p>
                        </div>

                        <div class="portfolio-tools">

                            <div class="hotel-search">

                                <i class="fa-solid fa-magnifying-glass"></i>

                                <input
                                    type="text"
                                    id="hotelSearch"
                                    placeholder="Search hotels..."
                                    autocomplete="off">

                            </div>

                            <div class="hotel-count">
                                <span id="visibleHotelCount">
                                    <%= totalHotels %>
                                </span>
                                Properties
                            </div>

                        </div>

                    </div>


                    <!-- =================================
                         HOTEL CARDS
                    ================================== -->

                    <div class="hotel-grid" id="hotelGrid">

                        <% if (hotels.isEmpty()) { %>

                            <div class="empty-state">

                                <div class="empty-icon">
                                    <i class="fa-solid fa-hotel"></i>
                                </div>

                                <h3>No properties found</h3>

                                <p>
                                    There are currently no hotels
                                    assigned to your manager account.
                                </p>

                            </div>

                        <% } else { %>

                            <% for (Hotel hotel : hotels) { %>

                                <article class="hotel-card">

                                    <div class="hotel-image">

                                        <% if (hotel.getImageUrl() != null
                                                && !hotel.getImageUrl().trim().isEmpty()) { %>

                                            <img
                                                src="<%= escapeHtml(hotel.getImageUrl()) %>"
                                                alt="<%= escapeHtml(hotel.getHotelName()) %>"
                                                loading="lazy">

                                        <% } else { %>

                                            <div class="hotel-image-placeholder">
                                                <i class="fa-solid fa-hotel"></i>
                                            </div>

                                        <% } %>

                                        <div class="image-overlay"></div>

                                        <div class="rating-badge">

                                            <i class="fa-solid fa-star"></i>

                                            <%= hotel.getRating() %>.0

                                        </div>

                                        <div class="property-label">
                                            YOUR PROPERTY
                                        </div>

                                    </div>


                                    <div class="hotel-card-body">

                                        <div class="hotel-location">

                                            <i class="fa-solid fa-location-dot"></i>

                                            <%= escapeHtml(hotel.getLocation()) %>

                                        </div>

                                        <h3 class="hotel-name">
                                            <%= escapeHtml(hotel.getHotelName()) %>
                                        </h3>

                                        <p class="hotel-description">

                                            <%= escapeHtml(
                                                hotel.getDescription() == null
                                                    ? "Discover this accommodation property."
                                                    : hotel.getDescription()
                                            ) %>

                                        </p>


                                        <div class="hotel-divider"></div>


                                        <div class="hotel-metrics">

                                            <div class="hotel-metric">

                                                <i class="fa-solid fa-layer-group"></i>

                                                <div>
                                                    <strong>
                                                        <%= hotel.getTotalRoomTypes() %>
                                                    </strong>

                                                    <span>Room Types</span>
                                                </div>

                                            </div>


                                            <div class="hotel-metric">

                                                <i class="fa-solid fa-bed"></i>

                                                <div>
                                                    <strong>
                                                        <%= hotel.getTotalRooms() %>
                                                    </strong>

                                                    <span>Physical Rooms</span>
                                                </div>

                                            </div>

                                        </div>


                                        <div class="hotel-card-footer">

                                            <div class="starting-price">

                                                <span>Starting from</span>

                                                <strong>
                                                    <%= formatPrice(hotel.getMinimumPrice()) %>
                                                </strong>

                                                <small>per night</small>

                                            </div>

                                            <a
                                                href="<%= contextPath %>/manager/rooms"
                                                class="view-rooms-btn">

                                                Manage Rooms

                                                <i class="fa-solid fa-arrow-right"></i>

                                            </a>

                                        </div>

                                    </div>

                                </article>

                            <% } %>

                        <% } %>

                    </div>

                    <div class="no-search-results" id="noSearchResults"
                         style="display:none;">

                        <i class="fa-solid fa-magnifying-glass"></i>

                        <h3>No matching hotels</h3>

                        <p>Try another hotel name or location.</p>

                    </div>

                </section>
                <!-- =================================
                     PAGE FOOTER
                ================================== -->

                <footer class="page-footer">

                    <div class="footer-left">

                        <span class="footer-brand">
                            <i class="fa-solid fa-water"></i>
                            KivuStay
                        </span>

                        <span>
                            Hospitality Management Platform
                        </span>

                    </div>

                    <div class="footer-right">
                        © 2026 KivuStay. All rights reserved.
                    </div>

                </footer>

            </div>

        </section>

    </main>

</div>


<!-- =========================================
     JAVASCRIPT
========================================== -->

<script src="<%= contextPath %>/js/manager-hotels.js"></script>

</body>
</html>