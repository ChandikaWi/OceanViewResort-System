<%-- 
    Document   : dashboard
    Created on : Jan 31, 2026, 7:58:43 PM
    Author     : Chand
--%>

<%@page import="java.util.List"%>
<%@page import="com.oceanview.dao.ReservationDAO"%>
<%@page import="com.oceanview.model.Reservation"%>
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
            var sidebar = document.getElementById("mySidebar");
            var main = document.getElementById("main");
            
            sidebar.classList.toggle("collapsed");
            main.classList.toggle("expanded");
        }
    </script>
</head>
<body>

    <button class="openbtn" onclick="toggleNav()">&#9776;</button>

    <div id="mySidebar" class="sidebar">
        <div style="text-align: center; color: white; margin-bottom: 30px; white-space: nowrap;">
            <span class="menu-text" style="font-weight: bold; font-size: 18px;">Ocean View<br>Resort</span>
        </div>

        <a href="#addSection">
            <span class="icon">&#10133;</span> <span class="menu-text">New Booking</span>
        </a>
        <a href="#listSection">
            <span class="icon">&#128196;</span> <span class="menu-text">Reservations</span>
        </a>
        <a href="BillServlet?id=last" onclick="alert('Please select a specific user from the list to print bill.')">
            <span class="icon">&#128424;</span> <span class="menu-text">Print Bill</span>
        </a>
        
        <a href="logout.jsp" style="margin-top: 50px; color: #ff6b6b;">
            <span class="icon">&#128682;</span> <span class="menu-text">Logout</span>
        </a>
    </div>

    <div id="main" class="main-content">
        
        <div style="text-align: right; margin-bottom: 20px;">
            Welcome, <b><%= session.getAttribute("user") %></b>
        </div>

        <div id="addSection" class="container">
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

        <div id="listSection" class="container">
            <h2>Current Reservations</h2>
            
            <div style="margin-bottom: 20px; text-align: right;">
                <form action="dashboard.jsp#listSection" method="get" style="display: inline-block;">
                    <input type="text" name="q" placeholder="Search by Name or ID..." 
                           value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"
                           style="width: 250px; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                    <button type="submit" style="padding: 8px 15px; background-color: #007bff; color: white; border: none; border-radius: 4px;">Search</button>
                </form>
                <% if (request.getParameter("q") != null) { %>
                    <a href="dashboard.jsp#listSection" style="margin-left: 10px; text-decoration: none; color: #dc3545; font-weight: bold;">Reset</a>
                <% } %>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Guest</th>
                        <th>Room</th>
                        <th>Check-In</th>
                        <th>Check-Out</th>
                        <th>Total Bill</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        ReservationDAO dao = new ReservationDAO();
                        List<Reservation> list;
                        String searchQuery = request.getParameter("q");
                        
                        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                            list = dao.searchReservations(searchQuery);
                        } else {
                            list = dao.getAllReservations();
                        }
                        
                        if (list.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7" style="text-align:center; color: red;">No reservations found.</td>
                        </tr>
                    <%
                        }
                        for (Reservation r : list) {
                    %>
                    <tr>
                        <td><%= r.getId() %></td>
                        <td><%= r.getGuestName() %></td>
                        <td><%= r.getRoomType() %></td>
                        <td><%= r.getCheckIn() %></td>
                        <td><%= r.getCheckOut() %></td>
                        <td>$<%= r.getTotalCost() %></td>
                        <td>
                            <a href="BillServlet?id=<%= r.getId() %>" target="_blank" 
                               style="background-color: #17a2b8; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; font-size: 14px;">
                               Print Bill
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
