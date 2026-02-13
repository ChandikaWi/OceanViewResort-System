/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.oceanview.model;

import java.math.BigDecimal;

/**
 *
 * @author Chand
 */

public class RoomType {
    private int id;
    private String typeName;
    private BigDecimal price;
    private String description;
    private String imageUrl;
    private int quantity;

    public RoomType() {}

    public RoomType(int id, String typeName, BigDecimal price, String description, String imageUrl, int quantity) {
        this.id = id;
        this.typeName = typeName;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
        this.quantity = quantity; 
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
