<%-- 
    Document   : reservations
    Created on : Feb 4, 2026, 8:08:37 AM
    Author     : Chand
--%>

<%@page import="java.math.BigDecimal"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="com.oceanview.dao.RoomTypeDAO"%>
<%@page import="java.util.List"%>
<%@page import="com.oceanview.dao.ReservationDAO"%>
<%@page import="com.oceanview.model.Reservation"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security Check
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
                <span class="icon">&#128202;</span> <span class="menu-text">Statistics</span>
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
            <% if ("deleted".equals(request.getParameter("success"))) { %>
                <div class="alert" style="background-color: #f8d7da; color: #721c24; margin-bottom: 15px; padding: 10px; border-radius: 4px;">
                    Reservation deleted successfully.
                </div>
            <% } %>
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
                        RoomTypeDAO roomDao = new RoomTypeDAO(); 
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
                            long nights = ChronoUnit.DAYS.between(r.getCheckIn().toLocalDate(), r.getCheckOut().toLocalDate());
                            if (nights == 0) nights = 1;
                            
                            BigDecimal rate = roomDao.getRoomPrice(r.getRoomType());
                            BigDecimal grandTotal = rate.multiply(new BigDecimal(nights));
                    %>
                    <tr>
                        <td><%= r.getId() %></td>
                        <td><%= r.getGuestName() %></td>
                        <td><%= r.getRoomType() %></td>
                        <td><%= r.getCheckIn() %></td>
                        <td><%= r.getCheckOut() %></td>
                        
                        <td style="font-weight: bold; color: #2c3e50;">$<%= grandTotal %></td>
                        
                        <td>
                            <div style="display: flex; gap: 8px; align-items: center;">
                                
                                <a href="BillServlet?id=<%= r.getId() %>" target="_blank" 
                                   style="background-color: #17a2b8; color: white; padding: 6px 12px; text-decoration: none; border-radius: 4px; font-size: 13px; display: inline-block; white-space: nowrap;">
                                   &#128424; Print
                                </a>

                                <button type="button" onclick="openDeleteModal('<%= r.getId() %>')"
                                        style="background-color: #dc3545; color: white; padding: 6px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; display: inline-block; white-space: nowrap;">
                                    &#128465; Delete
                                </button>
                                
                            </div>
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
                <input type="text" name="q" class="modal-input" placeholder="e.g., Guest or 1001" required>
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
    
    <div id="deleteModal" class="modal">
        <div class="modal-content" style="width: 400px; text-align: center; border-top: 5px solid #dc3545;">
            <span class="close-modal" onclick="closeDeleteModal()">&times;</span>
            
            <div style="font-size: 50px; color: #dc3545; margin-bottom: 10px;">&#9888;</div>
            <h3 style="margin-top: 0; color: #333;">Delete Reservation?</h3>
            <p style="color: #666;">Are you sure you want to cancel and delete this reservation?</p>
            
            <form action="ReservationServlet" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="deleteId" name="id">
                
                <div style="margin-top: 20px;">
                    <button type="button" onclick="closeDeleteModal()" 
                            style="background-color: #ccc; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;">
                        Cancel
                    </button>
                    <button type="submit" 
                            style="background-color: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer;">
                        Confirm Delete
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openBillModal() { document.getElementById("billModal").style.display = "block"; }
        function closeBillModal() { document.getElementById("billModal").style.display = "none"; }

        function openDeleteModal(id) {
            document.getElementById("deleteId").value = id;
            document.getElementById("deleteModal").style.display = "block";
        }
        function closeDeleteModal() {
            document.getElementById("deleteModal").style.display = "none";
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById("billModal")) closeBillModal();
            if (event.target == document.getElementById("deleteModal")) closeDeleteModal();
        }
    </script>
    
</body>
</html>
