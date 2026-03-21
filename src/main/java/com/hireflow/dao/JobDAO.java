package com.hireflow.dao;

import com.hireflow.model.Job;
import com.hireflow.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JobDAO {

    // ── Search jobs with filters ──────────────────────
    public List<Job> searchJobs(String keyword,
                                String location,
                                int categoryId,
                                int page,
                                int pageSize)
            throws SQLException {

        StringBuilder sql = new StringBuilder(
                "SELECT j.*, u.full_name AS company_name, " +
                        "       c.name AS category_name " +
                        "FROM jobs j " +
                        "JOIN users u ON j.employer_id = u.user_id " +
                        "LEFT JOIN categories c " +
                        "       ON j.category_id = c.category_id " +
                        "WHERE j.status = 'active' "
        );

        // Full-text search on title + description
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(
                    "AND to_tsvector('english', j.title || ' ' " +
                            "|| j.description) " +
                            "@@ plainto_tsquery('english', ?) ");
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND LOWER(j.location) = LOWER(?) ");
        }

        if (categoryId > 0) {
            sql.append("AND j.category_id = ? ");
        }

        sql.append(
                "ORDER BY j.is_featured DESC, j.posted_at DESC " +
                        "LIMIT ? OFFSET ?"
        );

        List<Job> jobs = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps =
                     conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty())
                ps.setString(idx++, keyword.trim());
            if (location != null && !location.trim().isEmpty())
                ps.setString(idx++, location.trim());
            if (categoryId > 0)
                ps.setInt(idx++, categoryId);

            ps.setInt(idx++, pageSize);
            ps.setInt(idx,   (page - 1) * pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) jobs.add(mapRow(rs));
        }

        return jobs;
    }

    // ── Get featured jobs for homepage ────────────────
    public List<Job> getFeaturedJobs(int limit)
            throws SQLException {
        String sql =
                "SELECT j.*, u.full_name AS company_name, " +
                        "       c.name AS category_name " +
                        "FROM jobs j " +
                        "JOIN users u ON j.employer_id = u.user_id " +
                        "LEFT JOIN categories c " +
                        "       ON j.category_id = c.category_id " +
                        "WHERE j.status = 'active' " +
                        "ORDER BY j.is_featured DESC, j.posted_at DESC " +
                        "LIMIT ?";

        List<Job> jobs = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) jobs.add(mapRow(rs));
        }
        return jobs;
    }

    // ── Get single job by ID ──────────────────────────
    public Job getJobById(int jobId) throws SQLException {
        String sql =
                "SELECT j.*, u.full_name AS company_name, " +
                        "       c.name AS category_name " +
                        "FROM jobs j " +
                        "JOIN users u ON j.employer_id = u.user_id " +
                        "LEFT JOIN categories c " +
                        "       ON j.category_id = c.category_id " +
                        "WHERE j.job_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    // ── Get jobs by employer ──────────────────────────
    public List<Job> getJobsByEmployer(int employerId)
            throws SQLException {
        String sql =
                "SELECT j.*, u.full_name AS company_name, " +
                        "       c.name AS category_name " +
                        "FROM jobs j " +
                        "JOIN users u ON j.employer_id = u.user_id " +
                        "LEFT JOIN categories c " +
                        "       ON j.category_id = c.category_id " +
                        "WHERE j.employer_id = ? " +
                        "ORDER BY j.posted_at DESC";

        List<Job> jobs = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) jobs.add(mapRow(rs));
        }
        return jobs;
    }

    // ── Count total active jobs ───────────────────────
    public int countActiveJobs() throws SQLException {
        String sql = "SELECT COUNT(*) FROM jobs " +
                "WHERE status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // ── Insert new job ────────────────────────────────
    public boolean insertJob(Job job) throws SQLException {
        String sql =
                "INSERT INTO jobs (employer_id, category_id, title, " +
                        "description, location, job_type, salary_min, " +
                        "salary_max, status) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, job.getEmployerId());
            ps.setInt(2, job.getCategoryId());
            ps.setString(3, job.getTitle());
            ps.setString(4, job.getDescription());
            ps.setString(5, job.getLocation());
            ps.setString(6, job.getJobType());
            ps.setBigDecimal(7, job.getSalaryMin());
            ps.setBigDecimal(8, job.getSalaryMax());
            return ps.executeUpdate() == 1;
        }
    }

    // ── Map ResultSet → Job POJO ──────────────────────
    private Job mapRow(ResultSet rs) throws SQLException {
        Job j = new Job();
        j.setJobId(rs.getInt("job_id"));
        j.setEmployerId(rs.getInt("employer_id"));
        j.setCategoryId(rs.getInt("category_id"));
        j.setTitle(rs.getString("title"));
        j.setDescription(rs.getString("description"));
        j.setLocation(rs.getString("location"));
        j.setJobType(rs.getString("job_type"));
        j.setSalaryMin(rs.getBigDecimal("salary_min"));
        j.setSalaryMax(rs.getBigDecimal("salary_max"));
        j.setStatus(rs.getString("status"));
        j.setFeatured(rs.getBoolean("is_featured"));
        j.setApplicationCount(rs.getInt("application_count"));
        j.setCompanyName(rs.getString("company_name"));
        j.setCategoryName(rs.getString("category_name"));
// Map PostgreSQL TEXT[] → Java String[]
        try {
            java.sql.Array skillsArr = rs.getArray("skills");
            if (skillsArr != null) {
                j.setSkills((String[]) skillsArr.getArray());
            }
        } catch (Exception ignored) {
            // skills column missing or null — safe to skip
        }

        Timestamp posted = rs.getTimestamp("posted_at");
        if (posted != null)
            j.setPostedAt(posted.toLocalDateTime());

        Timestamp expires = rs.getTimestamp("expires_at");
        if (expires != null)
            j.setExpiresAt(expires.toLocalDateTime());

        return j;
    }

    // ── Delete job (employer can only delete own jobs) ─
    public boolean deleteJob(int jobId, int employerId)
            throws SQLException {
        String sql = "DELETE FROM jobs " +
                "WHERE job_id = ? AND employer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, jobId);
            ps.setInt(2, employerId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── Update job status (admin approval workflow) ───
    public boolean updateJobStatus(int jobId, String status)
            throws SQLException {
        String sql = "UPDATE jobs SET status = ? WHERE job_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, jobId);
            return ps.executeUpdate() > 0;
        }
    }

    // ── ADD TO JobDAO.java ────────────────────────────────────────────────────

    // Count all jobs regardless of status
    public int countAllJobs() throws SQLException {
        String sql = "SELECT COUNT(*) FROM jobs";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // Get jobs by status (e.g. "pending", "active", "expired")
    public List<Job> getByStatus(String status) throws SQLException {
        String sql =
                "SELECT j.*, u.full_name AS company_name, " +
                        "       c.name AS category_name " +
                        "FROM jobs j " +
                        "JOIN users u ON j.employer_id = u.user_id " +
                        "LEFT JOIN categories c ON j.category_id = c.category_id " +
                        "WHERE j.status = ? " +
                        "ORDER BY j.posted_at DESC";

        List<Job> jobs = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) jobs.add(mapRow(rs));
        }
        return jobs;
    }

    // Auto-expire jobs past their expires_at date
    public int expireOldJobs() throws SQLException {
        String sql =
                "UPDATE jobs SET status = 'expired' " +
                        "WHERE status = 'active' " +
                        "AND expires_at IS NOT NULL " +
                        "AND expires_at < NOW()";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate();
        }
    }


}