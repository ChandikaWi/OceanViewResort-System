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
        body { background-color: #f4f4f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        .navbar { background-color: #2c3e50; padding: 15px 30px; color: white; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        .nav-brand { font-size: 20px; font-weight: bold; letter-spacing: 1px; }
        .back-link { color: #1abc9c; text-decoration: none; font-size: 14px; border: 1px solid #1abc9c; padding: 5px 15px; border-radius: 4px; transition: 0.3s; }
        .back-link:hover { background-color: #1abc9c; color: white; }

        .help-container { max-width: 900px; margin: 40px auto; background: white; padding: 50px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        
        h1 { border-bottom: 2px solid #eee; padding-bottom: 15px; color: #2c3e50; margin-top: 0; }
        h2.role-title { 
            background-color: #2c3e50; 
            color: white; 
            padding: 10px 15px; 
            border-radius: 4px; 
            margin-top: 40px; 
            font-size: 18px;
            display: inline-block;
        }

        .step { margin-bottom: 30px; border-left: 5px solid #1abc9c; padding-left: 20px; margin-top: 25px; }
        .step h3 { color: #2c3e50; margin-top: 0; display: flex; align-items: center; font-size: 18px; }
        .step-icon { background-color: #2c3e50; color: white; width: 30px; height: 30px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-right: 12px; font-size: 14px; font-weight: bold; }
        
        code { background-color: #f1f2f6; padding: 2px 6px; border-radius: 3px; font-family: monospace; color: #e74c3c; border: 1px solid #ddd; }
        
        ul, ol { line-height: 1.6; color: #555; }
        li { margin-bottom: 8px; }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="nav-brand">Ocean View Resort <span style="font-weight: 300; opacity: 0.8;">| Help Portal</span></div>
        <a href="login.jsp" class="back-link">&larr; Back to Login</a>
    </div>

    <div class="help-container">
        <h1>User Manual</h1>
        <p style="color: #666; font-size: 16px;">Welcome to the Ocean View Resort Reservation System. Below you will find detailed instructions regarding the latest features, including Email Automation and Inventory Management.</p>

        <h2 class="role-title">&#128100; Staff & Front Desk Guide</h2>
        <p><em>For all Front Desk Officers and Staff members.</em></p>

        <div class="step">
            <h3><span class="step-icon">1</span> Access & Login</h3>
            <ul>
                <li><strong>Credentials:</strong> Log in using your username and password.</li>
                <li><strong>Remember Me:</strong> Check the "Remember Me" box to keep your username saved for 7 days.</li>
                <li><strong>Sidebar:</strong> Use the left menu to navigate. Click <strong>&#9776;</strong> to collapse/expand.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">2</span> New Booking & Inventory</h3>
            <p>Go to the <strong>New Booking</strong> (Dashboard) page:</p>
            <ul>
                <li><strong>Email Required:</strong> You must enter the guest's <strong>Email Address</strong>. The system automatically sends a confirmation email upon success.</li>
                <li><strong>Room Availability:</strong> When selecting a Room Type, the dropdown shows the <strong>Total Capacity</strong>. </li>
                <li><strong>Validation:</strong> If a room type is fully booked for the selected dates, the system will show an error and prevent the booking.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">3</span> Managing Reservations</h3>
            <p>Go to the <strong>Reservations</strong> page:</p>
            <ul>
                <li><strong>Search:</strong> Find guests by Name or ID.</li>
                <li><strong>Delete:</strong> Click the red <span style="color:#dc3545; font-weight:bold;">Delete</span> button to cancel a booking. A warning popup will ask for confirmation.</li>
                <li><strong>Total Bill:</strong> The table automatically calculates cost based on: <em>(Room Rate &times; Nights Stayed)</em>.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">4</span> Billing & Auto-Email</h3>
            <p>Generating an invoice handles two tasks at once:</p>
            <ol>
                <li>Click the teal <strong>Print Bill</strong> button next to a reservation (or use the sidebar popup).</li>
                <li>The system downloads a <strong>PDF Invoice</strong> to your computer.</li>
                <li>Simultaneously, the system <strong>Emails a copy</strong> of the PDF to the guest automatically.</li>
            </ol>
        </div>

        <div class="step">
            <h3><span class="step-icon">5</span> Statistics & Reports</h3>
            <p>Click <strong>Statistics</strong> in the sidebar:</p>
            <ul>
                <li>View today's Arrivals and Departures.</li>
                <li><strong>Export:</strong> Click the floating red <strong>Download Report</strong> button (bottom-right) to save the dashboard as a formal PDF report.</li>
            </ul>
        </div>

        <hr style="margin-top: 50px; border: 0; border-top: 1px dashed #ccc;">

        <h2 class="role-title" style="background-color: #c0392b;">&#128736; Administrator Guide</h2>
        <p><em>Exclusive features for Managers.</em></p>

        <div class="step" style="border-left-color: #c0392b;">
            <h3><span class="step-icon" style="background-color: #c0392b;">A</span> Admin Dashboard & Revenue</h3>
            <p>The Admin <strong>Statistics</strong> page offers financial insights:</p>
            <ul>
                <li><strong>Real-time Revenue:</strong> Calculates total earnings from all active reservations.</li>
                <li><strong>Visuals:</strong> Includes Bar Charts (Monthly Trends) and Pie Charts (Room Preferences).</li>
                <li><strong>PDF Export:</strong> Like the staff page, you can download a "Management Report" using the floating red button.</li>
            </ul>
        </div>

        <div class="step" style="border-left-color: #c0392b;">
            <h3><span class="step-icon" style="background-color: #c0392b;">B</span> Staff Management</h3>
            <ul>
                <li>Create new accounts with specific roles (Admin vs Staff).</li>
                <li><strong>Update:</strong> Click the Yellow button to change passwords or usernames via a popup.</li>
                <li><strong>Delete:</strong> Click the Red button to remove access securely.</li>
            </ul>
        </div>

        <div class="step" style="border-left-color: #c0392b;">
            <h3><span class="step-icon" style="background-color: #c0392b;">C</span> Room & Inventory Control</h3>
            <p>Go to <strong>Manage Rooms</strong> to control the hotel layout:</p>
            <ul>
                <li><strong>Quantity (Inventory):</strong> You must set the <strong>Total Rooms</strong> (Quantity) for each type. This number is used to prevent overbooking.</li>
                <li><strong>Pricing:</strong> Changing the price here updates future billing calculations.</li>
                <li><strong>Images:</strong> Enter the path to images stored in the project folder (e.g., <code>images/suite.jpg</code>).</li>
            </ul>
        </div>

        <div style="text-align: center; margin-top: 40px;">
            <a href="login.jsp" class="back-link" style="padding: 12px 30px; font-size: 16px;">Return to System Login</a>
        </div>
    </div>
</body>
</html>
