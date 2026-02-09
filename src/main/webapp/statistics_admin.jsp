<%-- 
    Document   : statistics_admin
    Created on : Feb 6, 2026, 8:54:12 AM
    Author     : Chand
--%>

<%@page import="java.util.Map"%>
<%@page import="com.oceanview.dao.StatsDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String role = (String) session.getAttribute("role");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("dashboard.jsp?error=access_denied");
        return;
    }
    
    StatsDAO dao = new StatsDAO();
    double totalRev = dao.getTotalRevenue();
    int activeRes = dao.getTotalActiveReservations();
    Map<String, Integer> roomDist = dao.getRoomTypeDistribution();
    Map<String, Double> monthlyRev = dao.getMonthlyRevenue();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Statistics - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); text-align: center; }
        .card h3 { margin: 0; color: #7f8c8d; font-size: 14px; text-transform: uppercase; }
        .card p { margin: 10px 0 0; font-size: 28px; font-weight: bold; color: #2c3e50; }
        .chart-container { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 20px; }
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
        <h2>Manager Dashboard & Analytics</h2>
        
        <div class="stats-grid">
            <div class="card" style="border-top: 4px solid #1abc9c;">
                <h3>Total Revenue</h3>
                <p>$<%= String.format("%,.2f", totalRev) %></p>
            </div>
            <div class="card" style="border-top: 4px solid #3498db;">
                <h3>Active Bookings</h3>
                <p><%= activeRes %></p>
            </div>
            <div class="card" style="border-top: 4px solid #9b59b6;">
                <h3>Occupancy Rate</h3>
                <p>85%</p> </div>
        </div>

        <div style="display: flex; gap: 20px;">
            <div class="chart-container" style="flex: 2;">
                <canvas id="revenueChart"></canvas>
            </div>
            
            <div class="chart-container" style="flex: 1;">
                <canvas id="roomChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        const ctxRev = document.getElementById('revenueChart');
        new Chart(ctxRev, {
            type: 'bar',
            data: {
                labels: [<%= monthlyRev.keySet().stream().map(s -> "'" + s + "'").reduce((a, b) -> a + "," + b).orElse("") %>],
                datasets: [{
                    label: 'Monthly Revenue ($)',
                    data: [<%= monthlyRev.values().stream().map(Object::toString).reduce((a, b) -> a + "," + b).orElse("") %>],
                    backgroundColor: '#3498db',
                    borderRadius: 5
                }]
            },
            options: { plugins: { title: { display: true, text: 'Revenue Trends' } } }
        });

        const ctxRoom = document.getElementById('roomChart');
        new Chart(ctxRoom, {
            type: 'doughnut',
            data: {
                labels: [<%= roomDist.keySet().stream().map(s -> "'" + s + "'").reduce((a, b) -> a + "," + b).orElse("") %>],
                datasets: [{
                    data: [<%= roomDist.values().stream().map(Object::toString).reduce((a, b) -> a + "," + b).orElse("") %>],
                    backgroundColor: ['#1abc9c', '#f1c40f', '#e74c3c']
                }]
            },
            options: { plugins: { title: { display: true, text: 'Room Preference' } } }
        });
    </script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    <style>
        .pdf-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background-color: #c0392b;
            color: white;
            border: none;
            border-radius: 50px;
            padding: 15px 25px;
            font-size: 16px;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            cursor: pointer;
            z-index: 1000;
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .pdf-btn:hover {
            background-color: #a93226;
            transform: translateY(-3px);
        }
    </style>

    <button onclick="downloadReport()" class="pdf-btn" id="downloadBtn">
        <span>&#128196;</span> Download Report
    </button>

    <script>
        async function downloadReport() {
            const { jsPDF } = window.jspdf;
            const btn = document.getElementById('downloadBtn');
            const content = document.getElementById('main'); 

            btn.style.display = 'none';

            const originalBg = content.style.backgroundColor;
            content.style.backgroundColor = "#ffffff"; 

            html2canvas(content, {
                scale: 2, 
                useCORS: true 
            }).then(canvas => {
                const imgData = canvas.toDataURL('image/png');

                const pdf = new jsPDF('p', 'mm', 'a4');
                const pageWidth = pdf.internal.pageSize.getWidth();
                const pageHeight = pdf.internal.pageSize.getHeight();

                pdf.setFillColor(44, 62, 80); 
                pdf.rect(0, 0, pageWidth, 25, 'F');

                pdf.setFontSize(18);
                pdf.setTextColor(255, 255, 255); 
                pdf.setFont("helvetica", "bold");
                pdf.text("OCEAN VIEW RESORT", 15, 12);

                pdf.setFontSize(10);
                pdf.setFont("helvetica", "normal");
                pdf.text("OFFICIAL STATISTICAL REPORT", 15, 19);

                const today = new Date().toLocaleDateString();
                pdf.text("Date: " + today, pageWidth - 40, 15);

                const imgWidth = pageWidth - 20; 
                const imgHeight = (canvas.height * imgWidth) / canvas.width;

                pdf.addImage(imgData, 'PNG', 10, 30, imgWidth, imgHeight);

                pdf.save("OceanView_Statistics_Report.pdf");

                btn.style.display = 'flex';
                content.style.backgroundColor = originalBg;
            });
        }
    </script>
</body>
</html>
