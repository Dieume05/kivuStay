<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String contextPath = request.getContextPath();

    Object userId = session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");
    String role = (String) session.getAttribute("role");

    boolean loggedIn = userId != null &&
                       role != null &&
                       !role.trim().isEmpty();

    String dashboardUrl = contextPath + "/guest/dashboard";

    if ("MANAGER".equalsIgnoreCase(role)) {
        dashboardUrl = contextPath + "/manager/dashboard";
    }

    if (fullName == null || fullName.trim().isEmpty()) {
        fullName = "Traveller";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>KivuStay | Discover Your Place by the Lake</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/home.css">
</head>

<body>

    <!-- Navigation -->
    <header class="navbar">

        <a href="<%= contextPath %>/index.jsp" class="logo">
            <span class="logo-icon">K</span>
            <span>KivuStay</span>
        </a>

        <nav class="nav-links">
            <a href="<%= contextPath %>/index.jsp" class="active">Home</a>
            <a href="#stays">Explore Stays</a>
            <a href="#destinations">Destinations</a>
            <a href="#about">About Us</a>
        </nav>

        <div class="nav-actions">

            <% if (loggedIn) { %>

                <span class="welcome-user">
                    Welcome, <%= fullName %>
                </span>

                <a href="<%= dashboardUrl %>" class="sign-in">
                    My Dashboard
                </a>

                <form action="<%= contextPath %>/logout"
                      method="POST"
                      style="display:inline;">

                    <button type="submit" class="register-button">
                        Sign out
                    </button>

                </form>

            <% } else { %>

                <a href="<%= contextPath %>/login.jsp"
                   class="sign-in">
                    Sign in
                </a>

                <a href="<%= contextPath %>/register.jsp"
                   class="register-button">
                    Create account
                </a>

            <% } %>

        </div>

    </header>

    <!-- Hero Section -->
    <main>

        <section class="hero">

            <div class="hero-overlay"></div>

            <div class="hero-content">

                <span class="eyebrow">
                    YOUR JOURNEY STARTS HERE
                </span>

                <h1>
                    Find your place<br>
                    <em>by the lake.</em>
                </h1>

                <p>
                    Discover beautiful stays, explore remarkable
                    destinations and experience the magic of Lake Kivu.
                </p>

                <a href="#stays" class="hero-button">
                    Explore accommodations <span>→</span>
                </a>

            </div>

            <div class="hero-location">
                <span>⌖</span>
                LAKE KIVU · RWANDA & DRC
            </div>

        </section>

        <!-- Search Section -->
        <section class="search-section" id="staySearchSection">

            <div class="search-heading">

                <span class="eyebrow">PLAN YOUR GETAWAY</span>

                <h2>Where would you like to stay?</h2>

            </div>

            <form class="search-form"
                  id="staySearchForm"
                  action="<%= contextPath %>/search"
                  method="GET"
                  novalidate>

                <div class="search-field">

                    <label for="location">DESTINATION</label>

                    <input type="text"
                           id="location"
                           name="location"
                           placeholder="Where are you going?">

                </div>

                <div class="search-field">

                    <label for="checkin">CHECK-IN</label>

                    <input type="date"
                           id="checkin"
                           name="checkIn"
                           required>

                </div>

                <div class="search-field">

                    <label for="checkout">CHECK-OUT</label>

                    <input type="date"
                           id="checkout"
                           name="checkOut"
                           required>

                </div>

                <div class="search-field">

                    <label for="guests">GUESTS</label>

                    <select id="guests" name="guests">
                        <option value="1">1 Guest</option>
                        <option value="2" selected>2 Guests</option>
                        <option value="3">3 Guests</option>
                        <option value="4">4 Guests</option>
                        <option value="5">5+ Guests</option>
                    </select>

                </div>

                <button type="submit" class="search-button">
                    Search stays →
                </button>

            </form>

            <p id="searchMessage"
               class="search-message"
               aria-live="polite"></p>

        </section>

        <!-- Featured Stays -->
        <section class="featured-section" id="stays">

            <div class="section-heading">

                <div>

                    <span class="eyebrow">HANDPICKED FOR YOU</span>

                    <h2>Discover beautiful stays.</h2>

                    <p>
                        Find a comfortable place to relax,
                        reconnect and enjoy the lake.
                    </p>

                </div>

                <a href="#stays" class="view-all">
                    Explore all stays →
                </a>

            </div>

            <div class="hotel-grid">

                <article class="hotel-card">

                    <img src="<%= contextPath %>/images/hotel-gisenyi2.jpeg"
                         alt="Lakeside accommodation in Gisenyi">

                    <div class="hotel-info">

                        <span class="hotel-location">
                            RUBAVU, RWANDA
                        </span>

                        <h3>Relax by the water</h3>

                        <p>Beautiful lakeside accommodation.</p>

                    </div>

                </article>

                <article class="hotel-card">

                    <img src="<%= contextPath %>/images/hotel-karongi.jpeg"
                         alt="Accommodation near Karongi">

                    <div class="hotel-info">

                        <span class="hotel-location">
                            KARONGI, RWANDA
                        </span>

                        <h3>Escape into nature</h3>

                        <p>Enjoy peaceful views and fresh air.</p>

                    </div>

                </article>

                <article class="hotel-card">

                    <img src="<%= contextPath %>/images/hotel-goma2.jpeg"
                         alt="Accommodation in Goma">

                    <div class="hotel-info">

                        <span class="hotel-location">
                            GOMA, DRC
                        </span>

                        <h3>Experience the city</h3>

                        <p>Discover the beauty of the eastern shore.</p>

                    </div>

                </article>

            </div>

        </section>

        <!-- Destinations -->
        <section class="destinations-section" id="destinations">

            <div class="section-heading">

                <div>
                    <span class="eyebrow">EXPLORE THE REGION</span>
                    <h2>Places worth discovering.</h2>
                </div>

            </div>

            <div class="destination-grid">

                <div class="destination-card rubavu">
                    <span>RWANDA</span>
                    <h3>Rubavu</h3>
                </div>

                <div class="destination-card karongi">
                    <span>RWANDA</span>
                    <h3>Karongi</h3>
                </div>

                <div class="destination-card goma">
                    <span>DR CONGO</span>
                    <h3>Goma</h3>
                </div>

            </div>

        </section>

        <!-- About -->
        <section class="about-section" id="about">

            <span class="eyebrow">THE KIVUSTAY EXPERIENCE</span>

            <h2>More than a place to sleep.</h2>

            <p>
                We bring travellers and accommodation providers
                together, making it easier to discover the Lake Kivu
                region and find a place that feels right.
            </p>

        </section>

    </main>

    <!-- Footer -->
    <footer class="footer">

        <a href="<%= contextPath %>/index.jsp"
           class="logo footer-logo">

            <span class="logo-icon">K</span>
            <span>KivuStay</span>

        </a>

        <p>Made for travellers. Inspired by Lake Kivu.</p>

        <span>© 2026 KivuStay. All rights reserved.</span>

    </footer>

    <script src="<%= contextPath %>/js/home.js"></script>

</body>
</html>