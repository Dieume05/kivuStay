document.addEventListener("DOMContentLoaded", function () {

// =====================================
// HOTEL SEARCH
// =====================================

const searchInput = document.getElementById("hotelSearch");
const hotelGrid = document.getElementById("hotelGrid");
const noResults = document.getElementById("noSearchResults");
const visibleHotelCount = document.getElementById("visibleHotelCount");

if (searchInput && hotelGrid) {

    const hotelCards = Array.from(
        hotelGrid.querySelectorAll(".hotel-card")
    );

    function filterHotels() {

        const searchTerm = searchInput.value
            .trim()
            .toLowerCase();

        let visibleCount = 0;

        hotelCards.forEach(function (card) {

            const searchableText = card.textContent.toLowerCase();

            const matches = searchableText.includes(searchTerm);

            card.style.display = matches ? "" : "none";

            if (matches) {
                visibleCount++;
            }
        });

        if (visibleHotelCount) {
            visibleHotelCount.textContent = visibleCount;
        }

        if (noResults) {
            noResults.style.display =
                visibleCount === 0 ? "flex" : "none";
        }
    }

    searchInput.addEventListener("input", filterHotels);

}

// =====================================
// MOBILE SIDEBAR
// =====================================

const mobileMenuBtn = document.getElementById("mobileMenuBtn");
const sidebar = document.querySelector(".sidebar");

if (mobileMenuBtn && sidebar) {

    mobileMenuBtn.addEventListener("click", function () {

        sidebar.classList.toggle("open");

    });

}
// =====================================
    // CLOSE SIDEBAR WHEN CLICKING OUTSIDE
    // =====================================

    document.addEventListener("click", function (event) {

        if (!sidebar || !mobileMenuBtn) {
            return;
        }

        const clickedInsideSidebar = sidebar.contains(event.target);
        const clickedMenuButton = mobileMenuBtn.contains(event.target);

        if (!clickedInsideSidebar && !clickedMenuButton) {
            sidebar.classList.remove("open");
        }

    });

    // =====================================
    // CLOSE SIDEBAR WITH ESCAPE KEY
    // =====================================

    document.addEventListener("keydown", function (event) {

        if (event.key === "Escape" && sidebar) {
            sidebar.classList.remove("open");
        }

    });

});