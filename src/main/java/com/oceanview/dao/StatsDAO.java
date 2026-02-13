/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.dao;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Chand
 */

public class StatsDAO {

    // Get Total Revenue 
    public double getTotalRevenue() {
        String sql = "SELECT SUM(GREATEST(DATEDIFF(r.check_out, r.check_in), 1) * rt.price) " +
                     "FROM reservations r " +
                     "JOIN room_types rt ON r.room_type = rt.type_name";
                     
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    // Get Count of Each Room Type
    public Map<String, Integer> getRoomTypeDistribution() {
        Map<String, Integer> data = new HashMap<>();
        String sql = "SELECT room_type, COUNT(*) FROM reservations GROUP BY room_type";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                data.put(rs.getString(1), rs.getInt(2));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return data;
    }

    // Get Revenue by Month
    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> data = new HashMap<>();
        String sql = "SELECT MONTHNAME(r.check_in), " +
                     "SUM(GREATEST(DATEDIFF(r.check_out, r.check_in), 1) * rt.price) " +
                     "FROM reservations r " +
                     "JOIN room_types rt ON r.room_type = rt.type_name " +
                     "GROUP BY MONTHNAME(r.check_in) " +
                     "ORDER BY MIN(r.check_in)";
                     
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                data.put(rs.getString(1), rs.getDouble(2));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return data;
    }

    // Operational Counts
    public int getTodaysCheckIns() {
        return getCount("SELECT COUNT(*) FROM reservations WHERE check_in = CURRENT_DATE()");
    }
    
    public int getTodaysCheckOuts() {
        return getCount("SELECT COUNT(*) FROM reservations WHERE check_out = CURRENT_DATE()");
    }
    
    public int getTotalActiveReservations() {
        return getCount("SELECT COUNT(*) FROM reservations WHERE check_out >= CURRENT_DATE()");
    }


    public int getTotalBookings() {
        return getCount("SELECT COUNT(*) FROM reservations");
    }

    // Helper method
    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}

