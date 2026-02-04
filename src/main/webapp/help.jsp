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
        body { background-color: #f4f4f9; }
        .navbar { background-color: #2c3e50; padding: 15px; color: white; display: flex; justify-content: space-between; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        .help-container { max-width: 900px; margin: 40px auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .step { margin-bottom: 30px; border-left: 5px solid #1abc9c; padding-left: 20px; }
        .step h3 { color: #2c3e50; margin-top: 0; display: flex; align-items: center; }
        .step-icon { background-color: #2c3e50; color: white; width: 30px; height: 30px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; margin-right: 10px; font-size: 14px; }
        .back-link { display: inline-block; margin-top: 20px; text-decoration: none; color: #2c3e50; font-weight: bold; border: 1px solid #2c3e50; padding: 10px 20px; border-radius: 4px; transition: 0.3s; }
        .back-link:hover { background-color: #2c3e50; color: white; }
        code { background-color: #eee; padding: 2px 5px; border-radius: 3px; font-family: monospace; color: #c0392b; }
    </style>
</head>
<body>
    <div class="navbar">
        <div style="font-size: 18px; font-weight: bold;">Ocean View Resort - Staff Help Portal</div>
        <a href="login.jsp" style="color:white; text-decoration: none; font-size: 14px;">&larr; Back to Login</a>
    </div>

    <div class="help-container">
        <h1 style="border-bottom: 2px solid #eee; padding-bottom: 15px; color: #2c3e50;">User Manual for New Staff</h1>
        <p>Welcome to the Ocean View Resort Management System. This guide covers all system functionalities including the new Sidebar navigation and Billing features.</p>

        <div class="step">
            <h3><span class="step-icon">1</span> System Access</h3>
            <p><strong>Log In:</strong> Enter your staff username and password on the Login page.</p>
            <ul>
                <li><strong>Default Admin:</strong> <code>admin</code> / <code>admin123</code></li>
                <li><strong>Staff Accounts:</strong> If you are a new staff member, ask your Manager (Admin) to create an account for you via the "Manage Staff" page.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">2</span> Navigation (Sidebar)</h3>
            <p>The system uses a collapsible <strong>Sidebar Menu</strong> on the left:</p>
            <ul>
                <li><strong>Expand/Collapse:</strong> Click the <strong>&#9776;</strong> (Hamburger) button in the top-left corner to toggle the menu view.</li>
                <li><strong>New Booking:</strong> Takes you to the Dashboard to add reservations.</li>
                <li><strong>Reservations:</strong> Takes you to the Search & View page.</li>
                <li><strong>Print Bill:</strong> Opens the billing popup.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">3</span> Creating a Reservation</h3>
            <p>Navigate to <strong>New Booking</strong> in the sidebar:</p>
            <ol>
                <li><strong>Reservation Number:</strong> You must manually enter a unique ID (e.g., <code>1005</code>). If the ID exists, the system will alert you.</li>
                <li><strong>Guest Details:</strong> Fill in Name, Address, and Contact Number.</li>
                <li><strong>Room & Dates:</strong> Select the Room Type and Dates. (Note: Check-out must be after Check-in).</li>
                <li>Click <strong>Create Reservation</strong> to save.</li>
            </ol>
        </div>

        <div class="step">
            <h3><span class="step-icon">4</span> Searching Reservations</h3>
            <p>To find a guest, click <strong>Reservations</strong> in the sidebar:</p>
            <ul>
                <li>Use the <strong>Search Bar</strong> at the top right of the table.</li>
                <li>You can search by <strong>Guest Name</strong> or <strong>Reservation ID</strong>.</li>
                <li>Click "Reset" to view the full list again.</li>
            </ul>
        </div>

        <div class="step">
            <h3><span class="step-icon">5</span> Printing Bills (PDF)</h3>
            <p>There are two ways to print a bill:</p>
            <ol>
                <li><strong>Quick Print:</strong> Click <strong>Print Bill</strong> in the sidebar. A popup box will appear. Enter the Guest Name or ID to find them, then click the "Print Bill" button in the results.</li>
                <li><strong>List Print:</strong> Go to the <strong>Reservations</strong> page, find the user in the table, and click the teal <span style="background-color: #17a2b8; color: white; padding: 2px 6px; border-radius: 3px; font-size: 11px;">Print Bill</span> button.</li>
            </ol>
            <p><em>The system automatically calculates the cost based on nights stayed and generates a PDF invoice.</em></p>
        </div>

        <div class="step">
            <h3><span class="step-icon">6</span> Admin Features</h3>
            <p><em>(Visible only to Administrators)</em></p>
            <p>Admins will see an extra link called <strong>Manage Staff</strong>. This allows them to:</p>
            <ul>
                <li>Create new staff accounts (Username/Password/Role).</li>
                <li>Delete existing staff accounts from the database.</li>
            </ul>
        </div>

        <div style="text-align: center; margin-top: 40px;">
            <a href="login.jsp" class="back-link">I'm ready to Log In</a>
        </div>
    </div>
</body>
</html>
