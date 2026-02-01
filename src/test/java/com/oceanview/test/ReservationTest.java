/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.test;

/**
 *
 * @author Chand
 */

import com.oceanview.model.Reservation;
import java.math.BigDecimal;
import java.sql.Date;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ReservationTest {

    @Test
    public void testReservationModel() {
        Reservation res = new Reservation();
        res.setGuestName("John Doe");
        res.setTotalCost(new BigDecimal("200.00"));
        
        assertEquals("John Doe", res.getGuestName());
        assertEquals(new BigDecimal("200.00"), res.getTotalCost());
    }
}
