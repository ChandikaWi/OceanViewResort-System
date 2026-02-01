/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.model;

/**
 *
 * @author Chand
 */

import java.math.BigDecimal;
import java.sql.Date;

public class Reservation {
    private int id;
    private String guestName;
    private String address;
    private String contactNumber;
    private String roomType;
    private Date checkIn;
    private Date checkOut;
    private BigDecimal totalCost;

    public Reservation() {}

    public Reservation(String guestName, String address, String contactNumber, String roomType, Date checkIn, Date checkOut, BigDecimal totalCost) {
        this.guestName = guestName;
        this.address = address;
        this.contactNumber = contactNumber;
        this.roomType = roomType;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.totalCost = totalCost;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }
    public Date getCheckIn() { return checkIn; }
    public void setCheckIn(Date checkIn) { this.checkIn = checkIn; }
    public Date getCheckOut() { return checkOut; }
    public void setCheckOut(Date checkOut) { this.checkOut = checkOut; }
    public BigDecimal getTotalCost() { return totalCost; }
    public void setTotalCost(BigDecimal totalCost) { this.totalCost = totalCost; }
}
