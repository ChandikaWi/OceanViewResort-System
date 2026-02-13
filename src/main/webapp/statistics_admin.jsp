<%-- 
    Document   : statistics_admin
    Created on : Feb 6, 2026, 8:54:12 AM
    Author     : Chand
--%>

<%@page import="java.util.Map"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.oceanview.dao.StatsDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security - Only Admin
    if (session.getAttribute("user") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    
    // Data Fetching
    StatsDAO dao = new StatsDAO();
    double totalRev = dao.getTotalRevenue();
    int activeRes = dao.getTotalActiveReservations();
    Map<String, Integer> roomDist = dao.getRoomTypeDistribution();
    Map<String, Double> monthlyRev = dao.getMonthlyRevenue();
    
    // Calculated Metrics for Admin
    int totalBookings = 0;
    if (roomDist != null) {
        for (int count : roomDist.values()) {
            totalBookings += count;
        }
    }
    
    // Formatting
    NumberFormat currency = NumberFormat.getCurrencyInstance(java.util.Locale.US);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Analytics - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --admin-dark: #2c3e50;
            --admin-gold: #f1c40f;
            --admin-blue: #3498db;
            --admin-purple: #9b59b6;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* DASHBOARD LAYOUT */
        .dashboard-container {
            padding: 25px;
            max-width: 1600px;
            margin: 0 auto;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .header-section h2 { margin: 0; color: var(--admin-dark); font-size: 24px; }
        .badge-admin { 
            background: var(--admin-dark); color: white; 
            padding: 5px 15px; border-radius: 20px; font-size: 12px; font-weight: bold; 
        }

        /* KPI CARDS */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .kpi-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
            transition: transform 0.3s;
        }
        .kpi-card:hover { transform: translateY(-5px); }
        
        .kpi-card::before {
            content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%;
        }
        .border-gold::before { background: var(--admin-gold); }
        .border-blue::before { background: var(--admin-blue); }
        .border-purple::before { background: var(--admin-purple); }
        .border-green::before { background: #2ecc71; }

        .kpi-label { font-size: 13px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 600; }
        .kpi-value { font-size: 32px; font-weight: 700; color: var(--admin-dark); margin: 10px 0; }
        .kpi-sub { font-size: 12px; color: #95a5a6; display: flex; align-items: center; gap: 5px; }
        .trend-up { color: #27ae60; font-weight: bold; }

        .kpi-icon-bg {
            position: absolute; right: 20px; top: 25px;
            font-size: 45px; opacity: 0.1; color: var(--admin-dark);
        }

        /* CHARTS AREA */
        .charts-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }

        .chart-panel {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .panel-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 15px;
        }
        .panel-title { font-size: 16px; font-weight: 700; color: var(--admin-dark); }

        /* DATA TABLE */
        .data-panel {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .admin-table {
            width: 100%; border-collapse: collapse; margin-top: 10px;
        }
        .admin-table th { text-align: left; padding: 15px; background: #f8f9fa; color: #7f8c8d; font-size: 12px; text-transform: uppercase; }
        .admin-table td { padding: 15px; border-bottom: 1px solid #eee; color: var(--admin-dark); }
        .admin-table tr:hover { background: #fafafa; }
        .progress-bar-bg { width: 100px; height: 6px; background: #eee; border-radius: 3px; overflow: hidden; }
        .progress-fill { height: 100%; border-radius: 3px; }

        /* Sidebar Toggle */
        .sidebar { transition: 0.3s; }
        .collapsed { width: 0; padding: 0; overflow: hidden; }
        .expanded { margin-left: 0; }

        /* FLOATING PDF BUTTON */
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
        
        <% if (session.getAttribute("role") != null && "ADMIN".equals(session.getAttribute("role"))) { %>
            <a href="manage_staff.jsp">
                <span class="icon">&#128100;</span> <span class="menu-text">Manage Staff</span>
            </a>
            <a href="manage_rooms.jsp">
                <span class="icon">&#128716;</span> <span class="menu-text">Manage Rooms</span>
            </a>
        <% } %>
        
        <a href="statistics_admin.jsp" style="background-color: #34495e; border-left: 5px solid #1abc9c;">
            <span class="icon">&#128202;</span> <span class="menu-text">Statistics</span>
        </a>

        <a href="logout.jsp" style="margin-top: 50px; color: #ff6b6b;">
            <span class="icon">&#128682;</span> <span class="menu-text">Logout</span>
        </a>
    </div>

    <div id="main" class="main-content">
        
        <div class="dashboard-container">
            
            <div class="header-section">
                <div>
                    <h2>Admin Dashboard</h2>
                    <span style="color: #7f8c8d; font-size: 14px;">Financial & Operational Overview</span>
                </div>
                <div class="badge-admin"><i class="fas fa-shield-alt"></i> ADMIN ACCESS</div>
            </div>

            <div class="kpi-grid">
                <div class="kpi-card border-gold">
                    <div class="kpi-label">Total Revenue</div>
                    <div class="kpi-value"><%= currency.format(totalRev) %></div>
                    <div class="kpi-sub">
                        <span class="trend-up"><i class="fas fa-arrow-up"></i> 12%</span> vs last month
                    </div>
                    <i class="fas fa-coins kpi-icon-bg"></i>
                </div>

                <div class="kpi-card border-blue">
                    <div class="kpi-label">Active Bookings</div>
                    <div class="kpi-value"><%= activeRes %></div>
                    <div class="kpi-sub">Currently In-House/Reserved</div>
                    <i class="fas fa-calendar-check kpi-icon-bg"></i>
                </div>

                <div class="kpi-card border-purple">
                    <div class="kpi-label">Total Bookings</div>
                    <div class="kpi-value"><%= totalBookings %></div>
                    <div class="kpi-sub">Lifetime Volume</div>
                    <i class="fas fa-users kpi-icon-bg"></i>
                </div>

                <div class="kpi-card border-green">
                    <div class="kpi-label">Occupancy Rate</div>
                    <div class="kpi-value">85%</div>
                    <div class="kpi-sub">High Demand</div>
                    <i class="fas fa-chart-pie kpi-icon-bg"></i>
                </div>
            </div>

            <div class="charts-row">
                <div class="chart-panel">
                    <div class="panel-header">
                        <span class="panel-title">Monthly Revenue Performance</span>
                        <i class="fas fa-chart-line" style="color: #ccc;"></i>
                    </div>
                    <canvas id="revenueChart" height="120"></canvas>
                </div>

                <div class="chart-panel">
                    <div class="panel-header">
                        <span class="panel-title">Room Preference</span>
                        <i class="fas fa-bed" style="color: #ccc;"></i>
                    </div>
                    <canvas id="roomChart" height="200"></canvas>
                </div>
            </div>

            <div class="data-panel">
                <div class="panel-header">
                    <span class="panel-title">Room Type Performance Breakdown</span>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Room Category</th>
                            <th>Total Bookings</th>
                            <th>Contribution</th>
                            <th>Trend</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        if (roomDist != null) {
                            String[] colors = {"#1abc9c", "#3498db", "#9b59b6", "#f1c40f", "#e74c3c"};
                            int i = 0;
                            for (Map.Entry<String, Integer> entry : roomDist.entrySet()) {
                                int val = entry.getValue();
                                int percent = (totalBookings > 0) ? (val * 100) / totalBookings : 0;
                                String color = colors[i % colors.length];
                                i++;
                        %>
                        <tr>
                            <td><strong><%= entry.getKey() %></strong></td>
                            <td><%= val %></td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <div class="progress-bar-bg">
                                        <div class="progress-fill" style="width: <%= percent %>%; background: <%= color %>;"></div>
                                    </div>
                                    <span style="font-size: 11px; font-weight: bold;"><%= percent %>%</span>
                                </div>
                            </td>
                            <td><i class="fas fa-chart-line" style="color: <%= color %>;"></i> Stable</td>
                        </tr>
                        <% 
                            }
                        } else { 
                        %>
                        <tr><td colspan="4">No data available</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

        </div> </div>

    <script>
        // Revenue Chart (Bar)
        const ctxRev = document.getElementById('revenueChart');
        
        // Dynamic Data from JSP
        const revLabels = [<%= monthlyRev.keySet().stream().map(s -> "'" + s + "'").reduce((a, b) -> a + "," + b).orElse("") %>];
        const revData = [<%= monthlyRev.values().stream().map(Object::toString).reduce((a, b) -> a + "," + b).orElse("") %>];

        new Chart(ctxRev, {
            type: 'bar',
            data: {
                labels: revLabels.length ? revLabels : ['Jan', 'Feb', 'Mar'], 
                datasets: [{
                    label: 'Revenue ($)',
                    data: revData.length ? revData : [0, 0, 0],
                    backgroundColor: '#3498db',
                    borderRadius: 4,
                    barPercentage: 0.6
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { borderDash: [2, 4] } },
                    x: { grid: { display: false } }
                }
            }
        });

        // Room Pie Chart
        const ctxRoom = document.getElementById('roomChart');
        
        const roomLabels = [<%= roomDist.keySet().stream().map(s -> "'" + s + "'").reduce((a, b) -> a + "," + b).orElse("") %>];
        const roomData = [<%= roomDist.values().stream().map(Object::toString).reduce((a, b) -> a + "," + b).orElse("") %>];

        new Chart(ctxRoom, {
            type: 'doughnut',
            data: {
                labels: roomLabels.length ? roomLabels : ['Standard', 'Deluxe'],
                datasets: [{
                    data: roomData.length ? roomData : [1, 1],
                    backgroundColor: ['#1abc9c', '#3498db', '#9b59b6', '#f1c40f', '#e74c3c'],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                cutout: '70%',
                plugins: {
                    legend: { position: 'bottom', labels: { usePointStyle: true, boxWidth: 8 } }
                }
            }
        });
    </script>
    
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
        function openBillModal() { document.getElementById("billModal").style.display = "block"; }
        function closeBillModal() { document.getElementById("billModal").style.display = "none"; }
        window.onclick = function(event) {
            var modal = document.getElementById("billModal");
            if (event.target == modal) { modal.style.display = "none"; }
        }
    </script>
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    <button onclick="downloadReport()" class="pdf-btn" id="downloadBtn">
        <span>&#128196;</span> Download Report
    </button>

    <script>
        window.jsPDF = window.jspdf.jsPDF;

        async function downloadReport() {
            const btn = document.getElementById('downloadBtn');
            const content = document.getElementById('main'); 
            
            // HIDE BUTTON
            btn.style.display = 'none';

            // PREPARE UI FOR CAPTURE
            const originalOverflow = content.style.overflow;
            const originalHeight = content.style.height;
            const originalBg = content.style.backgroundColor;

            // Expand to full height 
            content.style.overflow = "visible";
            content.style.height = "auto";
            content.style.backgroundColor = "#ffffff"; 

            window.scrollTo(0, 0);

            // CAPTURE
            html2canvas(content, {
                scale: 2, 
                useCORS: true,
                scrollY: -window.scrollY, 
                windowHeight: content.scrollHeight 
            }).then(canvas => {
                
                // GENERATE PDF
                const pdf = new jsPDF('p', 'mm', 'a4'); 
                const pdfWidth = pdf.internal.pageSize.getWidth();
                
                // Header Block
                pdf.setFillColor(52, 73, 94);
                pdf.rect(0, 0, pdfWidth, 25, 'F');
                
                pdf.setFontSize(16);
                pdf.setTextColor(255, 255, 255);
                pdf.setFont("helvetica", "bold");
                pdf.text("OCEAN VIEW RESORT - ADMIN REPORT", 10, 15);
                
                pdf.setFontSize(10);
                pdf.setFont("helvetica", "normal");
                const today = new Date().toLocaleDateString();
                pdf.text("Generated: " + today, pdfWidth - 40, 15);

                // Image Logic 
                const imgData = canvas.toDataURL('image/png');
                const imgProps = pdf.getImageProperties(imgData);
                
                const margin = 10;
                const availableWidth = pdfWidth - (margin * 2);
                const imgHeight = (imgProps.height * availableWidth) / imgProps.width;
                
                pdf.addImage(imgData, 'PNG', margin, 30, availableWidth, imgHeight);

                pdf.save("OceanView_admin-statistics_Report.pdf");

                // RESTORE UI
                btn.style.display = 'flex';
                content.style.overflow = originalOverflow;
                content.style.height = originalHeight;
                content.style.backgroundColor = originalBg;
            });
        }
    </script>

</body>
</html>
