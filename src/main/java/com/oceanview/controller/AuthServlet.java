/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.oceanview.controller;

import com.oceanview.dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Chand
 */

@WebServlet("/AuthServlet")
public class AuthServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        
        // Validate User
        String role = validateAndGetRole(u, p); 
        
        if (role != null) {
            // SUCCESSFUL LOGIN
            
            // Session Management
            HttpSession session = request.getSession();
            session.setAttribute("user", u);        // Keeps user logged in
            session.setAttribute("username", u);    // Used for displaying name in Sidebar
            session.setAttribute("role", role);     // Used for Security/Access Control

            // Cookie Management ("Remember Me")
            String remember = request.getParameter("remember"); 
            Cookie cookie = new Cookie("remember_user", u);     
            
            if (remember != null) {
                // Checkbox is checked: Save for 7 days
                cookie.setMaxAge(60 * 60 * 24 * 7); 
            } else {
                // Checkbox NOT checked: Delete cookie immediately
                cookie.setMaxAge(0); 
            }
            
            // Add the cookie to the response so the browser saves it
            response.addCookie(cookie);

            // Redirect to Dashboard
            response.sendRedirect("dashboard.jsp");
            
        } else {
            // FAILED LOGIN 
            response.sendRedirect("login.jsp?error=invalid");
        }
    }

    // Helper method to check credentials and get Role
    private String validateAndGetRole(String username, String password) {
        String role = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT role FROM users WHERE username=? AND password=?")) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    role = rs.getString("role"); 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
    }
}
