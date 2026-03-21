package com.hireflow.dao;

import com.hireflow.model.Application;
import com.hireflow.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    // ── Check if seeker already applied ──────────────
    public boolean hasApplied(int seekerId, int jobId)
            throws SQLException {

        String sql = """
                SELECT 1 FROM applications
                WHERE seeker_id = ? AND job_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seekerId);
            ps.setInt(2, jobId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    // ── Fetch all applications for a job (employer view) ─
    public List<Application> getByJob(int jobId)
            throws SQLException {

        String sql = """
                SELECT a.application_id, a.job_id, a.seeker_id,
                       a.resume_url, a.cover_letter, a.status,
                       a.applied_at, a.updated_at,
                       u.full_name   AS seeker_name,
                       u.email       AS seeker_email,
                       j.title       AS job_title,
                       j.location, j.job_type,
                       COALESCE(c.name, 'Unknown') AS company_name
                FROM   applications a
                JOIN   users u ON u.user_id  = a.seeker_id
                JOIN   jobs  j ON j.job_id   = a.job_id
                LEFT JOIN companies c ON c.owner_id = j.employer_id
                WHERE  a.job_id = ?
                ORDER  BY a.applied_at DESC
                """;

        List<Application> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application a = mapRow(rs);
                a.setSeekerName(rs.getString("seeker_name"));
                a.setSeekerEmail(rs.getString("seeker_email"));
                list.add(a);
            }
        }
        return list;
    }

    // ── Fetch all applications for a seeker ───────────
    public List<Application> getBySeeker(int seekerId)
            throws SQLException {

        String sql = """
                SELECT a.application_id, a.job_id, a.seeker_id,
                       a.resume_url, a.cover_letter, a.status,
                       a.applied_at, a.updated_at,
                       j.title      AS job_title,
                       j.location,
                       j.job_type,
                       COALESCE(c.name, 'Unknown Company') AS company_name
                FROM   applications a
                JOIN   jobs      j ON j.job_id      = a.job_id
                LEFT JOIN companies c ON c.owner_id = j.employer_id
                WHERE  a.seeker_id = ?
                ORDER  BY a.applied_at DESC
                """;

        List<Application> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, seekerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    // ── Insert a new application ──────────────────────
    public boolean insert(Application app) throws SQLException {

        // Prevent duplicate applications
        String checkSql = """
                SELECT 1 FROM applications
                WHERE job_id = ? AND seeker_id = ?
                """;

        String insertSql = """
                INSERT INTO applications
                    (job_id, seeker_id, resume_url, cover_letter, status)
                VALUES (?, ?, ?, ?, 'applied')
                """;

        try (Connection conn = DBConnection.getConnection()) {

            // Check duplicate
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, app.getJobId());
                ps.setInt(2, app.getSeekerId());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) return false; // already applied
            }

            // Insert
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, app.getJobId());
                ps.setInt(2, app.getSeekerId());
                ps.setString(3, app.getResumeUrl());
                ps.setString(4, app.getCoverLetter());
                return ps.executeUpdate() > 0;
            }
        }
    }

    // ── Update application status (employer action) ───
    public boolean updateStatus(int applicationId, String status)
            throws SQLException {

        String sql = """
                UPDATE applications
                SET    status = ?, updated_at = NOW()
                WHERE  application_id = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, applicationId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Count applications per status for a seeker ───
    public int countByStatus(int seekerId, String status)
            throws SQLException {

        String sql = """
                SELECT COUNT(*) FROM applications
                WHERE seeker_id = ? AND status = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, seekerId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ── ResultSet → Application POJO ─────────────────
    private Application mapRow(ResultSet rs) throws SQLException {
        Application a = new Application();
        a.setApplicationId(rs.getInt("application_id"));
        a.setJobId(rs.getInt("job_id"));
        a.setSeekerId(rs.getInt("seeker_id"));
        a.setResumeUrl(rs.getString("resume_url"));
        a.setCoverLetter(rs.getString("cover_letter"));
        a.setStatus(rs.getString("status"));
        a.setJobTitle(rs.getString("job_title"));
        a.setCompanyName(rs.getString("company_name"));
        a.setLocation(rs.getString("location"));
        a.setJobType(rs.getString("job_type"));

        Timestamp appliedAt = rs.getTimestamp("applied_at");
        if (appliedAt != null)
            a.setAppliedAt(appliedAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null)
            a.setUpdatedAt(updatedAt.toLocalDateTime());

        return a;
    }
    // ── ADD TO ApplicationDAO.java ────────────────────────────────────────────

    // Count all applications platform-wide
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM applications";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
