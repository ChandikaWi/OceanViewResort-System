/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.api;

import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.RoomType;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chand
 */

@WebServlet("/api/rooms")
public class RoomWebService extends HttpServlet {

    private RoomTypeDAO roomDao = new RoomTypeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            List<RoomType> rooms = roomDao.getAllRoomTypes();
            
            // Build JSON manually
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < rooms.size(); i++) {
                RoomType r = rooms.get(i);
                json.append(String.format(
                    "{\"id\":%d, \"name\":\"%s\", \"price\":%.2f, \"quantity\":%d}", 
                    r.getId(), r.getTypeName(), r.getPrice(), r.getQuantity()
                ));
                if (i < rooms.size() - 1) json.append(",");
            }
            json.append("]");
            
            out.print(json.toString());
        }
    }
}
