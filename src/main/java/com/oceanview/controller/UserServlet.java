/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chand
 */

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("add".equals(action)) {
            String u = request.getParameter("username");
            String p = request.getParameter("password");
            String r = request.getParameter("role");
            if(dao.addUser(u, p, r)) {
                response.sendRedirect("manage_staff.jsp?success=added");
            } else {
                response.sendRedirect("manage_staff.jsp?error=fail");
            }
        } 
        else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if(dao.deleteUser(id)) {
                response.sendRedirect("manage_staff.jsp?success=deleted");
            } else {
                response.sendRedirect("manage_staff.jsp?error=fail");
            }
        }
        else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String u = request.getParameter("username");
            String p = request.getParameter("password");
            String r = request.getParameter("role");
            
            User user = new User(id, u, p, r);
            
            if(dao.updateUser(user)) {
                response.sendRedirect("manage_staff.jsp?success=updated");
            } else {
                response.sendRedirect("manage_staff.jsp?error=fail");
            }
        }
    }
}