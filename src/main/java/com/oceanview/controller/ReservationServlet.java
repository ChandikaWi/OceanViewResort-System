/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
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
    }

    private void addReservation(HttpServletRequest request, HttpServletResponse response) 
        throws IOException, ServletException {
    try {
        int resId = Integer.parseInt(request.getParameter("resId"));
        
        String name = request.getParameter("guestName");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String roomType = request.getParameter("roomType");
        Date checkIn = Date.valueOf(request.getParameter("checkIn"));
        Date checkOut = Date.valueOf(request.getParameter("checkOut"));

        long days = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
        BigDecimal rate = "Suite".equals(roomType) ? new BigDecimal("150.00") : new BigDecimal("100.00");
        BigDecimal totalCost = rate.multiply(new BigDecimal(days));

        Reservation res = new Reservation(name, address, contact, roomType, checkIn, checkOut, totalCost);
        res.setId(resId); 
        
        if (reservationDAO.addReservation(res)) {
            response.sendRedirect("dashboard.jsp?success=true");
        } else {
            response.sendRedirect("dashboard.jsp?error=true");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("dashboard.jsp?error=duplicate_or_invalid");
    }
}
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    }
}
