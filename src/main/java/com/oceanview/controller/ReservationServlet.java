/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.Reservation;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Chand
 */

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO;

    public void init() {
        reservationDAO = new ReservationDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addReservation(request, response);
        }
        else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if(reservationDAO.deleteReservation(id)) {
                response.sendRedirect("reservations.jsp?success=deleted");
            } else {
                response.sendRedirect("reservations.jsp?error=delete_failed");
            }
        }
    }

    private void addReservation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        try {
            int resId = Integer.parseInt(request.getParameter("resId"));
            String name = request.getParameter("guestName");
            String address = request.getParameter("address");
            String contact = request.getParameter("contact");
            String email = request.getParameter("email");
            String roomType = request.getParameter("roomType");
            Date checkIn = Date.valueOf(request.getParameter("checkIn"));
            Date checkOut = Date.valueOf(request.getParameter("checkOut"));

            RoomTypeDAO roomDao = new RoomTypeDAO();

            if (!roomDao.isRoomAvailable(roomType, checkIn, checkOut)) {
                response.sendRedirect("dashboard.jsp?error=no_rooms");
                return; 
            }
            
            long days = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
            if (days == 0) days = 1; 
            
            BigDecimal rate = roomDao.getRoomPrice(roomType);
            
            BigDecimal totalCost = rate.multiply(new BigDecimal(days));

            Reservation res = new Reservation(name, address, contact, email, roomType, checkIn, checkOut, totalCost);
            res.setId(resId);
            
            if (reservationDAO.addReservation(res)) {
                new Thread(() -> {
                    com.oceanview.util.EmailService.sendBookingConfirmation(
                        email, name, resId, checkIn.toString(), checkOut.toString()
                    );
                }).start();

                response.sendRedirect("dashboard.jsp?success=true");
            } else {
                response.sendRedirect("dashboard.jsp?error=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=invalid_data");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    }
}
