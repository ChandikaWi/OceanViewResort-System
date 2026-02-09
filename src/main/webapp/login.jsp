<%-- 
    Document   : login
    Created on : Jan 31, 2026, 7:58:22 PM
    Author     : Chand
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Login - Ocean View Resort</title>
    <link rel="stylesheet" href="css/style.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body class="login-body">

    <div class="login-card">
        <div style="margin-bottom: 20px;">
            <span style="font-size: 50px; color: #1abc9c;">&#127968;</span>
            <h2 style="color: #2c3e50; margin: 10px 0;">Staff Portal</h2>
            <p style="color: #7f8c8d; font-size: 14px;">Please sign in to continue</p>
        </div>

        <% 
            String error = request.getParameter("error");
            if (error != null && error.equals("invalid")) {
        %>
            <div class="error-msg" style="display: block;">
                &#9888; Invalid Username or Password!
            </div>
        <% 
            } else if (error != null && error.equals("logout")) {
        %>
            <div class="error-msg" style="background-color: #2ecc71; display: block;">
                &#10004; You have been logged out.
            </div>
        <% } %>

        <form action="AuthServlet" method="post">
            
            <%
                String savedUser = "";
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie c : cookies) {
                        if ("remember_user".equals(c.getName())) {
                            savedUser = c.getValue();
                        }
                    }
                }
            %>

            <div class="input-container">
                <input type="text" name="username" value="<%= savedUser %>" required>
                <label>Username</label>
            </div>

            <div class="input-container">
                <input type="password" name="password" required>
                <label>Password</label>
            </div>

            <div class="remember-box">
                <input type="checkbox" name="remember" id="chkRemember" <%= !savedUser.isEmpty() ? "checked" : "" %>>
                <label for="chkRemember">Remember me</label>
            </div>

            <button type="submit" class="login-btn">Login</button>

            <div style="margin-top: 20px; font-size: 13px;">
                <a href="help.jsp" style="color: #1abc9c; text-decoration: none;">Need Help?</a>
            </div>
        </form>
    </div>

</body>
</html>
