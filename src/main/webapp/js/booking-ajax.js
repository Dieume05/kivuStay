document.addEventListener("DOMContentLoaded", function () {

    var bookingForms = document.querySelectorAll(
        'form[action*="/guest/book"]'
    );

    bookingForms.forEach(function (form) {

        form.addEventListener("submit", function (event) {

            event.preventDefault();

            var button = form.querySelector(
                'button[type="submit"]'
            );

            var card = form.closest(".result-card");

            var note = card
                ? card.querySelector(".booking-note")
                : null;

            if (!button || button.disabled) {
                return;
            }

            var originalText = button.textContent;

            button.disabled = true;
            button.textContent = "Processing booking...";

            if (note) {
                note.textContent = "Processing your booking...";
            }

            var xhr = new XMLHttpRequest();

            xhr.open("POST", form.action, true);

            xhr.setRequestHeader(
                "Accept",
                "application/json"
            );

            xhr.setRequestHeader(
                "Content-Type",
                "application/x-www-form-urlencoded; charset=UTF-8"
            );

            xhr.onreadystatechange = function () {

                if (xhr.readyState !== 4) {
                    return;
                }

                var data;

                try {
                    data = JSON.parse(xhr.responseText);
                } catch (error) {

                    button.disabled = false;
                    button.textContent = originalText;

                    if (note) {
                        note.textContent =
                            "Invalid server response. Please try again.";
                    }

                    return;
                }

                if (xhr.status >= 200 &&
                        xhr.status < 300 &&
                        data.success) {

                    button.textContent = "Booking successful!";

                    if (note) {
                        note.textContent = data.message + " ";

                        var link = document.createElement("a");
                        link.href = data.redirectUrl;
                        link.textContent = "View booking details";

                        note.appendChild(link);
                    }

                    return;
                }

                button.disabled = false;
                button.textContent = originalText;

                if (note) {
                    note.textContent = data.message ||
                        "Booking could not be completed.";
                }
            };

            xhr.onerror = function () {

                button.disabled = false;
                button.textContent = originalText;

                if (note) {
                    note.textContent =
                        "Network error. Please try again.";
                }
            };

            var formData = new FormData(form);

            var parameters = new URLSearchParams(formData);

            xhr.send(parameters.toString());

        });

    });

});