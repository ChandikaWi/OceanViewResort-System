/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.api;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.Reservation;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.temporal.ChronoUnit;
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

@WebServlet("/api/reservations")
public class ReservationWebService extends HttpServlet {

    private ReservationDAO resDao = new ReservationDAO();
    private RoomTypeDAO roomDao = new RoomTypeDAO();

    // GET: List all reservations
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            List<Reservation> list = resDao.getAllReservations();
            
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < list.size(); i++) {
                Reservation r = list.get(i);
                json.append("{");
                json.append("\"id\":").append(r.getId()).append(",");
                json.append("\"guestName\":\"").append(r.getGuestName()).append("\",");
                json.append("\"roomType\":\"").append(r.getRoomType()).append("\",");
                json.append("\"totalCost\":").append(r.getTotalCost());
                json.append("}");
                
                if (i < list.size() - 1) json.append(",");
            }
            json.append("]");
            out.print(json.toString());
        }
    }

    // POST: Create a new reservation 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Read parameters
            int resId = Integer.parseInt(request.getParameter("resId"));
            String name = request.getParameter("guestName");
            String email = request.getParameter("email");
            String roomType = request.getParameter("roomType");
            Date checkIn = Date.valueOf(request.getParameter("checkIn"));
            Date checkOut = Date.valueOf(request.getParameter("checkOut"));

            // Validate Availability
            if (!roomDao.isRoomAvailable(roomType, checkIn, checkOut)) {
                response.setStatus(HttpServletResponse.SC_CONFLICT); 
                out.print("{\"status\":\"error\", \"message\":\"Room not available\"}");
                return;
            }

            // Calculate Cost
            BigDecimal rate = roomDao.getRoomPrice(roomType);
            long days = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
            if(days == 0) days = 1;
            BigDecimal total = rate.multiply(new BigDecimal(days));

            // Save
            Reservation res = new Reservation(name, "N/A", "N/A", email, roomType, checkIn, checkOut, total);
            res.setId(resId);
            
            if (resDao.addReservation(res)) {
                
                String totalBillStr = "$ " + total.toString(); 
                
                new Thread(() -> com.oceanview.util.EmailService.sendBookingConfirmation(
                        email, 
                        name, 
                        resId, 
                        roomType,          
                        checkIn.toString(), 
                        checkOut.toString(), 
                        totalBillStr        
                )).start();
                
                out.print("{\"status\":\"success\", \"message\":\"Reservation Created\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"status\":\"error\", \"message\":\"Database Error\"}");
            }

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); 
            out.print("{\"status\":\"error\", \"message\":\"Invalid Data Format\"}");
        }
    }
}
