package com.hireflow.model;

import java.time.LocalDateTime;

public class Application {

    private int           applicationId;
    private int           jobId;
    private int           seekerId;
    private String        resumeUrl;
    private String        coverLetter;
    private String        status; // applied, reviewed, hired, rejected
    private LocalDateTime appliedAt;
    private LocalDateTime updatedAt;

    // Joined fields from jobs / companies
    private String        jobTitle;
    private String        companyName;
    private String        location;
    private String        jobType;

    // Joined fields for employer view
    private String        seekerName;
    private String        seekerEmail;

    // ── Constructors ──────────────────────────────────
    public Application() {}

    // ── Getters & Setters ─────────────────────────────
    public int    getApplicationId()              { return applicationId; }
    public void   setApplicationId(int id)        { this.applicationId = id; }

    public int    getJobId()                      { return jobId; }
    public void   setJobId(int jobId)             { this.jobId = jobId; }

    public int    getSeekerId()                   { return seekerId; }
    public void   setSeekerId(int seekerId)       { this.seekerId = seekerId; }

    public String getResumeUrl()                  { return resumeUrl; }
    public void   setResumeUrl(String url)        { this.resumeUrl = url; }

    public String getCoverLetter()                { return coverLetter; }
    public void   setCoverLetter(String cl)       { this.coverLetter = cl; }

    public String getStatus()                     { return status; }
    public void   setStatus(String status)        { this.status = status; }

    public LocalDateTime getAppliedAt()           { return appliedAt; }
    public void setAppliedAt(LocalDateTime t)     { this.appliedAt = t; }

    public LocalDateTime getUpdatedAt()           { return updatedAt; }
    public void setUpdatedAt(LocalDateTime t)     { this.updatedAt = t; }

    public String getJobTitle()                   { return jobTitle; }
    public void   setJobTitle(String t)           { this.jobTitle = t; }

    public String getCompanyName()                { return companyName; }
    public void   setCompanyName(String n)        { this.companyName = n; }

    public String getLocation()                   { return location; }
    public void   setLocation(String loc)         { this.location = loc; }

    public String getJobType()                    { return jobType; }
    public void   setJobType(String type)         { this.jobType = type; }

    public String getSeekerName()                 { return seekerName; }
    public void   setSeekerName(String n)         { this.seekerName = n; }

    public String getSeekerEmail()                { return seekerEmail; }
    public void   setSeekerEmail(String e)        { this.seekerEmail = e; }

    // ── Helpers ───────────────────────────────────────
    public String getCompanyInitial() {
        if (companyName == null || companyName.isEmpty()) return "?";
        return String.valueOf(companyName.charAt(0)).toUpperCase();
    }

    public String getSeekerInitial() {
        if (seekerName == null || seekerName.isEmpty()) return "?";
        return String.valueOf(seekerName.charAt(0)).toUpperCase();
    }

    public String getAppliedAtFormatted() {
        if (appliedAt == null) return "—";
        return appliedAt.format(
                java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy"));
    }

    public String getStatusBadgeClass() {
        return switch (status == null ? "" : status) {
            case "hired"    -> "badge-hired";
            case "reviewed" -> "badge-reviewed";
            case "rejected" -> "badge-rejected";
            default         -> "badge-applied";
        };
    }
}
