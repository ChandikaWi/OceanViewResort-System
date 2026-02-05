<%-- 
    Document   : manage_staff
    Created on : Feb 3, 2026, 3:24:20 AM
    Author     : Chand
--%>

<%@page import="java.util.List"%>
<%@page import="com.oceanview.dao.UserDAO"%>
<%@page import="com.oceanview.model.User"%>
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
    <title>Manage Staff - Ocean View Resort</title>
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
            <span class="icon">&#127968;</span> <span class="menu-text">Dashboard</span>
        </a>
        <a href="manage_staff.jsp" style="background-color: #34495e; border-left: 5px solid #1abc9c;">
            <span class="icon">&#128100;</span> <span class="menu-text">Manage Staff</span>
        </a>
        <a href="logout.jsp" style="margin-top: 50px; color: #ff6b6b;">
            <span class="icon">&#128682;</span> <span class="menu-text">Logout</span>
        </a>
    </div>

    <div id="main" class="main-content">
        <h2>Manage Staff Accounts</h2>
        
        <div class="container">
            <h3>Create New Staff Account</h3>
            <% if ("added".equals(request.getParameter("success"))) { %>
                <div class="alert">Staff account created successfully!</div>
            <% } %>
            
            <form action="UserServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="text" name="password" required>
                </div>
                <div class="form-group">
                    <label>Role</label>
                    <select name="role">
                        <option value="STAFF">Front Desk Staff</option>
                        <option value="ADMIN">Manager/Admin</option>
                    </select>
                </div>
                <button type="submit">Create Account</button>
            </form>
        </div>

        <div class="container">
            <h3>Existing Staff Accounts</h3>
            <% if ("updated".equals(request.getParameter("success"))) { %>
                <div class="alert" style="background-color: #d4edda; color: #155724; border-color: #c3e6cb;">
                    Staff details updated successfully!
                </div>
            <% } %>
            
            <% if ("deleted".equals(request.getParameter("success"))) { %>
                <div class="alert" style="background-color: #f8d7da; color: #721c24;">Account deleted successfully.</div>
            <% } %>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Role</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        UserDAO dao = new UserDAO();
                        List<User> users = dao.getAllUsers();
                        for (User u : users) {
                    %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td><%= u.getUsername() %></td>
                        <td><%= u.getRole() %></td>
                        <td>
                            <button type="button" 
                                    onclick="openUpdateModal('<%= u.getId() %>', '<%= u.getUsername() %>', '<%= u.getPassword() %>', '<%= u.getRole() %>')"
                                    style="background-color: #ffc107; color: black; padding: 5px 10px; font-size: 14px; margin-right: 5px; border: none; border-radius: 4px; cursor: pointer;">
                                Update
                            </button>

                            <button type="button" 
                                    onclick="openDeleteModal('<%= u.getId() %>')"
                                    style="background-color: #dc3545; color: white; padding: 5px 10px; font-size: 14px; border: none; border-radius: 4px; cursor: pointer;">
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
        <div class="modal-content" style="width: 350px;">
            <span class="close-modal" onclick="closeUpdateModal()">&times;</span>
            <div class="modal-header">Update Staff Details</div>
            
            <form action="UserServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" id="updateId" name="id"> <div style="text-align: left; margin-bottom: 10px;">
                    <label style="font-weight: bold;">Username</label>
                    <input type="text" id="updateUsername" name="username" class="modal-input" style="width: 93%;" required>
                </div>

                <div style="text-align: left; margin-bottom: 10px;">
                    <label style="font-weight: bold;">Password</label>
                    <input type="text" id="updatePassword" name="password" class="modal-input" style="width: 93%;" required>
                </div>

                <div style="text-align: left; margin-bottom: 10px;">
                    <label style="font-weight: bold;">Role</label>
                    <select id="updateRole" name="role" class="modal-input" style="width: 100%;">
                        <option value="STAFF">Front Desk Staff</option>
                        <option value="ADMIN">Manager/Admin</option>
                    </select>
                </div>

                <button type="submit" class="modal-btn" style="width: 100%; background-color: #ffc107; color: black;">Save Changes</button>
            </form>
        </div>
    </div>
                
    <div id="deleteModal" class="modal">
        <div class="modal-content" style="width: 400px; text-align: center; border-top: 5px solid #dc3545;">
            <span class="close-modal" onclick="closeDeleteModal()">&times;</span>
            
            <div style="font-size: 50px; color: #dc3545; margin-bottom: 10px;">&#9888;</div>
            
            <h3 style="margin-top: 0; color: #333;">Are you sure?</h3>
            <p style="color: #666; font-size: 14px;">Do you really want to delete this staff account?<br>This process cannot be undone.</p>
            
            <form action="UserServlet" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="deleteId" name="id"> <div style="margin-top: 20px;">
                    <button type="button" onclick="closeDeleteModal()" 
                            style="background-color: #ccc; color: black; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;">
                        Cancel
                    </button>
                    
                    <button type="submit" 
                            style="background-color: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer;">
                        Delete Account
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openDeleteModal(id) {
            document.getElementById("deleteId").value = id; 
            document.getElementById("deleteModal").style.display = "block";
        }

        function closeDeleteModal() {
            document.getElementById("deleteModal").style.display = "none";
        }

        window.onclick = function(event) {
            var updateModal = document.getElementById("updateModal");
            var deleteModal = document.getElementById("deleteModal");
            if (event.target == updateModal) {
                updateModal.style.display = "none";
            }
            if (event.target == deleteModal) {
                deleteModal.style.display = "none";
            }
        }
    </script>

    <script>
        function openUpdateModal(id, username, password, role) {
            document.getElementById("updateId").value = id;
            document.getElementById("updateUsername").value = username;
            document.getElementById("updatePassword").value = password;
            document.getElementById("updateRole").value = role;
            
            document.getElementById("updateModal").style.display = "block";
        }

        function closeUpdateModal() {
            document.getElementById("updateModal").style.display = "none";
        }

        window.onclick = function(event) {
            var modal = document.getElementById("updateModal");
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
    
</body>
</html>
