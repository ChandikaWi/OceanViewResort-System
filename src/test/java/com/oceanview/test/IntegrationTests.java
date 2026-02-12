/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.test;

import com.oceanview.dao.DBConnection;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.dao.StatsDAO;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Chand
 */

public class IntegrationTests {

    @Test
    public void testDBConnection() throws SQLException {
        System.out.println("Running TC_04: DB Connection...");
        Connection conn = DBConnection.getConnection();
        assertNotNull(conn, "Database connection failed! Is MySQL running?");
    }

    @Test
    public void testRoomAvailability() {
        System.out.println("Running TC_05: Availability Check...");
        RoomTypeDAO dao = new RoomTypeDAO();
        
        Date checkIn = Date.valueOf("2099-01-01");
        Date checkOut = Date.valueOf("2099-01-05");
        
        boolean result = dao.isRoomAvailable("Luxury Suite", checkIn, checkOut);
        
        assertTrue(result, "Luxury Suite should be available in 2099");
    }

    @Test
    public void testGetRoomPrice() {
        System.out.println("Running TC_06: Price Lookup...");
        RoomTypeDAO dao = new RoomTypeDAO();
        
        BigDecimal price = dao.getRoomPrice("Luxury Suite");
        
        assertNotNull(price);
        assertTrue(price.doubleValue() > 0, "Price should be greater than 0");
    }

    @Test
    public void testStatsRevenue() {
        System.out.println("Running TC_07: Stats Revenue...");
        StatsDAO stats = new StatsDAO();
        
        double revenue = stats.getTotalRevenue();
        
        assertTrue(revenue >= 0.0, "Revenue calculation crashed or returned negative");
    }
}
