<%-- 
    Document   : logout
    Created on : Jan 31, 2026, 7:59:17?PM
    Author     : Chand
--%>

<%
    session.invalidate();
    response.sendRedirect("login.jsp");
%>
