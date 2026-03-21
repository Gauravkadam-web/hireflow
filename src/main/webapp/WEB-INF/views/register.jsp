<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HireFlow — Create Account</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;500;600;700;800&family=Instrument+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
    :root{
      --navy:#080c14;--navy-2:#0d1422;
      --teal:#00d4aa;--teal-glow:rgba(0,212,170,0.15);--teal-glow-2:rgba(0,212,170,0.06);
      --text:#f0f4ff;--text-2:#94a3b8;--text-3:#4a5568;
      --border:rgba(255,255,255,0.07);--border-bright:rgba(0,212,170,0.3);
      --glass:rgba(255,255,255,0.03);--glass-2:rgba(255,255,255,0.06);
      --red-glow:rgba(248,113,113,0.15);
    }
    body{font-family:'Instrument Sans',sans-serif;background:var(--navy);color:var(--text);min-height:100vh;display:flex;align-items:flex-start;justify-content:center;overflow-x:hidden;overflow-y:auto;padding:24px 0;}
    canvas#particles{position:fixed;inset:0;z-index:0;pointer-events:none;}

    @keyframes fadeUp{from{opacity:0;transform:translateY(28px);}to{opacity:1;transform:translateY(0);}}
    @keyframes logoPulse{0%,100%{box-shadow:0 0 0 0 rgba(0,212,170,0.4);}50%{box-shadow:0 0 0 12px rgba(0,212,170,0);}}
    @keyframes shake{0%,100%{transform:translateX(0);}20%,60%{transform:translateX(-6px);}40%,80%{transform:translateX(6px);}}
    @keyframes spin{to{transform:rotate(360deg);}}

    .wrapper{position:relative;z-index:1;display:flex;width:100%;max-width:900px;margin:24px;border-radius:24px;overflow:hidden;border:1px solid var(--border);animation:fadeUp 0.6s ease both;box-shadow:0 32px 80px rgba(0,0,0,0.6);}

    /* Left Panel */
    .left-panel{flex:1;background:linear-gradient(150deg,#091525 0%,#0b1d38 55%,#080f1e 100%);padding:44px 40px;display:flex;flex-direction:column;border-right:1px solid var(--border);position:relative;overflow:hidden;}
    .left-panel::before{content:'';position:absolute;top:-100px;right:-100px;width:280px;height:280px;background:radial-gradient(circle,rgba(0,212,170,0.09),transparent 70%);pointer-events:none;}
    .left-panel::after{content:'';position:absolute;bottom:-80px;left:-60px;width:220px;height:220px;background:radial-gradient(circle,rgba(59,130,246,0.07),transparent 70%);pointer-events:none;}

    .brand{font-family:'Syne',sans-serif;font-size:1.5rem;font-weight:800;color:var(--text);letter-spacing:-0.5px;display:flex;align-items:center;gap:10px;}
    .logo-icon{width:36px;height:36px;border-radius:10px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.72rem;font-weight:800;color:#000;font-family:'Syne',sans-serif;animation:logoPulse 3s ease-in-out infinite;flex-shrink:0;}
    .brand-name span{color:var(--teal);}

    .left-tagline{font-size:1.7rem;font-family:'Syne',sans-serif;font-weight:800;color:var(--text);line-height:1.22;letter-spacing:-0.5px;margin-top:32px;}
    .left-tagline em{color:var(--teal);font-style:normal;}
    .left-sub{color:var(--text-2);font-size:0.875rem;margin-top:10px;line-height:1.7;}

    .feature-list{margin-top:24px;display:flex;flex-direction:column;gap:11px;}
    .feature{display:flex;align-items:flex-start;gap:11px;}
    .feat-icon{width:32px;height:32px;border-radius:9px;background:var(--teal-glow);border:1px solid rgba(0,212,170,0.2);display:flex;align-items:center;justify-content:center;font-size:0.85rem;flex-shrink:0;margin-top:1px;}
    .feat-body{flex:1;}
    .feat-title{font-size:0.83rem;font-weight:500;color:var(--text);}
    .feat-desc{font-size:0.78rem;color:var(--text-3);margin-top:2px;line-height:1.4;}

    .stats-strip{margin-top:24px;display:flex;border:1px solid var(--border);border-radius:14px;overflow:hidden;}
    .stat-cell{flex:1;padding:12px 14px;text-align:center;border-right:1px solid var(--border);}
    .stat-cell:last-child{border-right:none;}
    .stat-num{font-family:'Syne',sans-serif;font-size:1.1rem;font-weight:800;color:var(--teal);}
    .stat-lbl{font-size:0.65rem;color:var(--text-3);margin-top:2px;text-transform:uppercase;letter-spacing:0.05em;}

    .testimonial{margin-top:20px;background:rgba(255,255,255,0.025);border:1px solid var(--border);border-radius:14px;padding:14px 16px;}
    .testimonial-quote{font-size:0.78rem;color:var(--text-2);line-height:1.6;font-style:italic;}
    .testimonial-quote::before{content:'\201C';color:var(--teal);font-size:1rem;font-style:normal;margin-right:2px;}
    .t-author{display:flex;align-items:center;gap:10px;margin-top:10px;}
    .t-avatar{width:26px;height:26px;border-radius:50%;background:linear-gradient(135deg,#8b5cf6,#3b82f6);display:flex;align-items:center;justify-content:center;font-size:0.65rem;font-weight:700;color:#fff;flex-shrink:0;}
    .t-name{font-size:0.76rem;font-weight:500;color:var(--text);}
    .t-role{font-size:0.67rem;color:var(--text-3);}

    /* Right panel */
    .card{width:420px;flex-shrink:0;background:var(--navy-2);padding:36px 38px;}
    .card-title{font-family:'Syne',sans-serif;font-size:1.25rem;font-weight:700;margin-bottom:4px;}
    .subtitle{color:var(--text-2);font-size:0.85rem;margin-bottom:22px;}

    .alert{padding:11px 14px;border-radius:10px;font-size:0.85rem;margin-bottom:16px;}
    .alert-error{background:rgba(248,113,113,0.08);border:1px solid rgba(248,113,113,0.2);color:#f87171;animation:shake 0.4s ease;}

    .form-row{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
    .form-group{margin-bottom:14px;}
    label{display:block;font-size:0.8rem;font-weight:500;color:var(--text-2);margin-bottom:7px;letter-spacing:0.2px;}
    .pwd-wrap{position:relative;}
    input[type="email"],input[type="password"],input[type="text"]{width:100%;padding:11px 14px;background:var(--glass);border:1px solid var(--border);border-radius:10px;font-size:0.875rem;font-family:inherit;color:var(--text);transition:all 0.2s;outline:none;}
    .pwd-wrap input{padding-right:44px;}
    input::placeholder{color:var(--text-3);}
    input:focus{border-color:var(--border-bright);background:var(--glass-2);box-shadow:0 0 0 3px var(--teal-glow);}
    input.field-invalid{border-color:rgba(248,113,113,0.5)!important;box-shadow:0 0 0 3px var(--red-glow)!important;}
    input.field-valid{border-color:rgba(52,211,153,0.35);}
    .field-err{font-size:0.73rem;color:#f87171;margin-top:5px;display:none;}
    .field-err.visible{display:block;}

    .pwd-toggle{position:absolute;right:12px;top:50%;transform:translateY(-50%);background:none;border:none;cursor:pointer;color:var(--text-3);padding:4px;transition:color 0.2s;display:flex;align-items:center;}
    .pwd-toggle:hover{color:var(--text-2);}
    .pwd-toggle svg{width:16px;height:16px;stroke:currentColor;fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round;}

    .strength-wrap{margin-top:8px;display:none;}
    .strength-bars{display:flex;gap:4px;margin-bottom:4px;}
    .strength-bar{height:3px;flex:1;border-radius:99px;background:rgba(255,255,255,0.08);transition:background 0.3s;}
    .strength-bar.active-weak{background:#f87171;}
    .strength-bar.active-fair{background:#fbbf24;}
    .strength-bar.active-good{background:#34d399;}
    .strength-bar.active-strong{background:var(--teal);}
    .strength-label{font-size:0.71rem;color:var(--text-3);}

    .role-label{font-size:0.8rem;font-weight:500;color:var(--text-2);margin-bottom:9px;letter-spacing:0.2px;}
    .role-row{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:16px;}
    .role-btn{padding:11px 14px;border:1px solid var(--border);border-radius:12px;background:var(--glass);cursor:pointer;font-size:0.85rem;font-weight:600;color:var(--text-2);text-align:center;transition:all 0.2s;font-family:inherit;}
    .role-btn:hover{border-color:rgba(255,255,255,0.15);color:var(--text);}
    .role-btn.selected{border-color:var(--border-bright);background:var(--teal-glow-2);color:var(--teal);}
    .role-icon{font-size:1rem;margin-bottom:3px;display:block;}

    .btn{width:100%;padding:13px;background:var(--teal);color:#000;border:none;border-radius:10px;font-size:0.95rem;font-weight:700;font-family:'Syne',sans-serif;cursor:pointer;letter-spacing:0.3px;transition:all 0.2s;display:flex;align-items:center;justify-content:center;gap:8px;}
    .btn:hover{background:#00f0c0;box-shadow:0 0 32px rgba(0,212,170,0.4);}
    .btn:active{transform:scale(0.97);}
    .spinner{width:16px;height:16px;border:2px solid rgba(0,0,0,0.25);border-top-color:#000;border-radius:50%;animation:spin 0.6s linear infinite;display:none;flex-shrink:0;}
    .btn.loading .spinner{display:block;}
    .btn.loading .btn-text{display:none;}
    .btn.loading{opacity:0.75;pointer-events:none;}

    .divider{display:flex;align-items:center;gap:12px;margin:16px 0;color:var(--text-3);font-size:0.78rem;}
    .divider::before,.divider::after{content:'';flex:1;height:1px;background:var(--border);}

    .social-row{display:grid;grid-template-columns:1fr 1fr;gap:10px;}
    .social-btn{display:flex;align-items:center;justify-content:center;gap:8px;padding:10px;background:var(--glass);border:1px solid var(--border);border-radius:10px;font-size:0.82rem;font-weight:500;color:var(--text-2);cursor:pointer;transition:all 0.2s;font-family:inherit;}
    .social-btn:hover{border-color:rgba(255,255,255,0.15);color:var(--text);background:var(--glass-2);}
    .social-btn svg{width:16px;height:16px;flex-shrink:0;}

    .bottom-link{text-align:center;margin-top:14px;font-size:0.82rem;color:var(--text-2);}
    .bottom-link a{color:var(--teal);font-weight:600;text-decoration:none;}
    .bottom-link a:hover{text-decoration:underline;}
    .terms{font-size:0.7rem;color:var(--text-3);text-align:center;margin-top:10px;line-height:1.5;}

    @media(max-width:720px){.wrapper{flex-direction:column;max-width:460px;margin:16px;}.left-panel{display:none;}.card{width:100%;padding:28px 20px;}.form-row{grid-template-columns:1fr;}}
  </style>
</head>
<body>
<canvas id="particles"></canvas>

<div class="wrapper">
  <div class="left-panel">
    <div class="brand">
      <div class="logo-icon">HF</div>
      <span class="brand-name">Hire<span>Flow</span></span>
    </div>

    <div class="left-tagline">Join <em>28,500+</em> professionals finding their next role</div>
    <div class="left-sub">Whether you're a seeker or an employer — HireFlow connects the right people to the right opportunities.</div>

    <div class="feature-list">
      <div class="feature">
        <div class="feat-icon">🎯</div>
        <div class="feat-body">
          <div class="feat-title">Smart job matching</div>
          <div class="feat-desc">Get matched to roles that fit your skills and location</div>
        </div>
      </div>
      <div class="feature">
        <div class="feat-icon">📊</div>
        <div class="feat-body">
          <div class="feat-title">Real-time application tracking</div>
          <div class="feat-desc">Know exactly where you stand — applied, reviewed, hired</div>
        </div>
      </div>
      <div class="feature">
        <div class="feat-icon">🏢</div>
        <div class="feat-body">
          <div class="feat-title">1,340+ companies hiring</div>
          <div class="feat-desc">From startups to enterprise — across every industry</div>
        </div>
      </div>
    </div>

    <div class="stats-strip">
      <div class="stat-cell"><div class="stat-num">28.5K</div><div class="stat-lbl">Job Seekers</div></div>
      <div class="stat-cell"><div class="stat-num">4.2K+</div><div class="stat-lbl">Active Jobs</div></div>
      <div class="stat-cell"><div class="stat-num">86%</div><div class="stat-lbl">Placement</div></div>
    </div>

    <div class="testimonial">
      <div class="testimonial-quote">Posted a job and had 12 qualified applicants within 48 hours. Incredible platform for hiring.</div>
      <div class="t-author">
        <div class="t-avatar">P</div>
        <div>
          <div class="t-name">Priya Nair</div>
          <div class="t-role">HR Manager · TechCorp India</div>
        </div>
      </div>
    </div>
  </div>

  <div class="card">
    <div class="card-title">Create your account</div>
    <div class="subtitle">Free forever · No credit card required</div>

    <c:if test="${not empty error}">
      <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post" id="regForm" novalidate>
      <input type="hidden" name="csrfToken" value="${csrfToken}"/>
      <input type="hidden" name="role" id="roleInput" value="seeker"/>

      <div class="form-row">
        <div class="form-group">
          <label for="fullName">Full Name</label>
          <input type="text" id="fullName" name="fullName" required
                 placeholder="Gaurav Kadam"
                 value="<c:out value='${param.fullName}'/>"
                 onblur="validateField('fullName','nameErr')"/>
          <div class="field-err" id="nameErr">Full name is required.</div>
        </div>
        <div class="form-group">
          <label for="phone">Phone <span style="color:var(--text-3);font-weight:400">(optional)</span></label>
          <input type="text" id="phone" name="phone"
                 placeholder="+91 98765 43210"
                 value="<c:out value='${param.phone}'/>"/>
        </div>
      </div>

      <div class="form-group">
        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" required
               placeholder="you@example.com" autocomplete="email"
               value="<c:out value='${param.email}'/>"
               onblur="validateEmail()"/>
        <div class="field-err" id="emailErr">Please enter a valid email address.</div>
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <div class="pwd-wrap">
          <input type="password" id="password" name="password" required
                 placeholder="Min 6 characters" autocomplete="new-password"
                 oninput="checkStrength(this.value)" onblur="validatePwd()"/>
          <button type="button" class="pwd-toggle" onclick="togglePwd()" tabindex="-1">
            <svg id="eyeIcon" viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
          </button>
        </div>
        <div class="strength-wrap" id="strengthWrap">
          <div class="strength-bars">
            <div class="strength-bar" id="bar1"></div>
            <div class="strength-bar" id="bar2"></div>
            <div class="strength-bar" id="bar3"></div>
            <div class="strength-bar" id="bar4"></div>
          </div>
          <div class="strength-label" id="strengthLabel"></div>
        </div>
        <div class="field-err" id="pwdErr">Password must be at least 6 characters.</div>
      </div>

      <div class="role-label">I am a...</div>
      <div class="role-row">
        <button type="button" class="role-btn" id="btnSeeker" onclick="selectRole('seeker')">
          <span class="role-icon">🎯</span>Job Seeker
        </button>
        <button type="button" class="role-btn" id="btnEmployer" onclick="selectRole('employer')">
          <span class="role-icon">🏢</span>Employer
        </button>
      </div>

      <button type="submit" class="btn" id="submitBtn">
        <div class="spinner"></div>
        <span class="btn-text">Create Account</span>
      </button>
    </form>

    <div class="divider">or sign up with</div>
    <div class="social-row">
      <button class="social-btn" onclick="socialNotice(event)">
        <svg viewBox="0 0 24 24" fill="none"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"/><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/></svg>
        Google
      </button>
      <button class="social-btn" onclick="socialNotice(event)">
        <svg viewBox="0 0 24 24"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433a2.062 2.062 0 01-2.063-2.065 2.064 2.064 0 112.063 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z" fill="#0A66C2"/></svg>
        LinkedIn
      </button>
    </div>
    <div class="bottom-link">Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a></div>
    <div class="terms">By registering, you agree to HireFlow's Terms of Service and Privacy Policy.</div>
  </div>
</div>

<script>
(function(){
  const canvas=document.getElementById('particles'),ctx=canvas.getContext('2d');
  let W,H,pts;
  const N=60,D=130,T='0,212,170',B='59,130,246';
  function resize(){W=canvas.width=innerWidth;H=canvas.height=innerHeight;}
  function init(){pts=Array.from({length:N},()=>({x:Math.random()*W,y:Math.random()*H,vx:(Math.random()-.5)*.4,vy:(Math.random()-.5)*.4,r:Math.random()*1.5+.5,c:Math.random()>.6?T:B}));}
  function draw(){
    ctx.clearRect(0,0,W,H);
    pts.forEach((p,i)=>{
      p.x+=p.vx;p.y+=p.vy;
      if(p.x<0||p.x>W)p.vx*=-1;if(p.y<0||p.y>H)p.vy*=-1;
      ctx.beginPath();ctx.arc(p.x,p.y,p.r,0,Math.PI*2);
      ctx.fillStyle=`rgba(${p.c},.65)`;ctx.fill();
      for(let j=i+1;j<N;j++){
        const q=pts[j],dx=p.x-q.x,dy=p.y-q.y,d=Math.sqrt(dx*dx+dy*dy);
        if(d<D){ctx.beginPath();ctx.moveTo(p.x,p.y);ctx.lineTo(q.x,q.y);ctx.strokeStyle=`rgba(${p.c},${(1-d/D)*.18})`;ctx.lineWidth=.8;ctx.stroke();}
      }
    });
    requestAnimationFrame(draw);
  }
  window.addEventListener('resize',()=>{resize();init();});
  resize();init();draw();
})();

function selectRole(r){
  document.getElementById('roleInput').value=r;
  document.getElementById('btnSeeker').classList.toggle('selected',r==='seeker');
  document.getElementById('btnEmployer').classList.toggle('selected',r==='employer');
}
selectRole(document.getElementById('roleInput').value||'seeker');

function togglePwd(){
  const i=document.getElementById('password'),icon=document.getElementById('eyeIcon'),s=i.type==='password';
  i.type=s?'text':'password';
  icon.innerHTML=s?'<line x1="1" y1="1" x2="23" y2="23"/><path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19"/>':'<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
}

function checkStrength(v){
  const w=document.getElementById('strengthWrap'),l=document.getElementById('strengthLabel'),bars=[1,2,3,4].map(n=>document.getElementById('bar'+n));
  if(!v){w.style.display='none';return;}w.style.display='block';
  let s=0;if(v.length>=6)s++;if(v.length>=10)s++;if(/[A-Z]/.test(v)&&/[a-z]/.test(v))s++;if(/[0-9]/.test(v)&&/[^A-Za-z0-9]/.test(v))s++;
  const c=['','active-weak','active-fair','active-good','active-strong'],lb=['','Weak — add more characters','Fair — mix upper & lowercase','Good — add numbers or symbols','Strong password ✓'],lc=['','#f87171','#fbbf24','#34d399','var(--teal)'];
  bars.forEach((b,i)=>{b.className='strength-bar';if(i<s)b.classList.add(c[s]);});
  l.textContent=lb[s];l.style.color=lc[s];
}

function validateField(id,errId){
  const i=document.getElementById(id),e=document.getElementById(errId),ok=i.value.trim().length>0;
  i.classList.toggle('field-invalid',!ok);i.classList.toggle('field-valid',ok);e.classList.toggle('visible',!ok);return ok;
}
function validateEmail(){
  const i=document.getElementById('email'),e=document.getElementById('emailErr'),ok=/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(i.value.trim());
  i.classList.toggle('field-invalid',!ok&&i.value.length>0);i.classList.toggle('field-valid',ok);e.classList.toggle('visible',!ok&&i.value.length>0);return ok;
}
function validatePwd(){
  const i=document.getElementById('password'),e=document.getElementById('pwdErr'),ok=i.value.trim().length>=6;
  i.classList.toggle('field-invalid',!ok);i.classList.toggle('field-valid',ok);e.classList.toggle('visible',!ok);return ok;
}

document.getElementById('regForm').addEventListener('submit',function(e){
  const n=validateField('fullName','nameErr'),em=validateEmail(),pw=validatePwd();
  if(!n||!em||!pw){e.preventDefault();return;}
  document.getElementById('submitBtn').classList.add('loading');
});
function socialNotice(e){e.preventDefault();alert('Social login coming soon!');}
</script>
</body>
</html>
