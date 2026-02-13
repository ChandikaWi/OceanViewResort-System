<%-- 
    Document   : statistics_staff
    Created on : Feb 6, 2026, 8:55:09 AM
    Author     : Chand
--%>

<%@page import="java.util.Map"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="com.oceanview.dao.StatsDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security Check
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Data Fetching from Database
    StatsDAO dao = new StatsDAO();
    
    // Core Ops Data
    int checkIns = dao.getTodaysCheckIns();
    int checkOuts = dao.getTodaysCheckOuts();
    int active = dao.getTotalActiveReservations();
    
    double totalRevenue = 0.0;
    try { totalRevenue = dao.getTotalRevenue(); } catch(Exception e){}
    
    Map<String, Integer> roomDist = null;
    try { roomDist = dao.getRoomTypeDistribution(); } catch(Exception e){}

    Map<String, Double> monthlyRev = null;
    try { monthlyRev = dao.getMonthlyRevenue(); } catch(Exception e){}
    
    // Formatter for Currency
    NumberFormat currency = NumberFormat.getCurrencyInstance(java.util.Locale.US);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Analytics - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --primary-blue: #2c3e50;
            --accent-teal: #1abc9c;
            --ocean-light: #ecf0f1;
            --text-dark: #2c3e50;
        }

        body {
            background-color: #f4f7f6; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* DASHBOARD GRID */
        .dashboard-container {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }

        /* KPI CARDS ROW */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .kpi-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 5px solid var(--accent-teal);
            transition: transform 0.3s ease;
        }
        .kpi-card:hover { transform: translateY(-5px); }

        .kpi-info h4 { margin: 0; color: #7f8c8d; font-size: 14px; text-transform: uppercase; letter-spacing: 1px; }
        .kpi-info h2 { margin: 5px 0 0 0; color: var(--text-dark); font-size: 28px; font-weight: 700; }
        .kpi-icon { font-size: 40px; color: #dcdde1; opacity: 0.5; }

        /* Specific Colors for Cards */
        .card-green { border-left-color: #27ae60; }
        .card-red { border-left-color: #e74c3c; }
        .card-blue { border-left-color: #3498db; }
        .card-gold { border-left-color: #f1c40f; }

        /* CHARTS ROW */
        .charts-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }

        .chart-box {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .chart-title { font-weight: bold; color: var(--text-dark); }

        /* DATA TABLE SECTION */
        .table-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }
        .styled-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .styled-table th, .styled-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        .styled-table th { background-color: #f8f9fa; color: #7f8c8d; font-weight: 600; }
        .styled-table tr:hover { background-color: #f1f1f1; }

        /* Sidebar Toggles */
        .sidebar { transition: 0.3s; }
        .collapsed { width: 0; padding: 0; overflow: hidden; }
        .expanded { margin-left: 0; }
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

        <a href="statistics_staff.jsp" style="background-color: #34495e; border-left: 5px solid #1abc9c;">
            <span class="icon">&#128202;</span> <span class="menu-text">Statistics</span>
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
        
        <div class="dashboard-container">
            
            <div style="margin-bottom: 25px;">
                <h2 style="color: #2c3e50; margin-bottom: 5px;">Staff Dashboard</h2>
                <small style="color: #95a5a6;">Real-time hotel performance overview</small>
            </div>

            <div class="kpi-grid">
                <div class="kpi-card card-green">
                    <div class="kpi-info">
                        <h4>Check-ins Today</h4>
                        <h2><%= checkIns %></h2>
                    </div>
                    <div class="kpi-icon"><i class="fas fa-luggage-cart"></i></div>
                </div>

                <div class="kpi-card card-red">
                    <div class="kpi-info">
                        <h4>Check-outs Today</h4>
                        <h2><%= checkOuts %></h2>
                    </div>
                    <div class="kpi-icon"><i class="fas fa-sign-out-alt"></i></div>
                </div>

                <div class="kpi-card card-blue">
                    <div class="kpi-info">
                        <h4>Active Guests</h4>
                        <h2><%= active %></h2>
                    </div>
                    <div class="kpi-icon"><i class="fas fa-bed"></i></div>
                </div>

                <div class="kpi-card card-gold">
                    <div class="kpi-info">
                        <h4>Total Revenue</h4>
                        <h2 style="font-size: 22px;"><%= currency.format(totalRevenue) %></h2>
                    </div>
                    <div class="kpi-icon"><i class="fas fa-chart-line"></i></div>
                </div>
            </div>

            <div class="charts-grid">
                <div class="chart-box">
                    <div class="chart-header">
                        <span class="chart-title">Revenue & Occupancy Trend</span>
                        <i class="fas fa-chart-area" style="color: #3498db;"></i>
                    </div>
                    <canvas id="revenueChart" height="120"></canvas>
                </div>

                <div class="chart-box">
                    <div class="chart-header">
                        <span class="chart-title">Operational Load</span>
                        <i class="fas fa-tasks" style="color: #2ecc71;"></i>
                    </div>
                    <canvas id="opsChart" height="200"></canvas>
                </div>
            </div>
            
            <div class="table-section">
                <div class="chart-header">
                    <span class="chart-title">Room Performance Breakdown</span>
                    <i class="fas fa-table" style="color: #95a5a6;"></i>
                </div>
                <table class="styled-table">
                    <thead>
                        <tr>
                            <th>Room Type</th>
                            <th>Total Bookings</th>
                            <th>Status</th>
                            <th>Popularity</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (roomDist != null) {
                                for (Map.Entry<String, Integer> entry : roomDist.entrySet()) {
                                    int count = entry.getValue();
                                    int width = Math.min(count * 5, 100); 
                        %>
                        <tr>
                            <td><strong><%= entry.getKey() %></strong></td>
                            <td><%= count %> Bookings</td>
                            <td><span style="color: green; font-size: 12px;">● Active</span></td>
                            <td>
                                <div style="background: #ecf0f1; width: 100px; height: 8px; border-radius: 4px;">
                                    <div style="background: #3498db; width: <%= width %>%; height: 100%; border-radius: 4px;"></div>
                                </div>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <tr><td colspan="4">No chart data available.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

        </div> </div>

    <script>
        // Operations Polar Chart 
        const ctxOps = document.getElementById('opsChart');
        new Chart(ctxOps, {
            type: 'polarArea',
            data: {
                labels: ['Check-ins', 'Check-outs', 'In-House'],
                datasets: [{
                    data: [<%= checkIns %>, <%= checkOuts %>, <%= active %>],
                    backgroundColor: ['rgba(46, 204, 113, 0.7)', 'rgba(231, 76, 60, 0.7)', 'rgba(52, 152, 219, 0.7)'],
                    borderWidth: 1
                }]
            },
            options: {
                scales: { r: { suggestedMin: 0 } },
                plugins: { legend: { position: 'bottom' } }
            }
        });

        // Revenue Trend Line Chart 
        const ctxRev = document.getElementById('revenueChart');
        
        const labels = [];
        const data = [];
        
        <% 
            if (monthlyRev != null) {
                for(Map.Entry<String, Double> e : monthlyRev.entrySet()) {
        %>
                labels.push("<%= e.getKey() %>");
                data.push(<%= e.getValue() %>);
        <% 
                }
            }
        %>

        new Chart(ctxRev, {
            type: 'line',
            data: {
                labels: labels.length > 0 ? labels : ['Jan', 'Feb', 'Mar'], 
                datasets: [{
                    label: 'Monthly Revenue ($)',
                    data: data.length > 0 ? data : [0, 0, 0],
                    borderColor: '#f1c40f',
                    backgroundColor: 'rgba(241, 196, 15, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
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

    <style>
        .pdf-btn {
            position: fixed; bottom: 30px; right: 30px;
            background-color: #c0392b; color: white;
            border: none; border-radius: 50px;
            padding: 15px 25px; font-size: 16px; font-weight: bold;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            cursor: pointer; z-index: 1000;
            display: flex; align-items: center; gap: 10px;
            transition: 0.3s;
        }
        .pdf-btn:hover { background-color: #a93226; transform: translateY(-3px); }
    </style>

    <button onclick="downloadReport()" class="pdf-btn" id="downloadBtn">
        <span>&#128196;</span> Download Report
    </button>

    <script>
        window.jsPDF = window.jspdf.jsPDF;

        async function downloadReport() {
            const btn = document.getElementById('downloadBtn');
            const content = document.getElementById('main'); 
            
            // PREPARE UI
            btn.style.display = 'none'; 
            
            // Store original styles to restore later
            const originalOverflow = content.style.overflow;
            const originalHeight = content.style.height;
            const originalBg = content.style.backgroundColor;

            content.style.overflow = "visible";
            content.style.height = "auto";
            content.style.backgroundColor = "#ffffff"; 

            // Scroll to top to ensure capture starts correctly
            window.scrollTo(0, 0);

            // CAPTURE CANVAS
            html2canvas(content, {
                scale: 2, 
                useCORS: true,
                scrollY: -window.scrollY, // Handle scroll offset
                windowHeight: content.scrollHeight // Capture full scroll height
            }).then(canvas => {
                
                // GENERATE PDF
                const pdf = new jsPDF('p', 'mm', 'a4'); 
                
                const pdfWidth = pdf.internal.pageSize.getWidth();
                const pdfHeight = pdf.internal.pageSize.getHeight();
                
                // Header Background
                pdf.setFillColor(44, 62, 80);
                pdf.rect(0, 0, pdfWidth, 25, 'F');
                
                // Header Text
                pdf.setFontSize(16);
                pdf.setTextColor(255, 255, 255);
                pdf.setFont("helvetica", "bold");
                pdf.text("OCEAN VIEW RESORT - STAFF REPORT", 10, 15);
                
                pdf.setFontSize(10);
                pdf.setFont("helvetica", "normal");
                const today = new Date().toLocaleDateString();
                pdf.text("Generated: " + today, pdfWidth - 40, 15);

                // CALCULATE IMAGE DIMENSIONS TO FIT PAGE
                const imgData = canvas.toDataURL('image/png');
                
                const imgProps = pdf.getImageProperties(imgData);
                const margin = 10;
                const availableWidth = pdfWidth - (margin * 2);
                
                // Calculate height maintaining aspect ratio
                const imgHeight = (imgProps.height * availableWidth) / imgProps.width;
                
                // Add Image 
                pdf.addImage(imgData, 'PNG', margin, 30, availableWidth, imgHeight);

                // Save
                pdf.save("OceanView_staff-statistics_Report.pdf");

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
