const TripPlannerController = (function () {
    "use strict";

    function refresh() {
        const trips = TripPlannerModel.getTrips();
        const total = TripPlannerModel.calculateTotal();

        TripPlannerView.render(trips, total);
    }

    function addStay(stay) {
        if (
            !stay.roomId ||
            !stay.checkIn ||
            !stay.checkOut ||
            !Number.isFinite(Number(stay.pricePerNight)) ||
            Number(stay.pricePerNight) <= 0 ||
            !stay.hotelName
        ) {
            const result = {
                success: false,
                message: "Invalid stay information."
            };

            TripPlannerView.showMessage(result.message, true);
            return result;
        }

        if (new Date(stay.checkOut) <= new Date(stay.checkIn)) {
            const result = {
                success: false,
                message: "Check-out must be after check-in."
            };

            TripPlannerView.showMessage(result.message, true);
            return result;
        }

        const result = TripPlannerModel.addStay(stay);

        TripPlannerView.showMessage(
            result.message,
            !result.success
        );

        refresh();

        return result;
    }

    function handlePlannerActions(event) {
        const button = event.target.closest("button[data-action]");

        if (!button) {
            return;
        }

        const action = button.dataset.action;

        if (action === "remove") {
            TripPlannerModel.removeStay(button.dataset.roomId);
            TripPlannerView.showMessage("Stay removed.", false);
        }

        if (action === "up" || action === "down") {
            const fromIndex = Number(button.dataset.index);
            const toIndex = action === "up"
                ? fromIndex - 1
                : fromIndex + 1;

            TripPlannerModel.moveStay(fromIndex, toIndex);
        }

        refresh();
    }

    function init() {
        const container = document.getElementById("trip-list");

        if (container) {
            container.addEventListener("click", handlePlannerActions);
        }

        refresh();
    }

    return {
        init: init,
        addStay: addStay,
        refresh: refresh
    };
})();

document.addEventListener("DOMContentLoaded", function () {
    TripPlannerController.init();
});