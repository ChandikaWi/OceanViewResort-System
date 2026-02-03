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
        function confirmDelete() {
            return confirm("Are you sure you want to delete this staff account?");
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
                            <form action="UserServlet" method="post" onsubmit="return confirmDelete()" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= u.getId() %>">
                                <button type="submit" style="background-color: #dc3545; padding: 5px 10px; font-size: 14px;">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
