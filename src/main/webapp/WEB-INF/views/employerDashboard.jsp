<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Employer Dashboard — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Instrument+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
:root{
  --navy:#080c14;--navy-2:#0d1422;--navy-3:#111827;--navy-4:#1a2236;
  --teal:#00d4aa;--teal-glow:rgba(0,212,170,0.15);--teal-glow-2:rgba(0,212,170,0.06);
  --blue:#3b82f6;--amber:#f59e0b;--green:#10b981;--red:#f87171;
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
nav{position:sticky;top:0;z-index:100;display:flex;align-items:center;gap:16px;padding:0 48px;height:66px;background:rgba(8,12,20,0.85);backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);border-bottom:1px solid var(--border);}
.logo{font-family:'Syne',sans-serif;font-size:1.35rem;font-weight:800;color:var(--text);text-decoration:none;letter-spacing:-0.5px;display:flex;align-items:center;gap:8px;flex-shrink:0;}
.logo-icon{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:800;color:#000;font-family:'Syne',sans-serif;}
.logo span{color:var(--teal);}
.nav-right{margin-left:auto;display:flex;align-items:center;gap:8px;}
.nav-right a{text-decoration:none;font-size:0.875rem;color:var(--text-2);font-weight:500;padding:7px 14px;border-radius:8px;transition:all 0.2s;}
.nav-right a:hover{color:var(--text);background:var(--glass-2);}
.btn-ghost{border:1px solid var(--border)!important;color:var(--text-2)!important;}
.btn-ghost:hover{border-color:var(--border-bright)!important;color:var(--teal)!important;}
.btn-post-nav{background:var(--teal)!important;color:#000!important;font-weight:700!important;font-family:'Syne',sans-serif;padding:7px 18px;border-radius:8px;}
.btn-post-nav:hover{background:#00f0c0!important;box-shadow:0 0 20px rgba(0,212,170,0.3);}
.nav-user{display:flex;align-items:center;gap:8px;color:var(--text-2);font-size:0.875rem;}
.nav-avatar{width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.65rem;font-weight:700;color:#000;flex-shrink:0;}

/* PAGE */
.page{position:relative;z-index:1;max-width:1200px;margin:0 auto;padding:36px 48px 60px;}

/* PROFILE HEADER */
.profile-header{background:linear-gradient(135deg,var(--navy-4) 0%,#0a1628 100%);border:1px solid var(--border-bright);border-radius:var(--radius);padding:28px 32px;display:flex;align-items:center;gap:20px;margin-bottom:24px;position:relative;overflow:hidden;}
.profile-header::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 0% 50%,rgba(59,130,246,0.08),transparent 60%);pointer-events:none;}
.avatar{width:60px;height:60px;border-radius:50%;background:linear-gradient(135deg,#3b82f6,var(--teal));display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;color:#fff;flex-shrink:0;position:relative;z-index:1;}
.profile-info{position:relative;z-index:1;}
.profile-info h1{font-family:'Syne',sans-serif;font-size:1.3rem;font-weight:800;color:var(--text);letter-spacing:-0.3px;}
.profile-info p{color:var(--text-2);font-size:0.82rem;margin-top:4px;}
.profile-badge{margin-left:auto;background:rgba(59,130,246,0.1);color:#60a5fa;border:1px solid rgba(59,130,246,0.25);font-size:0.72rem;font-weight:700;padding:5px 14px;border-radius:20px;letter-spacing:0.5px;text-transform:uppercase;position:relative;z-index:1;flex-shrink:0;}
.btn-post-header{display:inline-flex;align-items:center;gap:6px;padding:9px 20px;background:var(--teal);color:#000;font-size:0.85rem;font-weight:700;font-family:'Syne',sans-serif;border-radius:8px;text-decoration:none;transition:all 0.2s;position:relative;z-index:1;flex-shrink:0;}
.btn-post-header:hover{background:#00f0c0;box-shadow:0 0 20px rgba(0,212,170,0.3);}

/* STATS */
.stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:28px;}
.stat-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:20px 24px;position:relative;overflow:hidden;transition:all 0.2s;}
.stat-card:hover{background:var(--glass-2);}
.stat-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;}
.stat-card.jobs::before{background:var(--blue);}
.stat-card.active::before{background:var(--teal);}
.stat-card.apps::before{background:var(--amber);}
.stat-card.hired::before{background:var(--green);}
.stat-icon{font-size:1.2rem;margin-bottom:10px;}
.stat-num{font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;line-height:1;letter-spacing:-1px;}
.stat-card.jobs   .stat-num{color:var(--blue);}
.stat-card.active .stat-num{color:var(--teal);}
.stat-card.apps   .stat-num{color:var(--amber);}
.stat-card.hired  .stat-num{color:var(--green);}
.stat-label{font-size:0.78rem;color:var(--text-3);margin-top:6px;}

/* SECTION HEADER */
.section-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px;}
.section-title{font-family:'Syne',sans-serif;font-size:1rem;font-weight:700;color:var(--text);}

/* ALERTS */
.alert{padding:12px 16px;border-radius:10px;font-size:0.875rem;margin-bottom:20px;}
.alert-success{background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.2);color:#34d399;}
.alert-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:#f87171;}

/* EMPTY STATE */
.empty-state{padding:56px 24px;text-align:center;background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);}
.empty-icon{font-size:2.5rem;margin-bottom:16px;}
.empty-state h3{font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:var(--text);margin-bottom:8px;}
.empty-state p{font-size:0.85rem;color:var(--text-2);margin-bottom:20px;}
.btn-cta{display:inline-flex;align-items:center;gap:6px;padding:10px 22px;background:var(--teal);color:#000;font-size:0.875rem;font-weight:700;font-family:'Syne',sans-serif;border-radius:8px;text-decoration:none;transition:all 0.2s;}
.btn-cta:hover{background:#00f0c0;box-shadow:0 0 20px rgba(0,212,170,0.3);}

/* JOB CARDS */
.jobs-list{display:flex;flex-direction:column;gap:12px;}
.job-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;transition:border-color 0.2s;}
.job-card:hover{border-color:rgba(255,255,255,0.1);}
.job-card-header{padding:20px 24px;display:flex;align-items:center;gap:16px;cursor:pointer;transition:background 0.15s;}
.job-card-header:hover{background:var(--glass-2);}
.job-logo{width:44px;height:44px;border-radius:10px;background:var(--navy-4);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:1rem;font-weight:700;color:var(--text-2);flex-shrink:0;}
.job-title-wrap{flex:1;min-width:0;}
.job-title{font-size:0.95rem;font-weight:600;color:var(--text);margin-bottom:4px;}
.job-meta{font-size:0.78rem;color:var(--text-3);display:flex;gap:12px;flex-wrap:wrap;}
.job-meta span{display:flex;align-items:center;gap:4px;}
.job-actions{display:flex;gap:8px;align-items:center;flex-shrink:0;}

/* STATUS PILLS */
.status-pill{font-size:0.7rem;font-weight:700;padding:3px 10px;border-radius:20px;letter-spacing:0.3px;text-transform:capitalize;}
.status-active {background:rgba(0,212,170,0.1);border:1px solid var(--border-bright);color:var(--teal);}
.status-pending{background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);color:var(--amber);}
.status-expired{background:rgba(255,255,255,0.04);border:1px solid var(--border);color:var(--text-3);}
.status-closed {background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:var(--red);}

/* SMALL BUTTONS */
.btn-sm{font-size:0.75rem;padding:5px 12px;border-radius:6px;border:1px solid var(--border);background:transparent;color:var(--text-2);cursor:pointer;text-decoration:none;transition:all 0.2s;font-family:inherit;}
.btn-sm:hover{border-color:var(--border-bright);color:var(--text);}
.btn-danger{border-color:rgba(248,113,113,0.3)!important;color:var(--red)!important;}
.btn-danger:hover{background:rgba(248,113,113,0.08)!important;}

/* TOGGLE CHEVRON */
.toggle-chevron{font-size:0.75rem;color:var(--text-3);transition:transform 0.25s;margin-left:4px;flex-shrink:0;}
.toggle-chevron.open{transform:rotate(180deg);}

/* APPLICANTS PANEL */
.applicants-panel{border-top:1px solid var(--border);display:none;}
.applicants-panel.open{display:block;}
.applicants-header{padding:12px 24px;background:rgba(255,255,255,0.02);font-size:0.78rem;font-weight:600;color:var(--text-3);border-bottom:1px solid var(--border);letter-spacing:0.5px;text-transform:uppercase;}
.applicant-row{display:flex;align-items:center;gap:14px;padding:14px 24px;border-bottom:1px solid var(--border);transition:background 0.15s;}
.applicant-row:last-child{border-bottom:none;}
.applicant-row:hover{background:var(--glass-2);}
.applicant-avatar{width:36px;height:36px;border-radius:50%;background:var(--navy-4);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:0.82rem;font-weight:700;color:var(--text-2);flex-shrink:0;}
.applicant-info{flex:1;min-width:0;}
.applicant-name{font-size:0.875rem;font-weight:600;color:var(--text);}
.applicant-email{font-size:0.75rem;color:var(--text-3);margin-top:2px;}
.applicant-date{font-size:0.75rem;color:var(--text-3);white-space:nowrap;flex-shrink:0;}
.no-applicants{padding:20px 24px;text-align:center;font-size:0.82rem;color:var(--text-3);}

/* APPLICATION BADGES */
.badge{font-size:0.7rem;font-weight:700;padding:3px 10px;border-radius:6px;text-transform:capitalize;flex-shrink:0;}
.badge-applied  {background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.25);color:#60a5fa;}
.badge-reviewed {background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.25);color:var(--amber);}
.badge-hired    {background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.25);color:#34d399;}
.badge-rejected {background:rgba(248,113,113,0.1);border:1px solid rgba(248,113,113,0.25);color:var(--red);}

/* STATUS UPDATE FORM */
.status-form{display:flex;align-items:center;gap:6px;flex-shrink:0;}
.status-select{font-size:0.75rem;padding:4px 8px;border:1px solid var(--border);border-radius:6px;background:var(--navy-3);color:var(--text);cursor:pointer;outline:none;font-family:inherit;}
.status-select:focus{border-color:var(--border-bright);}
.status-select option{background:var(--navy-3);}
.btn-update{font-size:0.75rem;padding:5px 12px;background:var(--blue);color:#fff;border:none;border-radius:6px;cursor:pointer;font-family:inherit;transition:background 0.15s;}
.btn-update:hover{background:#2d5fb8;}

/* RESPONSIVE */
@media(max-width:1024px){.page{padding-left:24px;padding-right:24px;}}
@media(max-width:768px){
  nav{padding:0 16px;}
  .stats-row{grid-template-columns:repeat(2,1fr);}
  .profile-header{flex-wrap:wrap;gap:12px;}
  .job-card-header{flex-wrap:wrap;}
  .applicant-row{flex-wrap:wrap;}
  .status-form{width:100%;}
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
  <div class="nav-right">
    <a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
  <!--  <a href="${pageContext.request.contextPath}/jobs/create" class="btn-post-nav">+ Post Job</a>   -->
    <div class="nav-user">
      <div class="nav-avatar">${employerInitial}</div>
      <c:out value="${sessionScope.userName}"/>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-ghost">Logout</a>
  </div>
</nav>

<div class="page">

  <%-- ALERTS --%>
  <c:if test="${not empty success}">
    <div class="alert alert-success">✅ <c:out value="${success}"/></div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-error">⚠️ <c:out value="${error}"/></div>
  </c:if>

  <%-- PROFILE HEADER --%>
  <div class="profile-header">
    <div class="avatar">${employerInitial}</div>
    <div class="profile-info">
      <h1><c:out value="${sessionScope.userName}"/></h1>
      <p>Employer Dashboard · Manage your job listings and applicants</p>
    </div>
    <span class="profile-badge">Employer</span>
  <!--  <a href="${pageContext.request.contextPath}/jobs/create" class="btn-post-header">+ Post a Job</a> -->
  </div>

  <%-- STATS --%>
  <div class="stats-row">
    <div class="stat-card jobs">
      <div class="stat-icon">📁</div>
      <div class="stat-num">${totalJobs}</div>
      <div class="stat-label">Total Jobs Posted</div>
    </div>
    <div class="stat-card active">
      <div class="stat-icon">✅</div>
      <div class="stat-num">${totalActive}</div>
      <div class="stat-label">Active Listings</div>
    </div>
    <div class="stat-card apps">
      <div class="stat-icon">👥</div>
      <div class="stat-num">${totalApplicants}</div>
      <div class="stat-label">Total Applicants</div>
    </div>
    <div class="stat-card hired">
      <div class="stat-icon">🎉</div>
      <div class="stat-num">${totalHired}</div>
      <div class="stat-label">Hired</div>
    </div>
  </div>

  <%-- JOBS LIST --%>
  <div class="section-head">
    <span class="section-title">My Job Listings</span>
    <a href="${pageContext.request.contextPath}/jobs/create" class="btn-cta">+ Post New Job</a>
  </div>

  <c:choose>
    <c:when test="${empty jobs}">
      <div class="empty-state">
        <div class="empty-icon">📋</div>
        <h3>No jobs posted yet</h3>
        <p>Post your first job listing and start receiving applications.</p>
        <a href="${pageContext.request.contextPath}/jobs/create" class="btn-cta">+ Post a Job</a>
      </div>
    </c:when>
    <c:otherwise>
      <div class="jobs-list">
        <c:forEach var="job" items="${jobs}">
          <div class="job-card">

            <%-- JOB HEADER — click to expand applicants --%>
            <div class="job-card-header"
                 onclick="toggleApplicants('panel-${job.jobId}', 'chevron-${job.jobId}')">
              <div class="job-logo">${job.companyInitial}</div>
              <div class="job-title-wrap">
                <div class="job-title"><c:out value="${job.title}"/></div>
                <div class="job-meta">
                  <span>📍 <c:out value="${not empty job.location ? job.location : 'Remote'}"/></span>
                  <span>💼 <c:out value="${not empty job.jobType ? job.jobType : 'Full-time'}"/></span>
                  <span>🗓 ${job.postedAtFormatted}</span>
                  <span>👥 ${applicantsMap[job.jobId].size()} applicant(s)</span>
                </div>
              </div>
              <div class="job-actions" onclick="event.stopPropagation()">
                <span class="status-pill
                  <c:choose>
                    <c:when test="${job.status == 'active'}">status-active</c:when>
                    <c:when test="${job.status == 'pending'}">status-pending</c:when>
                    <c:when test="${job.status == 'closed'}">status-closed</c:when>
                    <c:otherwise>status-expired</c:otherwise>
                  </c:choose>">
                  <c:out value="${job.status}"/>
                </span>
                <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}"
                   class="btn-sm" target="_blank">View</a>
                <form action="${pageContext.request.contextPath}/jobs/delete"
                      method="post" style="display:inline"
                      onsubmit="return confirm('Delete this job? This cannot be undone.')">
                  <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                  <input type="hidden" name="jobId" value="${job.jobId}"/>
                  <button type="submit" class="btn-sm btn-danger">Delete</button>
                </form>
              </div>
              <span class="toggle-chevron" id="chevron-${job.jobId}">▼</span>
            </div>

            <%-- APPLICANTS PANEL --%>
            <div class="applicants-panel" id="panel-${job.jobId}">
              <div class="applicants-header">
                Applicants for "<c:out value="${job.title}"/>" — ${applicantsMap[job.jobId].size()} total
              </div>

              <c:choose>
                <c:when test="${empty applicantsMap[job.jobId]}">
                  <div class="no-applicants">No applicants yet for this role.</div>
                </c:when>
                <c:otherwise>
                  <c:forEach var="app" items="${applicantsMap[job.jobId]}">
                    <div class="applicant-row">
                      <div class="applicant-avatar">${app.seekerInitial}</div>
                      <div class="applicant-info">
                        <div class="applicant-name">
                          <c:out value="${not empty app.seekerName ? app.seekerName : 'Applicant'}"/>
                        </div>
                        <div class="applicant-email">
                          <c:out value="${not empty app.seekerEmail ? app.seekerEmail : ''}"/>
                        </div>
                      </div>
                      <div class="applicant-date">${app.appliedAtFormatted}</div>
                      <c:if test="${not empty app.resumeUrl}">
                        <a href="${app.resumeUrl}" class="btn-sm" target="_blank">Resume</a>
                      </c:if>
                      <span class="badge badge-${app.status}"><c:out value="${app.status}"/></span>
                      <form action="${pageContext.request.contextPath}/application/status"
                            method="post" class="status-form">
                        <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                        <input type="hidden" name="applicationId" value="${app.applicationId}"/>
                        <select name="status" class="status-select">
                          <option value="applied"  ${app.status == 'applied'  ? 'selected' : ''}>Applied</option>
                          <option value="reviewed" ${app.status == 'reviewed' ? 'selected' : ''}>Reviewed</option>
                          <option value="hired"    ${app.status == 'hired'    ? 'selected' : ''}>Hired</option>
                          <option value="rejected" ${app.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                        </select>
                        <button type="submit" class="btn-update">Update</button>
                      </form>
                    </div>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </div>

          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

</div>

<script>
function toggleApplicants(panelId, chevronId) {
  const panel   = document.getElementById(panelId);
  const chevron = document.getElementById(chevronId);
  panel.classList.toggle('open');
  chevron.classList.toggle('open');
}
</script>
</body>
</html>
