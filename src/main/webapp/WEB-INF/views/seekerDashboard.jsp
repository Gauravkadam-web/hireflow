<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>My Dashboard — HireFlow</title>
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
nav{position:sticky;top:0;z-index:100;display:flex;align-items:center;gap:32px;padding:0 48px;height:66px;background:rgba(8,12,20,0.85);backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);border-bottom:1px solid var(--border);}
.logo{font-family:'Syne',sans-serif;font-size:1.35rem;font-weight:800;color:var(--text);text-decoration:none;letter-spacing:-0.5px;display:flex;align-items:center;gap:8px;flex-shrink:0;}
.logo-icon{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:800;color:#000;font-family:'Syne',sans-serif;}
.logo span{color:var(--teal);}
.nav-right{margin-left:auto;display:flex;align-items:center;gap:8px;}
.nav-right a{text-decoration:none;font-size:0.875rem;color:var(--text-2);font-weight:500;padding:7px 14px;border-radius:8px;transition:all 0.2s;}
.nav-right a:hover{color:var(--text);background:var(--glass-2);}
.btn-ghost{border:1px solid var(--border)!important;color:var(--text-2)!important;}
.btn-ghost:hover{border-color:var(--border-bright)!important;color:var(--teal)!important;}
.nav-user{display:flex;align-items:center;gap:8px;color:var(--text-2);font-size:0.875rem;}
.nav-avatar{width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.65rem;font-weight:700;color:#000;flex-shrink:0;}

/* PAGE */
.page{position:relative;z-index:1;max-width:1100px;margin:0 auto;padding:36px 48px 60px;}

/* PROFILE HEADER */
.profile-header{background:linear-gradient(135deg,var(--navy-4) 0%,#0a1628 100%);border:1px solid var(--border-bright);border-radius:var(--radius);padding:28px 32px;display:flex;align-items:center;gap:20px;margin-bottom:24px;position:relative;overflow:hidden;}
.profile-header::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 0% 50%,rgba(0,212,170,0.08),transparent 60%);pointer-events:none;}
.avatar{width:60px;height:60px;border-radius:50%;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:800;color:#000;flex-shrink:0;position:relative;z-index:1;}
.profile-info{position:relative;z-index:1;}
.profile-info h1{font-family:'Syne',sans-serif;font-size:1.3rem;font-weight:800;color:var(--text);letter-spacing:-0.3px;}
.profile-info p{color:var(--text-2);font-size:0.82rem;margin-top:4px;}
.profile-badge{margin-left:auto;background:var(--teal-glow-2);color:var(--teal);border:1px solid var(--border-bright);font-size:0.72rem;font-weight:700;padding:5px 14px;border-radius:20px;letter-spacing:0.5px;text-transform:uppercase;position:relative;z-index:1;flex-shrink:0;}

/* STATS */
.stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:24px;}
.stat-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:20px 24px;position:relative;overflow:hidden;transition:all 0.2s;}
.stat-card:hover{background:var(--glass-2);border-color:rgba(255,255,255,0.1);}
.stat-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;}
.stat-card.total::before{background:var(--blue);}
.stat-card.review::before{background:var(--amber);}
.stat-card.hired::before{background:var(--green);}
.stat-card.rejected::before{background:var(--red);}
.stat-icon{font-size:1.2rem;margin-bottom:10px;}
.stat-num{font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;line-height:1;letter-spacing:-1px;}
.stat-card.total   .stat-num{color:var(--blue);}
.stat-card.review  .stat-num{color:var(--amber);}
.stat-card.hired   .stat-num{color:var(--green);}
.stat-card.rejected .stat-num{color:var(--red);}
.stat-label{font-size:0.78rem;color:var(--text-3);margin-top:6px;}

/* GRID */
.grid-2{display:grid;grid-template-columns:1fr 360px;gap:20px;align-items:start;}

/* SECTION HEADER */
.section-head{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;}
.section-title{font-family:'Syne',sans-serif;font-size:1rem;font-weight:700;color:var(--text);letter-spacing:-0.2px;}
.count-pill{background:var(--glass);border:1px solid var(--border);font-size:0.72rem;color:var(--text-3);padding:3px 10px;border-radius:20px;}

/* CARD BASE */
.dash-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;}
.card-header{padding:18px 24px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
.card-header-title{font-size:0.875rem;font-weight:600;color:var(--text);}

/* APPLICATION ROWS */
.app-row{padding:16px 24px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:14px;transition:background 0.15s;}
.app-row:last-child{border-bottom:none;}
.app-row:hover{background:var(--glass-2);}
.company-initial{width:40px;height:40px;border-radius:10px;background:var(--navy-4);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:0.9rem;font-weight:700;color:var(--text-2);flex-shrink:0;}
.app-info{flex:1;min-width:0;}
.app-title{font-size:0.875rem;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:3px;}
.app-meta{font-size:0.78rem;color:var(--text-3);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
.app-date{font-size:0.72rem;color:var(--text-3);margin-top:3px;}

/* STATUS BADGES */
.badge{padding:3px 10px;border-radius:6px;font-size:0.7rem;font-weight:700;text-transform:capitalize;flex-shrink:0;letter-spacing:0.2px;}
.badge-applied  {background:rgba(59,130,246,0.1);border:1px solid rgba(59,130,246,0.25);color:#60a5fa;}
.badge-reviewed {background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.25);color:var(--amber);}
.badge-hired    {background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.25);color:#34d399;}
.badge-rejected {background:rgba(248,113,113,0.1);border:1px solid rgba(248,113,113,0.25);color:var(--red);}

/* EMPTY STATE */
.empty-state{padding:48px 24px;text-align:center;}
.empty-icon{font-size:2rem;margin-bottom:12px;}
.empty-state strong{font-size:0.95rem;color:var(--text);display:block;margin-bottom:6px;}
.empty-state p{font-size:0.82rem;color:var(--text-3);}
.btn-browse{display:inline-block;margin-top:16px;padding:10px 20px;background:var(--teal);color:#000;font-size:0.82rem;font-weight:700;font-family:'Syne',sans-serif;border-radius:8px;text-decoration:none;transition:all 0.2s;}
.btn-browse:hover{background:#00f0c0;box-shadow:0 0 20px rgba(0,212,170,0.3);}

/* RECOMMENDED JOBS */
.job-item{padding:14px 20px;border-bottom:1px solid var(--border);display:block;text-decoration:none;color:inherit;transition:background 0.15s;position:relative;}
.job-item:last-child{border-bottom:none;}
.job-item:hover{background:var(--glass-2);}
.job-item::before{content:'';position:absolute;left:0;top:0;bottom:0;width:2px;background:var(--teal);transform:scaleY(0);transition:transform 0.2s;}
.job-item:hover::before{transform:scaleY(1);}
.job-item-title{font-size:0.875rem;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:5px;}
.job-item-meta{font-size:0.75rem;color:var(--text-3);display:flex;gap:10px;flex-wrap:wrap;align-items:center;}
.job-type-pill{background:var(--teal-glow-2);color:var(--teal);border:1px solid var(--border-bright);font-size:0.68rem;padding:2px 8px;border-radius:20px;font-weight:600;}
.card-footer{padding:14px 20px;border-top:1px solid var(--border);}
.card-footer a{font-size:0.82rem;color:var(--teal);text-decoration:none;font-weight:600;}
.card-footer a:hover{text-decoration:underline;}

/* ALERT */
.alert-error{padding:12px 16px;background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:#f87171;border-radius:10px;font-size:0.875rem;margin-bottom:20px;}

/* RESPONSIVE */
@media(max-width:1024px){.page{padding-left:24px;padding-right:24px;}}
@media(max-width:820px){
  nav{padding:0 16px;}
  .stats-row{grid-template-columns:repeat(2,1fr);}
  .grid-2{grid-template-columns:1fr;}
  .profile-header{flex-wrap:wrap;}
  .profile-badge{margin-left:0;}
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
    <div class="nav-user">
      <div class="nav-avatar">${userInitial}</div>
      <c:out value="${sessionScope.userName}"/>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-ghost">Logout</a>
  </div>
</nav>

<div class="page">

  <%-- Error --%>
  <c:if test="${not empty error}">
    <div class="alert-error"><c:out value="${error}"/></div>
  </c:if>

  <%-- PROFILE HEADER --%>
  <div class="profile-header">
    <div class="avatar">${userInitial}</div>
    <div class="profile-info">
      <h1>Welcome back, <c:out value="${sessionScope.userName}"/>!</h1>
      <p>Job Seeker · Track your applications and discover new opportunities</p>
    </div>
    <span class="profile-badge">Seeker</span>
  </div>

  <%-- STATS --%>
  <div class="stats-row">
    <div class="stat-card total">
      <div class="stat-icon">📋</div>
      <div class="stat-num">${totalApplied}</div>
      <div class="stat-label">Total Applied</div>
    </div>
    <div class="stat-card review">
      <div class="stat-icon">👀</div>
      <div class="stat-num">${underReview}</div>
      <div class="stat-label">Under Review</div>
    </div>
    <div class="stat-card hired">
      <div class="stat-icon">🎉</div>
      <div class="stat-num">${hired}</div>
      <div class="stat-label">Hired</div>
    </div>
    <div class="stat-card rejected">
      <div class="stat-icon">❌</div>
      <div class="stat-num">${rejected}</div>
      <div class="stat-label">Rejected</div>
    </div>
  </div>

  <%-- MAIN GRID --%>
  <div class="grid-2">

    <%-- APPLICATIONS --%>
    <div>
      <div class="section-head">
        <span class="section-title">My Applications</span>
        <span class="count-pill">${totalApplied} total</span>
      </div>
      <div class="dash-card">
        <div class="card-header">
          <span class="card-header-title">Application History</span>
        </div>

        <c:choose>
          <c:when test="${empty applications}">
            <div class="empty-state">
              <div class="empty-icon">📋</div>
              <strong>No applications yet</strong>
              <p>Start applying to jobs and track your progress here.</p>
              <a href="${pageContext.request.contextPath}/jobs" class="btn-browse">Browse Jobs</a>
            </div>
          </c:when>
          <c:otherwise>
            <c:forEach var="app" items="${applications}">
              <div class="app-row">
                <div class="company-initial">${app.companyInitial}</div>
                <div class="app-info">
                  <div class="app-title"><c:out value="${app.jobTitle}"/></div>
                  <div class="app-meta">
                    <c:out value="${app.companyName}"/>
                    <c:if test="${not empty app.location}"> · <c:out value="${app.location}"/></c:if>
                  </div>
                  <div class="app-date">Applied: ${app.appliedAtFormatted}</div>
                </div>
                <span class="badge ${app.statusBadgeClass}">
                  <c:out value="${app.status}"/>
                </span>
              </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <%-- RECOMMENDED JOBS --%>
    <div>
      <div class="section-head">
        <span class="section-title">Recommended Jobs</span>
      </div>
      <div class="dash-card">
        <div class="card-header">
          <span class="card-header-title">Latest Openings</span>
        </div>

        <c:choose>
          <c:when test="${empty recommendedJobs}">
            <div class="empty-state">
              <div class="empty-icon">🔍</div>
              <p>No jobs available right now.</p>
            </div>
          </c:when>
          <c:otherwise>
            <c:forEach var="job" items="${recommendedJobs}">
              <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}" class="job-item">
                <div class="job-item-title"><c:out value="${job.title}"/></div>
                <div class="job-item-meta">
                  <span><c:out value="${job.companyName}"/></span>
                  <c:if test="${not empty job.location}">
                    <span>📍 <c:out value="${job.location}"/></span>
                  </c:if>
                  <c:if test="${not empty job.jobType}">
                    <span class="job-type-pill"><c:out value="${job.jobType}"/></span>
                  </c:if>
                </div>
              </a>
            </c:forEach>
          </c:otherwise>
        </c:choose>

        <div class="card-footer">
          <a href="${pageContext.request.contextPath}/jobs">View all jobs →</a>
        </div>
      </div>
    </div>

  </div>
</div>

</body>
</html>
