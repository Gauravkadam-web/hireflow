<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>HireFlow — Find Your Next Dream Role</title>
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
}
html{scroll-behavior:smooth;}
body{font-family:'Instrument Sans',sans-serif;background:var(--navy);color:var(--text);min-height:100vh;overflow-x:hidden;}
body::before{content:'';position:fixed;inset:0;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.04'/%3E%3C/svg%3E");pointer-events:none;z-index:0;opacity:0.4;}
.bg-orb{position:fixed;border-radius:50%;filter:blur(120px);pointer-events:none;z-index:0;}
.orb-1{width:600px;height:600px;background:radial-gradient(circle,rgba(0,212,170,0.12),transparent 70%);top:-200px;right:-100px;animation:orbFloat 12s ease-in-out infinite;}
.orb-2{width:500px;height:500px;background:radial-gradient(circle,rgba(59,130,246,0.08),transparent 70%);bottom:10%;left:-150px;animation:orbFloat 16s ease-in-out infinite reverse;}
.orb-3{width:300px;height:300px;background:radial-gradient(circle,rgba(0,212,170,0.06),transparent 70%);top:50%;left:50%;transform:translate(-50%,-50%);animation:orbFloat 20s ease-in-out infinite;}
@keyframes orbFloat{0%,100%{transform:translateY(0) scale(1);}50%{transform:translateY(-30px) scale(1.05);}}
nav{position:sticky;top:0;z-index:100;display:flex;align-items:center;gap:32px;padding:0 48px;height:66px;background:rgba(8,12,20,0.8);backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);border-bottom:1px solid var(--border);}
.logo{font-family:'Syne',sans-serif;font-size:1.35rem;font-weight:800;color:var(--text);text-decoration:none;letter-spacing:-0.5px;display:flex;align-items:center;gap:8px;flex-shrink:0;}
.logo-icon{width:30px;height:30px;border-radius:8px;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.75rem;font-weight:800;color:#000;font-family:'Syne',sans-serif;}
.logo span{color:var(--teal);}
.nav-pills{display:flex;gap:2px;background:var(--glass);border:1px solid var(--border);border-radius:10px;padding:3px;}
.nav-pill{padding:5px 14px;border-radius:7px;font-size:0.8rem;font-weight:500;cursor:default;border:1px solid transparent;background:transparent;color:var(--text-3);transition:all 0.2s;font-family:inherit;opacity:0.4;pointer-events:none;}
.nav-pill.active{background:var(--glass-2);color:var(--teal);border:1px solid var(--border-bright);opacity:1;pointer-events:none;}
.nav-right{margin-left:auto;display:flex;align-items:center;gap:8px;list-style:none;}
.nav-right a{text-decoration:none;font-size:0.875rem;color:var(--text-2);font-weight:500;padding:7px 14px;border-radius:8px;transition:all 0.2s;}
.nav-right a:hover{color:var(--text);background:var(--glass-2);}
.btn-ghost{border:1px solid var(--border)!important;color:var(--text-2)!important;padding:7px 18px;border-radius:8px;background:transparent;font-size:0.85rem;font-weight:500;transition:all 0.2s;text-decoration:none;display:inline-block;}
.btn-ghost:hover{border-color:var(--border-bright)!important;color:var(--teal)!important;}
.btn-primary{border:1px solid var(--border)!important;color:var(--text-2)!important;padding:7px 18px;border-radius:8px;background:transparent;font-size:0.85rem;font-weight:500;transition:all 0.2s;text-decoration:none;display:inline-block;}
.btn-primary:hover{border-color:var(--border-bright)!important;color:var(--teal)!important;}
.nav-user{display:flex;align-items:center;gap:8px;}
.nav-avatar{width:28px;height:28px;border-radius:50%;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.65rem;font-weight:700;color:#000;flex-shrink:0;}
.hamburger{display:none;flex-direction:column;justify-content:center;gap:5px;width:38px;height:38px;cursor:pointer;background:var(--glass);border:1px solid var(--border);border-radius:8px;padding:8px;margin-left:auto;flex-shrink:0;}
.hamburger span{display:block;height:1.5px;background:var(--text-2);border-radius:2px;transition:all 0.3s;transform-origin:center;width:100%;}
.hamburger.open span:nth-child(1){transform:translateY(6.5px) rotate(45deg);}
.hamburger.open span:nth-child(2){opacity:0;transform:scaleX(0);}
.hamburger.open span:nth-child(3){transform:translateY(-6.5px) rotate(-45deg);}
.mobile-menu{display:none;position:fixed;top:60px;left:0;right:0;bottom:0;z-index:99;background:rgba(8,12,20,0.98);backdrop-filter:blur(24px);padding:24px 20px 40px;flex-direction:column;gap:4px;overflow-y:auto;}
.mobile-menu.open{display:flex;}
.m-section-label{font-size:0.68rem;color:var(--text-3);letter-spacing:1.5px;text-transform:uppercase;font-weight:600;padding:16px 8px 6px;margin-top:8px;border-top:1px solid var(--border);}
.m-section-label:first-child{border-top:none;padding-top:4px;margin-top:0;}
.mobile-menu a{display:block;padding:13px 12px;border-radius:10px;text-decoration:none;font-size:0.95rem;font-weight:500;color:var(--text-2);transition:all 0.15s;}
.mobile-menu a:hover{background:var(--glass-2);color:var(--teal);}
.m-actions{display:flex;gap:10px;margin-top:16px;padding-top:16px;border-top:1px solid var(--border);}
.m-actions a{flex:1;text-align:center;padding:13px;border-radius:10px;font-weight:600;font-size:0.9rem;text-decoration:none;display:block;}
.m-login{border:1px solid var(--border);color:var(--text-2);}
.m-register{background:var(--teal);color:#000;font-family:'Syne',sans-serif;}
.hero{position:relative;z-index:1;max-width:1100px;margin:0 auto;padding:100px 48px 80px;text-align:center;}
.hero-eyebrow{display:inline-flex;align-items:center;gap:8px;background:var(--glass);border:1px solid var(--border-bright);color:var(--teal);font-size:0.78rem;font-weight:600;padding:6px 16px;border-radius:20px;margin-bottom:32px;letter-spacing:0.8px;text-transform:uppercase;animation:fadeUp 0.6s ease both;}
.hero-eyebrow::before{content:'';width:6px;height:6px;border-radius:50%;background:var(--teal);animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{opacity:1;transform:scale(1);}50%{opacity:0.5;transform:scale(1.4);}}
.hero h1{font-family:'Syne',sans-serif;font-size:clamp(3rem,6vw,5rem);font-weight:800;line-height:1.08;letter-spacing:-2px;margin-bottom:24px;animation:fadeUp 0.6s 0.1s ease both;}
.hero h1 .line-1{color:var(--text);}
.hero h1 .line-2{background:linear-gradient(90deg,var(--teal),#00a8ff 60%,var(--teal));background-size:200% auto;-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;animation:shimmer 4s linear infinite,fadeUp 0.6s 0.1s ease both;}
@keyframes shimmer{0%{background-position:0% center;}100%{background-position:200% center;}}
.hero p{color:var(--text-2);font-size:1.1rem;line-height:1.7;max-width:560px;margin:0 auto 48px;animation:fadeUp 0.6s 0.2s ease both;}
.search-wrap{max-width:780px;margin:0 auto 20px;animation:fadeUp 0.6s 0.3s ease both;}
.search-box{display:flex;align-items:center;background:var(--glass-2);border:1px solid var(--border);border-radius:var(--radius);padding:6px 6px 6px 20px;transition:all 0.3s;backdrop-filter:blur(12px);}
.search-box:focus-within{border-color:var(--border-bright);box-shadow:0 0 0 3px var(--teal-glow),0 8px 40px rgba(0,0,0,0.4);}
.search-box input{flex:1;border:none;outline:none;background:transparent;color:var(--text);font-size:0.95rem;font-family:inherit;}
.search-box input::placeholder{color:var(--text-3);}
.search-divider{width:1px;height:24px;background:var(--border);margin:0 12px;}
.search-select-wrap{display:flex;align-items:center;gap:6px;color:var(--text-2);}
.search-select-wrap select{border:none;outline:none;background:transparent;color:var(--text-2);font-size:0.85rem;font-family:inherit;cursor:pointer;appearance:none;-webkit-appearance:none;padding:4px;}
.search-select-wrap select option{background:var(--navy-3);color:var(--text);}
.chevron{width:14px;height:14px;color:var(--text-3);}
.btn-search{padding:11px 28px;border-radius:10px;border:none;background:var(--teal);color:#000;font-size:0.9rem;font-weight:700;font-family:'Syne',sans-serif;cursor:pointer;transition:all 0.2s;margin-left:10px;flex-shrink:0;}
.btn-search:hover{background:#00f0c0;box-shadow:0 0 24px rgba(0,212,170,0.4);}
.search-tags{display:flex;align-items:center;gap:8px;justify-content:center;flex-wrap:wrap;animation:fadeUp 0.6s 0.4s ease both;}
.search-tag-label{font-size:0.78rem;color:var(--text-3);}
.search-tag{padding:4px 12px;border-radius:20px;border:1px solid var(--border);background:var(--glass);color:var(--text-2);font-size:0.78rem;cursor:pointer;transition:all 0.2s;}
.search-tag:hover{border-color:var(--border-bright);color:var(--teal);}
.stats-bar{position:relative;z-index:1;max-width:1100px;margin:64px auto 0;padding:0 48px;display:grid;grid-template-columns:repeat(4,1fr);gap:1px;background:var(--border);border-radius:var(--radius-lg);overflow:hidden;animation:fadeUp 0.6s 0.5s ease both;}
.stat-cell{background:var(--navy-2);padding:32px 28px;transition:background 0.2s;}
.stat-cell:hover{background:var(--navy-4);}
.stat-num{font-family:'Syne',sans-serif;font-size:2.4rem;font-weight:800;color:var(--teal);letter-spacing:-1.5px;line-height:1;margin-bottom:6px;}
.stat-label{font-size:0.82rem;color:var(--text-2);font-weight:500;}
.section{position:relative;z-index:1;max-width:1100px;margin:0 auto;padding:96px 48px 0;}
.section-head{display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:40px;}
.section-label{font-size:0.72rem;color:var(--teal);font-weight:600;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:8px;}
.section-title{font-family:'Syne',sans-serif;font-size:clamp(1.6rem,3vw,2.2rem);font-weight:800;letter-spacing:-0.8px;color:var(--text);}
.see-all{font-size:0.85rem;color:var(--teal);text-decoration:none;font-weight:600;display:flex;align-items:center;gap:4px;transition:gap 0.2s;padding-bottom:4px;}
.see-all:hover{gap:8px;}
.logos-strip{position:relative;z-index:1;max-width:1100px;margin:96px auto 0;padding:0 48px;}
.logos-label{text-align:center;font-size:0.75rem;color:var(--text-3);letter-spacing:1.5px;text-transform:uppercase;margin-bottom:28px;font-weight:600;}
.logos-row{display:flex;align-items:center;justify-content:space-between;gap:32px;padding:24px 40px;background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);}
.logo-item{font-family:'Syne',sans-serif;font-size:0.95rem;font-weight:700;color:var(--text-3);letter-spacing:-0.3px;transition:color 0.2s;cursor:default;}
.logo-item:hover{color:var(--text-2);}
.categories-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;}
.cat-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:28px 24px;cursor:pointer;transition:all 0.25s;position:relative;overflow:hidden;text-decoration:none;display:block;}
.cat-card::before{content:'';position:absolute;inset:0;background:linear-gradient(135deg,var(--teal-glow),transparent);opacity:0;transition:opacity 0.3s;}
.cat-card:hover{border-color:var(--border-bright);transform:translateY(-3px);}
.cat-card:hover::before{opacity:1;}
.cat-card:hover .cat-arrow{transform:translateX(4px);opacity:1;}
.cat-icon-wrap{width:44px;height:44px;border-radius:10px;background:var(--glass-2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.3rem;margin-bottom:16px;transition:border-color 0.2s;}
.cat-card:hover .cat-icon-wrap{border-color:var(--border-bright);}
.cat-name{font-size:0.9rem;font-weight:600;color:var(--text);margin-bottom:4px;}
.cat-count{font-size:0.78rem;color:var(--text-2);}
.cat-arrow{position:absolute;top:24px;right:20px;color:var(--teal);font-size:1rem;opacity:0;transition:all 0.2s;}
.jobs-grid{display:flex;flex-direction:column;gap:10px;}
.job-card{display:flex;align-items:center;gap:20px;padding:20px 24px;background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);cursor:pointer;transition:all 0.25s;position:relative;overflow:hidden;text-decoration:none;color:inherit;}
.job-card::after{content:'';position:absolute;left:0;top:0;bottom:0;width:3px;background:var(--teal);transform:scaleY(0);transform-origin:center;transition:transform 0.25s;border-radius:2px 0 0 2px;}
.job-card:hover{border-color:var(--border-bright);background:var(--glass-2);transform:translateX(4px);}
.job-card:hover::after{transform:scaleY(1);}
.job-card.featured{border-color:rgba(245,158,11,0.25);}
.job-card.featured::after{background:#f59e0b;}
.job-logo{width:48px;height:48px;border-radius:12px;background:var(--glass-2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:1.3rem;flex-shrink:0;font-weight:700;color:var(--text-2);transition:border-color 0.2s;}
.job-body{flex:1;min-width:0;}
.job-title{font-size:0.95rem;font-weight:600;color:var(--text);margin-bottom:3px;}
.job-company{font-size:0.82rem;color:var(--teal);font-weight:600;margin-bottom:10px;}
.job-tags{display:flex;align-items:center;gap:8px;flex-wrap:wrap;}
.tag{padding:3px 10px;border-radius:6px;font-size:0.72rem;font-weight:600;border:1px solid var(--border);color:var(--text-2);background:var(--glass);}
.tag.type{border-color:rgba(0,212,170,0.3);color:var(--teal);}
.tag.remote{border-color:rgba(59,130,246,0.3);color:#60a5fa;}
.tag.contract{border-color:rgba(168,85,247,0.3);color:#c084fc;}
.tag-loc{font-size:0.78rem;color:var(--text-2);}
.tag-salary{font-size:0.78rem;color:var(--text-2);font-weight:500;margin-left:auto;}
.badge-featured{padding:3px 10px;border-radius:6px;background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);color:#f59e0b;font-size:0.7rem;font-weight:700;letter-spacing:0.3px;flex-shrink:0;}
.btn-view{padding:8px 20px;border-radius:8px;border:1px solid var(--border);background:transparent;color:var(--text-2);font-size:0.82rem;font-weight:600;cursor:pointer;font-family:inherit;transition:all 0.2s;flex-shrink:0;white-space:nowrap;}
.btn-view:hover{border-color:var(--teal);color:var(--teal);}
.how-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;}
.how-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:32px 28px;position:relative;overflow:hidden;transition:all 0.25s;}
.how-card:hover{border-color:var(--border-bright);background:var(--glass-2);}
.how-num{font-family:'Syne',sans-serif;font-size:3.5rem;font-weight:800;color:var(--border);position:absolute;top:16px;right:20px;line-height:1;pointer-events:none;letter-spacing:-2px;transition:color 0.3s;}
.how-card:hover .how-num{color:rgba(0,212,170,0.1);}
.how-icon{width:48px;height:48px;border-radius:12px;background:var(--teal-glow);border:1px solid var(--border-bright);display:flex;align-items:center;justify-content:center;font-size:1.3rem;margin-bottom:20px;}
.how-title{font-family:'Syne',sans-serif;font-size:1.05rem;font-weight:700;color:var(--text);margin-bottom:8px;}
.how-desc{font-size:0.85rem;color:var(--text-2);line-height:1.6;}
.testi-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;}
.testi-card{background:var(--glass);border:1px solid var(--border);border-radius:var(--radius);padding:28px;transition:all 0.25s;}
.testi-card:hover{border-color:var(--border-bright);transform:translateY(-3px);}
.testi-stars{color:var(--teal);font-size:0.8rem;margin-bottom:14px;letter-spacing:2px;}
.testi-quote{font-size:0.88rem;color:var(--text-2);line-height:1.7;margin-bottom:20px;font-style:italic;}
.testi-author{display:flex;align-items:center;gap:12px;}
.testi-avatar{width:36px;height:36px;border-radius:50%;background:linear-gradient(135deg,var(--teal),#00a8ff);display:flex;align-items:center;justify-content:center;font-size:0.8rem;font-weight:700;color:#000;font-family:'Syne',sans-serif;flex-shrink:0;}
.testi-name{font-size:0.85rem;font-weight:600;color:var(--text);}
.testi-role{font-size:0.75rem;color:var(--text-3);}
.cta-wrap{position:relative;z-index:1;max-width:1100px;margin:96px auto 0;padding:0 48px;}
.cta-banner{background:linear-gradient(135deg,var(--navy-4) 0%,#0a1628 50%,var(--navy-4));border:1px solid var(--border-bright);border-radius:var(--radius-lg);padding:64px 72px;text-align:center;position:relative;overflow:hidden;}
.cta-banner::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 50% -20%,rgba(0,212,170,0.12),transparent 70%);}
.cta-banner h2{font-family:'Syne',sans-serif;font-size:clamp(1.8rem,4vw,2.8rem);font-weight:800;letter-spacing:-1px;color:var(--text);margin-bottom:14px;position:relative;z-index:1;}
.cta-banner p{font-size:1rem;color:var(--text-2);margin-bottom:36px;position:relative;z-index:1;}
.cta-buttons{display:flex;gap:12px;justify-content:center;position:relative;z-index:1;}
.btn-cta-primary{padding:13px 32px;border-radius:10px;border:none;background:var(--teal);color:#000;font-size:0.95rem;font-weight:700;font-family:'Syne',sans-serif;cursor:pointer;transition:all 0.2s;letter-spacing:0.2px;text-decoration:none;display:inline-block;}
.btn-cta-primary:hover{background:#00f0c0;box-shadow:0 0 32px rgba(0,212,170,0.5);}
.btn-cta-ghost{padding:13px 32px;border-radius:10px;border:1px solid var(--border);background:transparent;color:var(--text);font-size:0.95rem;font-weight:600;font-family:inherit;cursor:pointer;transition:all 0.2s;text-decoration:none;display:inline-block;}
.btn-cta-ghost:hover{border-color:var(--border-bright);color:var(--teal);}
footer{position:relative;z-index:1;max-width:1100px;margin:96px auto 0;padding:48px;border-top:1px solid var(--border);display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:48px;}
.footer-brand .logo{margin-bottom:12px;display:inline-flex;}
.footer-brand p{font-size:0.82rem;color:var(--text-3);line-height:1.6;max-width:240px;}
.footer-col h4{font-family:'Syne',sans-serif;font-size:0.78rem;font-weight:700;color:var(--text);letter-spacing:1px;text-transform:uppercase;margin-bottom:16px;}
.footer-col ul{list-style:none;display:flex;flex-direction:column;gap:10px;}
.footer-col ul a{font-size:0.82rem;color:var(--text-3);text-decoration:none;transition:color 0.2s;}
.footer-col ul a:hover{color:var(--teal);}
.footer-bottom{position:relative;z-index:1;max-width:1100px;margin:0 auto;padding:20px 48px 48px;display:flex;align-items:center;justify-content:space-between;}
.footer-bottom p{font-size:0.78rem;color:var(--text-3);}
.footer-bottom span{color:var(--teal);}
.empty-state{text-align:center;padding:48px;color:var(--text-3);font-size:0.9rem;}
@keyframes fadeUp{from{opacity:0;transform:translateY(24px);}to{opacity:1;transform:translateY(0);}}
.fade-up{opacity:1;transform:translateY(0);transition:opacity 0.6s ease,transform 0.6s ease;animation:ensureVisible 0s 1.2s forwards;}
.fade-up.fade-up--init{opacity:0;transform:translateY(24px);}
.fade-up.visible{opacity:1!important;transform:translateY(0)!important;}
@keyframes ensureVisible{to{opacity:1;transform:translateY(0);}}
@media(prefers-reduced-motion:reduce){.fade-up,.fade-up.fade-up--init{opacity:1;transform:none;animation:none;transition:none;}}
@media(max-width:1024px){.stats-bar,.section,.logos-strip,.cta-wrap{padding-left:24px;padding-right:24px;}footer{padding:48px 24px;gap:28px;}.footer-bottom{padding:16px 24px 40px;}}
@media(max-width:768px){nav{padding:0 16px;gap:0;height:60px;}.nav-pills{display:none;}.nav-right{display:none;}.hamburger{display:flex;}.hero{padding:44px 16px 36px;text-align:left;}.hero h1{font-size:clamp(2rem,9vw,2.8rem);letter-spacing:-1px;margin-bottom:16px;}.hero p{font-size:0.92rem;margin:0 0 28px;max-width:100%;}.search-wrap{max-width:100%;}.search-box{flex-direction:column;align-items:stretch;padding:14px 16px;gap:12px;}.search-box input{font-size:1rem;padding:0;}.search-divider{width:100%;height:1px;margin:0;}.btn-search{margin-left:0;width:100%;padding:13px;}.stats-bar{margin:40px 16px 0;padding:0;grid-template-columns:1fr 1fr;border-radius:var(--radius);}.stat-cell{padding:20px 16px;}.stat-num{font-size:1.7rem;}.logos-strip{padding:0 16px;}.logos-row{flex-wrap:wrap;gap:10px 16px;padding:16px 20px;justify-content:center;}.logo-item{font-size:0.8rem;}.section{padding:56px 16px 0;}.section-head{flex-direction:column;align-items:flex-start;gap:8px;margin-bottom:20px;}.section-title{font-size:1.4rem;}.categories-grid{grid-template-columns:1fr 1fr;gap:8px;}.cat-card{padding:18px 14px;}.cat-arrow{display:none;}.job-card{flex-wrap:wrap;gap:10px;padding:14px;}.job-logo{width:40px;height:40px;}.job-title{font-size:0.88rem;}.tag-salary{margin-left:0;}.btn-view{width:100%;text-align:center;order:5;padding:10px;}.how-grid{grid-template-columns:1fr;gap:8px;}.how-card{padding:22px 18px;}.testi-grid{grid-template-columns:1fr;gap:8px;}.testi-card{padding:20px 16px;}.cta-wrap{padding:0 16px;}.cta-banner{padding:36px 20px;border-radius:var(--radius);}.cta-buttons{flex-direction:column;gap:10px;}.btn-cta-primary,.btn-cta-ghost{width:100%;padding:14px;text-align:center;}footer{grid-template-columns:1fr;gap:28px;padding:40px 16px 20px;margin-top:56px;}.footer-bottom{flex-direction:column;gap:4px;text-align:center;padding:12px 16px 36px;}}
@media(max-width:380px){.hero h1{font-size:1.85rem;}.stats-bar{grid-template-columns:1fr 1fr;}.stat-num{font-size:1.5rem;}}
</style>
</head>
<body>
<div class="bg-orb orb-1"></div>
<div class="bg-orb orb-2"></div>
<div class="bg-orb orb-3"></div>

<nav>
  <a href="${pageContext.request.contextPath}/home" class="logo">
    <div class="logo-icon">HF</div>
    Hire<span>Flow</span>
  </a>
  <div class="nav-pills">
    <button class="nav-pill ${empty sessionScope.userId ? 'active' : ''}">Guest</button>
    <button class="nav-pill ${sessionScope.userRole == 'seeker'   ? 'active' : ''}">Job Seeker</button>
    <button class="nav-pill ${sessionScope.userRole == 'employer' ? 'active' : ''}">Employer</button>
    <button class="nav-pill ${sessionScope.userRole == 'admin'    ? 'active' : ''}">Admin</button>
  </div>
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
        <li><a href="${pageContext.request.contextPath}/login"    class="btn-ghost">Login</a></li>
        <li><a href="${pageContext.request.contextPath}/register" class="btn-primary">Register</a></li>
      </c:otherwise>
    </c:choose>
  </ul>
  <button class="hamburger" id="hamburger" aria-label="Menu">
    <span></span><span></span><span></span>
  </button>
</nav>

<div class="mobile-menu" id="mobileMenu">
  <div class="m-section-label">Navigate</div>
  <a href="${pageContext.request.contextPath}/home">Home</a>
  <a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a>
  <div class="m-actions">
    <c:choose>
      <c:when test="${not empty sessionScope.userId}">
        <a href="${pageContext.request.contextPath}/dashboard/seeker" class="m-login">Dashboard</a>
        <a href="${pageContext.request.contextPath}/logout" class="m-register">Logout</a>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/login"    class="m-login">Login</a>
        <a href="${pageContext.request.contextPath}/register" class="m-register">Register</a>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<section class="hero">
  <div class="hero-eyebrow">${totalJobs}+ Active Opportunities</div>
  <h1><span class="line-1">Find Your Next</span><br><span class="line-2">Dream Role</span></h1>
  <p>Connect with top employers, track your applications, and land the job you deserve — all in one place.</p>
  <div class="search-wrap">
    <form class="search-box" action="${pageContext.request.contextPath}/jobs" method="get">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24" style="color:var(--text-3);flex-shrink:0;margin-right:10px"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
      <input type="text" name="keyword" placeholder="Job title, skill, or keyword…" value="<c:out value='${param.keyword}'/>"/>
      <div class="search-divider"></div>
      <div class="search-select-wrap">
        <svg class="chevron" viewBox="0 0 20 20" fill="currentColor"><path d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"/></svg>
        <select name="location">
          <option value="">All Locations</option>
          <option value="Mumbai">Mumbai</option>
          <option value="Pune">Pune</option>
          <option value="Bangalore">Bangalore</option>
          <option value="Delhi">Delhi</option>
          <option value="Remote">Remote</option>
        </select>
      </div>
      <div class="search-divider"></div>
      <div class="search-select-wrap">
        <svg class="chevron" viewBox="0 0 20 20" fill="currentColor"><path d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"/></svg>
        <select name="category">
          <option value="">All Categories</option>
          <c:forEach items="${categories}" var="cat">
            <option value="${cat.categoryId}"><c:out value="${cat.name}"/></option>
          </c:forEach>
        </select>
      </div>
      <button type="submit" class="btn-search">Search</button>
    </form>
    <div class="search-tags" style="margin-top:14px;">
      <span class="search-tag-label">Popular:</span>
      <span class="search-tag">Java Developer</span>
      <span class="search-tag">React Engineer</span>
      <span class="search-tag">UI/UX Designer</span>
      <span class="search-tag">Data Analyst</span>
      <span class="search-tag">Remote</span>
    </div>
  </div>
</section>

<div class="stats-bar fade-up">
  <div class="stat-cell"><div class="stat-num" data-target="${totalJobs}" data-suffix="">0</div><div class="stat-label">Jobs Posted</div></div>
  <div class="stat-cell"><div class="stat-num" data-target="1340" data-suffix="">0</div><div class="stat-label">Companies Hiring</div></div>
  <div class="stat-cell"><div class="stat-num" data-target="28500" data-suffix="">0</div><div class="stat-label">Job Seekers</div></div>
  <div class="stat-cell"><div class="stat-num" data-target="86" data-suffix="%">0</div><div class="stat-label">Placement Rate</div></div>
</div>

<div class="logos-strip fade-up">
  <p class="logos-label">Trusted by leading companies</p>
  <div class="logos-row">
    <div class="logo-item">Infosys</div>
    <div class="logo-item">Wipro</div>
    <div class="logo-item">TCS</div>
    <div class="logo-item">Persistent</div>
    <div class="logo-item">HCL Tech</div>
    <div class="logo-item">Cognizant</div>
    <div class="logo-item">Mphasis</div>
  </div>
</div>

<section class="section fade-up">
  <div class="section-head">
    <div><div class="section-label">Explore</div><h2 class="section-title">Browse by Category</h2></div>
    <a href="${pageContext.request.contextPath}/jobs" class="see-all">View all categories →</a>
  </div>
  <div class="categories-grid">
    <c:choose>
      <c:when test="${not empty categories}">
        <c:forEach items="${categories}" var="cat">
          <a href="${pageContext.request.contextPath}/jobs?category=${cat.categoryId}" class="cat-card">
            <div class="cat-icon-wrap"><c:out value="${cat.icon}"/></div>
            <div class="cat-name"><c:out value="${cat.name}"/></div>
            <div class="cat-count">${cat.jobCount} jobs</div>
            <div class="cat-arrow">→</div>
          </a>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <div class="cat-card"><div class="cat-icon-wrap">💻</div><div class="cat-name">IT &amp; Software</div><div class="cat-count">— jobs</div></div>
        <div class="cat-card"><div class="cat-icon-wrap">📊</div><div class="cat-name">Finance &amp; Accounting</div><div class="cat-count">— jobs</div></div>
        <div class="cat-card"><div class="cat-icon-wrap">🎨</div><div class="cat-name">Design &amp; Creative</div><div class="cat-count">— jobs</div></div>
        <div class="cat-card"><div class="cat-icon-wrap">🏗️</div><div class="cat-name">Engineering</div><div class="cat-count">— jobs</div></div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<section class="section fade-up">
  <div class="section-head">
    <div><div class="section-label">Handpicked</div><h2 class="section-title">Featured Jobs</h2></div>
    <a href="${pageContext.request.contextPath}/jobs" class="see-all">All jobs →</a>
  </div>
  <div class="jobs-grid">
    <c:choose>
      <c:when test="${empty featuredJobs}">
        <div class="empty-state">No featured jobs yet — check back soon!</div>
      </c:when>
      <c:otherwise>
        <c:forEach items="${featuredJobs}" var="job">
          <a href="${pageContext.request.contextPath}/jobs/detail?id=${job.jobId}" class="job-card ${job.featured ? 'featured' : ''}">
            <div class="job-logo">${job.companyInitial}</div>
            <div class="job-body">
              <div class="job-title"><c:out value="${job.title}"/></div>
              <div class="job-company"><c:out value="${job.companyName}"/></div>
              <div class="job-tags">
                <c:choose>
                  <c:when test="${job.jobType == 'Remote'}"><span class="tag remote"><c:out value="${job.jobType}"/></span></c:when>
                  <c:when test="${job.jobType == 'Contract'}"><span class="tag contract"><c:out value="${job.jobType}"/></span></c:when>
                  <c:when test="${not empty job.jobType}"><span class="tag type"><c:out value="${job.jobType}"/></span></c:when>
                </c:choose>
                <c:if test="${not empty job.location}"><span class="tag-loc">📍 <c:out value="${job.location}"/></span></c:if>
                <span class="tag-salary">${job.salaryRange}</span>
              </div>
            </div>
            <c:if test="${job.featured}"><span class="badge-featured">Featured</span></c:if>
            <span class="btn-view">View →</span>
          </a>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<section class="section fade-up">
  <div class="section-head">
    <div><div class="section-label">Simple Process</div><h2 class="section-title">How HireFlow Works</h2></div>
  </div>
  <div class="how-grid">
    <div class="how-card"><div class="how-num">01</div><div class="how-icon">🔍</div><div class="how-title">Create Your Profile</div><div class="how-desc">Sign up in seconds. Add your skills, experience, and preferences to build a compelling profile that gets noticed by top employers.</div></div>
    <div class="how-card"><div class="how-num">02</div><div class="how-icon">⚡</div><div class="how-title">Discover Opportunities</div><div class="how-desc">Browse thousands of curated roles. Use smart filters to find positions that match your skills, salary expectations, and location.</div></div>
    <div class="how-card"><div class="how-num">03</div><div class="how-icon">🎯</div><div class="how-title">Apply &amp; Get Hired</div><div class="how-desc">Submit applications with one click. Track your status in real time and connect directly with hiring managers.</div></div>
  </div>
</section>

<section class="section fade-up">
  <div class="section-head">
    <div><div class="section-label">Success Stories</div><h2 class="section-title">What People Say</h2></div>
  </div>
  <div class="testi-grid">
    <div class="testi-card">
      <div class="testi-stars">★★★★★</div>
      <div class="testi-quote">"HireFlow completely transformed my job search. I landed a senior role at Infosys within three weeks of signing up."</div>
      <div class="testi-author"><div class="testi-avatar">AR</div><div><div class="testi-name">Arjun Rao</div><div class="testi-role">Senior Java Developer, Infosys</div></div></div>
    </div>
    <div class="testi-card">
      <div class="testi-stars">★★★★★</div>
      <div class="testi-quote">"As an employer, the quality of candidates we found through HireFlow was outstanding. The filtering tools saved our HR team hours."</div>
      <div class="testi-author"><div class="testi-avatar" style="background:linear-gradient(135deg,#3b82f6,#8b5cf6);">PS</div><div><div class="testi-name">Priya Sharma</div><div class="testi-role">HR Manager, Persistent Systems</div></div></div>
    </div>
    <div class="testi-card">
      <div class="testi-stars">★★★★★</div>
      <div class="testi-quote">"From resume to offer letter in 2 weeks! HireFlow's smart matching showed me roles I wouldn't have found on my own."</div>
      <div class="testi-author"><div class="testi-avatar" style="background:linear-gradient(135deg,#f59e0b,#ef4444);">NK</div><div><div class="testi-name">Neha Kumar</div><div class="testi-role">UI/UX Designer, Wipro Digital</div></div></div>
    </div>
  </div>
</section>

<div class="cta-wrap fade-up">
  <div class="cta-banner">
    <h2>Ready to Find Your Dream Role?</h2>
    <p>Join 28,500+ professionals already using HireFlow to land their next opportunity.</p>
    <div class="cta-buttons">
      <c:choose>
        <c:when test="${not empty sessionScope.userId}">
          <a href="${pageContext.request.contextPath}/jobs" class="btn-cta-primary">Browse Jobs</a>
          <a href="${pageContext.request.contextPath}/dashboard/seeker" class="btn-cta-ghost">My Dashboard</a>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/register" class="btn-cta-primary">Get Started — It's Free</a>
          <a href="${pageContext.request.contextPath}/jobs" class="btn-cta-ghost">Post a Job →</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<footer class="fade-up">
  <div class="footer-brand">
    <a href="${pageContext.request.contextPath}/home" class="logo" style="margin-bottom:16px;"><div class="logo-icon">HF</div>Hire<span>Flow</span></a>
    <p>A full-stack job portal built with JSP, Servlets &amp; PostgreSQL. Connecting talent with opportunity across India.</p>
  </div>
  <div class="footer-col"><h4>For Job Seekers</h4><ul><li><a href="${pageContext.request.contextPath}/jobs">Browse Jobs</a></li><li><a href="${pageContext.request.contextPath}/register">Create Account</a></li><li><a href="${pageContext.request.contextPath}/dashboard/seeker">My Applications</a></li></ul></div>
  <div class="footer-col"><h4>For Employers</h4><ul><li><a href="${pageContext.request.contextPath}/jobs/create">Post a Job</a></li><li><a href="${pageContext.request.contextPath}/register">Register</a></li><li><a href="${pageContext.request.contextPath}/dashboard/employer">Dashboard</a></li></ul></div>
  <div class="footer-col"><h4>Platform</h4><ul><li><a href="${pageContext.request.contextPath}/home">Home</a></li><li><a href="${pageContext.request.contextPath}/login">Login</a></li><li><a href="${pageContext.request.contextPath}/jobs">All Jobs</a></li></ul></div>
</footer>
<div class="footer-bottom">
  <p>&copy; 2025 <span>HireFlow</span>. Built with JSP · Servlets · PostgreSQL</p>
  <p style="color:var(--text-3);font-size:0.78rem;">Made with ♥ for job seekers across India</p>
</div>

<script>
  const hamburger = document.getElementById('hamburger');
  const mobileMenu = document.getElementById('mobileMenu');
  hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('open');
    mobileMenu.classList.toggle('open');
    document.body.style.overflow = mobileMenu.classList.contains('open') ? 'hidden' : '';
  });
  mobileMenu.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
      hamburger.classList.remove('open');
      mobileMenu.classList.remove('open');
      document.body.style.overflow = '';
    });
  });

  (function () {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    if (!('IntersectionObserver' in window)) return;
    var els = document.querySelectorAll('.fade-up');
    els.forEach(function (el) { el.classList.add('fade-up--init'); });
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add('visible'); observer.unobserve(e.target); }
      });
    }, { threshold: 0.05, rootMargin: '0px 0px -20px 0px' });
    requestAnimationFrame(function () { els.forEach(function (el) { observer.observe(el); }); });
  })();

  document.querySelectorAll('.cat-card').forEach((card, i) => {
    card.style.transitionDelay = (i * 40) + 'ms';
  });

  document.querySelectorAll('.search-tag').forEach(tag => {
    tag.addEventListener('click', () => {
      const input = document.querySelector('.search-box input[name="keyword"]');
      if (input) { input.value = tag.textContent; input.focus(); }
    });
  });

  function formatNum(n) {
    return n >= 1000 ? n.toLocaleString('en-IN') : String(n);
  }
  function animateCounter(el) {
    const target = parseInt(el.getAttribute('data-target'));
    const suffix = el.getAttribute('data-suffix') || '';
    const duration = 1600;
    const start = performance.now();
    function step(now) {
      const elapsed = now - start;
      const progress = Math.min(elapsed / duration, 1);
      const ease = 1 - Math.pow(1 - progress, 3);
      const current = Math.round(ease * target);
      el.textContent = formatNum(current) + suffix;
      if (progress < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }
  const statsBar = document.querySelector('.stats-bar');
  if (statsBar) {
    const counterObserver = new IntersectionObserver((entries) => {
      entries.forEach(e => {
        if (e.isIntersecting) {
          e.target.querySelectorAll('.stat-num[data-target]').forEach(animateCounter);
          counterObserver.unobserve(e.target);
        }
      });
    }, { threshold: 0.35 });
    counterObserver.observe(statsBar);
  }
</script>
</body>
</html>
