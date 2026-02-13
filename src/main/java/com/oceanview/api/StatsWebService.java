/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.api;

import com.oceanview.dao.StatsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chand
 */

@WebServlet("/api/stats")
public class StatsWebService extends HttpServlet {

    private StatsDAO statsDao = new StatsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            double revenue = statsDao.getTotalRevenue();
            int bookings = statsDao.getTotalBookings();
            
            // Return JSON object
            String json = String.format(
                "{\"revenue\": %.2f, \"total_bookings\": %d, \"company\": \"Ocean View Resort\"}", 
                revenue, bookings
            );
            
            out.print(json);
        }
    }
}
