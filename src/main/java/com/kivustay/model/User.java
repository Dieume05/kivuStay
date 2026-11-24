package com.kivustay.model;

public class User {

    private int userId;
    private String fullName;
    private String email;
    private String role;

    // Empty constructor
    public User() {
    }

    // Constructor with parameters
    public User(int userId, String fullName,
                String email, String role) {

        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.role = role;
    }

    // Getters and Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}