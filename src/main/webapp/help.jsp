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
        <p style="color: #666; font-size: 16px;">Welcome to the Ocean View Resort Reservation System. Below you will find detailed instructions separated by user role.</p>

        <h2 class="role-title">&#128100; Staff & Front Desk Guide</h2>
        <p><em>For all Front Desk Officers and Staff members.</em></p>

        <div class="step">
            <h3><span class="step-icon">1</span> System Access & Navigation</h3>
            <ul>
                <li><strong>Log In:</strong> Use the credentials provided by your manager. If you forget your password, contact an Admin.</li>
                <li><strong>Sidebar Menu:</strong> The main menu is on the left. Click the <strong>&#9776;</strong> (Hamburger) button to expand or collapse it.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">2</span> Managing Reservations</h3>
            <ul>
                <li><strong>New Booking:</strong> Go to the Dashboard. Enter guest details and select a <strong>Room Type</strong> from the dropdown list.
                <br><small>(Note: Room prices are automatically fetched from the database).</small></li>
                <li><strong>Search:</strong> Click <strong>Reservations</strong> in the sidebar to search for guests by Name or ID.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">3</span> Billing & Invoices</h3>
            <p>You can generate professional PDF invoices in two ways:</p>
            <ol>
                <li><strong>Quick Print:</strong> Click <strong>"Print Bill"</strong> in the sidebar. A popup box will appear. Enter the Guest Name or ID to find and print.</li>
                <li><strong>Table Print:</strong> Go to the <strong>Reservations</strong> page and click the teal <strong>Print Bill</strong> button next to any guest.</li>
            </ol>
            <p><em>The system automatically calculates the total based on: (Room Rate &times; Number of Nights).</em></p>
        </div>

        <div class="step">
            <h3><span class="step-icon">4</span> Staff Statistics</h3>
            <p>Click <strong>Statistics</strong> in the sidebar to view your daily workflow:</p>
            <ul>
                <li><strong>Arrivals:</strong> Number of guests checking in today.</li>
                <li><strong>Departures:</strong> Number of guests checking out today.</li>
                <li><strong>Workload Chart:</strong> A visual breakdown of today's tasks.</li>
            </ul>
        </div>

        <hr style="margin-top: 50px; border: 0; border-top: 1px dashed #ccc;">

        <h2 class="role-title" style="background-color: #c0392b;">&#128736; Administrator Guide</h2>
        <p><em>Exclusive features for Managers and Admins.</em></p>

        <div class="step" style="border-left-color: #c0392b;">
            <h3><span class="step-icon" style="background-color: #c0392b;">A</span> Admin Dashboard (Statistics)</h3>
            <p>When an Admin clicks <strong>Statistics</strong>, they see the Financial Dashboard:</p>
            <ul>
                <li><strong>KPI Cards:</strong> View Total Revenue, Active Bookings, and Occupancy Rate.</li>
                <li><strong>Charts:</strong> Analyze Monthly Revenue trends and Room Type popularity (Pie Chart).</li>
            </ul>
        </div>

        <div class="step" style="border-left-color: #c0392b;">
            <h3><span class="step-icon" style="background-color: #c0392b;">B</span> Manage Staff Accounts</h3>
            <p>Go to the <strong>Manage Staff</strong> page to control system access:</p>
            <ul>
                <li><strong>Create:</strong> Add new users with a Username, Password, and Role (Admin/Staff).</li>
                <li><strong>Update:</strong> Click the <span style="background-color: #ffc107; padding: 2px 5px; border-radius: 3px; font-size: 12px;">Update</span> button to change passwords or roles via a popup.</li>
                <li><strong>Delete:</strong> Remove accounts securely. A warning popup will ask for confirmation.</li>
            </ul>
        </div>

        <div class="step" style="border-left-color: #c0392b;">
            <h3><span class="step-icon" style="background-color: #c0392b;">C</span> Manage Rooms & Rates</h3>
            <p>Go to the <strong>Manage Rooms</strong> page to configure hotel inventory:</p>
            <ul>
                <li><strong>Add Room Type:</strong> Define new room categories (e.g., "Penthouse"), set the Price per Night, and add a Description.</li>
                <li><strong>Room Images:</strong> To add an image, place the file in your project's <code>web/images/</code> folder and type the path (e.g., <code>images/room1.jpg</code>).</li>
                <li><strong>Pricing Updates:</strong> Updating a price here immediately updates the billing calculation for all future reservations.</li>
            </ul>
        </div>

        <div style="text-align: center; margin-top: 40px;">
            <a href="login.jsp" class="back-link" style="padding: 12px 30px; font-size: 16px;">Return to System Login</a>
        </div>
    </div>
</body>
</html>
