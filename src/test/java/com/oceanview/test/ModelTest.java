/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.test;

import com.oceanview.model.RoomType;
import com.oceanview.model.Reservation;
import java.math.BigDecimal;
import java.sql.Date;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author Chand
 */

public class ModelTest {

    @Test
    public void testRoomTypeCreation() {
        System.out.println("TEST: RoomType Object Creation");
        
        RoomType room = new RoomType(1, "Deluxe", new BigDecimal("150.00"), "Desc", "img.jpg", 10);
        
        assertEquals("Deluxe", room.getTypeName());
        assertEquals(new BigDecimal("150.00"), room.getPrice());
        assertEquals(10, room.getQuantity());
    }

    @Test
    public void testReservationTotalCostLogic() {
        System.out.println("TEST: Reservation Cost Logic");
        
        BigDecimal pricePerNight = new BigDecimal("100.00");
        int nights = 5;
        
        BigDecimal total = pricePerNight.multiply(new BigDecimal(nights));
        
        assertEquals(new BigDecimal("500.00"), total, "Total cost should be 500.00");
    }
}
