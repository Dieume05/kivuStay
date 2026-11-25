QUnit.module("Date Calculations", function () {

    QUnit.test("1. Calculate a one-night stay", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateNights(
                "2026-11-20", "2026-11-21"
            ),
            1
        );
    });

    QUnit.test("2. Calculate a seven-night stay", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateNights(
                "2026-11-20", "2026-11-27"
            ),
            7
        );
    });

    QUnit.test("3. Handle a month-end date range", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateNights(
                "2026-01-30", "2026-02-02"
            ),
            3
        );
    });

    QUnit.test("4. Reject same-day check-in and check-out", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateNights(
                "2026-11-20", "2026-11-20"
            ),
            0
        );
    });

    QUnit.test("5. Reject check-out before check-in", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateNights(
                "2026-11-22", "2026-11-20"
            ),
            0
        );
    });

    QUnit.test("6. Handle invalid dates", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateNights(
                "invalid", "2026-11-25"
            ),
            0
        );
    });
});


QUnit.module("Price Calculations", function () {

    QUnit.test("7. Calculate the cost of one stay", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateStayTotal(120, 3),
            360
        );
    });

    QUnit.test("8. Calculate the total for multiple stays", function (assert) {
        const stays = [
            {
                checkIn: "2026-11-20",
                checkOut: "2026-11-23",
                pricePerNight: 120
            },
            {
                checkIn: "2026-11-24",
                checkOut: "2026-11-26",
                pricePerNight: 80
            }
        ];

        assert.strictEqual(
            TripPlannerCalculations.calculateTotal(stays),
            520
        );
    });

    QUnit.test("9. Round prices to two decimal places", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateStayTotal(19.999, 1),
            20
        );
    });

    QUnit.test("10. Reject negative prices", function (assert) {
        assert.strictEqual(
            TripPlannerCalculations.calculateStayTotal(-50, 2),
            0
        );
    });
});


QUnit.module("Booking Date Overlap", function () {

    QUnit.test("11. Detect overlapping booking dates", function (assert) {
        assert.true(
            TripPlannerCalculations.datesOverlap(
                "2026-11-20", "2026-11-25",
                "2026-11-23", "2026-11-28"
            )
        );
    });

    QUnit.test("12. Allow consecutive bookings without overlap", function (assert) {
        assert.false(
            TripPlannerCalculations.datesOverlap(
                "2026-11-20", "2026-11-25",
                "2026-11-25", "2026-11-28"
            )
        );
    });

    QUnit.test("13. Detect one booking inside another", function (assert) {
        assert.true(
            TripPlannerCalculations.datesOverlap(
                "2026-11-20", "2026-11-30",
                "2026-11-23", "2026-11-26"
            )
        );
    });

    QUnit.test("14. Reject invalid booking date ranges", function (assert) {
        assert.false(
            TripPlannerCalculations.datesOverlap(
                "2026-11-25", "2026-11-20",
                "2026-11-22", "2026-11-28"
            )
        );
    });
	QUnit.test("15. Reject impossible calendar dates", function (assert) {
	    assert.strictEqual(
	        TripPlannerCalculations.calculateNights(
	            "2026-02-30", "2026-03-03"
	        ),
	        0
	    );
	});
});
QUnit.test("7. Accept a valid leap-year date", function (assert) {
    assert.strictEqual(
        TripPlannerCalculations.calculateNights(
            "2024-02-29", "2024-03-01"
        ),
        1
    );
});