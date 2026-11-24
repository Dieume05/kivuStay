package com.kivustay.model;

import java.math.BigDecimal;

public class Hotel {

    private int hotelId;
    private int managerId;

    private String hotelName;
    private String location;
    private String description;
    private String imageUrl;

    private int rating;

    private int totalRoomTypes;
    private int totalRooms;

    private BigDecimal minimumPrice;

    public Hotel() {
    }

    public int getHotelId() {
        return hotelId;
    }

    public void setHotelId(int hotelId) {
        this.hotelId = hotelId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getHotelName() {
        return hotelName;
    }

    public void setHotelName(String hotelName) {
        this.hotelName = hotelName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public int getTotalRoomTypes() {
        return totalRoomTypes;
    }

    public void setTotalRoomTypes(int totalRoomTypes) {
        this.totalRoomTypes = totalRoomTypes;
    }

    public int getTotalRooms() {
        return totalRooms;
    }

    public void setTotalRooms(int totalRooms) {
        this.totalRooms = totalRooms;
    }

    public BigDecimal getMinimumPrice() {
        return minimumPrice;
    }

    public void setMinimumPrice(BigDecimal minimumPrice) {
        this.minimumPrice = minimumPrice;
    }
}