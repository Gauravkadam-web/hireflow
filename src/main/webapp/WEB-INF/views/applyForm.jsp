<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Apply — <c:out value="${job.title}"/> — HireFlow</title>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Instrument+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
:root{
  --navy:#080c14;--navy-2:#0d1422;--navy-3:#111827;--navy-4:#1a2236;
  --teal:#00d4aa;--teal-dim:#00b894;
  --teal-glow:rgba(0,212,170,0.15);--teal-glow-2:rgba(0,212,170,0.06);
  --blue-accent:#3b82f6;
  --text:#f0f4ff;--text-2:#94a3b8;--text-3:#4a5568;
  --border:rgba(255,255,255,0.07);--border-bright:rgba(0,212,170,0.3);
  --glass:rgba(255,255,255,0.03);--glass-2:rgba(255,255,255,0.06);
  --radius:14px;--radius-lg:20px;
  --red:#ef4444;
}
html{scroll-behavior:smooth;}
body{font-family:'Instrument Sans',sans-serif;background:var(--navy);color:var(--text);min-height:100vh;overflow-x:hidden;}
body::before{content:'';position:fixed;inset:0;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");pointer-events:none;z-index:0;opacity:0.4;}
.bg-orb{position:fixed;border-radius:50%;filter:blur(120px);pointer-events:none;z-index:0;}
.orb-1{width:500px;height:500px;background:radial-gradient(circle,rgba(0,212,170,0.10),transparent 70%);top:-150px;right:-100px;animation:orbFloat 12s ease-in-out infinite;}
.orb-2{width:400px;height:400px;background:radial-gradient(circle,rgba(59,130,246,0.07),transparent 70%);bottom:5%;left:-100px;animation:orbFloat 16s ease-in-out infinite reverse;}
@keyframes orbFloat{0%,100%{transform:translateY(0) scale(1);}50%{transform:translateY(-24px) scale(1.04);}}

/* ── NAV ── */
nav{position:sticky;top:0;z-index:100;display:flex;align-items:center;gap:32px;padding:0 48px;height:66px;background:rgba(8,12,20,0.85);backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);border-bottom:1px solid var(--border);}
.logo{font-family:'Syne',sans-serif;font-size:1.35rem;font-weight:800;color:var(--text);text-decoration:none;letter-spacing:-0.5px;display:flex;align-items:center;gap:8px;}
.logo-icon{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:800;color:#000;}
.logo span{color:var(--teal);}
.nav-right{margin-left:auto;display:flex;align-items:center;gap:8px;}
.nav-right a{text-decoration:none;font-size:0.875rem;color:var(--text-2);font-weight:500;padding:7px 14px;border-radius:8px;transition:all 0.2s;}
.nav-right a:hover{color:var(--text);background:var(--glass-2);}

/* ── PAGE ── */
.page{position:relative;z-index:1;max-width:740px;margin:0 auto;padding:40px 24px 80px;}

.back-link{display:inline-flex;align-items:center;gap:6px;font-size:0.85rem;color:var(--text-2);text-decoration:none;margin-bottom:28px;transition:color 0.15s;}
.back-link:hover{color:var(--teal);}
.back-link svg{width:16px;height:16px;}

/* ── JOB BANNER ── */
.job-banner{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:20px 24px;display:flex;align-items:center;gap:16px;margin-bottom:28px;backdrop-filter:blur(12px);}
.company-avatar{width:48px;height:48px;border-radius:10px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:700;color:#000;flex-shrink:0;}
.job-banner-title{font-size:1rem;font-weight:600;color:var(--text);}
.job-banner-meta{font-size:0.8rem;color:var(--text-2);margin-top:3px;}
.job-banner-badge{margin-left:auto;padding:4px 12px;border-radius:20px;font-size:0.75rem;font-weight:600;background:var(--teal-glow);color:var(--teal);border:1px solid var(--border-bright);}

/* ── FORM CARD ── */
.form-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius-lg);overflow:hidden;backdrop-filter:blur(12px);}

.form-header{padding:28px 32px;border-bottom:1px solid var(--border);background:linear-gradient(135deg,rgba(0,212,170,0.06),rgba(0,168,255,0.04));}
.form-header h1{font-family:'Syne',sans-serif;font-size:1.4rem;font-weight:700;color:var(--text);}
.form-header p{font-size:0.85rem;color:var(--text-2);margin-top:6px;}

.form-body{padding:32px;}

.form-group{margin-bottom:24px;}

label{display:block;font-size:0.85rem;font-weight:600;margin-bottom:8px;color:var(--text-2);letter-spacing:0.3px;}
.required{color:var(--red);margin-left:2px;}
.hint{font-size:0.75rem;color:var(--text-3);font-weight:400;margin-left:6px;}

input[type="text"],
input[type="tel"],
input[type="url"],
textarea{
  width:100%;
  padding:12px 16px;
  background:rgba(255,255,255,0.04);
  border:1px solid var(--border);
  border-radius:10px;
  font-family:'Instrument Sans',sans-serif;
  font-size:0.9rem;
  color:var(--text);
  transition:border-color 0.2s,box-shadow 0.2s;
  outline:none;
}
input::placeholder,textarea::placeholder{color:var(--text-3);}
input:focus,textarea:focus{
  border-color:var(--teal-dim);
  box-shadow:0 0 0 3px var(--teal-glow);
  background:rgba(0,212,170,0.03);
}
textarea{resize:vertical;min-height:150px;line-height:1.7;}

/* ── FILE UPLOAD ── */
.file-upload-area{
  border:2px dashed var(--border);
  border-radius:12px;
  padding:32px;
  text-align:center;
  cursor:pointer;
  transition:border-color 0.2s,background 0.2s;
  position:relative;
}
.file-upload-area:hover,.file-upload-area.dragover{
  border-color:var(--teal-dim);
  background:var(--teal-glow-2);
}
.file-upload-area input[type="file"]{position:absolute;inset:0;opacity:0;cursor:pointer;width:100%;height:100%;}
.file-icon{font-size:2rem;margin-bottom:10px;}
.file-upload-text{font-size:0.9rem;font-weight:500;color:var(--text);}
.file-upload-hint{font-size:0.75rem;color:var(--text-3);margin-top:5px;}
.file-name{font-size:0.8rem;color:var(--teal);margin-top:8px;font-weight:600;}

/* ── DIVIDER ── */
.or-divider{display:flex;align-items:center;gap:12px;margin:16px 0;color:var(--text-3);font-size:0.8rem;}
.or-divider::before,.or-divider::after{content:'';flex:1;height:1px;background:var(--border);}

/* ── BUTTONS ── */
.form-footer{display:flex;gap:12px;align-items:center;padding-top:8px;}

.btn-submit{
  padding:13px 32px;
  background:var(--teal);
  color:#000;
  font-family:'Syne',sans-serif;
  font-size:0.9rem;
  font-weight:700;
  border:none;
  border-radius:10px;
  cursor:pointer;
  transition:background 0.15s,transform 0.1s,box-shadow 0.2s;
  letter-spacing:0.2px;
}
.btn-submit:hover{background:var(--teal-dim);transform:translateY(-1px);box-shadow:0 4px 20px rgba(0,212,170,0.3);}
.btn-submit:active{transform:translateY(0);}

.btn-cancel{
  padding:13px 24px;
  background:var(--glass);
  color:var(--text-2);
  font-size:0.9rem;
  border:1px solid var(--border);
  border-radius:10px;
  text-decoration:none;
  transition:all 0.15s;
  font-family:'Instrument Sans',sans-serif;
}
.btn-cancel:hover{border-color:var(--border-bright);color:var(--text);}

/* ── ERROR ── */
.error-msg{
  background:rgba(239,68,68,0.08);
  border:1px solid rgba(239,68,68,0.25);
  color:#fca5a5;
  padding:14px 18px;
  border-radius:var(--radius);
  font-size:0.875rem;
  margin-bottom:24px;
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
    <a href="${pageContext.request.contextPath}/dashboard/seeker">Dashboard</a>
  </div>
</nav>

<div class="page">

  <!-- Back -->
  <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}" class="back-link">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 12H5M5 12l7 7M5 12l7-7"/></svg>
    Back to job
  </a>

  <!-- Job Banner -->
  <div class="job-banner">
    <div class="company-avatar">${jobInitial}</div>
    <div>
      <div class="job-banner-title"><c:out value="${job.title}"/></div>
      <div class="job-banner-meta">
        <c:out value="${job.companyName}"/>
        <c:if test="${not empty job.location}"> · <c:out value="${job.location}"/></c:if>
        <c:if test="${not empty job.jobType}"> · <c:out value="${job.jobType}"/></c:if>
      </div>
    </div>
    <div class="job-banner-badge">Applying</div>
  </div>

  <!-- Error -->
  <c:if test="${not empty error}">
    <div class="error-msg">⚠ <c:out value="${error}"/></div>
  </c:if>

  <!-- Form Card -->
  <div class="form-card">
    <div class="form-header">
      <h1>Submit Your Application</h1>
      <p>Fill in the details below — it takes less than 2 minutes.</p>
    </div>

    <div class="form-body">
      <form action="${pageContext.request.contextPath}/apply"
            method="post"
            enctype="multipart/form-data">
        <input type="hidden" name="csrfToken" value="${csrfToken}"/>
        <input type="hidden" name="jobId" value="${job.jobId}"/>

        <!-- Phone -->
        <div class="form-group">
          <label for="phone">
            Phone Number
            <span class="hint">(optional)</span>
          </label>
          <input type="tel" id="phone" name="phone"
                 placeholder="+91 98765 43210"
                 value="<c:out value='${param.phone}'/>">
        </div>

        <!-- Cover Letter -->
        <div class="form-group">
          <label for="coverLetter">
            Cover Letter <span class="required">*</span>
            <span class="hint">(tell them why you're a great fit)</span>
          </label>
          <textarea id="coverLetter" name="coverLetter"
                    placeholder="Dear Hiring Manager, I am excited to apply for this position because..."
                    required><c:out value="${param.coverLetter}"/></textarea>
        </div>

        <!-- Resume -->
        <div class="form-group">
          <label>Resume <span class="hint">(upload a file or paste a link below)</span></label>

          <div class="file-upload-area" id="uploadArea">
            <input type="file" name="resumeFile" id="resumeFile"
                   accept=".pdf,.doc,.docx"
                   onchange="handleFileSelect(this)">
            <div class="file-icon">📄</div>
            <div class="file-upload-text">Drop your resume here or click to browse</div>
            <div class="file-upload-hint">PDF, DOC, DOCX · Max 5 MB</div>
            <div class="file-name" id="fileName"></div>
          </div>

          <div class="or-divider">or paste a link</div>

          <input type="url" name="resumeUrl" id="resumeUrl"
                 placeholder="https://drive.google.com/your-resume"
                 value="<c:out value='${param.resumeUrl}'/>">
        </div>

        <!-- Submit -->
        <div class="form-footer">
          <button type="submit" class="btn-submit">Submit Application</button>
          <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}" class="btn-cancel">Cancel</a>
        </div>

      </form>
    </div>
  </div>

</div>

<script>
function handleFileSelect(input) {
  const name = input.files[0] ? input.files[0].name : '';
  document.getElementById('fileName').textContent = name ? '✓ ' + name : '';
  if (name) {
    document.getElementById('resumeUrl').value = '';
    document.getElementById('uploadArea').style.borderColor = 'var(--teal-dim)';
    document.getElementById('uploadArea').style.background = 'var(--teal-glow-2)';
  }
}
const area = document.getElementById('uploadArea');
area.addEventListener('dragover', e => { e.preventDefault(); area.classList.add('dragover'); });
area.addEventListener('dragleave', () => area.classList.remove('dragover'));
area.addEventListener('drop', e => { e.preventDefault(); area.classList.remove('dragover'); });
</script>

</body>
</html>
