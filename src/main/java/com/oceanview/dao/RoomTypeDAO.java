/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.dao;

import com.oceanview.model.RoomType;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Chand
 */

public class RoomTypeDAO {

    public boolean addRoomType(RoomType room) {
        String sql = "INSERT INTO room_types (type_name, price, description, image_url, quantity) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getTypeName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getDescription());
            stmt.setString(4, room.getImageUrl());
            stmt.setInt(5, room.getQuantity()); 
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateRoomType(RoomType room) {
        String sql = "UPDATE room_types SET type_name=?, price=?, description=?, image_url=?, quantity=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getTypeName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getDescription());
            stmt.setString(4, room.getImageUrl());
            stmt.setInt(5, room.getQuantity()); 
            stmt.setInt(6, room.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean deleteRoomType(int id) {
        String sql = "DELETE FROM room_types WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<RoomType> getAllRoomTypes() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_types";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new RoomType(
                    rs.getInt("id"),
                    rs.getString("type_name"),
                    rs.getBigDecimal("price"),
                    rs.getString("description"),
                    rs.getString("image_url"),
                    rs.getInt("quantity") 
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    // Get Price for a specific room type
    public java.math.BigDecimal getRoomPrice(String typeName) {
        String sql = "SELECT price FROM room_types WHERE type_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, typeName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("price");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO; 
    }
    
    
    
    public boolean isRoomAvailable(String roomType, Date checkIn, Date checkOut) {
        int totalRooms = 0;
        int bookedRooms = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Get Total Capacity
            String sqlTotal = "SELECT quantity FROM room_types WHERE type_name = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlTotal)) {
                stmt.setString(1, roomType);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) totalRooms = rs.getInt("quantity");
            }

            // Count Overlapping Reservations
            // Logic: A room is booked if the new check-in is before an existing check-out 
            // AND the new check-out is after an existing check-in.
            String sqlCount = "SELECT COUNT(*) FROM reservations WHERE room_type = ? " +
                              "AND (check_in < ? AND check_out > ?)";
            
            try (PreparedStatement stmt = conn.prepareStatement(sqlCount)) {
                stmt.setString(1, roomType);
                stmt.setDate(2, checkOut); // Overlap Logic
                stmt.setDate(3, checkIn);  // Overlap Logic
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) bookedRooms = rs.getInt(1);
            }
            
            // Compare
            return (totalRooms - bookedRooms) > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false; 
        }
    }
}
