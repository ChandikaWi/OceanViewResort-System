/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.oceanview.controller;

import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.RoomType;
import java.io.IOException;
import java.math.BigDecimal;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chand
 */

@WebServlet("/RoomServlet")
public class RoomServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        RoomTypeDAO dao = new RoomTypeDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("typeName");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                String desc = request.getParameter("description");
                String img = request.getParameter("imageUrl");
                
                RoomType room = new RoomType(0, name, price, desc, img);
                dao.addRoomType(room);
                response.sendRedirect("manage_rooms.jsp?success=added");
            } 
            else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("typeName");
                BigDecimal price = new BigDecimal(request.getParameter("price"));
                String desc = request.getParameter("description");
                String img = request.getParameter("imageUrl");

                RoomType room = new RoomType(id, name, price, desc, img);
                dao.updateRoomType(room);
                response.sendRedirect("manage_rooms.jsp?success=updated");
            } 
            else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteRoomType(id);
                response.sendRedirect("manage_rooms.jsp?success=deleted");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manage_rooms.jsp?error=fail");
        }
    }
}
