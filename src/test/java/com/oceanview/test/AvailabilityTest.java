/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.test;

import com.oceanview.dao.RoomTypeDAO;
import java.sql.Date;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Chand
 */

public class AvailabilityTest {
    
    
    @Test
    public void testRoomAvailabilityCheck() {
        System.out.println("TEST: Room Availability Check (Integration)");
        
        RoomTypeDAO dao = new RoomTypeDAO();
        
        String type = "Luxury Suite";
        Date checkIn = Date.valueOf("2028-01-01");
        Date checkOut = Date.valueOf("2028-01-05");
        
        boolean isAvailable = dao.isRoomAvailable(type, checkIn, checkOut);
        
        assertTrue(isAvailable, "Luxury Suite should be available in 2028");
    }
    
    @Test
    public void testInvalidRoomType() {
        System.out.println("TEST: Invalid Room Type Check");
        
        RoomTypeDAO dao = new RoomTypeDAO();
        boolean result = dao.isRoomAvailable("NonExistentRoom", Date.valueOf("2026-01-01"), Date.valueOf("2026-01-05"));
        
        assertFalse(result, "Non-existent room should not be available");
    }
}
