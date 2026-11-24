document.addEventListener("DOMContentLoaded", function () {

    const searchInput =
        document.getElementById("reservationSearch");

    const statusFilter =
        document.getElementById("statusFilter");

    const tableBody =
        document.getElementById("reservationTableBody");

    const visibleCount =
        document.getElementById("visibleReservationCount");

    const noResults =
        document.getElementById("noReservationResults");


    // RESERVATION SEARCH AND FILTERING

    if (searchInput && statusFilter && tableBody) {

        const reservationRows = Array.from(
            tableBody.querySelectorAll(".reservation-row")
        );

        function filterReservations() {

            const searchTerm =
                searchInput.value.trim().toLowerCase();

            const selectedStatus =
                statusFilter.value;

            let matchingCount = 0;

            reservationRows.forEach(function (row) {

                const rowText =
                    row.textContent.toLowerCase();

                const rowStatus =
                    row.dataset.status;

                const matchesSearch =
                    rowText.includes(searchTerm);

                const matchesStatus =
                    selectedStatus === "ALL" ||
                    rowStatus === selectedStatus;

                const isVisible =
                    matchesSearch && matchesStatus;

                row.style.display =
                    isVisible ? "" : "none";

                if (isVisible) {
                    matchingCount++;
                }

            });


            // UPDATE RESULT COUNT

            if (visibleCount) {
                visibleCount.textContent = matchingCount;
            }


            // DISPLAY EMPTY SEARCH MESSAGE

            if (noResults) {

                noResults.style.display =
                    matchingCount === 0 ? "flex" : "none";

            }

        }


        searchInput.addEventListener(
            "input",
            filterReservations
        );

        statusFilter.addEventListener(
            "change",
            filterReservations
        );

    }

});
// =========================================
// MOBILE SIDEBAR
// =========================================

document.addEventListener("DOMContentLoaded", function () {

    const mobileMenuBtn =
        document.getElementById("mobileMenuBtn");

    const sidebar =
        document.querySelector(".sidebar");


    if (mobileMenuBtn && sidebar) {

        mobileMenuBtn.addEventListener("click", function () {

            sidebar.classList.toggle("open");

        });


        // CLOSE WHEN CLICKING OUTSIDE

        document.addEventListener("click", function (event) {

            const clickedInsideSidebar =
                sidebar.contains(event.target);

            const clickedMenuButton =
                mobileMenuBtn.contains(event.target);

            if (!clickedInsideSidebar && !clickedMenuButton) {

                sidebar.classList.remove("open");

            }

        });


        // CLOSE WITH ESCAPE KEY

        document.addEventListener("keydown", function (event) {

            if (event.key === "Escape") {

                sidebar.classList.remove("open");

            }

        });

    }

});