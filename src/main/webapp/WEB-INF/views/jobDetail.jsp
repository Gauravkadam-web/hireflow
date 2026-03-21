<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title><c:out value="${job.title}"/> — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Instrument+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
:root{
  --navy:#080c14;--navy-2:#0d1422;--navy-3:#111827;--navy-4:#1a2236;
  --teal:#00d4aa;--teal-glow:rgba(0,212,170,0.15);--teal-glow-2:rgba(0,212,170,0.06);
  --text:#f0f4ff;--text-2:#94a3b8;--text-3:#4a5568;
  --border:rgba(255,255,255,0.07);--border-bright:rgba(0,212,170,0.3);
  --glass:rgba(255,255,255,0.03);--glass-2:rgba(255,255,255,0.06);
  --radius:14px;
}
html{scroll-behavior:smooth;}
body{font-family:'Instrument Sans',sans-serif;background:var(--navy);color:var(--text);min-height:100vh;overflow-x:hidden;}
body::before{content:'';position:fixed;inset:0;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");pointer-events:none;z-index:0;opacity:0.4;}
.bg-orb{position:fixed;border-radius:50%;filter:blur(120px);pointer-events:none;z-index:0;}
.orb-1{width:500px;height:500px;background:radial-gradient(circle,rgba(0,212,170,0.08),transparent 70%);top:-150px;right:-100px;}
.orb-2{width:400px;height:400px;background:radial-gradient(circle,rgba(59,130,246,0.06),transparent 70%);bottom:10%;left:-100px;}

/* NAV */
nav{position:sticky;top:0;z-index:100;display:flex;align-items:center;gap:32px;padding:0 48px;height:66px;background:rgba(8,12,20,0.85);backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);border-bottom:1px solid var(--border);}
.logo{font-family:'Syne',sans-serif;font-size:1.35rem;font-weight:800;color:var(--text);text-decoration:none;letter-spacing:-0.5px;display:flex;align-items:center;gap:8px;flex-shrink:0;}
.logo-icon{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:800;color:#000;font-family:'Syne',sans-serif;}
.logo span{color:var(--teal);}
.nav-right{margin-left:auto;display:flex;align-items:center;gap:8px;list-style:none;}
.nav-right a{text-decoration:none;font-size:0.875rem;color:var(--text-2);font-weight:500;padding:7px 14px;border-radius:8px;transition:all 0.2s;}
.nav-right a:hover{color:var(--text);background:var(--glass-2);}
.btn-ghost{border:1px solid var(--border)!important;color:var(--text-2)!important;}
.btn-ghost:hover{border-color:var(--border-bright)!important;color:var(--teal)!important;}
.btn-primary{background:var(--teal)!important;color:#000!important;font-weight:700!important;font-family:'Syne',sans-serif;}
.btn-primary:hover{background:#00f0c0!important;box-shadow:0 0 20px rgba(0,212,170,0.3);}
.nav-user{display:flex;align-items:center;gap:8px;}
.nav-avatar{width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.65rem;font-weight:700;color:#000;flex-shrink:0;}

/* PAGE */
.page-container{position:relative;z-index:1;max-width:1100px;margin:0 auto;padding:32px 48px 60px;}
.breadcrumb{display:flex;align-items:center;gap:8px;font-size:0.78rem;color:var(--text-3);margin-bottom:24px;}
.breadcrumb a{color:var(--text-3);text-decoration:none;transition:color 0.2s;}
.breadcrumb a:hover{color:var(--teal);}
.page-grid{display:grid;grid-template-columns:1fr 320px;gap:24px;align-items:start;}

/* MAIN CARD */
.main-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;}
.job-header{padding:32px;border-bottom:1px solid var(--border);}
.company-row{display:flex;align-items:flex-start;gap:16px;margin-bottom:20px;}
.company-logo{width:56px;height:56px;border-radius:14px;background:var(--navy-4);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.3rem;font-weight:700;color:var(--text-2);flex-shrink:0;}
.job-title-wrap{flex:1;}
.job-title{font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;color:var(--text);line-height:1.2;letter-spacing:-0.5px;margin-bottom:6px;}
.company-name{font-size:0.9rem;color:var(--teal);font-weight:600;}
.badge-featured{padding:4px 12px;border-radius:6px;background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);color:#f59e0b;font-size:0.72rem;font-weight:700;flex-shrink:0;margin-top:4px;}
.meta-tags{display:flex;flex-wrap:wrap;gap:8px;}
.tag{padding:5px 12px;border-radius:8px;font-size:0.78rem;font-weight:500;border:1px solid var(--border);color:var(--text-2);background:var(--glass);display:inline-flex;align-items:center;gap:6px;}
.tag-type{border-color:rgba(0,212,170,0.3);color:var(--teal);}
.tag-remote{border-color:rgba(59,130,246,0.3);color:#60a5fa;}
.tag-contract{border-color:rgba(168,85,247,0.3);color:#c084fc;}

/* SKILLS */
.skills-wrap{display:flex;flex-wrap:wrap;gap:8px;margin-top:8px;}
.skill-chip{padding:4px 12px;border-radius:20px;background:var(--teal-glow-2);border:1px solid var(--border-bright);color:var(--teal);font-size:0.75rem;font-weight:600;}

/* JOB BODY */
.job-body{padding:32px;}
.section-label{font-size:0.72rem;font-weight:600;color:var(--teal);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:14px;}
.description{font-size:0.9rem;line-height:1.85;color:var(--text-2);white-space:pre-wrap;}
.salary-section{margin-top:28px;padding:20px 24px;background:rgba(0,212,170,0.04);border:1px solid var(--border-bright);border-radius:var(--radius);}
.salary-label{font-size:0.72rem;font-weight:600;color:var(--teal);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:8px;}
.salary-amount{font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;color:var(--teal);letter-spacing:-0.5px;}
.salary-note{font-size:0.75rem;color:var(--text-3);margin-top:4px;}

/* SIDEBAR */
.sidebar{display:flex;flex-direction:column;gap:16px;position:sticky;top:82px;}
.action-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:24px;}

/* ALERTS */
.alert{padding:12px 16px;border-radius:10px;font-size:0.85rem;display:flex;align-items:flex-start;gap:10px;}
.alert-success{background:rgba(52,211,153,0.08);border:1px solid rgba(52,211,153,0.2);color:#34d399;}
.alert-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:#f87171;}

/* APPLY BUTTONS */
.btn-apply{display:block;width:100%;padding:14px;background:var(--teal);color:#000;font-size:0.95rem;font-weight:700;font-family:'Syne',sans-serif;border:none;border-radius:10px;cursor:pointer;text-align:center;text-decoration:none;transition:all 0.2s;letter-spacing:0.2px;}
.btn-apply:hover{background:#00f0c0;box-shadow:0 0 28px rgba(0,212,170,0.4);transform:translateY(-1px);}
.btn-applied{display:block;width:100%;padding:14px;background:rgba(52,211,153,0.08);color:#34d399;font-size:0.9rem;font-weight:600;border:1px solid rgba(52,211,153,0.25);border-radius:10px;text-align:center;cursor:default;}
.btn-login{display:block;width:100%;padding:14px;background:var(--glass-2);color:var(--text);font-size:0.9rem;font-weight:600;border:1px solid var(--border);border-radius:10px;text-align:center;text-decoration:none;transition:all 0.2s;}
.btn-login:hover{border-color:var(--border-bright);color:var(--teal);}
.apply-note{font-size:0.75rem;color:var(--text-3);text-align:center;margin-top:10px;}
.apply-note a{color:var(--teal);text-decoration:none;}
.apply-note a:hover{text-decoration:underline;}

/* INFO ROWS */
.info-card-title{font-family:'Syne',sans-serif;font-size:0.82rem;font-weight:700;color:var(--text);letter-spacing:0.5px;text-transform:uppercase;margin-bottom:16px;}
.info-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border);font-size:0.85rem;}
.info-row:last-child{border-bottom:none;padding-bottom:0;}
.info-label{color:var(--text-3);}
.info-value{font-weight:600;color:var(--text);text-align:right;}
.info-value.teal{color:var(--teal);}

/* SHARE CARD */
.share-title{font-size:0.82rem;font-weight:600;color:var(--text-2);margin-bottom:12px;}
.share-btn{display:flex;align-items:center;gap:8px;width:100%;padding:9px 14px;background:var(--glass);border:1px solid var(--border);border-radius:8px;color:var(--text-2);font-size:0.82rem;font-weight:500;cursor:pointer;font-family:inherit;transition:all 0.2s;text-decoration:none;margin-bottom:8px;}
.share-btn:hover{border-color:var(--border-bright);color:var(--text);}
.share-btn:last-child{margin-bottom:0;}

/* RESPONSIVE */
@media(max-width:1024px){.page-container{padding-left:24px;padding-right:24px;}}
@media(max-width:768px){
  nav{padding:0 16px;}
  .page-container{padding:20px 16px 40px;}
  .page-grid{grid-template-columns:1fr;}
  .sidebar{position:static;}
  .job-title{font-size:1.2rem;}
}
</style>
</head>
<body>

<div class="bg-orb orb-1"></div>
<div class="bg-orb orb-2"></div>

<!-- NAV -->
<nav>
  <a href="${pageContext.request.contextPath}/home" class="logo">
    <div class="logo-icon">HF</div>
    Hire<span>Flow</span>
  </a>
  <ul class="nav-right">
    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
    <li><a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a></li>
    <c:choose>
      <c:when test="${not empty sessionScope.userId}">
        <li>
          <a href="${pageContext.request.contextPath}/dashboard/${sessionScope.userRole == 'employer' ? 'employer' : sessionScope.userRole == 'admin' ? '../admin/panel' : 'seeker'}" class="nav-user">
            <div class="nav-avatar">${userInitials}</div>
            <c:out value="${sessionScope.userName}"/>
          </a>
        </li>
        <li><a href="${pageContext.request.contextPath}/logout" class="btn-ghost">Logout</a></li>
      </c:when>
      <c:otherwise>
        <li><a href="${pageContext.request.contextPath}/login" class="btn-ghost">Login</a></li>
        <li><a href="${pageContext.request.contextPath}/register" class="btn-primary">Register</a></li>
      </c:otherwise>
    </c:choose>
  </ul>
</nav>

<div class="page-container">

  <!-- BREADCRUMB -->
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    &nbsp;›&nbsp;
    <a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
    &nbsp;›&nbsp;
    <c:out value="${job.title}"/>
  </div>

  <div class="page-grid">

    <!-- MAIN CONTENT -->
    <div class="main-card">

      <!-- JOB HEADER -->
      <div class="job-header">
        <div class="company-row">
          <div class="company-logo">${jobInitial}</div>
          <div class="job-title-wrap">
            <div class="job-title"><c:out value="${job.title}"/></div>
            <div class="company-name"><c:out value="${job.companyName}"/></div>
          </div>
          <c:if test="${job.featured}">
            <span class="badge-featured">Featured</span>
          </c:if>
        </div>

        <div class="meta-tags">
          <c:if test="${not empty job.location}">
            <span class="tag">📍 <c:out value="${job.location}"/></span>
          </c:if>
          <c:choose>
            <c:when test="${job.jobType == 'remote'}">
              <span class="tag tag-remote">🌐 Remote</span>
            </c:when>
            <c:when test="${job.jobType == 'contract'}">
              <span class="tag tag-contract">📋 Contract</span>
            </c:when>
            <c:when test="${not empty job.jobType}">
              <span class="tag tag-type">💼 <c:out value="${job.jobType}"/></span>
            </c:when>
          </c:choose>
          <c:if test="${not empty job.categoryName}">
            <span class="tag">🏷 <c:out value="${job.categoryName}"/></span>
          </c:if>
        </div>

        <%-- Skills — uses ${jobSkills} List set by servlet to avoid String[] iteration issues --%>
        <c:if test="${not empty jobSkills}">
          <div style="margin-top:16px;">
            <div style="font-size:0.72rem;color:var(--text-3);letter-spacing:0.8px;text-transform:uppercase;margin-bottom:8px;">
              Skills Required
            </div>
            <div class="skills-wrap">
              <c:forEach items="${jobSkills}" var="skill">
                <span class="skill-chip"><c:out value="${skill}"/></span>
              </c:forEach>
            </div>
          </div>
        </c:if>
      </div>

      <!-- JOB DESCRIPTION -->
      <div class="job-body">
        <div class="section-label">Job Description</div>
        <div class="description"><c:out value="${job.description}"/></div>

        <c:if test="${job.salaryMin != null || job.salaryMax != null}">
          <div class="salary-section">
            <div class="salary-label">Compensation</div>
            <div class="salary-amount">${job.salaryRange}</div>
            <div class="salary-note">Annual compensation in Indian Rupees (LPA)</div>
          </div>
        </c:if>
      </div>

    </div>

    <!-- SIDEBAR -->
    <div class="sidebar">

      <%-- Success / Error from ApplyServlet redirect --%>
      <c:if test="${not empty success}">
        <div class="alert alert-success">✅ <c:out value="${success}"/></div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-error">⚠️ <c:out value="${error}"/></div>
      </c:if>

      <%-- APPLY ACTION CARD --%>
      <div class="action-card">
        <c:choose>
          <c:when test="${alreadyApplied}">
            <div class="btn-applied">✓ Already Applied</div>
            <p class="apply-note">
              Check your <a href="${pageContext.request.contextPath}/dashboard/seeker">dashboard</a> for status updates.
            </p>
          </c:when>
          <c:when test="${isSeeker}">
            <a href="${pageContext.request.contextPath}/apply/form?jobId=${job.jobId}" class="btn-apply">
              Apply Now →
            </a>
            <p class="apply-note">Takes less than 2 minutes</p>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login" class="btn-login">
              Sign in to Apply
            </a>
            <p class="apply-note">
              No account? <a href="${pageContext.request.contextPath}/register">Register free</a>
            </p>
          </c:otherwise>
        </c:choose>
      </div>

      <%-- JOB DETAILS CARD --%>
      <div class="action-card">
        <div class="info-card-title">Job Details</div>
        <div class="info-row">
          <span class="info-label">Job Type</span>
          <span class="info-value">
            <c:out value="${not empty job.jobType ? job.jobType : 'Not specified'}"/>
          </span>
        </div>
        <div class="info-row">
          <span class="info-label">Location</span>
          <span class="info-value">
            <c:out value="${not empty job.location ? job.location : 'Not specified'}"/>
          </span>
        </div>
        <div class="info-row">
          <span class="info-label">Category</span>
          <span class="info-value">
            <c:out value="${not empty job.categoryName ? job.categoryName : 'General'}"/>
          </span>
        </div>
        <div class="info-row">
          <span class="info-label">Salary</span>
          <span class="info-value teal">${job.salaryRange}</span>
        </div>
        <div class="info-row">
          <span class="info-label">Posted</span>
          <span class="info-value">${job.postedAtFormatted}</span>
        </div>
        <c:if test="${job.expiresAt != null}">
          <div class="info-row">
            <span class="info-label">Expires</span>
            <span class="info-value">${job.expiresAtFormatted}</span>
          </div>
        </c:if>
        <c:if test="${job.applicationCount > 0}">
          <div class="info-row">
            <span class="info-label">Applicants</span>
            <span class="info-value">${job.applicationCount}</span>
          </div>
        </c:if>
      </div>

      <%-- SHARE CARD --%>
      <div class="action-card">
        <div class="share-title">Share this job</div>
        <a href="https://www.linkedin.com/sharing/share-offsite/?url=${pageContext.request.requestURL}"
           target="_blank" class="share-btn">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="#0A66C2">
            <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
          </svg>
          Share on LinkedIn
        </a>
        <button class="share-btn"
                onclick="navigator.clipboard.writeText(window.location.href).then(()=>{this.innerHTML='&lt;svg width=\'16\' height=\'16\' fill=\'none\' stroke=\'currentColor\' stroke-width=\'2\' viewBox=\'0 0 24 24\'&gt;&lt;path d=\'M20 6L9 17l-5-5\'/&gt;&lt;/svg&gt; Copied!';})">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path d="M10 13a5 5 0 007.54.54l3-3a5 5 0 00-7.07-7.07l-1.72 1.71"/>
            <path d="M14 11a5 5 0 00-7.54-.54l-3 3a5 5 0 007.07 7.07l1.71-1.71"/>
          </svg>
          Copy Link
        </button>
      </div>

    </div>
  </div>
</div>

</body>
</html>
