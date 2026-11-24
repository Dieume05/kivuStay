document.addEventListener("DOMContentLoaded", function () {

    // Select the sections and cards we want to animate
    const revealElements = document.querySelectorAll(
        ".search-section, " +
        ".featured-section, " +
        ".hotel-card, " +
        ".destinations-section, " +
        ".destination-card, " +
        ".about-section"
    );

    // Respect visitors who prefer reduced motion
    const prefersReducedMotion = window.matchMedia(
        "(prefers-reduced-motion: reduce)"
    ).matches;

    if (prefersReducedMotion) {
        return;
    }

    // Add the reveal class
    revealElements.forEach(function (element) {
        element.classList.add("reveal");
    });

    // Detect elements entering the visible screen
    const observer = new IntersectionObserver(
        function (entries, observer) {

            entries.forEach(function (entry) {

                if (entry.isIntersecting) {

                    entry.target.classList.add("revealed");

                    // Stop observing once the animation happens
                    observer.unobserve(entry.target);
                }

            });

        },
        {
            threshold: 0.15
        }
    );

    // Observe each selected element
    revealElements.forEach(function (element) {
        observer.observe(element);
    });

});
/* =================================
   KIVUSTAY SEARCH DATE VALIDATION
================================= */

document.addEventListener("DOMContentLoaded", function () {

    const searchForm = document.getElementById("staySearchForm");
    const checkIn = document.getElementById("checkin");
    const checkOut = document.getElementById("checkout");
    const searchMessage = document.getElementById("searchMessage");

    if (!searchForm || !checkIn || !checkOut) {
        return;
    }

    // Get today's date in local time
    function getToday() {
        const today = new Date();
        const year = today.getFullYear();
        const month = String(today.getMonth() + 1).padStart(2, "0");
        const day = String(today.getDate()).padStart(2, "0");

        return `${year}-${month}-${day}`;
    }

    // Set the earliest check-in date
    checkIn.min = getToday();
	checkOut.min = getToday();

    // Display validation messages
    function showMessage(message, isError) {
        searchMessage.textContent = message;
        searchMessage.classList.toggle("error", isError);
        searchMessage.classList.toggle("success", !isError);
    }

    // Update checkout date when check-in changes
	checkIn.addEventListener("change", function () {
	    checkOut.min = getToday();

	    if (checkIn.value && checkOut.value &&
	        checkOut.value <= checkIn.value) {
	        showMessage("Check-out must be after check-in.", true);
	        return;
	    }

	    showMessage("", false);
	});

    // Validate before submitting
    searchForm.addEventListener("submit", function (event) {

        const today = getToday();

        if (!checkIn.value || !checkOut.value) {
            event.preventDefault();
            showMessage("Please select both check-in and check-out dates.", true);
            return;
        }

        if (checkIn.value < today) {
            event.preventDefault();
            showMessage("Check-in cannot be in the past.", true);
            return;
        }

        if (checkOut.value <= checkIn.value) {
            event.preventDefault();
            showMessage("Check-out must be after check-in.", true);
            return;
        }

        showMessage("Dates look good! Searching for available stays...", false);
    });

});