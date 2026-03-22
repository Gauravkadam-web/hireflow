<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HireFlow — Admin Panel</title>
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
    .orb-1{width:500px;height:500px;background:radial-gradient(circle,rgba(139,92,246,0.08),transparent 70%);top:-150px;right:-100px;animation:orbFloat 14s ease-in-out infinite;}
    .orb-2{width:400px;height:400px;background:radial-gradient(circle,rgba(0,212,170,0.06),transparent 70%);bottom:10%;left:-100px;animation:orbFloat 18s ease-in-out infinite reverse;}
    @keyframes orbFloat{0%,100%{transform:translateY(0) scale(1);}50%{transform:translateY(-24px) scale(1.04);}}
    @keyframes fadeUp{from{opacity:0;transform:translateY(20px);}to{opacity:1;transform:translateY(0);}}
    .fade-up{opacity:0;transform:translateY(20px);transition:opacity 0.5s ease,transform 0.5s ease;}
    .fade-up.visible{opacity:1;transform:translateY(0);}

    nav{position:sticky;top:0;z-index:100;display:flex;align-items:center;gap:16px;padding:0 48px;height:66px;background:rgba(8,12,20,0.85);backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);border-bottom:1px solid var(--border);}
    .logo{font-family:'Syne',sans-serif;font-size:1.35rem;font-weight:800;color:var(--text);text-decoration:none;letter-spacing:-0.5px;display:flex;align-items:center;gap:8px;flex-shrink:0;}
    .logo-icon{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.72rem;font-weight:800;color:#000;font-family:'Syne',sans-serif;}
    .logo span{color:var(--teal);}
    .nav-right{margin-left:auto;display:flex;align-items:center;gap:8px;}
    .nav-right a{text-decoration:none;font-size:0.875rem;color:var(--text-2);font-weight:500;padding:7px 14px;border-radius:8px;transition:all 0.2s;}
    .nav-right a:hover{color:var(--text);background:var(--glass-2);}
    .btn-danger{border:1px solid rgba(248,113,113,0.2)!important;color:#f87171!important;background:rgba(248,113,113,0.06)!important;}
    .btn-danger:hover{background:rgba(248,113,113,0.12)!important;border-color:rgba(248,113,113,0.35)!important;}

    .page{position:relative;z-index:1;max-width:1200px;margin:0 auto;padding:36px 48px 60px;}

    .alert{padding:13px 16px;border-radius:10px;font-size:0.875rem;margin-bottom:24px;}
    .alert-success{background:rgba(52,211,153,0.08);border:1px solid rgba(52,211,153,0.2);color:#34d399;}
    .alert-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:#f87171;}

    .profile-header{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:24px 32px;display:flex;align-items:center;gap:20px;margin-bottom:28px;backdrop-filter:blur(12px);animation:fadeUp 0.5s ease both;}
    .avatar{width:52px;height:52px;border-radius:50%;background:linear-gradient(135deg,#8b5cf6,#3b82f6);display:flex;align-items:center;justify-content:center;font-size:1.1rem;font-weight:700;color:#fff;flex-shrink:0;font-family:'Syne',sans-serif;}
    .profile-info h1{font-family:'Syne',sans-serif;font-size:1.2rem;font-weight:800;color:var(--text);}
    .profile-info p{color:var(--text-2);font-size:0.85rem;margin-top:3px;}
    .admin-badge{margin-left:auto;background:rgba(139,92,246,0.1);color:#c084fc;border:1px solid rgba(139,92,246,0.25);font-size:0.72rem;font-weight:700;padding:4px 12px;border-radius:99px;letter-spacing:0.5px;font-family:'Syne',sans-serif;}

    .stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:32px;}
    .stat-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:20px 24px;position:relative;overflow:hidden;transition:border-color 0.2s;}
    .stat-card:hover{border-color:rgba(255,255,255,0.12);}
    .stat-card::before{content:'';position:absolute;top:0;left:0;right:0;height:2px;}
    .stat-card.users::before  {background:linear-gradient(90deg,#8b5cf6,#a78bfa);}
    .stat-card.jobs::before   {background:linear-gradient(90deg,#3b82f6,#60a5fa);}
    .stat-card.active::before {background:linear-gradient(90deg,var(--teal),#00a8ff);}
    .stat-card.apps::before   {background:linear-gradient(90deg,#f59e0b,#fbbf24);}
    .stat-num{font-family:'Syne',sans-serif;font-size:2rem;font-weight:800;line-height:1;letter-spacing:-1px;}
    .stat-card.users  .stat-num{color:#a78bfa;}
    .stat-card.jobs   .stat-num{color:#60a5fa;}
    .stat-card.active .stat-num{color:var(--teal);}
    .stat-card.apps   .stat-num{color:#fbbf24;}
    .stat-label{font-size:0.72rem;color:var(--text-3);margin-top:6px;text-transform:uppercase;letter-spacing:0.05em;}

    .section-header{display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:14px;}
    .section-label{font-size:0.72rem;color:var(--teal);font-weight:600;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:4px;}
    .section-title{font-family:'Syne',sans-serif;font-size:1.3rem;font-weight:800;color:var(--text);letter-spacing:-0.3px;}
    .count-pill{background:var(--navy-4);border:1px solid var(--border);font-size:0.72rem;color:var(--text-2);padding:3px 10px;border-radius:99px;}

    .panel-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;margin-bottom:32px;backdrop-filter:blur(8px);}
    .panel-header{padding:14px 24px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;background:rgba(255,255,255,0.02);}
    .panel-header-title{font-size:0.875rem;font-weight:600;color:var(--text);}

    .pending-row{display:flex;align-items:center;gap:16px;padding:16px 24px;border-bottom:1px solid var(--border);transition:background 0.15s;}
    .pending-row:last-child{border-bottom:none;}
    .pending-row:hover{background:var(--glass-2);}
    .job-info{flex:1;min-width:0;}
    .job-title-text{font-size:0.9rem;font-weight:600;color:var(--text);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
    .job-meta{font-size:0.78rem;color:var(--text-3);margin-top:3px;}
    .action-btns{display:flex;gap:8px;flex-shrink:0;}

    .btn-approve{font-size:0.78rem;padding:6px 14px;background:rgba(52,211,153,0.08);color:#34d399;border:1px solid rgba(52,211,153,0.2);border-radius:8px;cursor:pointer;font-weight:600;font-family:inherit;transition:all 0.2s;}
    .btn-approve:hover{background:rgba(52,211,153,0.15);border-color:rgba(52,211,153,0.35);}
    .btn-reject{font-size:0.78rem;padding:6px 14px;background:rgba(248,113,113,0.06);color:#f87171;border:1px solid rgba(248,113,113,0.15);border-radius:8px;cursor:pointer;font-weight:600;font-family:inherit;transition:all 0.2s;}
    .btn-reject:hover{background:rgba(248,113,113,0.12);border-color:rgba(248,113,113,0.3);}

    .empty-state{padding:40px 24px;text-align:center;color:var(--text-3);font-size:0.875rem;}

    table{width:100%;border-collapse:collapse;}
    thead{background:rgba(255,255,255,0.02);}
    th{padding:12px 20px;text-align:left;font-size:0.7rem;font-weight:600;text-transform:uppercase;letter-spacing:0.08em;color:var(--text-3);border-bottom:1px solid var(--border);}
    td{padding:14px 20px;font-size:0.875rem;border-bottom:1px solid var(--border);color:var(--text-2);}
    tr:last-child td{border-bottom:none;}
    tr:hover td{background:var(--glass-2);}
    td.name-col{color:var(--text);font-weight:500;}

    .role-badge{font-size:0.68rem;font-weight:700;padding:3px 10px;border-radius:99px;letter-spacing:0.3px;}
    .role-seeker  {background:rgba(59,130,246,0.1);color:#60a5fa;border:1px solid rgba(59,130,246,0.2);}
    .role-employer{background:rgba(245,158,11,0.1);color:#fbbf24;border:1px solid rgba(245,158,11,0.2);}
    .role-admin   {background:rgba(139,92,246,0.1);color:#c084fc;border:1px solid rgba(139,92,246,0.2);}

    .status-dot{display:inline-block;width:6px;height:6px;border-radius:50%;margin-right:6px;vertical-align:middle;}
    .dot-active{background:#34d399;}
    .dot-inactive{background:#f87171;}

    @media(max-width:1024px){.page{padding-left:24px;padding-right:24px;}}
    @media(max-width:768px){nav{padding:0 16px;}.stats-row{grid-template-columns:1fr 1fr;}.page{padding:20px 16px 40px;}}
  </style>
</head>
<body>

<div class="bg-orb orb-1"></div>
<div class="bg-orb orb-2"></div>

<nav>
  <a href="${pageContext.request.contextPath}/home" class="logo">
    <div class="logo-icon">HF</div>
    Hire<span>Flow</span>
  </a>
  <div class="nav-right">
    <a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-danger">Logout</a>
  </div>
</nav>

<div class="page">

  <c:if test="${not empty success}">
    <div class="alert alert-success">✅ <c:out value="${success}"/></div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-error">⚠️ <c:out value="${error}"/></div>
  </c:if>

  <div class="profile-header">
    <div class="avatar">${adminInitial}</div>
    <div class="profile-info">
      <h1>Admin Panel</h1>
      <p>Logged in as <c:out value="${sessionScope.userName}"/> · Full platform access</p>
    </div>
    <span class="admin-badge">ADMIN</span>
  </div>

  <div class="stats-row fade-up">
    <div class="stat-card users">
      <div class="stat-num">${totalUsers}</div>
      <div class="stat-label">Total Users</div>
    </div>
    <div class="stat-card jobs">
      <div class="stat-num">${totalJobs}</div>
      <div class="stat-label">Total Jobs</div>
    </div>
    <div class="stat-card active">
      <div class="stat-num">${totalActive}</div>
      <div class="stat-label">Active Jobs</div>
    </div>
    <div class="stat-card apps">
      <div class="stat-num">${totalApplications}</div>
      <div class="stat-label">Applications</div>
    </div>
  </div>

  <div class="fade-up">
    <div class="section-header">
      <div>
        <div class="section-label">Approvals</div>
        <div class="section-title">Pending Job Reviews</div>
      </div>
      <span class="count-pill">${pendingJobs.size()} pending</span>
    </div>
    <div class="panel-card">
      <div class="panel-header">
        <span class="panel-header-title">Jobs awaiting review</span>
      </div>
      <c:choose>
        <c:when test="${empty pendingJobs}">
          <div class="empty-state">✅ All caught up — no pending jobs!</div>
        </c:when>
        <c:otherwise>
          <c:forEach var="job" items="${pendingJobs}">
            <div class="pending-row">
              <div class="job-info">
                <div class="job-title-text"><c:out value="${job.title}"/></div>
                <div class="job-meta">
                  <c:out value="${job.companyName}"/>
                  <c:if test="${not empty job.location}"> · <c:out value="${job.location}"/></c:if>
                  · ${job.postedAtFormatted}
                </div>
              </div>
              <div class="action-btns">
                <form action="${pageContext.request.contextPath}/admin/job/status" method="post" style="display:inline">
                  <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                  <input type="hidden" name="jobId" value="${job.jobId}"/>
                  <input type="hidden" name="status" value="active"/>
                  <button type="submit" class="btn-approve">✓ Approve</button>
                </form>
                <form action="${pageContext.request.contextPath}/admin/job/status" method="post" style="display:inline" onsubmit="return confirm('Reject this job?')">
                  <input type="hidden" name="csrfToken" value="${csrfToken}"/>
                  <input type="hidden" name="jobId" value="${job.jobId}"/>
                  <input type="hidden" name="status" value="closed"/>
                  <button type="submit" class="btn-reject">✕ Reject</button>
                </form>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

  <div class="fade-up">
    <div class="section-header">
      <div>
        <div class="section-label">Users</div>
        <div class="section-title">All Registered Users</div>
      </div>
      <span class="count-pill">${totalUsers} total</span>
    </div>
    <div class="panel-card">
      <c:choose>
        <c:when test="${empty allUsers}">
          <div class="empty-state">No users found.</div>
        </c:when>
        <c:otherwise>
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Joined</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="user" items="${allUsers}">
                <tr>
                  <td class="name-col"><c:out value="${user.fullName}"/></td>
                  <td><c:out value="${user.email}"/></td>
                  <td><span class="role-badge role-${user.role}">${user.role}</span></td>
                  <td>
                    <span class="status-dot ${user.active ? 'dot-active' : 'dot-inactive'}"></span>
                    ${user.active ? 'Active' : 'Inactive'}
                  </td>
                  <td>${user.createdAtFormatted}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

</div>

<script>
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => { if(e.isIntersecting) e.target.classList.add('visible'); });
  }, {threshold: 0.08});
  document.querySelectorAll('.fade-up').forEach(el => observer.observe(el));
</script>
</body>
</html>
