/* =========================================
   KIVUSTAY — TRIP PLANNER
   Architecture: Model - View - Controller
========================================= */


/* =========================================
   1. MODEL
   Manages itinerary data and local storage.
========================================= */

const TripModel = (() => {

    const STORAGE_KEY = "kivustay_trip_itinerary_v1";

    let trips = [];

    function loadTrips() {
        try {
            const savedTrips = localStorage.getItem(STORAGE_KEY);

            trips = savedTrips ? JSON.parse(savedTrips) : [];

            if (!Array.isArray(trips)) {
                trips = [];
            }

            trips = trips.filter(trip =>
                trip &&
                typeof trip.id === "string" &&
                typeof trip.destination === "string" &&
                typeof trip.date === "string"
            );

        } catch (error) {
            console.error("Unable to load itinerary:", error);
            trips = [];
        }
    }

    function saveTrips() {
        try {
            localStorage.setItem(
                STORAGE_KEY,
                JSON.stringify(trips)
            );

            return true;

        } catch (error) {
            console.error("Unable to save itinerary:", error);
            return false;
        }
    }

    function getTrips() {
        return [...trips].sort((a, b) =>
            a.date.localeCompare(b.date)
        );
    }

    function addTrip(destination, date, notes) {

        const newTrip = {
            id: Date.now().toString() +
                Math.random().toString(36).slice(2, 8),

            destination: destination,
            date: date,
            notes: notes
        };

        trips.push(newTrip);

        if (!saveTrips()) {
            trips.pop();
            return false;
        }

        return true;
    }

    function removeTrip(id) {

        const previousTrips = [...trips];

        trips = trips.filter(trip => trip.id !== id);

        if (!saveTrips()) {
            trips = previousTrips;
            return false;
        }

        return true;
    }

    function initialize() {
        loadTrips();
    }

    return {
        initialize,
        getTrips,
        addTrip,
        removeTrip
    };

})();


/* =========================================
   2. VIEW
   Displays itinerary data on the page.
========================================= */

const TripView = (() => {

    const form = document.getElementById("tripPlannerForm");

    const destinationInput =
        document.getElementById("tripDestination");

    const dateInput =
        document.getElementById("tripDate");

    const notesInput =
        document.getElementById("tripNotes");

    const tripList =
        document.getElementById("tripList");

    const emptyState =
        document.getElementById("tripEmptyState");

    const tripCount =
        document.getElementById("tripCount");

    const message =
        document.getElementById("plannerMessage");


    function displayMessage(text, isError = false) {

        message.textContent = text;

        message.style.color = isError
            ? "#B45345"
            : "#267C78";
    }


    function formatDate(dateString) {

        const parts = dateString.split("-").map(Number);

        const date = new Date(
            parts[0],
            parts[1] - 1,
            parts[2]
        );

        return new Intl.DateTimeFormat("en-GB", {
            day: "numeric",
            month: "long",
            year: "numeric"
        }).format(date);
    }


    function createTripElement(trip) {

        const article = document.createElement("article");
        article.className = "trip-item";

        const content = document.createElement("div");
        content.className = "trip-item-content";

        const title = document.createElement("h4");
        title.textContent = trip.destination;

        const date = document.createElement("span");
        date.className = "trip-item-date";
        date.textContent = formatDate(trip.date);

        const notes = document.createElement("p");
        notes.className = "trip-item-notes";
        notes.textContent = trip.notes || "No additional notes.";

        const removeButton = document.createElement("button");
        removeButton.type = "button";
        removeButton.className = "trip-remove-button";
        removeButton.textContent = "Remove";
        removeButton.dataset.tripId = trip.id;

        content.appendChild(title);
        content.appendChild(date);
        content.appendChild(notes);

        article.appendChild(content);
        article.appendChild(removeButton);

        return article;
    }


    function renderTrips(trips) {

        tripList.replaceChildren();

        const hasTrips = trips.length > 0;

        emptyState.hidden = hasTrips;

        tripCount.textContent =
            `${trips.length} ${trips.length === 1 ? "stop" : "stops"}`;

        trips.forEach(trip => {
            tripList.appendChild(createTripElement(trip));
        });
    }


    function clearForm() {
        form.reset();
        displayMessage("");
    }


    function getFormData() {

        return {
            destination: destinationInput.value.trim(),
            date: dateInput.value,
            notes: notesInput.value.trim()
        };
    }


    function setMinimumDate() {

        const today = new Date();

        const localDate = [
            today.getFullYear(),
            String(today.getMonth() + 1).padStart(2, "0"),
            String(today.getDate()).padStart(2, "0")
        ].join("-");

        dateInput.min = localDate;
    }


    return {
        form,
        tripList,
        getFormData,
        renderTrips,
        clearForm,
        displayMessage,
        setMinimumDate
    };

})();


/* =========================================
   3. CONTROLLER
   Connects user actions to Model and View.
========================================= */

const TripController = (() => {

    function handleAddTrip(event) {

        event.preventDefault();

        const data = TripView.getFormData();

        if (!data.destination || !data.date) {
            TripView.displayMessage(
                "Please enter a destination and visit date.",
                true
            );
            return;
        }

        const selectedDate = new Date(
            data.date + "T00:00:00"
        );

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        if (Number.isNaN(selectedDate.getTime()) ||
            selectedDate < today) {

            TripView.displayMessage(
                "Please select today or a future date.",
                true
            );
            return;
        }

        const saved = TripModel.addTrip(
            data.destination,
            data.date,
            data.notes
        );

        if (!saved) {
            TripView.displayMessage(
                "Unable to save your trip. Check your browser storage.",
                true
            );
            return;
        }

        TripView.renderTrips(TripModel.getTrips());
        TripView.clearForm();

        TripView.displayMessage(
            "Destination added to your itinerary successfully!"
        );
    }


    function handleRemoveTrip(event) {

        const button = event.target.closest(
            ".trip-remove-button"
        );

        if (!button || !TripView.tripList.contains(button)) {
            return;
        }

        const tripId = button.dataset.tripId;

        const removed = TripModel.removeTrip(tripId);

        if (!removed) {
            TripView.displayMessage(
                "Unable to remove this destination.",
                true
            );
            return;
        }

        TripView.renderTrips(TripModel.getTrips());

        TripView.displayMessage(
            "Destination removed from your itinerary."
        );
    }


    function initialize() {

        TripModel.initialize();

        TripView.setMinimumDate();

        TripView.renderTrips(TripModel.getTrips());

        TripView.form.addEventListener(
            "submit",
            handleAddTrip
        );

        TripView.tripList.addEventListener(
            "click",
            handleRemoveTrip
        );
    }


    return {
        initialize
    };

})();


/* =========================================
   APPLICATION INITIALIZATION
========================================= */

document.addEventListener("DOMContentLoaded", () => {

    if (!document.getElementById("tripPlannerForm")) {
        return;
    }

    TripController.initialize();

});