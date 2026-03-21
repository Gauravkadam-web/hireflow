package com.hireflow.model;

import java.time.LocalDateTime;

public class User {

    private int       userId;
    private String    email;
    private String    passwordHash;
    private String    role;
    private String    fullName;
    private String    phone;
    private LocalDateTime createdAt;
    private boolean   isActive;

    // ── Constructors ──────────────────────────────────

    public User() {}

    public User(String email, String passwordHash,
                String role, String fullName) {
        this.email        = email;
        this.passwordHash = passwordHash;
        this.role         = role;
        this.fullName     = fullName;
    }

    // ── Getters & Setters ─────────────────────────────

    public int getUserId()               { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public String getEmail()             { return email; }
    public void setEmail(String email)   { this.email = email; }

    public String getPasswordHash()      { return passwordHash; }
    public void setPasswordHash(String h){ this.passwordHash = h; }

    public String getRole()              { return role; }
    public void setRole(String role)     { this.role = role; }

    public String getFullName()          { return fullName; }
    public void setFullName(String n)    { this.fullName = n; }

    public String getPhone()             { return phone; }
    public void setPhone(String phone)   { this.phone = phone; }

    public LocalDateTime getCreatedAt()          { return createdAt; }
    public void setCreatedAt(LocalDateTime t)    { this.createdAt = t; }

    public boolean isActive()                    { return isActive; }
    public void setActive(boolean active)        { this.isActive = active; }

    // ── Helper ────────────────────────────────────────

    public boolean isAdmin()    { return "admin".equals(role); }
    public boolean isEmployer() { return "employer".equals(role); }
    public boolean isSeeker()   { return "seeker".equals(role); }

    // ── ADD TO User.java helpers section ─────────────────

    public String getCreatedAtFormatted() {
        if (createdAt == null) return "—";
        return createdAt.format(
                java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }

    public String getRoleInitial() {
        if (role == null) return "?";
        return String.valueOf(role.charAt(0)).toUpperCase();
    }


    @Override
    public String toString() {
        return "User{id=" + userId + ", email=" + email
                + ", role=" + role + "}";
    }
}