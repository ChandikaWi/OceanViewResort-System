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
    </script>
</head>
<body>
    <div class="navbar">
        <div>Ocean View Resort Management</div>
        <div>
            Welcome, <%= session.getAttribute("user") %> | 
            <a href="logout.jsp">Logout</a>
        </div>
    </div>

    <div class="container">
        <h2>Add New Reservation</h2>
        <% if (request.getParameter("success") != null) { %>
            <div class="alert">Reservation added successfully!</div>
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

    <div class="container">
        <h2>Current Reservations</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Guest</th>
                    <th>Room</th>
                    <th>Check-In</th>
                    <th>Check-Out</th>
                    <th>Total Bill</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ReservationDAO dao = new ReservationDAO();
                    List<Reservation> list = dao.getAllReservations();
                    for (Reservation r : list) {
                %>
                <tr>
                    <td><%= r.getId() %></td>
                    <td><%= r.getGuestName() %></td>
                    <td><%= r.getRoomType() %></td>
                    <td><%= r.getCheckIn() %></td>
                    <td><%= r.getCheckOut() %></td>
                    <td>$<%= r.getTotalCost() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
