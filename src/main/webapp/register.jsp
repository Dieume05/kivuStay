<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Create Account | KivuStay</title>

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
                    YOUR JOURNEY STARTS HERE
                </span>

                <h1>
                    Discover more.
                    <span>Experience</span>
                    something special.
                </h1>

                <p>
                    Create your KivuStay account and explore
                    beautiful accommodations, peaceful lakeside
                    retreats and unforgettable experiences
                    around Lake Kivu.
                </p>

            </div>

            <footer class="visual-footer">
                <span>Made for travellers. Inspired by Lake Kivu.</span>
                <span>RWANDA · DRC</span>
            </footer>

        </section>

        <!-- Right: Registration form -->
        <section class="form-section">

            <div class="form-wrapper">

                <div class="mobile-brand">
                    <div class="brand-icon">K</div>
                    <span>KivuStay</span>
                </div>

                <div class="welcome-text">
                    <span class="eyebrow">JOIN KIVUSTAY</span>

                    <h2>Create your account.</h2>

                    <p>
                        Sign up to discover your next favourite stay.
                    </p>
                </div>

                <!-- Registration success/error messages -->
                <%
                    String error = request.getParameter("error");
                    String registered = request.getParameter("registered");

                    String message = null;

                    if ("missing".equals(error)) {
                        message = "Please complete all fields.";
                    } else if ("invalid".equals(error)) {
                        message = "Please check your name and email length.";
                    } else if ("email".equals(error)) {
                        message = "Please enter a valid email address.";
                    } else if ("password".equals(error)) {
                        message = "Password must contain between 8 and 128 characters.";
                    } else if ("mismatch".equals(error)) {
                        message = "Your passwords do not match.";
                    } else if ("exists".equals(error)) {
                        message = "An account with this email already exists.";
                    } else if ("failed".equals(error)) {
                        message = "Registration could not be completed. Please try again.";
                    }

                    if (message != null) {
                %>
                    <div class="login-error" role="alert">
                        <%= message %>
                    </div>
                <%
                    }

                    if ("success".equals(registered)) {
                %>
                    <div class="registration-success" role="status">
                        Your account has been created successfully.
                        You can now sign in.
                    </div>
                <%
                    }
                %>

                <!-- Registration form -->
                <form action="${pageContext.request.contextPath}/register"
                      method="POST">

                    <div class="form-group">

                        <label for="fullName">
                            Full name
                        </label>

                        <input
                            type="text"
                            id="fullName"
                            name="fullName"
                            placeholder="Enter your full name"
                            autocomplete="name"
                            maxlength="100"
                            required
                        >

                    </div>

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
                            maxlength="150"
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
                            placeholder="Create a password"
                            autocomplete="new-password"
                            minlength="8"
                            maxlength="128"
                            required
                        >

                    </div>

                    <div class="form-group">

                        <label for="confirmPassword">
                            Confirm password
                        </label>

                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            placeholder="Enter your password again"
                            autocomplete="new-password"
                            minlength="8"
                            maxlength="128"
                            required
                        >

                    </div>

                    <button type="submit" class="login-button">
                        Create account
                        <span>→</span>
                    </button>

                </form>

                <div class="security-note">
                    <span>◆</span>
                    Your account and personal information are protected.
                </div>

                <div class="form-footer">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login.jsp">
                        Sign in
                    </a>
                </div>

                <div class="form-footer">
                    © 2026 KivuStay. Explore more. Stay somewhere special.
                </div>

            </div>

        </section>

    </main>

</body>
</html>