<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Sign In | KivuStay</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/login.css">
</head>

<body>

    <main class="login-container">

        <!-- Left: Brand and destination story -->
        <section class="visual-section">

            <header class="brand">
                <div class="brand-icon">K</div>
                <span>KivuStay</span>
            </header>

            <div class="visual-content">

                <span class="eyebrow">
                    DISCOVER THE BEAUTY OF LAKE KIVU
                </span>

                <h1>
                    Your next
                    <span>escape</span>
                    begins here.
                </h1>

                <p>
                    Find your place by the lake.
                    Discover beautiful stays, unforgettable
                    destinations and experiences worth remembering.
                </p>

            </div>

            <footer class="visual-footer">
                <span>Made for travellers. Inspired by Lake Kivu.</span>
                <span>RWANDA · DRC</span>
            </footer>

        </section>

        <!-- Right: Login form -->
        <section class="form-section">

            <div class="form-wrapper">

                <div class="mobile-brand">
                    <div class="brand-icon">K</div>
                    <span>KivuStay</span>
                </div>

                <div class="welcome-text">
                    <span class="eyebrow">WELCOME BACK</span>

                    <h2>Good to see you again.</h2>

                    <p>
                        Sign in to continue your journey with KivuStay.
                    </p>
                </div>

                <!-- Registration success message -->
                <%
                    String registered =
                        request.getParameter("registered");

                    if ("success".equals(registered)) {
                %>
                    <div class="registration-success" role="status">
                        Your account has been created successfully.
                        You can now sign in.
                    </div>
                <%
                    }
                %>

                <!-- Login error message -->
                <%
                    String loginError =
                        (String) request.getAttribute("loginError");

                    if (loginError != null) {
                %>
                    <div class="login-error" role="alert">
                        <%= loginError %>
                    </div>
                <%
                    }
                %>

                <!-- Login form -->
                <form action="${pageContext.request.contextPath}/login"
                      method="POST">

                    <div class="form-group">

                        <label for="email">
                            Email address
                        </label>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="you@example.com"
                            autocomplete="email"
                            value="<%=
                                request.getAttribute("email") == null
                                ? ""
                                : request.getAttribute("email")
                            %>"
                            required
                        >

                    </div>

                    <div class="form-group">

                        <label for="password">
                            Password
                        </label>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required
                        >

                    </div>

                    <button type="submit" class="login-button">
                        Sign in
                        <span>→</span>
                    </button>

                </form>

                <!-- Create account button -->
               <div class="form-footer">
    Don't have an account?
    <a href="${pageContext.request.contextPath}/register.jsp">
        Register
    </a>
</div>

                <div class="security-note">
                    <span>◆</span>
                    Your account and personal information are protected.
                </div>

                <div class="form-footer">
                    © 2026 KivuStay. Explore more. Stay somewhere special.
                </div>

            </div>

        </section>

    </main>

</body>
</html>