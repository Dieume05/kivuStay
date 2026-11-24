const TripPlannerCalculations = (function () {
    "use strict";

    const MILLISECONDS_PER_DAY = 1000 * 60 * 60 * 24;

    // Parse and strictly validate a YYYY-MM-DD calendar date.
    function parseDate(dateString) {
        if (typeof dateString !== "string") {
            return null;
        }

        const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(dateString);

        if (!match) {
            return null;
        }

        const year = Number(match[1]);
        const month = Number(match[2]);
        const day = Number(match[3]);

        const timestamp = Date.UTC(year, month - 1, day);
        const date = new Date(timestamp);

        if (
            date.getUTCFullYear() !== year ||
            date.getUTCMonth() !== month - 1 ||
            date.getUTCDate() !== day
        ) {
            return null;
        }

        return timestamp;
    }

    function calculateNights(checkIn, checkOut) {
        const start = parseDate(checkIn);
        const end = parseDate(checkOut);

        if (start === null || end === null || end <= start) {
            return 0;
        }

        return (end - start) / MILLISECONDS_PER_DAY;
    }

    function calculateStayTotal(pricePerNight, nights) {
        const price = Number(pricePerNight);

        if (
            !Number.isFinite(price) ||
            price < 0 ||
            !Number.isFinite(nights) ||
            nights < 0
        ) {
            return 0;
        }

        return Math.round(price * nights * 100) / 100;
    }

    function calculateTotal(stays) {
        return stays.reduce(function (total, stay) {
            const nights = calculateNights(
                stay.checkIn,
                stay.checkOut
            );

            return total + calculateStayTotal(
                stay.pricePerNight,
                nights
            );
        }, 0);
    }

    function datesOverlap(startA, endA, startB, endB) {
        const aStart = parseDate(startA);
        const aEnd = parseDate(endA);
        const bStart = parseDate(startB);
        const bEnd = parseDate(endB);

        if (
            aStart === null ||
            aEnd === null ||
            bStart === null ||
            bEnd === null ||
            aEnd <= aStart ||
            bEnd <= bStart
        ) {
            return false;
        }

        return aStart < bEnd && aEnd > bStart;
    }

    return {
        calculateNights: calculateNights,
        calculateStayTotal: calculateStayTotal,
        calculateTotal: calculateTotal,
        datesOverlap: datesOverlap
    };
})();