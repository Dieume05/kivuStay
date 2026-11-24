<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.kivustay.model.Room" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    List<Room> rooms =
        (List<Room>) request.getAttribute("rooms");

    List<Room> roomTypes =
        (List<Room>) request.getAttribute("roomTypes");

    if (rooms == null) {
        rooms = new java.util.ArrayList<Room>();
    }

    if (roomTypes == null) {
        roomTypes = new java.util.ArrayList<Room>();
    }

    String managerName =
        (String) session.getAttribute("fullName");

    if (managerName == null || managerName.trim().isEmpty()) {
        managerName = "Manager";
    }

    int totalRooms = rooms.size();
    int availableRooms = 0;
    int maintenanceRooms = 0;
    int inactiveRooms = 0;

    for (Room room : rooms) {
        if ("AVAILABLE".equals(room.getRoomStatus())) {
            availableRooms++;
        } else if ("MAINTENANCE".equals(room.getRoomStatus())) {
            maintenanceRooms++;
        } else if ("INACTIVE".equals(room.getRoomStatus())) {
            inactiveRooms++;
        }
    }

    String roomSuccess =
        (String) request.getAttribute("roomSuccess");

    String roomError =
        (String) request.getAttribute("roomError");

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Room Management | KivuStay</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/manager-rooms.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body>

<div class="dashboard-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <div class="brand">
            <div class="brand-icon">
                <i class="fa-solid fa-water"></i>
            </div>

            <div class="brand-text">
                <h2>KivuStay</h2>
                <span>MANAGEMENT</span>
            </div>
        </div>

        <div class="sidebar-label">WORKSPACE</div>

        <nav class="sidebar-nav">

            <a href="<%= contextPath %>/manager/dashboard">
                <i class="fa-solid fa-grid-2"></i>
                <span>Overview</span>
            </a>

            <a href="<%= contextPath %>/manager/hotels">
                <i class="fa-solid fa-hotel"></i>
                <span>My Hotels</span>
            </a>

            <a href="<%= contextPath %>/manager/rooms"
               class="active">
                <i class="fa-solid fa-bed"></i>
                <span>Room Management</span>
            </a>

            <a href="<%= contextPath %>/manager/bookings">
                <i class="fa-solid fa-calendar-check"></i>
                <span>Reservations</span>
            </a>

            <a href="<%= contextPath %>/manager/dashboard#analytics">
                <i class="fa-solid fa-chart-line"></i>
                <span>Analytics</span>
            </a>

        </nav>

        <div class="sidebar-bottom">

            <div class="sidebar-profile">
                <div class="profile-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>

                <div>
                    <strong><%= escapeHtml(managerName) %></strong>
                    <span>Hotel Manager</span>
                </div>
            </div>

            <a href="<%= contextPath %>/logout"
               class="logout-link">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Sign out</span>
            </a>

        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <header class="topbar">

            <div class="breadcrumb">
                <span>Workspace</span>
                <i class="fa-solid fa-chevron-right"></i>
                <strong>Room Management</strong>
            </div>

            <div class="topbar-right">
                <span class="manager-label">
                    <i class="fa-solid fa-circle-check"></i>
                    Manager Account
                </span>
            </div>

        </header>

        <!-- PAGE INTRODUCTION -->
        <section class="page-heading">

            <div>
                <span class="eyebrow">PROPERTY OPERATIONS</span>

                <h1>Room Management</h1>

                <p>
                    Manage your accommodation inventory,
                    room categories and availability.
                </p>
            </div>

            <button type="button"
                    class="primary-button"
                    id="openAddRoom">

                <i class="fa-solid fa-plus"></i>
                Add New Room

            </button>

        </section>
        <section class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon total-icon">
            <i class="fa-solid fa-door-open"></i>
        </div>
        <div class="stat-info">
            <span>Total Rooms</span>
            <h2><%= totalRooms %></h2>
            <small>Across your properties</small>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon available-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <div class="stat-info">
            <span>Available</span>
            <h2><%= availableRooms %></h2>
            <small>Ready for reservations</small>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon maintenance-icon">
            <i class="fa-solid fa-screwdriver-wrench"></i>
        </div>
        <div class="stat-info">
            <span>Maintenance</span>
            <h2><%= maintenanceRooms %></h2>
            <small>Temporarily unavailable</small>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon inactive-icon">
            <i class="fa-solid fa-ban"></i>
        </div>
        <div class="stat-info">
            <span>Inactive</span>
            <h2><%= inactiveRooms %></h2>
            <small>Not listed for booking</small>
        </div>
    </div>
</section>

<% if (roomSuccess != null && !roomSuccess.trim().isEmpty()) { %>
    <div class="alert alert-success">
        <i class="fa-solid fa-circle-check"></i>
        <span><%= escapeHtml(roomSuccess) %></span>
    </div>
<% } %>

<% if (roomError != null && !roomError.trim().isEmpty()) { %>
    <div class="alert alert-error">
        <i class="fa-solid fa-circle-exclamation"></i>
        <span><%= escapeHtml(roomError) %></span>
    </div>
<% } %>

<section class="inventory-section">
    <div class="section-heading">
        <div>
            <span class="eyebrow">YOUR INVENTORY</span>
            <h2>All Rooms</h2>
            <p>Review and update the rooms registered under your properties.</p>
        </div>
    </div>

    <div class="inventory-toolbar">
        <div class="search-box">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input
                type="search"
                id="roomSearch"
                placeholder="Search room, hotel or category..."
                aria-label="Search rooms">
        </div>

        <select id="statusFilter" aria-label="Filter rooms by status">
            <option value="">All statuses</option>
            <option value="AVAILABLE">Available</option>
            <option value="MAINTENANCE">Maintenance</option>
            <option value="INACTIVE">Inactive</option>
        </select>
    </div>

    <div class="table-wrapper">
        <table class="rooms-table">
            <thead>
                <tr>
                    <th>ROOM</th>
                    <th>PROPERTY</th>
                    <th>CATEGORY</th>
                    <th>CAPACITY</th>
                    <th>PRICE / NIGHT</th>
                    <th>STATUS</th>
                    <th>ACTION</th>
                </tr>
            </thead>

            <tbody id="roomsTableBody">
            <% if (rooms.isEmpty()) { %>
                <tr>
                    <td colspan="7" class="empty-state">
                        <i class="fa-solid fa-bed"></i>
                        <strong>No rooms registered yet</strong>
                        <span>Add your first room to start managing your inventory.</span>
                    </td>
                </tr>
            <% } else {
                for (Room room : rooms) {
                    String statusClass = "status-inactive";
                    if ("AVAILABLE".equals(room.getRoomStatus())) {
                        statusClass = "status-available";
                    } else if ("MAINTENANCE".equals(room.getRoomStatus())) {
                        statusClass = "status-maintenance";
                    }
            %>
                <tr class="room-row"
                    data-status="<%= escapeHtml(room.getRoomStatus()) %>">

                    <td>
                        <div class="room-identity">
                            <div class="room-avatar">
                                <i class="fa-solid fa-bed"></i>
                            </div>
                            <div>
                                <strong><%= escapeHtml(room.getRoomNumber()) %></strong>
                                <small>Room ID #<%= room.getRoomId() %></small>
                            </div>
                        </div>
                    </td>

                    <td><%= escapeHtml(room.getHotelName()) %></td>

                    <td><%= escapeHtml(room.getRoomName()) %></td>

                    <td>
                        <span class="capacity-value">
                            <i class="fa-solid fa-user-group"></i>
                            <%= room.getCapacity() %> guests
                        </span>
                    </td>

                    <td class="price-value">
                        $<%= room.getPricePerNight() %>
                    </td>

                    <td>
                        <span class="status-badge <%= statusClass %>">
                            <%= escapeHtml(room.getRoomStatus()) %>
                        </span>
                    </td>

                   <td>
    <div class="room-actions">
        <button
            type="button"
            class="edit-room-button"
            data-room-id="<%= room.getRoomId() %>"
            data-room-type-id="<%= room.getRoomTypeId() %>"
            data-room-number="<%= escapeHtml(room.getRoomNumber()) %>"
            data-room-status="<%= escapeHtml(room.getRoomStatus()) %>"
            title="Edit room">
            <i class="fa-solid fa-pen"></i>
            Edit
        </button>

        <button
            type="button"
            class="delete-room-button"
            data-room-id="<%= room.getRoomId() %>"
            data-room-number="<%= escapeHtml(room.getRoomNumber()) %>"
            title="Delete room">
            <i class="fa-solid fa-trash"></i>
            Delete
        </button>
    </div>
</td>
                </tr>
            <%  }
               }
            %>
            </tbody>
        </table>
    </div>

    <div class="table-footer">
        <span>Showing <strong><%= totalRooms %></strong> registered rooms</span>
        <span>Inventory management · KivuStay</span>
    </div>
</section>
<!-- Add / Edit Room Modal -->
<div class="modal-overlay" id="roomModal">
    <div class="room-modal">

        <div class="modal-header">
            <div>
                <span class="eyebrow">PROPERTY INVENTORY</span>
                <h2 id="modalTitle">Add New Room</h2>
                <p id="modalDescription">
                    Register a physical room under one of your properties.
                </p>
            </div>

            <button type="button" class="close-modal" id="closeRoomModal"
                    aria-label="Close modal">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form action="<%= contextPath %>/manager/rooms"
              method="post"
              id="roomForm">
              <input type="hidden"
       name="csrfToken"
       value="<%= escapeHtml((String) request.getAttribute("csrfToken")) %>">

            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="roomId" id="roomId" value="">

            <div class="form-group">
                <label for="roomTypeId">Room Category</label>

                <select name="roomTypeId" id="roomTypeId" required>
                    <option value="">Select a room category</option>

                    <% for (Room type : roomTypes) { %>
                        <option value="<%= type.getRoomTypeId() %>">
                            <%= escapeHtml(type.getHotelName()) %>
                            — <%= escapeHtml(type.getRoomName()) %>
                            (Capacity: <%= type.getCapacity() %>)
                        </option>
                    <% } %>
                </select>

                <% if (roomTypes.isEmpty()) { %>
                    <small class="form-hint">
                        You need to have a hotel with a room category before
                        registering a physical room.
                    </small>
                <% } %>
            </div>

            <div class="form-group">
                <label for="roomNumber">Room Number</label>

                <input
                    type="text"
                    name="roomNumber"
                    id="roomNumber"
                    placeholder="e.g. 101 or DEL-02"
                    maxlength="30"
                    required>
            </div>

            <div class="form-group">
                <label for="roomStatus">Room Status</label>

                <select name="roomStatus" id="roomStatus" required>
                    <option value="AVAILABLE">Available</option>
                    <option value="MAINTENANCE">Maintenance</option>
                    <option value="INACTIVE">Inactive</option>
                </select>
            </div>

            <div class="modal-actions">
                <button type="button" class="secondary-button"
                        id="cancelRoomModal">
                    Cancel
                </button>

                <button type="submit" class="primary-button"
                        id="saveRoomButton"
                        <%= roomTypes.isEmpty() ? "disabled" : "" %>>
                    <i class="fa-solid fa-check"></i>
                    Save Room
                </button>
            </div>

        </form>
    </div>
</div>

<footer class="page-footer">
    <span>© 2026 KivuStay. Discover the beauty of Lake Kivu.</span>
    <span>Designed for better hospitality management.</span>
</footer>

</main>
</div>

<script src="<%= contextPath %>/js/manager-rooms.js"></script>
<!-- DELETE ROOM FORM -->
<form id="deleteRoomForm"
      action="<%= contextPath %>/manager/rooms"
      method="post"
      style="display: none;">
      <input type="hidden"
       name="csrfToken"
       value="<%= escapeHtml((String) request.getAttribute("csrfToken")) %>">

    <input type="hidden" name="action" value="delete">

    <input type="hidden"
           name="roomId"
           id="deleteRoomId">
</form>
</body>
</html>