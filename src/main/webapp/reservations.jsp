<%-- 
    Document   : reservations
    Created on : Feb 4, 2026, 8:08:37 AM
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
    <title>Reservations - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
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
        
        <a href="dashboard.jsp">
            <span class="icon">&#10133;</span> <span class="menu-text">New Booking</span>
        </a>
        <a href="reservations.jsp" style="background-color: #34495e; border-left: 5px solid #1abc9c;">
            <span class="icon">&#128196;</span> <span class="menu-text">Reservations</span>
        </a>
        <a href="javascript:void(0)" onclick="openBillModal()">
            <span class="icon">&#128424;</span> <span class="menu-text">Print Bill</span>
        </a>
        
        <% 
            String userRole = (String) session.getAttribute("role");
            if ("ADMIN".equals(userRole)) { 
        %>
            <a href="manage_staff.jsp">
                <span class="icon">&#128100;</span> <span class="menu-text">Manage Staff</span>
            </a>
            <a href="manage_rooms.jsp">
                <span class="icon">&#128716;</span> <span class="menu-text">Manage Rooms</span>
            </a>
        <% } %>
        
        <% 
            String roleForStats = (String) session.getAttribute("role");
            if ("ADMIN".equals(roleForStats)) { 
        %>
            <a href="statistics_admin.jsp">
                <span class="icon">&#128200;</span> <span class="menu-text">Statistics</span>
            </a>
        <% } else { %>
            <a href="statistics_staff.jsp">
                <span class="icon">&#128202;</span> <span class="menu-text">Statistics</span>
            </a>
        <% } %>

        <a href="logout.jsp" style="margin-top: 50px; color: #ff6b6b;">
            <span class="icon">&#128682;</span> <span class="menu-text">Logout</span>
        </a>
    </div>

    <div id="main" class="main-content">
        <h2>Current Reservations</h2>
            
        <div style="margin-bottom: 20px; text-align: right;">
            <form action="reservations.jsp" method="get" style="display: inline-block;">
                <input type="text" name="q" placeholder="Search by Name or ID..." 
                       value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>"
                       style="width: 250px; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
                <button type="submit" style="padding: 8px 15px; background-color: #007bff; color: white; border: none; border-radius: 4px;">Search</button>
            </form>
            <% if (request.getParameter("q") != null) { %>
                <a href="reservations.jsp" style="margin-left: 10px; text-decoration: none; color: #dc3545; font-weight: bold;">Reset</a>
            <% } %>
        </div>

        <div class="container" style="max-width: 100%;">
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
                
    <div id="billModal" class="modal">
    <div class="modal-content">
        <span class="close-modal" onclick="closeBillModal()">&times;</span>
        <div class="modal-header">Find Reservation for Billing</div>
        
        <p>Enter Guest Name or Reservation ID:</p>
        
        <form action="reservations.jsp" method="get">
            <input type="text" name="q" class="modal-input" placeholder="e.g., John or 1001" required>
            <br>
            <button type="submit" class="modal-btn">Find & Print</button>
        </form>
    </div>
</div>

<script>
    function openBillModal() {
        document.getElementById("billModal").style.display = "block";
    }

    function closeBillModal() {
        document.getElementById("billModal").style.display = "none";
    }

    window.onclick = function(event) {
        var modal = document.getElementById("billModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>
</body>
</html>
