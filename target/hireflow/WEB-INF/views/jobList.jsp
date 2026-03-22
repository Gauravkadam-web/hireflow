<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Browse Jobs — HireFlow</title>
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

/* PAGE HEADER */
.page-header{position:relative;z-index:1;max-width:1200px;margin:0 auto;padding:36px 48px 24px;}
.page-header h1{font-family:'Syne',sans-serif;font-size:1.75rem;font-weight:800;letter-spacing:-0.5px;color:var(--text);}
.page-header p{color:var(--text-2);font-size:0.9rem;margin-top:4px;}
.breadcrumb{display:flex;align-items:center;gap:8px;font-size:0.78rem;color:var(--text-3);margin-bottom:12px;}
.breadcrumb a{color:var(--text-3);text-decoration:none;transition:color 0.2s;}
.breadcrumb a:hover{color:var(--teal);}
.breadcrumb span{color:var(--text-3);}

/* LAYOUT */
.page-wrap{position:relative;z-index:1;max-width:1200px;margin:0 auto;padding:0 48px 60px;display:grid;grid-template-columns:280px 1fr;gap:24px;align-items:start;}

/* SIDEBAR */
.sidebar{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:24px;position:sticky;top:82px;}
.sidebar-title{font-family:'Syne',sans-serif;font-size:0.78rem;font-weight:700;color:var(--text);letter-spacing:1px;text-transform:uppercase;margin-bottom:20px;display:flex;align-items:center;justify-content:space-between;}
.sidebar-title a{font-size:0.72rem;color:var(--teal);text-decoration:none;font-weight:500;letter-spacing:0;text-transform:none;}
.sidebar-title a:hover{text-decoration:underline;}
.filter-group{margin-bottom:18px;}
.filter-label{font-size:0.72rem;font-weight:600;color:var(--text-3);margin-bottom:8px;display:block;letter-spacing:0.8px;text-transform:uppercase;}
.filter-group input,.filter-group select{width:100%;padding:10px 12px;background:var(--navy-3);border:1px solid var(--border);border-radius:10px;font-size:0.875rem;font-family:inherit;color:var(--text);outline:none;transition:all 0.2s;appearance:none;-webkit-appearance:none;}
.filter-group input::placeholder{color:var(--text-3);}
.filter-group input:focus,.filter-group select:focus{border-color:var(--border-bright);box-shadow:0 0 0 3px var(--teal-glow);}
.filter-group select option{background:var(--navy-3);color:var(--text);}
.select-wrap{position:relative;}
.select-wrap::after{content:'';position:absolute;right:12px;top:50%;transform:translateY(-50%);width:0;height:0;border-left:4px solid transparent;border-right:4px solid transparent;border-top:5px solid var(--text-3);pointer-events:none;}
.filter-divider{height:1px;background:var(--border);margin:20px 0;}
.filter-section-label{font-size:0.72rem;font-weight:600;color:var(--text-3);letter-spacing:0.8px;text-transform:uppercase;margin-bottom:10px;display:block;}
.chip-group{display:flex;flex-direction:column;gap:6px;}
.chip-option{display:flex;align-items:center;gap:8px;cursor:pointer;padding:6px 0;}
.chip-option input[type="radio"]{accent-color:var(--teal);width:14px;height:14px;cursor:pointer;flex-shrink:0;}
.chip-option span{font-size:0.83rem;color:var(--text-2);}
.chip-option:hover span{color:var(--text);}
.btn-search{width:100%;padding:11px;border-radius:10px;border:none;background:var(--teal);color:#000;font-size:0.875rem;font-weight:700;font-family:'Syne',sans-serif;cursor:pointer;transition:all 0.2s;margin-top:4px;}
.btn-search:hover{background:#00f0c0;box-shadow:0 0 20px rgba(0,212,170,0.3);}
.btn-clear{width:100%;padding:9px;border-radius:10px;border:1px solid var(--border);background:transparent;color:var(--text-2);font-size:0.82rem;font-weight:500;font-family:inherit;cursor:pointer;transition:all 0.2s;margin-top:8px;text-decoration:none;display:block;text-align:center;}
.btn-clear:hover{border-color:var(--border-bright);color:var(--teal);}

/* ACTIVE FILTERS */
.active-filters{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:16px;}
.filter-chip{display:inline-flex;align-items:center;gap:6px;padding:4px 10px;background:var(--teal-glow-2);border:1px solid var(--border-bright);border-radius:20px;font-size:0.75rem;color:var(--teal);font-weight:500;}
.filter-chip button{background:none;border:none;color:var(--teal);cursor:pointer;padding:0;display:flex;align-items:center;font-size:0.8rem;opacity:0.7;}
.filter-chip button:hover{opacity:1;}

/* RESULTS */
.results-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;}
.results-count{font-size:0.875rem;color:var(--text-2);}
.results-count strong{color:var(--text);font-weight:700;}
.sort-wrap{display:flex;align-items:center;gap:8px;font-size:0.82rem;color:var(--text-3);}
.sort-wrap select{background:var(--glass);border:1px solid var(--border);color:var(--text-2);font-size:0.82rem;font-family:inherit;padding:5px 10px;border-radius:8px;outline:none;cursor:pointer;}

/* JOB CARDS */
.jobs-list{display:flex;flex-direction:column;gap:10px;}
.job-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:20px 24px;display:flex;align-items:center;gap:16px;transition:all 0.25s;text-decoration:none;color:inherit;position:relative;overflow:hidden;}
.job-card::before{content:'';position:absolute;left:0;top:0;bottom:0;width:3px;background:var(--teal);transform:scaleY(0);transition:transform 0.2s;border-radius:0 3px 3px 0;}
.job-card:hover{border-color:rgba(255,255,255,0.12);background:var(--glass-2);transform:translateX(4px);}
.job-card:hover::before{transform:scaleY(1);}
.job-card.featured{border-color:rgba(245,158,11,0.25);}
.job-card.featured::before{background:#f59e0b;}
.job-card:hover .job-logo{border-color:var(--border-bright);}
.job-logo{width:48px;height:48px;border-radius:12px;background:var(--navy-4);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.2rem;flex-shrink:0;font-weight:700;color:var(--text-2);transition:border-color 0.2s;}
.job-body{flex:1;min-width:0;}
.job-title{font-size:0.95rem;font-weight:600;color:var(--text);margin-bottom:3px;}
.job-company{font-size:0.82rem;color:var(--teal);font-weight:600;margin-bottom:10px;}
.job-tags{display:flex;align-items:center;gap:8px;flex-wrap:wrap;}
.tag{padding:3px 10px;border-radius:6px;font-size:0.72rem;font-weight:600;border:1px solid var(--border);color:var(--text-2);background:var(--glass);}
.tag-type{border-color:rgba(0,212,170,0.3);color:var(--teal);}
.tag-remote{border-color:rgba(59,130,246,0.3);color:#60a5fa;}
.tag-contract{border-color:rgba(168,85,247,0.3);color:#c084fc;}
.tag-loc{font-size:0.78rem;color:var(--text-2);}
.tag-salary{font-size:0.78rem;color:var(--text-2);font-weight:500;margin-left:auto;}
.badge-featured{padding:3px 10px;border-radius:6px;background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);color:#f59e0b;font-size:0.7rem;font-weight:700;flex-shrink:0;}
.badge-new{padding:3px 10px;border-radius:6px;background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);color:#f87171;font-size:0.7rem;font-weight:700;flex-shrink:0;}
.btn-view{padding:8px 18px;border-radius:8px;border:1px solid var(--border);background:transparent;color:var(--text-2);font-size:0.82rem;font-weight:600;cursor:pointer;font-family:inherit;transition:all 0.2s;flex-shrink:0;white-space:nowrap;}
.btn-view:hover{border-color:var(--teal);color:var(--teal);}

/* EMPTY STATE */
.empty{text-align:center;padding:60px 24px;background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);}
.empty-icon{font-size:2.5rem;margin-bottom:16px;}
.empty h3{font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:var(--text);margin-bottom:8px;}
.empty p{font-size:0.875rem;color:var(--text-2);}
.empty a{display:inline-block;margin-top:16px;padding:9px 20px;border-radius:8px;background:var(--teal);color:#000;font-size:0.85rem;font-weight:700;font-family:'Syne',sans-serif;text-decoration:none;}

/* PAGINATION */
.pagination{display:flex;align-items:center;justify-content:center;gap:6px;margin-top:28px;}
.page-btn{width:36px;height:36px;border-radius:8px;border:1px solid var(--border);background:var(--glass);color:var(--text-2);font-size:0.85rem;font-weight:500;cursor:pointer;font-family:inherit;transition:all 0.2s;display:flex;align-items:center;justify-content:center;text-decoration:none;}
.page-btn:hover{border-color:var(--border-bright);color:var(--teal);}
.page-btn.active{background:var(--teal);border-color:var(--teal);color:#000;font-weight:700;}
.page-btn.disabled{opacity:0.3;pointer-events:none;}

/* ERROR */
.alert-error{padding:12px 16px;background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:#f87171;border-radius:10px;font-size:0.875rem;margin-bottom:16px;}

/* RESPONSIVE */
@media(max-width:1024px){.page-header,.page-wrap{padding-left:24px;padding-right:24px;}}
@media(max-width:768px){
  nav{padding:0 16px;}
  .page-header{padding:24px 16px 16px;}
  .page-wrap{grid-template-columns:1fr;padding:0 16px 40px;}
  .sidebar{position:static;}
  .tag-salary{margin-left:0;}
  .job-card{flex-wrap:wrap;}
  .btn-view{width:100%;text-align:center;}
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

<!-- PAGE HEADER -->
<div class="page-header">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    <span>›</span>
    <span>Browse Jobs</span>
  </div>
  <h1>Browse Jobs</h1>
  <p>
    <c:choose>
      <c:when test="${not empty keyword}">Showing results for "<strong><c:out value="${keyword}"/></strong>"</c:when>
      <c:otherwise>Explore active opportunities across all categories</c:otherwise>
    </c:choose>
  </p>
</div>

<!-- MAIN LAYOUT -->
<div class="page-wrap">

  <!-- SIDEBAR FILTERS -->
  <aside class="sidebar">
    <div class="sidebar-title">
      Filters
      <a href="${pageContext.request.contextPath}/jobs">Clear all</a>
    </div>

    <form action="${pageContext.request.contextPath}/jobs" method="get" id="filterForm">

      <div class="filter-group">
        <span class="filter-label">Keyword</span>
        <input type="text" name="keyword"
               value="<c:out value='${keyword}'/>"
               placeholder="Java, React, Designer…"/>
      </div>

      <div class="filter-group">
        <span class="filter-label">Location</span>
        <input type="text" name="location"
               value="<c:out value='${location}'/>"
               placeholder="Pune, Bangalore, Remote…"/>
      </div>

      <div class="filter-group">
        <span class="filter-label">Category</span>
        <div class="select-wrap">
          <select name="category">
            <option value="0">All Categories</option>
            <c:forEach items="${categories}" var="cat">
              <option value="${cat.categoryId}" ${categoryId == cat.categoryId ? 'selected' : ''}>
                <c:out value="${cat.name}"/>
              </option>
            </c:forEach>
          </select>
        </div>
      </div>

      <div class="filter-divider"></div>

      <span class="filter-section-label">Job Type</span>
      <div class="chip-group">
        <label class="chip-option">
          <input type="radio" name="jobType" value="" ${empty param.jobType ? 'checked' : ''}/> <span>All Types</span>
        </label>
        <label class="chip-option">
          <input type="radio" name="jobType" value="full-time" ${param.jobType == 'full-time' ? 'checked' : ''}/> <span>Full-Time</span>
        </label>
        <label class="chip-option">
          <input type="radio" name="jobType" value="part-time" ${param.jobType == 'part-time' ? 'checked' : ''}/> <span>Part-Time</span>
        </label>
        <label class="chip-option">
          <input type="radio" name="jobType" value="contract" ${param.jobType == 'contract' ? 'checked' : ''}/> <span>Contract</span>
        </label>
        <label class="chip-option">
          <input type="radio" name="jobType" value="remote" ${param.jobType == 'remote' ? 'checked' : ''}/> <span>Remote</span>
        </label>
      </div>

      <div class="filter-divider"></div>

      <button type="submit" class="btn-search">Search Jobs</button>
      <a href="${pageContext.request.contextPath}/jobs" class="btn-clear">Clear Filters</a>

    </form>
  </aside>

  <!-- RESULTS -->
  <main>

    <c:if test="${not empty error}">
      <div class="alert-error"><c:out value="${error}"/></div>
    </c:if>

    <%-- Active filter chips --%>
    <c:if test="${not empty keyword or not empty location or categoryId > 0}">
      <div class="active-filters">
        <c:if test="${not empty keyword}">
          <span class="filter-chip">
            🔍 <c:out value="${keyword}"/>
            <button onclick="clearParam('keyword')">✕</button>
          </span>
        </c:if>
        <c:if test="${not empty location}">
          <span class="filter-chip">
            📍 <c:out value="${location}"/>
            <button onclick="clearParam('location')">✕</button>
          </span>
        </c:if>
        <c:if test="${categoryId > 0}">
          <span class="filter-chip">
            <c:forEach items="${categories}" var="cat">
              <c:if test="${cat.categoryId == categoryId}"><c:out value="${cat.name}"/></c:if>
            </c:forEach>
            <button onclick="clearParam('category')">✕</button>
          </span>
        </c:if>
      </div>
    </c:if>

    <div class="results-head">
      <span class="results-count">
        <strong>${jobs.size()}</strong> job<c:if test="${jobs.size() != 1}">s</c:if> found
        <c:if test="${not empty keyword}"> for "<c:out value='${keyword}'/>"</c:if>
      </span>
      <div class="sort-wrap">
        <span>Sort by</span>
        <select onchange="this.form && this.form.submit()">
          <option>Most Recent</option>
          <option>Featured First</option>
        </select>
      </div>
    </div>

    <c:choose>
      <c:when test="${empty jobs}">
        <div class="empty">
          <div class="empty-icon">🔍</div>
          <h3>No jobs found</h3>
          <p>Try different keywords, change the location, or clear your filters.</p>
          <a href="${pageContext.request.contextPath}/jobs">Browse all jobs</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="jobs-list">
          <c:forEach items="${jobs}" var="job">
            <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}"
               class="job-card ${job.featured ? 'featured' : ''}">
              <div class="job-logo">${job.companyInitial}</div>
              <div class="job-body">
                <div class="job-title"><c:out value="${job.title}"/></div>
                <div class="job-company"><c:out value="${job.companyName}"/></div>
                <div class="job-tags">
                  <c:choose>
                    <c:when test="${job.jobType == 'remote'}"><span class="tag tag-remote">Remote</span></c:when>
                    <c:when test="${job.jobType == 'contract'}"><span class="tag tag-contract">Contract</span></c:when>
                    <c:when test="${not empty job.jobType}"><span class="tag tag-type"><c:out value="${job.jobType}"/></span></c:when>
                  </c:choose>
                  <c:if test="${not empty job.location}">
                    <span class="tag-loc">📍 <c:out value="${job.location}"/></span>
                  </c:if>
                  <span class="tag-salary">${job.salaryRange}</span>
                </div>
              </div>
              <c:if test="${job.featured}"><span class="badge-featured">Featured</span></c:if>
              <span class="btn-view">View →</span>
            </a>
          </c:forEach>
        </div>

        <%-- PAGINATION --%>
        <c:if test="${jobs.size() >= pageSize}">
          <div class="pagination">
            <c:if test="${page > 1}">
              <a href="${pageContext.request.contextPath}/jobs?keyword=${keyword}&location=${location}&category=${categoryId}&page=${page-1}" class="page-btn">‹</a>
            </c:if>
            <c:if test="${page > 2}">
              <a href="${pageContext.request.contextPath}/jobs?keyword=${keyword}&location=${location}&category=${categoryId}&page=1" class="page-btn">1</a>
              <c:if test="${page > 3}"><span class="page-btn disabled">…</span></c:if>
            </c:if>
            <c:if test="${page > 1}">
              <a href="${pageContext.request.contextPath}/jobs?keyword=${keyword}&location=${location}&category=${categoryId}&page=${page-1}" class="page-btn">${page-1}</a>
            </c:if>
            <span class="page-btn active">${page}</span>
            <a href="${pageContext.request.contextPath}/jobs?keyword=${keyword}&location=${location}&category=${categoryId}&page=${page+1}" class="page-btn">${page+1}</a>
            <a href="${pageContext.request.contextPath}/jobs?keyword=${keyword}&location=${location}&category=${categoryId}&page=${page+1}" class="page-btn">›</a>
          </div>
        </c:if>

      </c:otherwise>
    </c:choose>

  </main>
</div>

<script>
// Remove a single filter param and re-submit
function clearParam(name) {
  const url = new URL(window.location.href);
  url.searchParams.delete(name);
  url.searchParams.set('page', '1');
  window.location.href = url.toString();
}

// Auto-submit form on job type radio change
document.querySelectorAll('input[name="jobType"]').forEach(r => {
  r.addEventListener('change', () => {
    document.getElementById('filterForm').submit();
  });
});
</script>
</body>
</html>
