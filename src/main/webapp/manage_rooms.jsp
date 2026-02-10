<%-- 
    Document   : manage_rooms
    Created on : Feb 5, 2026, 10:01:06 AM
    Author     : Chand
--%>

<%@page import="java.util.List"%>
<%@page import="com.oceanview.dao.RoomTypeDAO"%>
<%@page import="com.oceanview.model.RoomType"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String role = (String) session.getAttribute("role");
    if (role == null || !"ADMIN".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Rooms - Ocean View Resort</title>
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
        <a href="reservations.jsp">
            <span class="icon">&#128196;</span> <span class="menu-text">Reservations</span>
        </a>
        <a href="javascript:void(0)" onclick="openBillModal()">
            <span class="icon">&#128424;</span> <span class="menu-text">Print Bill</span>
        </a>
        
        <a href="manage_staff.jsp">
            <span class="icon">&#128100;</span> <span class="menu-text">Manage Staff</span>
        </a>
        <a href="manage_rooms.jsp" style="background-color: #34495e; border-left: 5px solid #1abc9c;">
            <span class="icon">&#128716;</span> <span class="menu-text">Manage Rooms</span>
        </a>
        
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
        <h2>Manage Room Types</h2>
        
        <div class="container">
            <h3>Add New Room Type</h3>
            <% if ("added".equals(request.getParameter("success"))) { %>
                <div class="alert">Room type added successfully!</div>
            <% } %>
            <% if ("updated".equals(request.getParameter("success"))) { %>
                <div class="alert" style="background-color: #d4edda; color: #155724;">Room updated successfully!</div>
            <% } %>
            <% if ("deleted".equals(request.getParameter("success"))) { %>
                <div class="alert" style="background-color: #f8d7da; color: #721c24;">Room deleted successfully.</div>
            <% } %>

            <form action="RoomServlet" method="post">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label>Room Name (e.g., Deluxe Suite)</label>
                    <input type="text" name="typeName" required>
                </div>
                <div class="form-group">
                    <label>Price per Night (USD)</label>
                    <input type="number" step="0.01" name="price" required>
                </div>

                <div class="form-group">
                    <label>Total Rooms (Quantity)</label>
                    <input type="number" name="quantity" placeholder="e.g., 5" required>
                </div>
                <div class="form-group">
                    <label>Image URL (e.g., https://site.com/img.jpg)</label>
                    <input type="text" name="imageUrl" placeholder="Paste image link here" required>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <input type="text" name="description" required>
                </div>
                <button type="submit">Add Room Type</button>
            </form>
        </div>

        <div class="container" style="max-width: 100%;">
            <h3>Current Room Types</h3>
            <table>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Quantity</th> 
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        RoomTypeDAO dao = new RoomTypeDAO();
                        List<RoomType> rooms = dao.getAllRoomTypes();
                        for (RoomType r : rooms) {
                    %>
                    <tr>
                        <td>
                            <img src="<%= r.getImageUrl() %>" alt="Room" style="width: 80px; height: 50px; object-fit: cover; border-radius: 4px;">
                        </td>
                        <td><%= r.getTypeName() %></td>
                        <td>$<%= r.getPrice() %></td>
                        <td style="font-weight: bold; color: #2c3e50; text-align: center;"><%= r.getQuantity() %></td> 
                        <td><%= r.getDescription() %></td>
                        <td>
                            <button type="button" 
                                    onclick="openUpdateModal('<%= r.getId() %>', '<%= r.getTypeName() %>', '<%= r.getPrice() %>', '<%= r.getImageUrl() %>', '<%= r.getDescription() %>', '<%= r.getQuantity() %>')"
                                    style="background-color: #ffc107; color: black; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer; margin-right: 5px;">
                                Update
                            </button>

                            <button type="button" 
                                    onclick="openDeleteModal('<%= r.getId() %>')"
                                    style="background-color: #dc3545; color: white; padding: 5px 10px; border: none; border-radius: 4px; cursor: pointer;">
                                Delete
                            </button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div id="updateModal" class="modal">
        <div class="modal-content">
            <span class="close-modal" onclick="closeUpdateModal()">&times;</span>
            <div class="modal-header">Update Room Type</div>
            <form action="RoomServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="upId" name="id">
                
                <label>Name</label>
                <input type="text" id="upName" name="typeName" class="modal-input" required>
                
                <label>Price</label>
                <input type="number" step="0.01" id="upPrice" name="price" class="modal-input" required>
                
                <label>Quantity</label>
                <input type="number" id="upQty" name="quantity" class="modal-input" required>

                <label>Image URL</label>
                <input type="text" id="upImg" name="imageUrl" class="modal-input" required>
                
                <label>Description</label>
                <input type="text" id="upDesc" name="description" class="modal-input" required>

                <button type="submit" class="modal-btn">Save Changes</button>
            </form>
        </div>
    </div>

    <div id="deleteModal" class="modal">
        <div class="modal-content" style="border-top: 5px solid #dc3545;">
            <span class="close-modal" onclick="closeDeleteModal()">&times;</span>
            <h3 style="color: #dc3545;">&#9888; Confirm Delete</h3>
            <p>Are you sure you want to remove this room type?</p>
            <form action="RoomServlet" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="delId" name="id">
                <button type="button" onclick="closeDeleteModal()" style="padding:10px;">Cancel</button>
                <button type="submit" style="background-color: #dc3545; color: white; padding:10px; border:none;">Delete</button>
            </form>
        </div>
    </div>

    <script>
        function openUpdateModal(id, name, price, img, desc, qty) {
            document.getElementById("upId").value = id;
            document.getElementById("upName").value = name;
            document.getElementById("upPrice").value = price;
            document.getElementById("upQty").value = qty;
            document.getElementById("upImg").value = img;
            document.getElementById("upDesc").value = desc;
            document.getElementById("updateModal").style.display = "block";
        }
        function closeUpdateModal() { document.getElementById("updateModal").style.display = "none"; }

        function openDeleteModal(id) {
            document.getElementById("delId").value = id;
            document.getElementById("deleteModal").style.display = "block";
        }
        function closeDeleteModal() { document.getElementById("deleteModal").style.display = "none"; }
        
        window.onclick = function(event) {
            if (event.target == document.getElementById("updateModal")) closeUpdateModal();
            if (event.target == document.getElementById("deleteModal")) closeDeleteModal();
            if (event.target == document.getElementById("billModal")) closeBillModal();
        }
    </script>
    
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
        function openBillModal() { document.getElementById("billModal").style.display = "block"; }
        function closeBillModal() { document.getElementById("billModal").style.display = "none"; }
    </script>
</body>
</html>
