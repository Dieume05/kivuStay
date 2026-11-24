document.addEventListener("DOMContentLoaded", function () {

    const bookingForms = document.querySelectorAll(
        'form[action*="/guest/book"]'
    );

    bookingForms.forEach(function (form) {

        const roomId = form.querySelector('[name="roomId"]');
        const checkIn = form.querySelector('[name="checkIn"]');
        const checkOut = form.querySelector('[name="checkOut"]');
        const guests = form.querySelector('[name="guests"]');

        const button = form.querySelector('button[type="submit"]');
        const card = form.closest(".result-card");

        const note = card
            ? card.querySelector(".booking-note")
            : null;

        const imageBadge = card
            ? card.querySelector(".image-badge")
            : null;

        const availabilityLabel = card
            ? card.querySelector(".availability")
            : null;

        let availabilityConfirmed = false;

        if (!roomId || !checkIn || !checkOut || !guests || !button) {
            return;
        }

        // Prevent booking until the server confirms availability.
        button.disabled = true;
        button.textContent = "Checking availability...";

        if (imageBadge) {
            imageBadge.textContent = "CHECKING...";
        }

        if (availabilityLabel) {
            availabilityLabel.textContent = "Checking...";
        }

        if (note) {
            note.textContent = "Verifying room availability...";
        }

        // Prevent submission unless availability is confirmed.
        form.addEventListener("submit", function (event) {
            if (!availabilityConfirmed) {
                event.preventDefault();
            }
        });

        // Build the availability endpoint from the booking URL.
        const availabilityUrl = new URL(form.action);

        availabilityUrl.pathname =
            availabilityUrl.pathname.replace(
                /\/guest\/book$/,
                "/availability"
            );

        availabilityUrl.searchParams.set("roomId", roomId.value);
        availabilityUrl.searchParams.set("checkIn", checkIn.value);
        availabilityUrl.searchParams.set("checkOut", checkOut.value);
        availabilityUrl.searchParams.set("guests", guests.value);

        fetch(availabilityUrl.toString(), {
            method: "GET",
            headers: {
                "Accept": "application/json"
            },
            cache: "no-store"
        })

        .then(function (response) {
            return response.json().then(function (data) {
                if (!response.ok) {
                    throw new Error(
                        data.message || "Availability check failed."
                    );
                }

                return data;
            });
        })

        .then(function (data) {

            if (data.available === true) {

                availabilityConfirmed = true;

                button.disabled = false;
                button.textContent = "Book this room →";

                if (imageBadge) {
                    imageBadge.textContent = "AVAILABLE";
                }

                if (availabilityLabel) {
                    availabilityLabel.textContent = "Available";
                }

                if (note) {
                    note.textContent =
                        "Availability confirmed. You can now book this room.";
                }

            } else {

                availabilityConfirmed = false;

                button.disabled = true;
                button.textContent = "Room unavailable";

                if (imageBadge) {
                    imageBadge.textContent = "UNAVAILABLE";
                }

                if (availabilityLabel) {
                    availabilityLabel.textContent = "Unavailable";
                }

                if (note) {
                    note.textContent = data.message;
                }
            }
        })

        .catch(function (error) {

            availabilityConfirmed = false;
            button.disabled = true;
            button.textContent = "Unable to verify";

            if (imageBadge) {
                imageBadge.textContent = "NOT VERIFIED";
            }

            if (availabilityLabel) {
                availabilityLabel.textContent = "Check failed";
            }

            if (note) {
                note.textContent =
                    error.message ||
                    "Could not verify availability. Please refresh the page.";
            }

            console.error("Availability check:", error);
        });

    });

});