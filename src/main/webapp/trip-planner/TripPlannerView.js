const TripPlannerView = (function () {
    "use strict";

    // Original prices remain in USD.
    // Only their display values are converted.
    const exchangeRates = {
        USD: 1,
        EUR: 0.91755,
        CDF: 2316.57,
        RWF: 1473.99
    };

    const currencySymbols = {
        USD: "$",
        EUR: "€",
        CDF: "FC",
        RWF: "RF"
    };

    const decimalPlaces = {
        USD: 2,
        EUR: 2,
        CDF: 0,
        RWF: 0
    };

    function formatCurrency(amount) {
        const currency =
            window.kivuStayCurrency || "USD";

        const rate = exchangeRates[currency] || 1;
        const symbol = currencySymbols[currency] || "$";
		const decimals = decimalPlaces[currency] !== undefined
		? decimalPlaces[currency]
		: 2;

        const convertedAmount = Number(amount || 0) * rate;

        const formattedAmount = new Intl.NumberFormat("en-US", {
            minimumFractionDigits: decimals,
            maximumFractionDigits: decimals
        }).format(convertedAmount);

        return symbol + formattedAmount;
    }

    function createElement(tag, className, text) {
        const element = document.createElement(tag);

        if (className) {
            element.className = className;
        }

        if (text !== undefined && text !== null) {
            element.textContent = text;
        }

        return element;
    }

    function createDetail(label, value) {
        const wrapper = createElement("div", "stay-detail");

        const heading = createElement("span", "detail-label", label);
        const content = createElement("strong", "detail-value", value);

        wrapper.append(heading, content);

        return wrapper;
    }

    function createActionButton(text, action, index, roomId) {
        const button = createElement("button", "stay-action", text);

        button.type = "button";
        button.dataset.action = action;

        if (action === "remove") {
            button.dataset.roomId = roomId;
            button.classList.add("remove-action");
        } else {
            button.dataset.index = index;
        }

        return button;
    }

    function createStayCard(stay, index, totalStays) {
        const card = createElement("article", "trip-card");

        const visual = createElement("div", "stay-visual");

        if (stay.imageUrl) {
            const image = document.createElement("img");
            image.src = stay.imageUrl;
            image.alt = stay.hotelName;
            image.loading = "lazy";

            visual.appendChild(image);
            visual.classList.add("has-image");
        } else {
            const visualContent = createElement("div", "visual-content");

            const visualLabel = createElement(
                "span",
                "visual-label",
                "KIVUSTAY COLLECTION"
            );

            const visualTitle = createElement(
                "strong",
                "visual-title",
                "Your Lake Kivu stay"
            );

            visualContent.append(visualLabel, visualTitle);
            visual.appendChild(visualContent);
        }

        const content = createElement("div", "stay-content");
        const topRow = createElement("div", "stay-top-row");

        const location = createElement(
            "span",
            "stay-location",
            stay.location || "Lake Kivu"
        );

        const number = createElement(
            "span",
            "stay-number",
            "STAY " + String(index + 1).padStart(2, "0")
        );

        topRow.append(location, number);

        const title = createElement(
            "h3",
            "stay-title",
            stay.hotelName || "Accommodation"
        );

        const room = createElement(
            "p",
            "stay-room",
            stay.roomName || "Selected room"
        );

        const details = createElement("div", "stay-details");

        details.append(
            createDetail("CHECK-IN", stay.checkIn),
            createDetail("CHECK-OUT", stay.checkOut)
        );

        const footer = createElement("div", "stay-footer");
        const priceBox = createElement("div", "stay-price");

        const priceLabel = createElement(
            "span",
            "price-label",
            "PRICE PER NIGHT"
        );

        const priceValue = createElement(
            "strong",
            "price-value",
            formatCurrency(stay.pricePerNight)
        );

        priceBox.append(priceLabel, priceValue);

        const actions = createElement("div", "stay-actions");

        const removeButton = createActionButton(
            "Remove", "remove", index, stay.roomId
        );

        const upButton = createActionButton(
            "↑", "up", index, stay.roomId
        );

        upButton.title = "Move stay up";
        upButton.setAttribute("aria-label", "Move stay up");
        upButton.disabled = index === 0;

        const downButton = createActionButton(
            "↓", "down", index, stay.roomId
        );

        downButton.title = "Move stay down";
        downButton.setAttribute("aria-label", "Move stay down");
        downButton.disabled = index === totalStays - 1;

        actions.append(removeButton, upButton, downButton);
        footer.append(priceBox, actions);

        content.append(topRow, title, room, details, footer);
        card.append(visual, content);

        return card;
    }

    function render(trips, total) {
        const container = document.getElementById("trip-list");
        const totalElement = document.getElementById("trip-total");
        const messageElement = document.getElementById("trip-message");

        if (!container || !totalElement) {
            return;
        }

        container.innerHTML = "";

        if (trips.length === 0) {
            const empty = createElement("div", "empty-plan");

            const icon = createElement("div", "empty-icon", "✦");

            const title = createElement(
                "h3",
                "empty-title",
                "Your journey starts here"
            );

            const description = createElement(
                "p",
                "empty-description",
                "You haven't shortlisted any accommodation yet. Explore our stays and add your favourites to begin planning."
            );

            empty.append(icon, title, description);
            container.appendChild(empty);
        } else {
            trips.forEach(function (stay, index) {
                const card = createStayCard(stay, index, trips.length);
                container.appendChild(card);
            });
        }

        // The total is also stored and calculated in USD.
        // Conversion happens only when displaying it.
        totalElement.textContent = formatCurrency(total);

        if (messageElement && trips.length > 0) {
            messageElement.textContent =
                trips.length + " accommodation option(s) in your trip plan.";

            messageElement.className = "success-message";
        } else if (messageElement) {
            messageElement.textContent =
                "Your trip plan is currently empty.";

            messageElement.className = "";
        }
    }

    function showMessage(message, isError) {
        const element = document.getElementById("trip-message");

        if (element) {
            element.textContent = message;

            element.className = isError
                ? "error-message"
                : "success-message";
        }
    }

    return {
        render: render,
        showMessage: showMessage
    };
})();