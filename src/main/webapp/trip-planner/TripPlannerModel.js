const TripPlannerModel = (function () {
    "use strict";

    const STORAGE_KEY = "kivustay_trip_plan";

    function getTrips() {
        try {
            const savedTrips = localStorage.getItem(STORAGE_KEY);
            return savedTrips ? JSON.parse(savedTrips) : [];
        } catch (error) {
            console.error("Could not load trip plan:", error);
            return [];
        }
    }

    function saveTrips(trips) {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(trips));
    }

    function addStay(stay) {
        const trips = getTrips();

        const alreadyAdded = trips.some(function (item) {
            return item.roomId === stay.roomId;
        });

        if (alreadyAdded) {
            return {
                success: false,
                message: "This stay is already in your plan."
            };
        }

        trips.push(stay);
        saveTrips(trips);

        return {
            success: true,
            message: "Stay added to your trip plan."
        };
    }

    function removeStay(roomId) {
        const trips = getTrips().filter(function (stay) {
            return stay.roomId !== roomId;
        });

        saveTrips(trips);
        return trips;
    }

    function moveStay(fromIndex, toIndex) {
        const trips = getTrips();

        if (
            fromIndex < 0 || fromIndex >= trips.length ||
            toIndex < 0 || toIndex >= trips.length
        ) {
            return trips;
        }

        const movedStay = trips.splice(fromIndex, 1)[0];
        trips.splice(toIndex, 0, movedStay);

        saveTrips(trips);
        return trips;
    }

    function calculateTotal() {
        return TripPlannerCalculations.calculateTotal(getTrips());
    }

    return {
        getTrips: getTrips,
        addStay: addStay,
        removeStay: removeStay,
        moveStay: moveStay,
        calculateTotal: calculateTotal
    };
})();