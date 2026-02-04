<%-- 
    Document   : dashboard
    Created on : Jan 31, 2026, 7:58:43 PM
    Author     : Chand
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        function validateDates() {
            var checkIn = document.getElementById("checkIn").value;
            var checkOut = document.getElementById("checkOut").value;
            if (checkIn >= checkOut) {
                alert("Check-out date must be after check-in date.");
                return false;
            }
            return true;
        }

        function toggleNav() {
            document.getElementById("mySidebar").classList.toggle("collapsed");
            document.getElementById("main").classList.toggle("expanded");
        }
    </script>
</head>
<body>

    <button class="openbtn" onclick="toggleNav()">&#9776;</button>

    <div id="mySidebar" class="sidebar">
        <div style="text-align: center; color: white; margin-bottom: 30px; white-space: nowrap;">
            <span class="menu-text" style="font-weight: bold; font-size: 18px;">Ocean View<br>Resort</span>
        </div>

        <a href="dashboard.jsp" style="background-color: #34495e; border-left: 5px solid #1abc9c;">
            <span class="icon">&#10133;</span> <span class="menu-text">New Booking</span>
        </a>
        <a href="reservations.jsp">
            <span class="icon">&#128196;</span> <span class="menu-text">Reservations</span>
        </a>
        <a href="BillServlet?id=last" onclick="alert('Please go to Reservations page and select a user to print bill.')">
            <span class="icon">&#128424;</span> <span class="menu-text">Print Bill</span>
        </a>
        
        <% 
            String userRole = (String) session.getAttribute("role");
            if ("ADMIN".equals(userRole)) { 
        %>
            <a href="manage_staff.jsp">
                <span class="icon">&#128100;</span> <span class="menu-text">Manage Staff</span>
            </a>
        <% } %>

        <a href="logout.jsp" style="margin-top: 50px; color: #ff6b6b;">
            <span class="icon">&#128682;</span> <span class="menu-text">Logout</span>
        </a>
    </div>

    <div id="main" class="main-content">
        
        <div style="text-align: right; margin-bottom: 20px;">
            Welcome, <b><%= session.getAttribute("user") %></b>
        </div>

        <div class="container">
            <h2>Add New Reservation</h2>
            <% if (request.getParameter("success") != null) { %>
                <div class="alert">Reservation added successfully!</div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert" style="background-color: #f8d7da; color: #721c24;">Error adding reservation. ID might be duplicate.</div>
            <% } %>
            
            <form action="ReservationServlet" method="post" onsubmit="return validateDates()">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label>Reservation Number</label>
                    <input type="number" name="resId" required placeholder="Enter unique ID (e.g., 1001)">
                </div>

                <div class="form-group">
                    <label>Guest Name</label>
                    <input type="text" name="guestName" required>
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <input type="text" name="address" required>
                </div>
                <div class="form-group">
                    <label>Contact Number</label>
                    <input type="text" name="contact" pattern="[0-9]{10}" title="10 digit phone number" required>
                </div>
                <div class="form-group">
                    <label>Room Type</label>
                    <select name="roomType">
                        <option value="Standard">Standard ($100/night)</option>
                        <option value="Suite">Suite ($150/night)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Check-in Date</label>
                    <input type="date" id="checkIn" name="checkIn" required>
                </div>
                <div class="form-group">
                    <label>Check-out Date</label>
                    <input type="date" id="checkOut" name="checkOut" required>
                </div>
                <button type="submit">Create Reservation</button>
            </form>
        </div>
    </div>
</body>
</html>
