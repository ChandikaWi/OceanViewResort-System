<%-- 
    Document   : help
    Created on : Feb 2, 2026, 8:43:17 AM
    Author     : Chand
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>System Help Guide - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .help-container { max-width: 800px; margin: 30px auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .step { margin-bottom: 25px; border-left: 4px solid #007bff; padding-left: 15px; }
        .step h3 { color: #007bff; margin-top: 0; }
        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: #6c757d; }
        .back-link:hover { color: #333; }
    </style>
</head>
<body>
    <div class="navbar">
        <div>Ocean View Resort - Staff Help Portal</div>
        <a href="login.jsp" style="color:white; text-decoration: none;">Back to Login</a>
    </div>

    <div class="help-container">
        <h1 style="border-bottom: 2px solid #eee; padding-bottom: 15px;">User Manual for New Staff</h1>
        <p>Welcome to the Ocean View Resort Reservation Management System. Follow these steps to manage guest bookings efficiently.</p>

        <div class="step">
            <h3>Step 1: System Access</h3>
            <p><strong>Log In:</strong> Enter your staff username and password on the Login page. 
            <br><em>(Default Admin Credentials: admin / admin123)</em></p>
        </div>

        <div class="step">
            <h3>Step 2: Dashboard Overview</h3>
            <p>Once logged in, you will see the main Dashboard. This area is split into two sections:</p>
            <ul>
                <li><strong>Add New Reservation:</strong> A form to input new guest details.</li>
                <li><strong>Current Reservations:</strong> A table displaying all active bookings in the system.</li>
            </ul>
        </div>

        <div class="step">
            <h3>Step 3: Creating a Reservation</h3>
            <p>To register a new guest:</p>
            <ol>
                <li><strong>Reservation Number:</strong> Enter a unique ID (e.g., 1001).</li>
                <li><strong>Guest Details:</strong> Fill in the Name, Address, and Contact Number.</li>
                <li><strong>Room & Dates:</strong> Select the Room Type and the Check-in/Check-out dates.</li>
                <li>Click <strong>"Create Reservation"</strong>. The system will automatically calculate the total cost.</li>
            </ol>
        </div>

        <div class="step">
            <h3>Step 4: Managing Bills</h3>
            <p>In the "Current Reservations" table:</p>
            <ul>
                <li>Locate the specific guest row.</li>
                <li>Click the <strong style="color: #17a2b8;">Print Bill</strong> button.</li>
                <li>A professional PDF invoice will execute and download automatically.</li>
            </ul>
        </div>

        <div class="step">
            <h3>Step 5: Logging Out</h3>
            <p>Always ensure you log out securely by clicking the <strong>"Logout"</strong> link in the top right corner when your shift ends.</p>
        </div>

        <a href="login.jsp" class="back-link">&larr; Return to Login Page</a>
    </div>
</body>
</html>
