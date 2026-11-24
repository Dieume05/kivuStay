/* =========================================
   KIVUSTAY MANAGER DASHBOARD
   Dynamic Chart.js Analytics
   ========================================= */

document.addEventListener("DOMContentLoaded", function () {
    "use strict";

    if (typeof Chart === "undefined") {
        console.error("Chart.js could not be loaded.");
        return;
    }

    // =====================================
    // CHART DEFAULT SETTINGS
    // =====================================

    Chart.defaults.font.family = "'DM Sans', sans-serif";
    Chart.defaults.font.size = 11;
    Chart.defaults.color = "#77868A";

    Chart.defaults.plugins.legend.display = false;
    Chart.defaults.plugins.tooltip.backgroundColor = "#102B35";
    Chart.defaults.plugins.tooltip.padding = 12;
    Chart.defaults.plugins.tooltip.cornerRadius = 8;

    // =====================================
    // CHART INSTANCES
    // =====================================

    var occupancyChart = null;
    var monthlyBookingsChart = null;
    var roomTypeChart = null;

    // =====================================
    // HELPER: NORMALIZE NUMBERS
    // =====================================

    function numericValues(values) {
        return Array.isArray(values)
            ? values.map(function (value) {
                return Number(value) || 0;
            })
            : [];
    }

    // =====================================
    // HELPER: FORMAT MONTH LABELS
    // =====================================

    function formatMonth(value) {
        var parts = String(value).split("-");

        if (parts.length !== 2) {
            return value;
        }

        var date = new Date(
            Number(parts[0]),
            Number(parts[1]) - 1,
            1
        );

        return date.toLocaleDateString("en-US", {
            month: "short",
            year: "2-digit"
        });
    }

    // =====================================
    // 1. OCCUPANCY PER HOTEL
    // BAR CHART
    // =====================================

    function createOccupancyChart(data) {
        var canvas = document.getElementById(
            "occupancyPerHotelChart"
        );

        if (!canvas) return;

        var labels = data.map(function (item) {
            return item.hotelName || "Unknown hotel";
        });

        var values = numericValues(data.map(function (item) {
            return item.occupancyRate;
        }));

        var occupiedRooms = numericValues(data.map(function (item) {
            return item.occupiedRooms;
        }));

        var totalRooms = numericValues(data.map(function (item) {
            return item.totalRooms;
        }));

        var hasData = labels.length > 0;

        if (occupancyChart) {
            occupancyChart.destroy();
        }

        occupancyChart = new Chart(canvas, {
            type: "bar",

            data: {
                labels: hasData ? labels : ["No data"],

                datasets: [{
                    label: "Occupancy Rate",

                    data: hasData ? values : [0],

                    backgroundColor: hasData
                        ? "#267C78"
                        : "#E9E9E3",

                    hoverBackgroundColor: "#102B35",

                    borderRadius: 7,

                    borderSkipped: false,

                    maxBarThickness: 55
                }]
            },

            options: {
                responsive: true,

                maintainAspectRatio: false,

                plugins: {
                    legend: {
                        display: false
                    },

                    tooltip: {
                        enabled: hasData,

                        callbacks: {
                            label: function (context) {
                                var index = context.dataIndex;

                                return [
                                    " Occupancy: " +
                                        Number(context.raw).toFixed(1) + "%",

                                    " Occupied rooms: " +
                                        occupiedRooms[index] +
                                        " / " + totalRooms[index]
                                ];
                            }
                        }
                    }
                },

                scales: {
                    x: {
                        grid: {
                            display: false
                        },

                        border: {
                            display: false
                        }
                    },

                    y: {
                        beginAtZero: true,

                        max: 100,

                        border: {
                            display: false
                        },

                        grid: {
                            color: "#F0F0EC",
                            drawTicks: false
                        },

                        ticks: {
                            padding: 10,

                            callback: function (value) {
                                return value + "%";
                            }
                        }
                    }
                }
            }
        });
    }

    // =====================================
    // 2. BOOKINGS PER MONTH
    // LINE CHART
    // =====================================

    function createMonthlyBookingsChart(data) {
        var canvas = document.getElementById(
            "bookingsPerMonthChart"
        );

        if (!canvas) return;

        var rawLabels = data.map(function (item) {
            return item.month;
        });

        var values = numericValues(data.map(function (item) {
            return item.totalBookings;
        }));

        var hasData = rawLabels.length > 0;

        var labels = hasData
            ? rawLabels.map(formatMonth)
            : ["No data"];

        if (monthlyBookingsChart) {
            monthlyBookingsChart.destroy();
        }

        monthlyBookingsChart = new Chart(canvas, {
            type: "line",

            data: {
                labels: labels,

                datasets: [{
                    label: "Bookings",

                    data: hasData ? values : [0],

                    borderColor: "#267C78",

                    backgroundColor: "rgba(38, 124, 120, 0.10)",

                    fill: true,

                    tension: 0.35,

                    borderWidth: 3,

                    pointRadius: 4,

                    pointHoverRadius: 6,

                    pointBackgroundColor: "#267C78",

                    pointBorderColor: "#FFFFFF",

                    pointBorderWidth: 2
                }]
            },

            options: {
                responsive: true,

                maintainAspectRatio: false,

                interaction: {
                    intersect: false,
                    mode: "index"
                },

                plugins: {
                    legend: {
                        display: false
                    },

                    tooltip: {
                        enabled: hasData,

                        callbacks: {
                            label: function (context) {
                                return " Bookings: " + context.raw;
                            }
                        }
                    }
                },

                scales: {
                    x: {
                        grid: {
                            display: false
                        },

                        border: {
                            display: false
                        }
                    },

                    y: {
                        beginAtZero: true,

                        border: {
                            display: false
                        },

                        grid: {
                            color: "#F0F0EC",
                            drawTicks: false
                        },

                        ticks: {
                            precision: 0,
                            padding: 10
                        }
                    }
                }
            }
        });
    }

    // =====================================
    // 3. ROOM TYPE SHARE
    // PIE CHART
    // =====================================

    function createRoomTypeShareChart(data) {
        var canvas = document.getElementById(
            "roomTypeShareChart"
        );

        if (!canvas) return;

        var labels = data.map(function (item) {
            return item.roomName || "Other";
        });

        var values = numericValues(data.map(function (item) {
            return item.totalRooms;
        }));

        var hasData = labels.length > 0;

        var colors = [
            "#267C78",
            "#D69A45",
            "#102B35",
            "#8AA9A5",
            "#C65D5D",
            "#A7B2B3",
            "#B5A58A",
            "#567D8A"
        ];

        if (roomTypeChart) {
            roomTypeChart.destroy();
        }

        roomTypeChart = new Chart(canvas, {
            type: "pie",

            data: {
                labels: hasData ? labels : ["No data"],

                datasets: [{
                    data: hasData ? values : [1],

                    backgroundColor: hasData
                        ? labels.map(function (label, index) {
                            return colors[index % colors.length];
                        })
                        : ["#E9E9E3"],

                    borderColor: "#FFFFFF",

                    borderWidth: 3,

                    hoverOffset: hasData ? 7 : 0
                }]
            },

            options: {
                responsive: true,

                maintainAspectRatio: false,

                plugins: {
                    legend: {
                        display: hasData,

                        position: "bottom",

                        labels: {
                            usePointStyle: true,

                            pointStyle: "circle",

                            padding: 16,

                            font: {
                                size: 10
                            }
                        }
                    },

                    tooltip: {
                        enabled: hasData,

                        callbacks: {
                            label: function (context) {
                                var total =
                                    context.dataset.data.reduce(
                                        function (sum, value) {
                                            return sum + Number(value);
                                        },
                                        0
                                    );

                                var value = Number(context.raw);

                                var percentage = total > 0
                                    ? ((value / total) * 100).toFixed(1)
                                    : "0.0";

                                return " " + context.label +
                                    ": " + value +
                                    " rooms (" + percentage + "%)";
                            }
                        }
                    }
                }
            }
        });
    }

    // =====================================
    // LOAD DATA FROM JSON SERVLET
    // =====================================

    function loadDashboardCharts() {
        var endpoint =
            window.location.origin +
            window.location.pathname.substring(
                0,
                window.location.pathname.indexOf("/", 1)
            ) +
            "/manager/dashboard-data";

        fetch(endpoint, {
            method: "GET",

            credentials: "same-origin",

            headers: {
                "Accept": "application/json"
            }
        })
        .then(function (response) {
            if (!response.ok) {
                throw new Error(
                    "Dashboard request failed: HTTP " +
                    response.status
                );
            }

            return response.json();
        })
        .then(function (dashboard) {
            if (!dashboard.success) {
                throw new Error(
                    dashboard.message || "Unable to load dashboard data."
                );
            }

            createOccupancyChart(
                dashboard.occupancyPerHotel || []
            );

            createMonthlyBookingsChart(
                dashboard.bookingsPerMonth || []
            );

            createRoomTypeShareChart(
                dashboard.roomTypeShare || []
            );

            console.log(
                "KivuStay charts loaded successfully from JSON."
            );
        })
        .catch(function (error) {
            console.error(
                "Could not load dashboard charts:",
                error
            );
        });
    }

    // =====================================
    // INITIALIZE DASHBOARD
    // =====================================

    loadDashboardCharts();

    // Allow charts to be refreshed when new data is available.
    window.refreshKivuStayCharts = loadDashboardCharts;

});