/* =========================================
   KIVUSTAY - MANAGER ROOM MANAGEMENT
   Modal Controller
========================================= */

document.addEventListener("DOMContentLoaded", function () {
		console.log("DELETE ROOM DOM READY");

    const roomModal = document.getElementById("roomModal");
    const roomForm = document.getElementById("roomForm");

    const openAddRoomButton = document.getElementById("openAddRoom");
    const closeRoomModalButton = document.getElementById("closeRoomModal");
    const cancelRoomModalButton = document.getElementById("cancelRoomModal");

    const modalTitle = document.getElementById("modalTitle");
    const modalDescription = document.getElementById("modalDescription");

    const formAction = document.getElementById("formAction");
    const roomIdInput = document.getElementById("roomId");
    const roomTypeInput = document.getElementById("roomTypeId");
    const roomNumberInput = document.getElementById("roomNumber");
    const roomStatusInput = document.getElementById("roomStatus");

    const saveRoomButton = document.getElementById("saveRoomButton");

    /* OPEN MODAL */

    function openModal() {
        roomModal.classList.add("active");
        document.body.style.overflow = "hidden";
    }

    /* CLOSE MODAL */

    function closeModal() {
        roomModal.classList.remove("active");
        document.body.style.overflow = "";
    }

    /* RESET FORM */

    function resetRoomForm() {
        roomForm.reset();

        formAction.value = "add";
        roomIdInput.value = "";

        modalTitle.textContent = "Add New Room";

        modalDescription.textContent =
            "Register a physical room under one of your properties.";

        saveRoomButton.innerHTML =
            '<i class="fa-solid fa-check"></i> Save Room';
    }

    /* ADD ROOM */

    openAddRoomButton.addEventListener("click", function () {

        resetRoomForm();

        openModal();

        roomTypeInput.focus();
    });

    /* EDIT ROOM */

    document.querySelectorAll(".edit-room-button").forEach(function (button) {

        button.addEventListener("click", function () {

            resetRoomForm();

            formAction.value = "update";

            roomIdInput.value = this.dataset.roomId;

            roomTypeInput.value = this.dataset.roomTypeId;

            roomNumberInput.value = this.dataset.roomNumber;

            roomStatusInput.value = this.dataset.roomStatus;

            modalTitle.textContent = "Edit Room";

            modalDescription.textContent =
                "Update the room category, number or operational status.";

            saveRoomButton.innerHTML =
                '<i class="fa-solid fa-floppy-disk"></i> Update Room';

            openModal();

            roomNumberInput.focus();
        });

    });

    /* CLOSE BUTTONS */

    closeRoomModalButton.addEventListener("click", closeModal);

    cancelRoomModalButton.addEventListener("click", closeModal);

    /* CLOSE WHEN CLICKING OUTSIDE */

    roomModal.addEventListener("click", function (event) {

        if (event.target === roomModal) {
            closeModal();
        }

    });

    /* CLOSE WITH ESCAPE KEY */

    document.addEventListener("keydown", function (event) {

        if (event.key === "Escape" &&
            roomModal.classList.contains("active")) {

            closeModal();
        }

    });

});


/* =========================================
   ROOM SEARCH AND STATUS FILTER
========================================= */

document.addEventListener("DOMContentLoaded", function () {

    const searchInput = document.getElementById("roomSearch");
    const statusFilter = document.getElementById("statusFilter");
    const tableBody = document.getElementById("roomsTableBody");

    if (!searchInput || !statusFilter || !tableBody) {
        return;
    }

    const roomRows = Array.from(
        tableBody.querySelectorAll(".room-row")
    );

    function filterRooms() {

        const searchValue = searchInput.value
            .trim()
            .toLowerCase();

        const selectedStatus = statusFilter.value;

        let visibleCount = 0;

        roomRows.forEach(function (row) {

            const rowText = row.textContent.toLowerCase();

            const roomStatus = row.dataset.status;

            const matchesSearch =
                rowText.includes(searchValue);

            const matchesStatus =
                selectedStatus === "" ||
                roomStatus === selectedStatus;

            const shouldDisplay =
                matchesSearch && matchesStatus;

            row.style.display = shouldDisplay ? "" : "none";

            if (shouldDisplay) {
                visibleCount++;
            }

        });

        updateEmptyMessage(visibleCount);
    }

    function updateEmptyMessage(visibleCount) {

        let emptyRow = document.getElementById("filteredEmptyRow");

        if (visibleCount === 0 && roomRows.length > 0) {

            if (!emptyRow) {

                emptyRow = document.createElement("tr");

                emptyRow.id = "filteredEmptyRow";

                emptyRow.innerHTML = `
                    <td colspan="7" class="empty-state">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <strong>No matching rooms found</strong>
                        <span>Try changing your search or status filter.</span>
                    </td>
                `;

                tableBody.appendChild(emptyRow);
            }

        } else if (emptyRow) {

            emptyRow.remove();
        }
    }

    searchInput.addEventListener("input", filterRooms);

    statusFilter.addEventListener("change", filterRooms);

});


/* =========================================
   DELETE ROOM
========================================= */


document.addEventListener("DOMContentLoaded", function () {

    const deleteButtons = document.querySelectorAll(".delete-room-button");
		console.log("DELETE BUTTONS FOUND:", deleteButtons.length);

    const deleteForm = document.getElementById("deleteRoomForm");

    const deleteRoomId = document.getElementById("deleteRoomId");

    if (!deleteForm || !deleteRoomId) {
        return;
    }

    deleteButtons.forEach(function (button) {

        button.addEventListener("click", function () {
						console.log("DELETE BUTTON CLICKED");

            const roomId = this.dataset.roomId;
            const roomNumber = this.dataset.roomNumber;

            if (!roomId) {
                alert("Unable to identify the selected room.");
                return;
            }

            const confirmed = confirm(
                "Are you sure you want to delete room " +
                roomNumber +
                "?\n\nRooms with booking history cannot be permanently deleted."
            );

            if (!confirmed) {
                return;
            }

            deleteRoomId.value = roomId;

            deleteForm.submit();
						console.log("DELETE ROOM SCRIPT LOADED");

        });

    });

});