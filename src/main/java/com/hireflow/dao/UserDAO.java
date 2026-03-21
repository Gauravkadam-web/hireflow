package com.hireflow.dao;

import com.hireflow.model.User;
import com.hireflow.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ── INSERT new user ───────────────────────────────
    public boolean insertUser(User user) throws SQLException {
        String sql = "INSERT INTO users " +
                "(email, password_hash, role, full_name, phone) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhone());

            return ps.executeUpdate() == 1;
        }
    }

    // ── FIND user by email (used on login) ────────────
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users " +
                "WHERE email = ? AND is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
            return null; // not found
        }
    }

    // ── FIND user by ID (used for session restore) ────
    public User findById(int userId) throws SQLException {
        String sql = "SELECT * FROM users " +
                "WHERE user_id = ? AND is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        }
    }

    // ── CHECK if email already exists ─────────────────
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    // ── MAP ResultSet row → User POJO ─────────────────
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setActive(rs.getBoolean("is_active"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
        return u;
    }


// ── ADD TO UserDAO.java ───────────────────────────────────────────────────

    // Count all users
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Get all users ordered by join date
    public List<User> getAll() throws SQLException {
        String sql =
                "SELECT user_id, full_name, email, role, " +
                        "       is_active, created_at " +
                        "FROM users ORDER BY created_at DESC";

        List<User> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setActive(rs.getBoolean("is_active"));
                Timestamp t = rs.getTimestamp("created_at");
                if (t != null) u.setCreatedAt(t.toLocalDateTime());
                list.add(u);
            }
        }
        return list;
    }

}