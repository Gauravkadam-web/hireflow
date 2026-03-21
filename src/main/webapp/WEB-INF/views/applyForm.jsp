<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply — <c:out value="${job.title}"/> — HireFlow</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Serif+Display&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:        #f5f5f0;
            --surface:   #ffffff;
            --border:    #e8e8e2;
            --text:      #1a1a1a;
            --muted:     #6b6b6b;
            --accent:    #00c896;
            --accent-dk: #009e78;
            --red:       #ef4444;
            --radius:    12px;
            --shadow:    0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04);
        }

        body { font-family: 'DM Sans', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        nav {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 0 32px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo { font-family: 'DM Serif Display', serif; font-size: 22px; color: var(--text); text-decoration: none; }
        .logo span { color: var(--accent); }
        nav a { font-size: 14px; color: var(--muted); text-decoration: none; padding: 6px 14px; border-radius: 8px; }
        nav a:hover { background: var(--bg); color: var(--text); }

        .page { max-width: 720px; margin: 0 auto; padding: 36px 24px; }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            color: var(--muted);
            text-decoration: none;
            margin-bottom: 24px;
        }

        .back-link:hover { color: var(--text); }

        /* Job summary banner */
        .job-banner {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 20px 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
            box-shadow: var(--shadow);
        }

        .company-logo {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            background: var(--bg);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 600;
            color: var(--muted);
            flex-shrink: 0;
        }

        .job-banner-title { font-size: 17px; font-weight: 500; }
        .job-banner-meta { font-size: 13px; color: var(--muted); margin-top: 3px; }

        /* Form card */
        .form-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .form-header {
            padding: 24px 32px;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
        }

        .form-header h1 {
            font-family: 'DM Serif Display', serif;
            font-size: 22px;
            font-weight: 400;
        }

        .form-header p { font-size: 14px; color: var(--muted); margin-top: 4px; }

        .form-body { padding: 32px; }

        .form-group { margin-bottom: 24px; }

        label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 8px;
            color: var(--text);
        }

        .required { color: var(--red); margin-left: 2px; }

        .hint { font-size: 12px; color: var(--muted); font-weight: 400; margin-left: 6px; }

        input[type="text"],
        input[type="tel"],
        input[type="url"],
        textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            color: var(--text);
            background: var(--surface);
            transition: border-color 0.15s, box-shadow 0.15s;
            outline: none;
        }

        input:focus, textarea:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(0, 200, 150, 0.12);
        }

        textarea { resize: vertical; min-height: 140px; line-height: 1.6; }

        /* File upload */
        .file-upload-area {
            border: 2px dashed var(--border);
            border-radius: 10px;
            padding: 28px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
            position: relative;
        }

        .file-upload-area:hover,
        .file-upload-area.dragover {
            border-color: var(--accent);
            background: #f0fdf4;
        }

        .file-upload-area input[type="file"] {
            position: absolute;
            inset: 0;
            opacity: 0;
            cursor: pointer;
            width: 100%;
            height: 100%;
        }

        .file-icon { font-size: 28px; margin-bottom: 10px; }
        .file-upload-text { font-size: 14px; font-weight: 500; }
        .file-upload-hint { font-size: 12px; color: var(--muted); margin-top: 4px; }
        .file-name { font-size: 13px; color: var(--accent); margin-top: 8px; font-weight: 500; }

        /* Divider */
        .or-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 16px 0;
            color: var(--muted);
            font-size: 13px;
        }

        .or-divider::before,
        .or-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        /* Submit */
        .form-footer {
            display: flex;
            gap: 12px;
            align-items: center;
            padding-top: 8px;
        }

        .btn-submit {
            padding: 14px 32px;
            background: var(--accent);
            color: white;
            font-size: 15px;
            font-weight: 500;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.15s, transform 0.1s;
        }

        .btn-submit:hover { background: var(--accent-dk); transform: translateY(-1px); }
        .btn-submit:active { transform: translateY(0); }

        .btn-cancel {
            padding: 14px 24px;
            background: var(--bg);
            color: var(--muted);
            font-size: 15px;
            border: 1px solid var(--border);
            border-radius: 10px;
            text-decoration: none;
            transition: background 0.15s;
        }

        .btn-cancel:hover { background: #eee; color: var(--text); }

        .error-msg {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #991b1b;
            padding: 14px 18px;
            border-radius: var(--radius);
            font-size: 14px;
            margin-bottom: 24px;
        }
    </style>
</head>
<body>

<nav>
    <a href="${pageContext.request.contextPath}/" class="logo">Hire<span>Flow</span></a>
    <div style="display:flex;gap:8px">
        <a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
        <a href="${pageContext.request.contextPath}/dashboard/seeker">Dashboard</a>
    </div>
</nav>

<div class="page">

    <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}" class="back-link">
        ← Back to job
    </a>

    <!-- Job Summary Banner -->
    <div class="job-banner">
        <div class="company-logo">${jobInitial}</div>
        <div>
            <div class="job-banner-title"><c:out value="${job.title}"/></div>
            <div class="job-banner-meta">
                <c:out value="${job.companyName}"/>
                <c:if test="${not empty job.location}"> · <c:out value="${job.location}"/></c:if>
                <c:if test="${not empty job.jobType}"> · <c:out value="${job.jobType}"/></c:if>
            </div>
        </div>
    </div>

    <!-- Error -->
    <c:if test="${not empty error}">
        <div class="error-msg">⚠️ <c:out value="${error}"/></div>
    </c:if>

    <!-- Application Form -->
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
                <!-- Hidden job ID -->
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

                <!-- Resume Upload -->
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
                    <button type="submit" class="btn-submit">
                        Submit Application
                    </button>
                    <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}"
                       class="btn-cancel">Cancel</a>
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
            document.getElementById('uploadArea').style.borderColor = 'var(--accent)';
            document.getElementById('uploadArea').style.background = '#f0fdf4';
        }
    }

    // Drag and drop highlight
    const area = document.getElementById('uploadArea');
    area.addEventListener('dragover', e => { e.preventDefault(); area.classList.add('dragover'); });
    area.addEventListener('dragleave', () => area.classList.remove('dragover'));
    area.addEventListener('drop', e => { e.preventDefault(); area.classList.remove('dragover'); });
</script>

</body>
</html>
