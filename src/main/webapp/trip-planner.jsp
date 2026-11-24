<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Trip Planner | KivuStay</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:wght@500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --navy: #142D3B;
            --teal: #267C78;
            --teal-dark: #1D625F;
            --ivory: #F5F3ED;
            --gold: #D8B77A;
            --white: #FFFFFF;
            --text: #344955;
            --muted: #829098;
            --border: #E8EAE6;
            --shadow: 0 12px 35px rgba(20, 45, 59, 0.07);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: var(--ivory);
            color: var(--navy);
            font-family: 'DM Sans', sans-serif;
        }

        a {
            text-decoration: none;
        }

        /* NAVIGATION */

        .navbar {
            height: 76px;
            padding: 0 7%;
            background: var(--white);
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid var(--border);
        }

        .brand {
            font-size: 25px;
            font-weight: 700;
            letter-spacing: -1px;
            color: var(--navy);
        }

        .brand span {
            color: var(--teal);
        }

        .back-link {
            color: var(--teal);
            font-size: 14px;
            font-weight: 700;
            transition: 0.2s;
        }

        .back-link:hover {
            color: var(--navy);
        }

        /* HERO */

        .hero {
            position: relative;
            overflow: hidden;
            padding: 65px 7% 72px;
            color: white;
            background:
                radial-gradient(circle at 85% 20%, rgba(216,183,122,0.22), transparent 28%),
                linear-gradient(115deg, #142D3B 0%, #1C4B55 60%, #267C78 100%);
        }

        .hero::after {
            content: "";
            position: absolute;
            width: 380px;
            height: 380px;
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 50%;
            right: 8%;
            top: -190px;
            box-shadow:
                0 0 0 35px rgba(255,255,255,0.025),
                0 0 0 75px rgba(255,255,255,0.02);
        }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 1250px;
            margin: auto;
        }

        .eyebrow {
            color: var(--gold);
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 3px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(34px, 5vw, 52px);
            font-weight: 600;
            margin: 0 0 14px;
            line-height: 1.15;
        }

        .hero p {
            color: rgba(255,255,255,0.76);
            font-size: 15px;
            max-width: 550px;
            line-height: 1.8;
            margin: 0;
        }

        .hero-decoration {
            position: absolute;
            right: 10%;
            bottom: 20px;
            color: rgba(255,255,255,0.16);
            font-family: 'Playfair Display', serif;
            font-size: 100px;
            font-style: italic;
        }

        /* MAIN LAYOUT */

        main {
            max-width: 1250px;
            margin: 0 auto;
            padding: 45px 25px 80px;
        }

        .section-heading {
            margin-bottom: 25px;
        }

        .section-heading h2 {
            font-family: 'Playfair Display', serif;
            font-size: 27px;
            margin: 0 0 7px;
            color: var(--navy);
        }

        .section-heading p {
            color: var(--muted);
            font-size: 14px;
            margin: 0;
        }

        .planner-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 340px;
            gap: 28px;
            align-items: start;
        }

        /* ACCOMMODATION PANEL */

        .stays-panel {
            background: var(--white);
            padding: 28px;
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: var(--shadow);
            min-width: 0;
        }

        .panel-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            gap: 12px;
        }

        .panel-heading h3 {
            margin: 0;
            font-size: 17px;
            color: var(--navy);
        }

        .panel-label {
            background: #EAF4F2;
            color: var(--teal-dark);
            padding: 7px 12px;
            border-radius: 30px;
            font-size: 11px;
            font-weight: 700;
        }

        /* STATUS MESSAGE */

        #trip-message {
            font-size: 13px;
            line-height: 1.6;
            margin: 0 0 18px;
        }

        .success-message {
            color: #267C78;
        }

        .error-message {
            color: #B84A43;
        }

        /* TRIP CARDS */
        /* PREMIUM ACCOMMODATION CARDS */

#trip-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.trip-card {
    display: grid;
    grid-template-columns: 190px minmax(0, 1fr);
    overflow: hidden;
    background: #FFFEFC;
    border: 1px solid var(--border);
    border-radius: 13px;
    transition: 0.25s ease;
}

.trip-card:hover {
    border-color: #B8D5D1;
    box-shadow: 0 10px 28px rgba(20,45,59,0.07);
    transform: translateY(-2px);
}

.stay-visual {
    min-height: 230px;
    background:
        radial-gradient(circle at 80% 20%, rgba(216,183,122,0.35), transparent 35%),
        linear-gradient(145deg, #142D3B, #267C78);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    overflow: hidden;
}

.stay-visual.has-image {
    padding: 0;
}

.stay-visual img {
    width: 100%;
    height: 100%;
    min-height: 230px;
    object-fit: cover;
}

.visual-content {
    text-align: center;
    color: white;
}

.visual-label {
    display: block;
    color: var(--gold);
    font-size: 9px;
    font-weight: 700;
    letter-spacing: 2px;
    margin-bottom: 15px;
}

.visual-title {
    display: block;
    font-family: 'Playfair Display', serif;
    font-size: 22px;
    line-height: 1.4;
}

.stay-content {
    min-width: 0;
    padding: 21px;
    display: flex;
    flex-direction: column;
}

.stay-top-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
}

.stay-location {
    color: var(--teal);
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.stay-number {
    color: #A0AAA9;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 1px;
}

.stay-title {
    margin: 12px 0 4px;
    font-family: 'Playfair Display', serif;
    font-size: 23px;
    color: var(--navy);
}

.stay-room {
    margin: 0;
    color: var(--muted);
    font-size: 13px;
}

.stay-details {
    display: flex;
    gap: 35px;
    margin: 20px 0;
}

.stay-detail {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.detail-label,
.price-label {
    color: #89969A;
    font-size: 9px;
    font-weight: 700;
    letter-spacing: 1px;
}

.detail-value {
    color: var(--navy);
    font-size: 12px;
}

.stay-footer {
    margin-top: auto;
    padding-top: 15px;
    border-top: 1px solid var(--border);
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
}

.stay-price {
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.price-value {
    color: var(--teal-dark);
    font-size: 20px;
}

.stay-actions {
    display: flex;
    align-items: center;
    gap: 6px;
}

.stay-action {
    padding: 9px 12px;
    border: 1px solid #DCE6E3;
    border-radius: 7px;
    background: #F3F8F6;
    color: var(--teal-dark);
    font-family: inherit;
    font-size: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: 0.2s;
}

.stay-action:hover:not(:disabled) {
    background: var(--teal);
    color: white;
    border-color: var(--teal);
}

.stay-action.remove-action {
    background: #FFF5F2;
    color: #B65E50;
    border-color: #F0DDD7;
}

.stay-action.remove-action:hover {
    background: #B65E50;
    color: white;
}

.stay-action:disabled {
    opacity: 0.35;
    cursor: not-allowed;
}

.empty-plan {
    padding: 55px 25px;
    text-align: center;
    background: #FAFBF9;
    border: 1px dashed #CCD9D5;
    border-radius: 12px;
}

.empty-icon {
    color: var(--gold);
    font-size: 35px;
    margin-bottom: 12px;
}

.empty-title {
    color: var(--navy);
    font-family: 'Playfair Display', serif;
    font-size: 23px;
    margin: 0 0 10px;
}

.empty-description {
    max-width: 390px;
    margin: auto;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.8;
}

@media (max-width: 650px) {
    .trip-card {
        grid-template-columns: 1fr;
    }

    .stay-visual {
        min-height: 150px;
    }

    .stay-visual img {
        min-height: 150px;
        max-height: 190px;
    }

    .stay-details {
        gap: 18px;
        flex-wrap: wrap;
    }

    .stay-footer {
        align-items: flex-start;
        flex-direction: column;
    }

    .stay-actions {
        width: 100%;
    }
}
        /* SUMMARY PANEL */

        .summary-panel {
            position: sticky;
            top: 25px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow);
        }

        .summary-header {
            padding: 24px;
            background: var(--navy);
            color: white;
        }

        .summary-header span {
            display: block;
            color: var(--gold);
            text-transform: uppercase;
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 2px;
            margin-bottom: 9px;
        }

        .summary-header h3 {
            font-family: 'Playfair Display', serif;
            font-size: 23px;
            margin: 0;
            font-weight: 500;
        }

        .summary-body {
            padding: 25px;
        }

        .summary-description {
            color: var(--muted);
            font-size: 13px;
            line-height: 1.7;
            margin: 0 0 25px;
        }

        .summary-divider {
            height: 1px;
            background: var(--border);
            margin: 20px 0;
        }

        .total-label {
            color: #71828A;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 9px;
        }

        #trip-total {
            color: var(--teal-dark);
            font-size: 32px;
            font-weight: 700;
            letter-spacing: -1px;
        }

        .estimate-note {
            margin-top: 12px;
            color: var(--muted);
            font-size: 11px;
            line-height: 1.6;
        }

        .summary-footer {
            padding: 16px 25px;
            background: #F7F8F5;
            color: #71828A;
            font-size: 11px;
            line-height: 1.7;
        }

        .gold-line {
            width: 42px;
            height: 3px;
            background: var(--gold);
            border-radius: 5px;
            margin-bottom: 20px;
        }

        /* FOOTER */

        footer {
            padding: 25px;
            background: var(--navy);
            color: rgba(255,255,255,0.65);
            text-align: center;
            font-size: 12px;
        }

        footer strong {
            color: white;
        }

        /* RESPONSIVE */

        @media (max-width: 900px) {
            .planner-layout {
                grid-template-columns: 1fr;
            }

            .summary-panel {
                position: static;
            }

            .hero-decoration {
                right: 4%;
                font-size: 70px;
            }
        }

        @media (max-width: 600px) {
            .navbar {
                height: 65px;
                padding: 0 20px;
            }

            .brand {
                font-size: 22px;
            }

            .hero {
                padding: 48px 22px 55px;
            }

            .hero-decoration {
                display: none;
            }

            main {
                padding: 32px 15px 55px;
            }

            .stays-panel {
                padding: 18px;
            }

            .trip-card {
                padding: 18px;
            }

            .panel-heading {
                align-items: flex-start;
                flex-direction: column;
            }

            .summary-body {
                padding: 20px;
            }
        }
    </style>
</head>

<body>

<header class="navbar">
    <a href="<%= contextPath %>/" class="brand">
        Kivu<span>Stay</span>
    </a>

    <a href="javascript:history.back()" class="back-link">
        ← Back to search
    </a>
</header>

<section class="hero">
    <div class="hero-content">
        <div class="eyebrow">Your Lake Kivu experience</div>

        <h1>Your journey,<br>beautifully planned.</h1>

        <p>
            Bring your favourite stays together, organize your accommodation
            choices and keep track of your estimated travel budget.
        </p>
    </div>

    <div class="hero-decoration">Explore</div>
</section>

<main>

    <div class="section-heading">
        <h2>My Trip Planner</h2>
        <p>Your selected accommodation, organized in one place.</p>
    </div>

    <div class="planner-layout">

        <!-- LEFT: SHORTLISTED ACCOMMODATION -->

        <section class="stays-panel">

            <div class="panel-heading">
                <h3>Your shortlisted stays</h3>
                <span class="panel-label">MY JOURNEY</span>
            </div>

            <p id="trip-message" aria-live="polite">
                Your trip plan is loading...
            </p>

            <div id="trip-list"></div>

        </section>

        <!-- RIGHT: TRIP SUMMARY -->

        <aside class="summary-panel">

            <div class="summary-header">
                <span>Trip overview</span>
                <h3>Your travel budget</h3>
            </div>

            <div class="summary-body">

                <div class="gold-line"></div>

                <p class="summary-description">
                    Keep an eye on the estimated cost of all the
                    accommodation you have shortlisted.
                </p>

                <div class="summary-divider"></div>

                <div class="total-label">
                    ESTIMATED ACCOMMODATION TOTAL
                </div>

                <div id="trip-total">$0.00</div>

                <p class="estimate-note">
                    This estimate is calculated from your selected
                    room prices and stay durations. It does not
                    include transport or other travel expenses.
                </p>

            </div>

            <div class="summary-footer">
                Your selected stays are saved in this browser,
                so you can return to your plan later.
            </div>

        </aside>

    </div>

</main>

<footer>
    <strong>KivuStay</strong> &nbsp; | &nbsp;
    Discover the beauty of Lake Kivu.
</footer>
<script>
    window.kivuStayCurrency = "<%= preferredCurrency %>";
</script>
<script src="<%= contextPath %>/trip-planner/TripPlannerCalculations.js"></script>
<script src="<%= contextPath %>/trip-planner/TripPlannerModel.js"></script>
<script src="<%= contextPath %>/trip-planner/TripPlannerView.js"></script>
<script src="<%= contextPath %>/trip-planner/TripPlannerController.js"></script>

</body>
</html>