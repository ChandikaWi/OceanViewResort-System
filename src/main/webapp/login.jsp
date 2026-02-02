<%-- 
    Document   : login
    Created on : Jan 31, 2026, 7:58:22 PM
    Author     : Chand
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Ocean View Resort - Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container" style="max-width: 400px; margin-top: 100px;">
        <h2 style="text-align: center;">Staff Login</h2>
            <form action="AuthServlet" method="post">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <button type="submit" style="width: 100%;">Login</button>

                <div style="text-align: center; margin-top: 15px;">
                    <a href="help.jsp" style="color: #007bff; text-decoration: none; font-size: 14px;">Need Help?</a>
                </div>
            </form>
    </div>
</body>
</html>
