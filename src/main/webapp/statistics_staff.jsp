<%-- 
    Document   : statistics_staff
    Created on : Feb 6, 2026, 8:55:09 AM
    Author     : Chand
--%>

<%@page import="com.oceanview.dao.StatsDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    StatsDAO dao = new StatsDAO();
    int checkIns = dao.getTodaysCheckIns();
    int checkOuts = dao.getTodaysCheckOuts();
    int active = dao.getTotalActiveReservations();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Operations - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
        .card h3 { font-size: 14px; color: #7f8c8d; }
        .card p { font-size: 32px; font-weight: bold; margin: 5px 0; }
        .status-ok { color: #27ae60; }
        .status-busy { color: #e67e22; }
    </style>
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

        <a href="statistics_admin.jsp" style="background-color: #34495e; border-left: 5px solid #1abc9c;">
            <span class="icon">&#128200;</span> <span class="menu-text">Statistics</span>
        </a>
        
        <% 
            if (session.getAttribute("role") != null && "ADMIN".equals(session.getAttribute("role"))) { 
        %>
            <a href="manage_staff.jsp">
                <span class="icon">&#128100;</span> <span class="menu-text">Manage Staff</span>
            </a>
            <a href="manage_rooms.jsp">
                <span class="icon">&#128716;</span> <span class="menu-text">Manage Rooms</span>
            </a>
        <% } %>

        <a href="logout.jsp" style="margin-top: 50px; color: #ff6b6b;">
            <span class="icon">&#128682;</span> <span class="menu-text">Logout</span>
        </a>
    </div>

    <div id="main" class="main-content">
        <h2>Daily Operations Dashboard</h2>

        <div class="stats-grid">
            <div class="card">
                <h3>Check-ins Today</h3>
                <p class="<%= checkIns > 5 ? "status-busy" : "status-ok" %>"><%= checkIns %></p>
                <small>Guests arriving</small>
            </div>
            <div class="card">
                <h3>Check-outs Today</h3>
                <p class="<%= checkOuts > 5 ? "status-busy" : "status-ok" %>"><%= checkOuts %></p>
                <small>Prepare bills</small>
            </div>
            <div class="card">
                <h3>Total In-House</h3>
                <p style="color: #2980b9;"><%= active %></p>
                <small>Active Guests</small>
            </div>
        </div>

        <div style="background: white; padding: 20px; border-radius: 8px; width: 60%; margin: 0 auto;">
            <canvas id="opsChart"></canvas>
        </div>
    </div>

    <script>
        const ctx = document.getElementById('opsChart');
        new Chart(ctx, {
            type: 'polarArea',
            data: {
                labels: ['Arrivals', 'Departures', 'In-House'],
                datasets: [{
                    label: 'Daily Tasks',
                    data: [<%= checkIns %>, <%= checkOuts %>, <%= active %>],
                    backgroundColor: ['#2ecc71', '#e74c3c', '#3498db']
                }]
            },
            options: {
                plugins: {
                    title: { display: true, text: 'Today\'s Workload Distribution' }
                }
            }
        });
    </script>
</body>
</html>
