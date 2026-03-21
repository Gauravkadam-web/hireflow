package com.hireflow.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Job {

    private static final DateTimeFormatter FMT =
            DateTimeFormatter.ofPattern("dd MMM yyyy");

    private int          jobId;
    private int          employerId;
    private int          categoryId;
    private String       title;
    private String       description;
    private String       location;
    private String       jobType;
    private BigDecimal   salaryMin;
    private BigDecimal   salaryMax;
    private String       status;
    private boolean      isFeatured;
    private int          applicationCount;
    private LocalDateTime postedAt;
    private LocalDateTime expiresAt;

    // Extra fields joined from other tables
    private String       companyName;
    private String       categoryName;

    private String[] skills;
    // ── Constructors ──────────────────────────────────
    public Job() {}

    // ── Getters & Setters ─────────────────────────────
    public int    getJobId()                   { return jobId; }
    public void   setJobId(int jobId)          { this.jobId = jobId; }

    public int    getEmployerId()              { return employerId; }
    public void   setEmployerId(int id)        { this.employerId = id; }

    public int    getCategoryId()              { return categoryId; }
    public void   setCategoryId(int id)        { this.categoryId = id; }

    public String getTitle()                   { return title; }
    public void   setTitle(String title)       { this.title = title; }

    public String getDescription()             { return description; }
    public void   setDescription(String d)     { this.description = d; }

    public String getLocation()                { return location; }
    public void   setLocation(String loc)      { this.location = loc; }

    public String getJobType()                 { return jobType; }
    public void   setJobType(String type)      { this.jobType = type; }

    public BigDecimal getSalaryMin()           { return salaryMin; }
    public void setSalaryMin(BigDecimal s)     { this.salaryMin = s; }

    public BigDecimal getSalaryMax()           { return salaryMax; }
    public void setSalaryMax(BigDecimal s)     { this.salaryMax = s; }

    public String getStatus()                  { return status; }
    public void   setStatus(String status)     { this.status = status; }

    public boolean isFeatured()                { return isFeatured; }
    public void    setFeatured(boolean f)      { this.isFeatured = f; }

    public int  getApplicationCount()          { return applicationCount; }
    public void setApplicationCount(int c)     { this.applicationCount = c; }

    public LocalDateTime getPostedAt()         { return postedAt; }
    public void setPostedAt(LocalDateTime t)   { this.postedAt = t; }

    public LocalDateTime getExpiresAt()        { return expiresAt; }
    public void setExpiresAt(LocalDateTime t)  { this.expiresAt = t; }

    public String getCompanyName()             { return companyName; }
    public void setCompanyName(String n)       { this.companyName = n; }

    public String getCategoryName()            { return categoryName; }
    public void setCategoryName(String n)      { this.categoryName = n; }

    public String[] getSkills()            { return skills; }
    public void     setSkills(String[] s)  { this.skills = s; }
    // ── Helpers ───────────────────────────────────────
    public String getSalaryRange() {
        if (salaryMin == null && salaryMax == null) return "Not disclosed";
        if (salaryMin == null) return "Up to ₹" + salaryMax + " LPA";
        if (salaryMax == null) return "₹" + salaryMin + "+ LPA";
        return "₹" + salaryMin + "–" + salaryMax + " LPA";
    }

    public boolean isActive() {
        return "active".equals(status);
    }

    public String getPostedAtFormatted() {
        return postedAt != null ? postedAt.format(FMT) : "—";
    }

    public String getExpiresAtFormatted() {
        return expiresAt != null ? expiresAt.format(FMT) : "—";
    }

    public String getCompanyInitial() {
        if (companyName == null || companyName.isEmpty()) return "?";
        return String.valueOf(companyName.charAt(0)).toUpperCase();
    }
}
