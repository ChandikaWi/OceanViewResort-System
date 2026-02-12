/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.test;

import com.oceanview.model.RoomType;
import com.oceanview.model.User;
import java.math.BigDecimal;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Chand
 */

public class LogicTests {

    @Test
    public void testRoomTypeModel() {
        System.out.println("Running TC_01: RoomType Model...");
        RoomType r = new RoomType(1, "Test Suite", new BigDecimal("200.00"), "Desc", "img.jpg", 5);
        
        assertEquals("Test Suite", r.getTypeName());
        assertEquals(5, r.getQuantity());
    }

    @Test
    public void testCostCalculation() {
        System.out.println("Running TC_02: Cost Calculation...");
        BigDecimal price = new BigDecimal("100.00");
        BigDecimal nights = new BigDecimal("5");
        
        BigDecimal total = price.multiply(nights);
        
        assertEquals(new BigDecimal("500.00"), total, "Math logic failed");
    }

    @Test
    public void testUserModel() {
        System.out.println("Running TC_03: User Logic...");
        User u = new User(1, "admin", "pass123", "ADMIN");
        
        assertEquals("ADMIN", u.getRole(), "Role storage failed");
        assertNotEquals("STAFF", u.getRole(), "User should not be STAFF");
    }
}
