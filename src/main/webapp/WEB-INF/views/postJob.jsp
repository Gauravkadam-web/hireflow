<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Post a Job — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Instrument+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
:root{
  --navy:#080c14;--navy-2:#0d1422;--navy-3:#111827;--navy-4:#1a2236;
  --teal:#00d4aa;--teal-glow:rgba(0,212,170,0.15);--teal-glow-2:rgba(0,212,170,0.06);
  --text:#f0f4ff;--text-2:#94a3b8;--text-3:#4a5568;
  --border:rgba(255,255,255,0.07);--border-bright:rgba(0,212,170,0.3);
  --glass:rgba(255,255,255,0.03);--glass-2:rgba(255,255,255,0.06);
  --red-glow:rgba(248,113,113,0.15);
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

/* PAGE */
.page{position:relative;z-index:1;max-width:780px;margin:0 auto;padding:36px 48px 60px;}
.breadcrumb{display:flex;align-items:center;gap:8px;font-size:0.78rem;color:var(--text-3);margin-bottom:24px;}
.breadcrumb a{color:var(--text-3);text-decoration:none;transition:color 0.2s;}
.breadcrumb a:hover{color:var(--teal);}

/* FORM CARD */
.form-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;}
.form-header{padding:28px 32px;border-bottom:1px solid var(--border);background:linear-gradient(135deg,var(--navy-4),var(--navy-3));}
.form-header h1{font-family:'Syne',sans-serif;font-size:1.3rem;font-weight:800;color:var(--text);letter-spacing:-0.3px;}
.form-header p{font-size:0.85rem;color:var(--text-2);margin-top:6px;line-height:1.5;}
.form-body{padding:32px;display:flex;flex-direction:column;gap:20px;}

/* NOTICE */
.notice{padding:12px 16px;background:rgba(245,158,11,0.06);border:1px solid rgba(245,158,11,0.2);border-radius:10px;font-size:0.82rem;color:#fbbf24;display:flex;align-items:flex-start;gap:10px;line-height:1.5;}

/* FORM ELEMENTS */
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
.form-group{display:flex;flex-direction:column;gap:7px;}
label{font-size:0.82rem;font-weight:600;color:var(--text-2);letter-spacing:0.2px;}
.required{color:#f87171;margin-left:2px;}
.hint{font-size:0.75rem;color:var(--text-3);font-weight:400;margin-left:4px;}

input[type="text"],
input[type="number"],
select,
textarea{
  width:100%;padding:11px 14px;
  background:var(--navy-3);
  border:1px solid var(--border);
  border-radius:10px;
  font-family:'Instrument Sans',sans-serif;
  font-size:0.875rem;
  color:var(--text);
  transition:all 0.2s;
  outline:none;
  appearance:none;
  -webkit-appearance:none;
}
input::placeholder,textarea::placeholder{color:var(--text-3);}
input:focus,select:focus,textarea:focus{
  border-color:var(--border-bright);
  background:var(--navy-2);
  box-shadow:0 0 0 3px var(--teal-glow);
}
select option{background:var(--navy-3);color:var(--text);}
textarea{resize:vertical;min-height:160px;line-height:1.7;}

/* SELECT WRAPPER */
.select-wrap{position:relative;}
.select-wrap::after{content:'';position:absolute;right:14px;top:50%;transform:translateY(-50%);width:0;height:0;border-left:4px solid transparent;border-right:4px solid transparent;border-top:5px solid var(--text-3);pointer-events:none;}

/* SALARY */
.salary-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
.salary-prefix{position:relative;}
.salary-prefix::before{content:'₹';position:absolute;left:14px;top:50%;transform:translateY(-50%);color:var(--text-3);font-size:0.875rem;pointer-events:none;z-index:1;}
.salary-prefix input{padding-left:28px;}

/* CHAR COUNTER */
.field-footer{display:flex;justify-content:space-between;align-items:center;}
.char-count{font-size:0.72rem;color:var(--text-3);}

/* FORM FOOTER */
.form-footer{display:flex;gap:12px;align-items:center;padding-top:4px;border-top:1px solid var(--border);margin-top:4px;}
.btn-submit{padding:12px 32px;background:var(--teal);color:#000;font-size:0.95rem;font-weight:700;font-family:'Syne',sans-serif;border:none;border-radius:10px;cursor:pointer;transition:all 0.2s;display:flex;align-items:center;gap:8px;}
.btn-submit:hover{background:#00f0c0;box-shadow:0 0 24px rgba(0,212,170,0.4);}
.btn-submit:active{transform:scale(0.97);}
.spinner{width:16px;height:16px;border:2px solid rgba(0,0,0,0.25);border-top-color:#000;border-radius:50%;animation:spin 0.6s linear infinite;display:none;flex-shrink:0;}
.btn-submit.loading .spinner{display:block;}
.btn-submit.loading .btn-text{display:none;}
.btn-submit.loading{opacity:0.75;pointer-events:none;}
@keyframes spin{to{transform:rotate(360deg);}}
.btn-cancel{padding:12px 24px;background:transparent;color:var(--text-2);font-size:0.9rem;font-weight:500;border:1px solid var(--border);border-radius:10px;text-decoration:none;transition:all 0.2s;display:inline-flex;align-items:center;}
.btn-cancel:hover{border-color:var(--border-bright);color:var(--teal);}

/* ALERT */
.alert-error{padding:12px 16px;background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:#f87171;border-radius:10px;font-size:0.875rem;margin-bottom:4px;}

/* RESPONSIVE */
@media(max-width:1024px){.page{padding-left:24px;padding-right:24px;}}
@media(max-width:600px){
  nav{padding:0 16px;}
  .page{padding:20px 16px 40px;}
  .form-row,.salary-row{grid-template-columns:1fr;}
  .form-body{padding:20px;}
  .form-header{padding:20px;}
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
    <a href="${pageContext.request.contextPath}/dashboard/employer">Dashboard</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-ghost">Logout</a>
  </div>
</nav>

<div class="page">

  <!-- BREADCRUMB -->
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a>
    &nbsp;›&nbsp;
    <a href="${pageContext.request.contextPath}/dashboard/employer">Dashboard</a>
    &nbsp;›&nbsp;
    Post a Job
  </div>

  <c:if test="${not empty error}">
    <div class="alert-error">⚠️ <c:out value="${error}"/></div>
  </c:if>

  <div class="form-card">
    <div class="form-header">
      <h1>Post a New Job</h1>
      <p>Fill in the details below. Your listing will be reviewed by our team before going live.</p>
    </div>

    <div class="form-body">

<div class="notice">
  ℹ️ &nbsp;Jobs are initially set to "pending" status and require admin approval before appearing in public listings.
</div>

      <form action="${pageContext.request.contextPath}/jobs/create"
            method="post" id="postJobForm" novalidate>
        <input type="hidden" name="csrfToken" value="${csrfToken}"/>

        <div style="display:flex;flex-direction:column;gap:20px;">

          <%-- JOB TITLE --%>
          <div class="form-group">
            <label for="title">Job Title <span class="required">*</span></label>
            <input type="text" id="title" name="title" required
                   placeholder="e.g. Senior Java Backend Developer"
                   value="<c:out value='${param.title}'/>"
                   maxlength="200"/>
          </div>

          <%-- LOCATION + JOB TYPE --%>
          <div class="form-row">
            <div class="form-group">
              <label for="location">Location <span class="required">*</span></label>
              <input type="text" id="location" name="location" required
                     placeholder="e.g. Pune, Maharashtra"
                     value="<c:out value='${param.location}'/>"/>
            </div>
            <div class="form-group">
              <label for="jobType">Job Type</label>
              <div class="select-wrap">
                <select id="jobType" name="jobType">
                  <option value="full-time"  ${param.jobType == 'full-time'  ? 'selected' : ''}>Full-Time</option>
                  <option value="part-time"  ${param.jobType == 'part-time'  ? 'selected' : ''}>Part-Time</option>
                  <option value="contract"   ${param.jobType == 'contract'   ? 'selected' : ''}>Contract</option>
                  <option value="remote"     ${param.jobType == 'remote'     ? 'selected' : ''}>Remote</option>
                </select>
              </div>
            </div>
          </div>

          <%-- CATEGORY --%>
          <div class="form-group">
            <label for="categoryId">Category <span class="hint">(optional)</span></label>
            <div class="select-wrap">
              <select id="categoryId" name="categoryId">
                <option value="">— Select a category —</option>
                <c:forEach var="cat" items="${categories}">
                  <option value="${cat.categoryId}">
                    <c:out value="${cat.name}"/>
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>

          <%-- SALARY --%>
          <div class="form-group">
            <label>Salary Range <span class="hint">(LPA — optional)</span></label>
            <div class="salary-row">
              <div class="salary-prefix">
                <input type="number" name="salaryMin" placeholder="Min e.g. 8"
                       min="0" step="0.5"
                       value="<c:out value='${param.salaryMin}'/>"/>
              </div>
              <div class="salary-prefix">
                <input type="number" name="salaryMax" placeholder="Max e.g. 18"
                       min="0" step="0.5"
                       value="<c:out value='${param.salaryMax}'/>"/>
              </div>
            </div>
          </div>

          <%-- DESCRIPTION --%>
          <div class="form-group">
            <div class="field-footer">
              <label for="description">Job Description <span class="required">*</span></label>
              <span class="char-count" id="charCount">0 / 5000</span>
            </div>
            <textarea id="description" name="description" required
                      placeholder="Describe the role, key responsibilities, required skills, experience level, and what makes this opportunity unique..."
                      maxlength="5000"
                      oninput="updateCharCount(this)"><c:out value="${param.description}"/></textarea>
          </div>

          <%-- FORM FOOTER --%>
          <div class="form-footer">
            <button type="submit" class="btn-submit" id="submitBtn">
              <div class="spinner"></div>
              <span class="btn-text">Post Job</span>
            </button>
            <a href="${pageContext.request.contextPath}/dashboard/employer" class="btn-cancel">
              Cancel
            </a>
          </div>

        </div>
      </form>
    </div>
  </div>
</div>

<script>
function updateCharCount(el) {
  document.getElementById('charCount').textContent = el.value.length + ' / ' + el.maxLength;
}

// Init count if form data preserved on error
const desc = document.getElementById('description');
if (desc && desc.value.length > 0) updateCharCount(desc);

// Loading state on submit
document.getElementById('postJobForm').addEventListener('submit', function(e) {
  const title = document.getElementById('title').value.trim();
  const loc   = document.getElementById('location').value.trim();
  const desc  = document.getElementById('description').value.trim();
  if (!title || !loc || !desc) return; // let browser handle required
  document.getElementById('submitBtn').classList.add('loading');
});
</script>
</body>
</html>
