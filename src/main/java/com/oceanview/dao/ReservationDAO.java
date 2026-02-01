/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.dao;

/**
 *
 * @author Chand
 */

import com.oceanview.model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public boolean addReservation(Reservation res) {
    String sql = "INSERT INTO reservations (res_id, guest_name, address, contact_number, room_type, check_in, check_out, total_cost) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        stmt.setInt(1, res.getId()); 
        stmt.setString(2, res.getGuestName());
        stmt.setString(3, res.getAddress());
        stmt.setString(4, res.getContactNumber());
        stmt.setString(5, res.getRoomType());
        stmt.setDate(6, res.getCheckIn());
        stmt.setDate(7, res.getCheckOut());
        stmt.setBigDecimal(8, res.getTotalCost());
        
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations ORDER BY res_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Reservation res = new Reservation();
                res.setId(rs.getInt("res_id"));
                res.setGuestName(rs.getString("guest_name"));
                res.setAddress(rs.getString("address"));
                res.setContactNumber(rs.getString("contact_number"));
                res.setRoomType(rs.getString("room_type"));
                res.setCheckIn(rs.getDate("check_in"));
                res.setCheckOut(rs.getDate("check_out"));
                res.setTotalCost(rs.getBigDecimal("total_cost"));
                list.add(res);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
