document.addEventListener("DOMContentLoaded", function () {

    var roomCards = document.querySelectorAll(".result-card");

    roomCards.forEach(function (card) {

        var bookingForm = card.querySelector(
            'form[action*="/guest/book"]'
        );

        if (!bookingForm) return;

        var roomId = bookingForm.querySelector(
            '[name="roomId"]'
        ).value;

        var checkIn = bookingForm.querySelector(
            '[name="checkIn"]'
        ).value;

        var checkOut = bookingForm.querySelector(
            '[name="checkOut"]'
        ).value;

        var quoteBox = document.createElement("div");

        quoteBox.className = "quote-box";

        quoteBox.innerHTML =
            '<p class="quote-title">YOUR PRICE QUOTE</p>' +
            '<p class="quote-status">Calculating your stay...</p>';

        var bookingAction = card.querySelector(".booking-action");

        bookingAction.parentNode.insertBefore(
            quoteBox,
            bookingAction
        );

        var xhr = new XMLHttpRequest();

        var contextPath = bookingForm.action.substring(
            0,
            bookingForm.action.indexOf("/guest/book")
        );

        var url = contextPath + "/quote"
            + "?roomId=" + encodeURIComponent(roomId)
            + "&checkIn=" + encodeURIComponent(checkIn)
            + "&checkOut=" + encodeURIComponent(checkOut);

        xhr.open("GET", url, true);

        xhr.setRequestHeader("Accept", "application/json");

        xhr.onreadystatechange = function () {

            if (xhr.readyState !== 4) return;

            var status = quoteBox.querySelector(".quote-status");

            try {

                var data = JSON.parse(xhr.responseText);

                if (xhr.status === 200 && data.success) {

                    quoteBox.innerHTML =
                        '<p class="quote-title">YOUR PRICE QUOTE</p>' +
                        '<div class="quote-line">' +
                            '<span>Duration</span>' +
                            '<strong>' + data.nights + ' nights</strong>' +
                        '</div>' +
                        '<div class="quote-line">' +
                            '<span>Subtotal</span>' +
                            '<strong>$' + Number(data.subtotal).toFixed(2) + '</strong>' +
                        '</div>' +
                        '<div class="quote-line">' +
                            '<span>Tax (10%)</span>' +
                            '<strong>$' + Number(data.tax).toFixed(2) + '</strong>' +
                        '</div>' +
                        '<div class="quote-total">' +
                            '<span>Total price</span>' +
                            '<strong>$' + Number(data.total).toFixed(2) + '</strong>' +
                        '</div>';

                } else {

                    status.textContent =
                        data.message || "Unable to calculate your quote.";
                }

            } catch (error) {

                status.textContent =
                    "Unable to read the price quote. Please try again.";
            }
        };

        xhr.onerror = function () {

            var status = quoteBox.querySelector(".quote-status");

            if (status) {
                status.textContent =
                    "Network error. Unable to calculate your quote.";
            }
        };

        xhr.send();
    });
});