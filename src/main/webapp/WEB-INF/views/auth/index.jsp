<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*" %>
<%
    Long pendingCourse = (Long) session.getAttribute("pendingCourseId");
    if (pendingCourse != null) session.removeAttribute("pendingCourseId");
%>
<% if (pendingCourse != null) { %>
<script>
    window.addEventListener('load', function() {
        setTimeout(function() {
            const btn = document.querySelector(
                '.buy-now-btn[data-course-id="<%= pendingCourse %>"]'
            );
            if (btn) btn.click();
        }, 600);
    });
</script>
<% } %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduMaster - Build Your Future</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --primary-color: #6366f1;
            --secondary-color: #8b5cf6;
            --accent-color: #ec4899;
            --dark-color: #1e293b;
            --light-color: #f8fafc;
            --text-dark: #334155;
            --text-light: #64748b;
            --gradient-primary: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #ec4899 100%);
            --gradient-secondary: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            --shadow-sm: 0 2px 10px rgba(99,102,241,0.1);
            --shadow-md: 0 8px 30px rgba(99,102,241,0.15);
            --shadow-lg: 0 20px 60px rgba(99,102,241,0.2);
            --border-radius: 16px;
            --transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
        }

        body { font-family:'Poppins',sans-serif; overflow-x:hidden; color:var(--text-dark); background:var(--light-color); }

        .navbar { background:rgba(255,255,255,0.98); backdrop-filter:blur(20px); padding:1rem 0; box-shadow:var(--shadow-sm); transition:var(--transition); border-bottom:1px solid rgba(99,102,241,0.1); }
        .navbar.scrolled { padding:.5rem 0; box-shadow:var(--shadow-md); }
        .navbar-brand { font-size:1.75rem; font-weight:800; background:var(--gradient-primary); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; display:flex; align-items:center; gap:10px; }
        .nav-link { color:var(--text-dark)!important; font-weight:500; margin:0 .25rem; padding:.5rem .75rem!important; transition:var(--transition); border-radius:8px; }
        .nav-link:hover { color:var(--primary-color)!important; background:rgba(99,102,241,.05); }
        .nav-link::after { display:none; }
        .btn-start { background:var(--gradient-primary); color:white!important; padding:.75rem 2rem; border-radius:50px; font-weight:600; border:none; transition:var(--transition); box-shadow:0 4px 20px rgba(99,102,241,.3); }
        .btn-start:hover { transform:translateY(-3px); box-shadow:0 8px 30px rgba(99,102,241,.4); }

        .hero-section { min-height:100vh; background:var(--gradient-primary); position:relative; overflow:hidden; display:flex; align-items:center; padding:120px 0 80px; }
        .hero-section::before { content:''; position:absolute; inset:0; background:url('https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=1200') center/cover; opacity:.08; animation:drift 30s infinite alternate; }
        .hero-section::after { content:''; position:absolute; width:600px; height:600px; background:rgba(255,255,255,.1); border-radius:50%; top:-300px; right:-200px; filter:blur(100px); }
        @keyframes drift { 0%{transform:scale(1) translateY(0)} 100%{transform:scale(1.05) translateY(-20px)} }
        .hero-content { position:relative; z-index:2; }
        .hero-title { font-size:clamp(2.5rem,5vw,4rem); font-weight:800; color:white; line-height:1.2; margin-bottom:25px; animation:fadeInUp 1s ease .2s backwards; }
        .hero-subtitle { font-size:clamp(1rem,2vw,1.25rem); color:rgba(255,255,255,.95); margin-bottom:40px; line-height:1.6; animation:fadeInUp 1s ease .4s backwards; max-width:90%; }
        .hero-buttons { animation:fadeInUp 1s ease .6s backwards; display:flex; flex-wrap:wrap; gap:15px; }
        .btn-hero { padding:16px 40px; border-radius:50px; font-weight:600; font-size:1rem; transition:var(--transition); border:none; display:inline-flex; align-items:center; gap:10px; }
        .btn-hero-primary { background:white; color:var(--primary-color); box-shadow:0 10px 30px rgba(0,0,0,.2); }
        .btn-hero-primary:hover { transform:translateY(-5px); box-shadow:0 15px 40px rgba(0,0,0,.25); color:var(--primary-color); }
        .btn-hero-secondary { background:rgba(255,255,255,.15); backdrop-filter:blur(10px); color:white; border:2px solid rgba(255,255,255,.3); }
        .btn-hero-secondary:hover { background:rgba(255,255,255,.25); color:white; transform:translateY(-5px); border-color:rgba(255,255,255,.5); }
        .hero-image { position:relative; animation:float 6s ease-in-out infinite; z-index:2; }
        @keyframes float { 0%,100%{transform:translateY(0)} 50%{transform:translateY(-20px)} }
        .hero-image img { border-radius:var(--border-radius); box-shadow:0 30px 80px rgba(0,0,0,.3); border:3px solid rgba(255,255,255,.2); width:100%; height:auto; }

        .stats-section { background:white; padding:60px 0; position:relative; margin-top:-80px; z-index:3; }
        .stats-container { background:white; border-radius:var(--border-radius); padding:40px; box-shadow:var(--shadow-lg); border:1px solid rgba(99,102,241,.1); }
        .stat-card { text-align:center; padding:20px; transition:var(--transition); }
        .stat-card:hover { transform:translateY(-10px); }
        .stat-icon { font-size:3rem; background:var(--gradient-primary); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; margin-bottom:15px; }
        .stat-number { font-size:2.5rem; font-weight:800; color:var(--dark-color); margin-bottom:10px; }
        .stat-label { color:var(--text-light); font-weight:500; font-size:.95rem; }

        .tech-section { padding:100px 0; background:var(--gradient-secondary); }
        .section-title { font-size:clamp(2rem,4vw,3rem); font-weight:800; text-align:center; margin-bottom:20px; color:var(--dark-color); }
        .section-subtitle { text-align:center; color:var(--dark-color); font-size:clamp(1rem,2vw,1.2rem); margin-bottom:60px; max-width:700px; margin-left:auto; margin-right:auto; }
        .tech-icons { display:flex; justify-content:center; flex-wrap:wrap; gap:25px; margin-top:50px; }
        .tech-icon { width:90px; height:90px; border-radius:var(--border-radius); display:flex; align-items:center; justify-content:center; font-size:3rem; background:var(--gradient-primary); -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text; box-shadow:var(--shadow-md); transition:var(--transition); animation:fadeIn 1s ease; border:2px solid rgba(99,102,241,.1); position:relative; }
        .tech-icon::before { content:''; position:absolute; inset:0; border-radius:var(--border-radius); background:white; z-index:-1; }
        .tech-icon:hover { transform:translateY(-15px) scale(1.1); box-shadow:var(--shadow-lg); border-color:var(--primary-color); }

        .courses-section { padding:100px 0; background:#f8fafc; }
        .course-card-new { background:#fff; border-radius:18px; overflow:hidden; box-shadow:0 4px 24px rgba(0,0,0,0.09); border:1.5px solid #e8eaf0; transition:box-shadow 0.3s ease,transform 0.3s ease; height:100%; display:flex; flex-direction:column; }
        .course-card-new:hover { transform:translateY(-7px); box-shadow:0 20px 52px rgba(99,102,241,0.16); border-color:rgba(99,102,241,0.35); }
        .cn-image { position:relative; height:215px; overflow:hidden; background:#e2e8f0; flex-shrink:0; }
        .cn-image img { width:100%; height:100%; object-fit:cover; transition:transform 0.5s ease; display:block; }
        .course-card-new:hover .cn-image img { transform:scale(1.06); }
        .cn-thumb-placeholder { width:100%; height:100%; background:linear-gradient(135deg,#6366f1,#8b5cf6); display:flex; align-items:center; justify-content:center; font-size:3.5rem; color:rgba(255,255,255,0.25); }
        .cn-badge { position:absolute; top:0; right:0; background:linear-gradient(135deg,#a67c00,#e6b422,#f5d060); color:#2d1a00; padding:9px 20px 9px 16px; border-radius:0 18px 0 16px; font-size:0.80rem; font-weight:800; letter-spacing:0.05em; box-shadow:0 3px 12px rgba(166,124,0,0.40); text-transform:uppercase; }
        .cn-discount-tag { position:absolute; bottom:12px; left:12px; background:linear-gradient(135deg,#ef4444,#f97316); color:white; padding:5px 13px; border-radius:50px; font-size:0.74rem; font-weight:800; box-shadow:0 2px 8px rgba(239,68,68,0.35); letter-spacing:0.03em; }
        .cn-body { padding:22px 24px 18px; flex:1; display:flex; flex-direction:column; gap:10px; }
        .cn-title { font-size:1.18rem; font-weight:800; color:#0f172a; line-height:1.35; margin:0; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }
        .cn-desc { font-size:0.875rem; color:#475569; line-height:1.65; margin:0; flex-grow:1; display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; overflow:hidden; }
        .cn-instructor { display:flex; align-items:center; gap:13px; padding:11px 13px; background:#f8fafc; border-radius:12px; border:1px solid #e2e8f0; }
        .cn-avatar { width:48px; height:48px; border-radius:50%; object-fit:cover; border:2.5px solid #fff; box-shadow:0 2px 10px rgba(99,102,241,0.22); flex-shrink:0; }
        .cn-avatar-initial { width:48px; height:48px; border-radius:50%; background:linear-gradient(135deg,#6366f1,#8b5cf6); display:flex; align-items:center; justify-content:center; color:white; font-weight:800; font-size:1.1rem; flex-shrink:0; border:2.5px solid #fff; box-shadow:0 2px 10px rgba(99,102,241,0.22); }
        .cn-instr-info { flex:1; min-width:0; }
        .cn-instr-name { font-size:0.92rem; font-weight:700; color:#1e293b; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .cn-instr-role { font-size:0.77rem; color:#64748b; margin-top:2px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .cn-rating-pill { display:inline-flex; align-items:center; gap:4px; font-size:0.80rem; font-weight:700; color:#78350f; background:#fef9c3; padding:4px 9px; border-radius:50px; border:1px solid #fde047; flex-shrink:0; }
        .cn-rating-pill i { color:#f59e0b; font-size:0.76rem; }
        .cn-price-block { border-top:1.5px solid #f1f5f9; padding-top:14px; }
        .cn-price-with-discount { display:flex; align-items:flex-start; justify-content:space-between; gap:8px; }
        .cn-price-left { display:flex; flex-direction:row; align-items:center; gap:7px; flex-wrap:nowrap; }
        .cn-price { font-size:1.80rem; font-weight:900; color:#1e1b4b; line-height:1; letter-spacing:-0.5px; }
        .cn-updated-label { font-size:0.74rem; font-weight:600; color:#6366f1; margin-top:0; line-height:1.80; align-self:flex-end; padding-bottom:2px; }
        .cn-price-right { text-align:right; line-height:1.6; flex-shrink:0; }
        .cn-orig-price-row { font-size:0.88rem; color:#64748b; font-weight:500; }
        .cn-orig-price { text-decoration:line-through; color:#94a3b8; font-weight:600; font-size:0.80rem; }
        .cn-discount-note { font-size:0.54rem; color:#dc2626; font-weight:700; }
        .cn-price-normal { display:flex; align-items:center; gap:10px; }
        .cn-price-plain { font-size:1.80rem; font-weight:900; color:#1e1b4b; letter-spacing:-0.5px; line-height:1; }
        .cn-free-tag { font-size:1.5rem; font-weight:900; color:#059669; }
        .cn-actions { display:flex; gap:10px; }
        .cn-btn-outline { flex:1; text-align:center; padding:12px 8px; border:2px solid #4f46e5; color:#4f46e5; border-radius:8px; font-size:0.80rem; font-weight:800; text-decoration:none; transition:all 0.25s ease; letter-spacing:0.06em; text-transform:uppercase; background:transparent; cursor:pointer; }
        .cn-btn-outline:hover { background:#4f46e5; color:white; }
        .cn-btn-solid { flex:1; text-align:center; padding:12px 8px; background:linear-gradient(135deg,#4f46e5,#7c3aed); color:white; border-radius:8px; font-size:0.80rem; font-weight:800; text-decoration:none; transition:all 0.25s ease; box-shadow:0 4px 16px rgba(79,70,229,0.40); letter-spacing:0.06em; text-transform:uppercase; border:none; display:inline-block; cursor:pointer; font-family:'Poppins',sans-serif; }
        .cn-btn-solid:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(79,70,229,0.50); color:white; }
        .cn-footer-meta { display:flex; justify-content:center; align-items:center; gap:8px; padding:10px 0 2px; border-top:1px solid #f1f5f9; font-size:0.77rem; color:#64748b; font-weight:600; flex-wrap:wrap; }
        .cn-footer-meta i { color:#6366f1; font-size:0.72rem; }
        .cn-dot { color:#cbd5e1; font-size:1rem; line-height:0; }

        .features-section { padding:100px 0; background:var(--gradient-primary); color:white; position:relative; overflow:hidden; }
        .features-section::before { content:''; position:absolute; width:500px; height:500px; background:rgba(255,255,255,.05); border-radius:50%; top:-250px; left:-100px; filter:blur(100px); }
        .features-section::after { content:''; position:absolute; width:400px; height:400px; background:rgba(255,255,255,.05); border-radius:50%; bottom:-200px; right:-100px; filter:blur(100px); }
        .feature-card { background:rgba(255,255,255,.1); backdrop-filter:blur(20px); padding:40px 30px; border-radius:var(--border-radius); text-align:center; transition:var(--transition); border:1px solid rgba(255,255,255,.2); margin-bottom:30px; height:100%; }
        .feature-card:hover { transform:translateY(-15px); background:rgba(255,255,255,.15); box-shadow:0 20px 50px rgba(0,0,0,.2); }
        .feature-icon { font-size:3.5rem; margin-bottom:25px; opacity:.95; }
        .feature-title { font-size:1.5rem; font-weight:700; margin-bottom:15px; }
        .feature-card p { opacity:.9; line-height:1.6; }

        .testimonials-section { padding:100px 0; background:white; }
        .testimonial-card { background:var(--gradient-secondary); padding:40px; border-radius:var(--border-radius); margin:20px; transition:var(--transition); border:1px solid rgba(99,102,241,.1); height:calc(100% - 40px); display:flex; flex-direction:column; }
        .testimonial-card:hover { transform:translateY(-15px); box-shadow:var(--shadow-lg); border-color:var(--primary-color); }
        .testimonial-text { font-size:1.05rem; color:var(--text-dark); margin-bottom:25px; font-style:italic; line-height:1.7; flex-grow:1; }
        .testimonial-author { display:flex; align-items:center; gap:15px; }
        .testimonial-avatar { width:60px; height:60px; border-radius:50%; object-fit:cover; border:3px solid white; box-shadow:var(--shadow-sm); }
        .testimonial-info h5 { margin:0; color:var(--dark-color); font-weight:700; font-size:1.1rem; }
        .testimonial-role { color:var(--text-light); font-size:.9rem; margin-top:3px; }
        .testimonial-rating { color:#ffa500; margin-left:auto; display:flex; gap:3px; }

        .cta-section { padding:100px 0; background:var(--gradient-primary); color:white; text-align:center; position:relative; overflow:hidden; }
        .cta-section::before { content:''; position:absolute; width:600px; height:600px; background:rgba(255,255,255,.1); border-radius:50%; top:-300px; right:-200px; filter:blur(100px); }
        .cta-section::after { content:''; position:absolute; width:400px; height:400px; background:rgba(255,255,255,.1); border-radius:50%; bottom:-200px; left:-100px; filter:blur(100px); }
        .cta-content { position:relative; z-index:2; }
        .cta-title { font-size:clamp(2rem,4vw,3rem); font-weight:800; margin-bottom:25px; }
        .cta-text { font-size:clamp(1rem,2vw,1.3rem); margin-bottom:40px; opacity:.95; max-width:700px; margin-left:auto; margin-right:auto; }

        .footer { background:#111a30; color:white; padding:80px 0 30px; }
        .footer-title { font-size:1.3rem; font-weight:700; margin-bottom:25px; color:white; }
        .footer-links { list-style:none; padding:0; }
        .footer-links li { margin-bottom:12px; }
        .footer-links a { color:rgba(255,255,255,.7); text-decoration:none; transition:var(--transition); display:inline-block; }
        .footer-links a:hover { color:white; transform:translateX(5px); }
        .social-icons { display:flex; gap:15px; margin-top:20px; flex-wrap:wrap; }
        .social-icon { width:45px; height:45px; background:rgba(255,255,255,.1); border-radius:50%; display:flex; align-items:center; justify-content:center; color:white; font-size:1.2rem; transition:var(--transition); text-decoration:none; border:1px solid rgba(255,255,255,.2); }
        .social-icon:hover { background:var(--gradient-primary); transform:translateY(-5px); color:white; border-color:transparent; }
        .copyright { text-align:center; padding-top:30px; margin-top:50px; border-top:1px solid rgba(255,255,255,.1); color:rgba(255,255,255,.6); }

        @media(max-width:992px) { .hero-section{padding:100px 0 60px;} .hero-image{margin-top:50px;} .stat-card{margin-bottom:30px;} }
        @media(max-width:768px) { .navbar-brand{font-size:1.5rem;} .hero-title{font-size:2.5rem;} .hero-subtitle{max-width:100%;} .hero-buttons{flex-direction:column;align-items:stretch;} .btn-hero{width:100%;justify-content:center;} .section-title{font-size:2rem;} .cta-title{font-size:2rem;} .tech-icon{width:70px;height:70px;font-size:2.5rem;} .stat-number{font-size:2rem;} .testimonial-card{margin:10px 0;} .stats-section{padding:40px 0;} .stats-container{padding:30px 20px;} }
        @media(max-width:576px) { .hero-section{padding:80px 0 40px;} .stat-card{padding:15px 10px;} .stat-icon{font-size:2.5rem;} .feature-card{padding:30px 20px;} .testimonial-card{padding:30px 20px;} .footer{padding:60px 0 30px;} }

        @keyframes fadeInDown { from{opacity:0;transform:translateY(-30px)} to{opacity:1;transform:translateY(0)} }
        @keyframes fadeInUp   { from{opacity:0;transform:translateY(30px)}  to{opacity:1;transform:translateY(0)} }
        @keyframes fadeIn     { from{opacity:0} to{opacity:1} }

        /* ── Razorpay Phone Modal ── */
        .rzp-overlay {
            display:none; position:fixed; inset:0; z-index:9999;
            background:rgba(10,10,30,0.6); backdrop-filter:blur(6px);
            align-items:center; justify-content:center; padding:16px;
        }
        .rzp-overlay.open { display:flex; }
        .rzp-box {
            background:#fff; border-radius:20px; padding:36px 32px;
            width:100%; max-width:400px;
            box-shadow:0 30px 80px rgba(0,0,0,0.3);
            animation:rzpIn 0.28s cubic-bezier(.4,0,.2,1);
            position:relative;
        }
        @keyframes rzpIn {
            from{opacity:0;transform:translateY(20px) scale(0.97)}
            to  {opacity:1;transform:translateY(0)    scale(1)}
        }
        .rzp-close {
            position:absolute; top:14px; right:18px;
            background:none; border:none; font-size:1.2rem;
            color:#94a3b8; cursor:pointer; line-height:1; padding:4px 8px;
            border-radius:6px; transition:all 0.2s;
        }
        .rzp-close:hover { color:#1e293b; background:#f1f5f9; }
        .rzp-brand {
            font-size:1.05rem; font-weight:800; margin-bottom:4px;
            background:linear-gradient(135deg,#6366f1,#8b5cf6);
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            display:flex; align-items:center; gap:8px;
        }
        .rzp-brand i { -webkit-text-fill-color:#6366f1; font-size:1.1rem; }
        .rzp-ctitle {
            font-size:0.85rem; color:#64748b; font-weight:600;
            margin-bottom:4px; white-space:nowrap;
            overflow:hidden; text-overflow:ellipsis;
        }
        .rzp-price {
            font-size:1.9rem; font-weight:900; color:#1e1b4b;
            letter-spacing:-0.5px; margin-bottom:20px;
        }
        .rzp-user-info {
            background:#f8fafc; border:1px solid #e2e8f0;
            border-radius:12px; padding:12px 14px; margin-bottom:20px;
            display:flex; align-items:center; gap:12px;
        }
        .rzp-avatar {
            width:42px; height:42px; border-radius:50%;
            background:linear-gradient(135deg,#6366f1,#8b5cf6);
            display:flex; align-items:center; justify-content:center;
            color:#fff; font-weight:800; font-size:1rem; flex-shrink:0;
        }
        .rzp-uname  { font-size:0.90rem; font-weight:700; color:#1e293b; }
        .rzp-uemail { font-size:0.76rem; color:#64748b; margin-top:1px; }
        .rzp-label {
            font-size:0.72rem; font-weight:700; color:#94a3b8;
            text-transform:uppercase; letter-spacing:0.07em; margin-bottom:6px;
        }
        .rzp-input {
            width:100%; border:1.5px solid #e2e8f0; border-radius:10px;
            padding:12px 14px; font-size:0.92rem; color:#1e293b;
            font-family:'Poppins',sans-serif; transition:border-color 0.2s;
        }
        .rzp-input:focus { outline:none; border-color:#6366f1; }
        .rzp-input.err   { border-color:#ef4444; }
        .rzp-err { font-size:0.74rem; color:#ef4444; font-weight:600; margin-top:5px; display:none; }
        .rzp-submit {
            width:100%; background:linear-gradient(135deg,#4f46e5,#7c3aed);
            color:#fff; border:none; border-radius:12px; padding:14px;
            font-size:1rem; font-weight:800; cursor:pointer;
            font-family:'Poppins',sans-serif; transition:all 0.25s;
            box-shadow:0 4px 16px rgba(79,70,229,0.4); margin-top:16px;
            display:flex; align-items:center; justify-content:center; gap:8px;
        }
        .rzp-submit:hover   { transform:translateY(-2px); box-shadow:0 8px 24px rgba(79,70,229,0.5); }
        .rzp-submit:disabled{ opacity:0.6; cursor:not-allowed; transform:none; }
        .rzp-secure {
            text-align:center; font-size:0.70rem; color:#94a3b8;
            font-weight:600; margin-top:12px;
            display:flex; align-items:center; justify-content:center; gap:5px;
        }
        .rzp-secure i { color:#10b981; }
      /* Hover - normal items */
/* ── Clean Light Dropdown ── */
/* ── Modern Profile Dropdown ── */
.edu-profile-btn {
    background: var(--gradient-primary);
    color: white;
    border: none;
    border-radius: 50px;
    padding: 7px 18px 7px 7px;
    display: flex;
    align-items: center;
    gap: 9px;
    font-family: 'Poppins', sans-serif;
    font-weight: 600;
    font-size: 0.90rem;
    cursor: pointer;
    box-shadow: 0 4px 20px rgba(99,102,241,.3);
    transition: var(--transition);
    position: relative;
}
.edu-profile-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(99,102,241,.4); }
.edu-btn-circle {
    width: 28px; height: 28px; border-radius: 50%;
    background: rgba(255,255,255,0.25);
    border: 2px solid rgba(255,255,255,0.7);
    display: flex; align-items: center; justify-content: center;
    font-weight: 800; font-size: 0.90rem;
}

.edu-dropdown {
    position: absolute;
    top: calc(100% + 12px);
    right: 0;
    width: 260px;
    background: #f4f7fe;
    border-radius: 16px;
    box-shadow: 0 10px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1);
    border: 1px solid #e5e7eb;  /* ← yeh change karo */
    overflow: hidden;           /* ← yeh already hai, confirm karo */
    display: none;
    transform-origin: top right;
    animation: eduDropIn 0.25s cubic-bezier(.4,0,.2,1);
    z-index: 9999;
}
.edu-dropdown.open { display: block; }

@keyframes eduDropIn {
    from { opacity:0; transform:scale(0.95) translateY(-8px); }
    to   { opacity:1; transform:scale(1)    translateY(0); }
}

.edu-drop-header {
    padding: 20px;
    border-bottom: 1px solid #e5e7eb;  /* ← #f3f4f6 se change karo */
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    background: #f4f7fe;               /* ← explicitly set karo */
}
.edu-drop-avatar {
 width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #7148fc 0%, #d42ad3 100%);            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 10px;
        
    }
.edu-drop-header h3 { color: #111827; font-size: 1rem; font-weight: 600; margin: 0 0 3px; }
.edu-drop-header p  { color: #6b7280; font-size: 0.75rem; margin: 0; }

.edu-drop-menu { list-style: none; padding: 8px; margin: 0; }
.edu-drop-menu li a {
    display: flex; align-items: center; gap: 12px;
    padding: 10px 12px;
    text-decoration: none;
    color: #374151;
    font-size: 0.875rem;
    font-weight: 500;
    border-radius: 10px;
    transition: all 0.2s;
}
.edu-drop-menu li a:hover { background: #f3f4f6; color: #6366f1; }

.edu-drop-icon {
    width: 32px; height: 32px; border-radius: 8px;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.875rem; flex-shrink: 0;
}
.edu-drop-divider { border-top: 1px solid #f3f4f6; margin: 4px 0; }
.edu-drop-logout { color: #dc2626 !important; padding-top: 12px !important; }
.edu-drop-logout:hover { background: #fef2f2 !important; color: #dc2626 !important; }

.navbar .container { position: relative; }
</style>
</head>
<body>

<%
    int totalStudents = 50;
    int totalCourses = 25;
    int totalInstructors = 10;
    double averageRating = 4.7;

    SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
    String currentYear = yearFormat.format(new Date());

    String[] navItems = {"Home","Courses","About","Instructor","Pricing & FAQ","Contact"};
    String[] navLinks = {"#home","#courses","about","#instructor","#pricing-faq","Contact"};

    Long sessionUid    = (Long)   session.getAttribute("userId");
    String sessionName  = (String) session.getAttribute("fullName"); if(sessionName  == null) sessionName  = "";
    String sessionEmail = (String) session.getAttribute("email");    if(sessionEmail == null) sessionEmail = "";
    String sessionPhone = (String) session.getAttribute("phone");    if(sessionPhone == null) sessionPhone = "";

    // ✅ CHANGE 1: Enrolled course IDs fetch karo session se
    java.util.Set<Long> enrolledIds = new java.util.HashSet<>();
    if (sessionUid != null) {
        Object rawEnrolled = session.getAttribute("enrolledCourseIds");
        if (rawEnrolled instanceof java.util.Set) {
            enrolledIds = (java.util.Set<Long>) rawEnrolled;
        }
    }
%>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg fixed-top">
    <div class="container">
        <a class="navbar-brand" href="/index">
            <i class="fas fa-graduation-cap"></i> EduMaster
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav mx-auto">
                <% for(int i=0;i<navItems.length;i++) { %>
                    <li class="nav-item"><a class="nav-link" href="<%= navLinks[i] %>"><%= navItems[i] %></a></li>
                <% } %>
            </ul>
			<% if (sessionUid != null) { 
			    String role = (String) session.getAttribute("userRole");
			    String dashUrl      = "admin".equals(role)      ? "/admin/dashboard" 
			                        : "instructor".equals(role) ? "/instructor/instructordashboard" 
			                        : "/student/dashboard";
			    String myCoursesUrl = "instructor".equals(role) ? "/instructor/my-courses" 
			                        : "/student/my-courses";
			    String firstLetter  = sessionName != null && !sessionName.isEmpty() 
			                        ? String.valueOf(sessionName.charAt(0)).toUpperCase() : "U";
			    String firstName    = sessionName != null && sessionName.contains(" ") 
			                        ? sessionName.split(" ")[0] : sessionName;
			    String profilePic   = (String) session.getAttribute("profilePictureUrl");
			%>
			
			<!-- Profile Trigger Button -->
<button class="edu-profile-btn" id="eduProfileBtn" type="button">
    <% if (profilePic != null && !profilePic.isEmpty()) { %>
        <img src="<%= profilePic %>" alt="<%= firstName %>"
             style="width:28px;height:28px;border-radius:50%;object-fit:cover;border:2px solid rgba(255,255,255,0.7);">
    <% } else { %>
        <div class="edu-btn-circle"><%= firstLetter %></div>
    <% } %>
    <span><%= firstName %></span>
    <i class="fas fa-chevron-down" style="font-size:11px;"></i>
</button>
			<div class="edu-dropdown" id="eduDropdown">
			    <div class="edu-drop-header">
			        <% if (profilePic != null && !profilePic.isEmpty()) { %>
			            <img src="<%= profilePic %>" alt="<%= firstName %>"
			                 style="width:50px;height:50px;border-radius:50%;object-fit:cover;margin-bottom:10px;">
			        <% } else { %>
			            <div class="edu-drop-avatar"><%= firstLetter %></div>
			        <% } %>
			        <h3><%= sessionName %></h3>
			        <p><%= sessionEmail %></p>
			    </div>
			
			    <ul class="edu-drop-menu">
			        <li>
			            <a href="<%= dashUrl %>">
			                <div class="edu-drop-icon" style="background:#e0e7ff;color:#4f46e5;">
			                    <i class="fas fa-chart-line"></i>
			                </div>
			                My Dashboard
			            </a>
			        </li>
			        <li>
			            <a href="<%= myCoursesUrl %>">
			                <div class="edu-drop-icon" style="background:#dcfce7;color:#16a34a;">
			                    <i class="fas fa-book-open"></i>
			                </div>
			                My Courses
			            </a>
			        </li>
			        <li class="edu-drop-divider"></li>
			        <li>
			            <a href="/logout" class="edu-drop-logout">
			                <div class="edu-drop-icon" style="background:#fee2e2;color:#dc2626;">
			                    <i class="fas fa-sign-out-alt"></i>
			                </div>
			                Logout Account
			            </a>
			        </li>
			    </ul>
			</div>
			
			<% } else { %>
			    <a href="/login"><button class="btn btn-start">Login</button></a>
			<% } %>        </div>
    </div>
</nav>

<!-- Hero Section -->
<section id="home" class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 hero-content">
                <h1 class="hero-title">Master Skills That Build Your Career</h1>
                <p class="hero-subtitle">
                    Join a community of <%= totalStudents %>+ dedicated students.
                    Explore <%= totalCourses %>+ specialized courses led by <%= totalInstructors %> expert instructors to jumpstart your career
                </p>        
           <div class="hero-buttons">
			<a href="<%= request.getContextPath() %>/courses">
			    <button class="btn btn-hero btn-hero-primary">Explore Courses<i class="fas fa-arrow-right ms-2"></i></button>
			</a>
      <%
        String startLearningUrl;
        if (sessionUid != null) {
            String roleForHero = (String) session.getAttribute("userRole");
            startLearningUrl = "instructor".equals(roleForHero)
                    ? request.getContextPath() + "/instructor/my-courses"
                    : request.getContextPath() + "/student/my-courses";
        } else {
            startLearningUrl = request.getContextPath() + "/courses";
        }
       %>
       <a href="<%= startLearningUrl %>">
        <button class="btn btn-hero btn-hero-secondary"><i class="fas fa-play me-2"></i>Start Learning</button>
       </a>
     </div>






            </div>
            <div class="col-lg-6">
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600&h=500&fit=crop" alt="Learning" class="img-fluid">
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="stats-section">
    <div class="container">
        <div class="stats-container">
            <div class="row">
                <%
                    String[] statIcons   = {"fa-users","fa-book","fa-chalkboard-teacher","fa-star"};
                    String[] statNumbers = {totalStudents+"+", totalCourses+"+", totalInstructors+"+", String.valueOf(averageRating)};
                    String[] statLabels  = {"Active Students","Expert Courses","Expert Instructors","Average Rating"};
                    for(int i=0;i<statIcons.length;i++) {
                %>
                    <div class="col-md-3 col-6">
                        <div class="stat-card">
                            <div class="stat-icon"><i class="fas <%= statIcons[i] %>"></i></div>
                            <div class="stat-number"><%= statNumbers[i] %></div>
                            <div class="stat-label"><%= statLabels[i] %></div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</section>

<!-- Technologies Section -->
<section class="tech-section">
    <div class="container">
        <h2 class="section-title">Technologies You Will Master</h2>
        <p class="section-subtitle">Learn the most in-demand tools and frameworks used by industry leaders</p>
        <div class="tech-icons">
            <%
                String[] techIcons = {"fa-html5","fa-css3-alt","fa-js","fa-react","fa-node-js","fa-python","fa-angular","fa-vuejs"};
                String[] techNames = {"HTML5","CSS3","JavaScript","React","Node.js","Python","Angular","Vue.js"};
                for(int i=0;i<techIcons.length;i++) {
            %>
                <div class="tech-icon" title="<%= techNames[i] %>"><i class="fab <%= techIcons[i] %>"></i></div>
            <% } %>
        </div>
    </div>
</section>

<!-- Courses Section -->
<section id="courses" class="courses-section">
    <div class="container">
        <h2 class="section-title">Popular Courses</h2>
        <p class="section-subtitle">Discover our most loved courses designed by industry experts</p>

        <div class="row">
        <%
            java.util.List<com.vp.entity.Course> liveCourses =
                (java.util.List<com.vp.entity.Course>) request.getAttribute("liveCourses");

            if (liveCourses != null && !liveCourses.isEmpty()) {
                int shown = 0;
                for (com.vp.entity.Course course : liveCourses) {
                    if (shown >= 6) break;
                    shown++;

                    String cTitle    = course.getTitle()         != null ? course.getTitle()         : "Untitled Course";
                    String cDesc     = course.getDescription()   != null ? course.getDescription()   :
                                      (course.getSubtitle()      != null ? course.getSubtitle()      : "No description available.");
                    String cThumb    = course.getThumbnailUrl()  != null ? course.getThumbnailUrl()  : "";
                    String cCat      = course.getCategory()      != null ? course.getCategory()      : "General";
                    String cLevel    = course.getLevel()         != null ? course.getLevel()         : "Self-Paced";
                    double cPrice    = course.getPrice()         != null ? course.getPrice()         : 0.0;
                    double cDiscount = course.getDiscountPrice() != null ? course.getDiscountPrice() : 0.0;
                    double cRating   = course.getAverageRating() != null ? course.getAverageRating() : 0.0;
                    int    cLectures = course.getLecturesCount() != null ? course.getLecturesCount() : 0;
                    String cDuration = course.getTotalDuration() != null ? course.getTotalDuration() : "";

                    String instrName   = "Expert Instructor";
                    String instrAvatar = "";
                    String instrRole   = "Instructor";

                    com.vp.entity.User cIU = course.getInstructor();
                    if (cIU != null) {
                        String fn = cIU.getFullName();
                        if (fn != null && !fn.trim().isEmpty())
                            instrName = fn.trim();
                        else if (cIU.getEmail() != null)
                            instrName = cIU.getEmail().split("@")[0];

                        if (cIU.getProfilePictureUrl() != null && !cIU.getProfilePictureUrl().isEmpty())
                            instrAvatar = cIU.getProfilePictureUrl();
                        else if (course.getInstructorPhotoUrl() != null && !course.getInstructorPhotoUrl().isEmpty())
                            instrAvatar = course.getInstructorPhotoUrl();

                        if (cIU instanceof com.vp.entity.Instructor) {
                            com.vp.entity.Instructor ci = (com.vp.entity.Instructor) cIU;
                            if (ci.getSpecialization() != null && !ci.getSpecialization().isEmpty())
                                instrRole = ci.getSpecialization();
                        }
                    } else if (course.getInstructorPhotoUrl() != null && !course.getInstructorPhotoUrl().isEmpty()) {
                        instrAvatar = course.getInstructorPhotoUrl();
                    }
                    String instrInitial = instrName.isEmpty() ? "?" :
                        String.valueOf(instrName.charAt(0)).toUpperCase();

                    boolean hasDisc  = cDiscount > 0 && cDiscount < cPrice;
                    int     discPct  = hasDisc ? (int) Math.round((1 - cDiscount / cPrice) * 100) : 0;
                    String  ratingLbl = cRating > 0 ? String.format("%.1f", cRating) : "";

                    double  finalPrice   = hasDisc ? cDiscount : cPrice;
                    long    priceInPaise = (long)(finalPrice * 100);
                    boolean isFree       = (finalPrice == 0);
                    String  exploreUrl   = request.getContextPath() + "/courses/" + course.getId();
                    String  enrollUrl    = request.getContextPath() + "/enroll/"  + course.getId();
                    String  loginUrl     = request.getContextPath() + "/login?redirectTo=checkout&courseId=" + course.getId();

                    // ✅ CHANGE 2: Check karo kya yeh course already enrolled hai
                    boolean isEnrolled = enrolledIds.contains(course.getId());
        %>
                <div class="col-lg-4 col-md-6 mb-4 d-flex">
                    <div class="course-card-new w-100">
                        <div class="cn-image">
                            <% if (!cThumb.isEmpty()) { %>
                                <img src="<%= cThumb %>" alt="<%= cTitle %>" loading="lazy">
                            <% } else { %>
                                <div class="cn-thumb-placeholder"><i class="fas fa-book-open"></i></div>
                            <% } %>
                            <span class="cn-badge"><%= cCat %></span>
                            <% if (hasDisc) { %>
                                <span class="cn-discount-tag"><%= discPct %>% OFF</span>
                            <% } %>
                        </div>
                        <div class="cn-body">
                            <h3 class="cn-title"><%= cTitle %></h3>
                            <p class="cn-desc"><%= cDesc %></p>
                            <div class="cn-instructor">
                                <% if (!instrAvatar.isEmpty()) { %>
                                    <img src="<%= instrAvatar %>" alt="<%= instrName %>" class="cn-avatar">
                                <% } else { %>
                                    <div class="cn-avatar-initial"><%= instrInitial %></div>
                                <% } %>
                                <div class="cn-instr-info">
                                    <div class="cn-instr-name"><%= instrName %></div>
                                    <div class="cn-instr-role"><%= instrRole %></div>
                                </div>
                                <% if (!ratingLbl.isEmpty()) { %>
                                    <div class="cn-rating-pill">
                                        <i class="fas fa-star"></i>&nbsp;<%= ratingLbl %>
                                    </div>
                                <% } %>
                            </div>
                            <div class="cn-price-block">
                            <% if (hasDisc) { %>
                                <div class="cn-price-with-discount">
                                    <div class="cn-price-left">
                                        <span class="cn-price">₹<%= String.format("%,.0f", cDiscount) %></span>
                                        <span class="cn-updated-label">Updated Price</span>
                                    </div>
                                    <div class="cn-price-right">
                                        <div class="cn-orig-price-row">
                                            Original:&nbsp;<span class="cn-orig-price">₹<%= String.format("%,.0f", cPrice) %></span>
                                        </div>
                                        <div class="cn-discount-note">Limited time offer!</div>
                                    </div>
                                </div>
                            <% } else { %>
                                <div class="cn-price-normal">
                                    <% if (isFree) { %>
                                        <span class="cn-free-tag">Free</span>
                                    <% } else { %>
                                        <span class="cn-price-plain">₹<%= String.format("%,.0f", cPrice) %></span>
                                    <% } %>
                                </div>
                            <% } %>
                            </div>

                            <!-- Actions -->
                            <div class="cn-actions">
                                <a href="<%= exploreUrl %>" class="cn-btn-outline">EXPLORE</a>

                                <% if (isEnrolled) { %>
                                    <a href="<%= request.getContextPath() %>/student/my-courses"
                                       class="cn-btn-solid"
                                       style="background:linear-gradient(135deg,#10b981,#059669);
                                              box-shadow:0 4px 16px rgba(16,185,129,0.4);">
                                        <i class="fas fa-check-circle me-1"></i>ENROLLED
                                    </a>
                                <% } else if (isFree) { %>
                                    <a href="<%= sessionUid != null ? enrollUrl : loginUrl %>" class="cn-btn-solid">
                                        <i class="fas fa-graduation-cap me-1"></i>ENROLL FREE
                                    </a>
                                <% } else if (sessionUid == null) { %>
                                    <a href="<%= loginUrl %>" class="cn-btn-solid">
                                        <i class="fas fa-shopping-cart me-1"></i>BUY NOW
                                    </a>
                                <% } else { %>
                                    <button type="button" class="cn-btn-solid buy-now-btn"
                                        data-course-id="<%= course.getId() %>"
                                        data-course-title="<%= cTitle.replace("\"","&quot;") %>"
                                        data-amount="<%= priceInPaise %>"
                                        data-price-display="<%= String.format("%,.0f", finalPrice) %>"
                                        data-name="<%= sessionName %>"
                                        data-email="<%= sessionEmail %>"
                                        data-phone="<%= sessionPhone %>">
                                        <i class="fas fa-shopping-cart me-1"></i>BUY NOW
                                    </button>
                                <% } %>
                            </div>

                            <div class="cn-footer-meta">
                                <% if (cLectures > 0) { %>
                                    <span><i class="fas fa-play-circle"></i> <%= cLectures %> Lectures</span>
                                    <span class="cn-dot">•</span>
                                <% } %>
                                <% if (!cDuration.isEmpty()) { %>
                                    <span><i class="fas fa-clock"></i> <%= cDuration %></span>
                                    <span class="cn-dot">•</span>
                                <% } %>
                                <span><i class="fas fa-infinity"></i> <%= cLevel %></span>
                            </div>
                        </div>
                    </div>
                </div>
        <%
                }
            } else {
        %>
                <div class="col-12 text-center py-5">
                    <i class="fas fa-book-open" style="font-size:4rem;color:#cbd5e1;display:block;margin-bottom:1rem;"></i>
                    <h4 style="color:#64748b;font-weight:600;">No courses available yet</h4>
                    <p style="color:#94a3b8;">Our instructors are busy building great content — check back soon!</p>
                </div>
        <%
            }
        %>
        </div>

        <div class="text-center mt-5">
            <a href="${pageContext.request.contextPath}/courses" class="btn btn-hero btn-hero-primary">
                View All Courses <i class="fas fa-arrow-right ms-2"></i>
            </a>
        </div>
    </div>
</section>

<!-- Features Section -->
<section id="features" class="features-section">
    <div class="container">
        <h2 class="section-title" style="color:white;">Why Choose EduMaster?</h2>
        <p class="section-subtitle" style="color:rgba(255,255,255,.85);">Experience learning like never before with our unique features</p>
        <div class="row mt-5">
            <%!
                static class Feature {
                    String icon, title, description;
                    Feature(String i, String t, String d){ icon=i; title=t; description=d; }
                }
            %>
            <%
                Feature[] features = {
                    new Feature("fa-laptop-code","Real-World Projects","Build real-world projects that showcase your skills and boost your portfolio."),
                    new Feature("fa-certificate","Certified Learning","Earn industry-recognized certificates that validate your expertise."),
                    new Feature("fa-users","Expert Mentors","Learn from industry professionals with years of practical experience."),
                    new Feature("fa-clock","Lifetime Access","Study at your own pace with 24/7 access to all course materials.")
                };
                for(Feature feature : features) {
            %>
                <div class="col-lg-3 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas <%= feature.icon %>"></i></div>
                        <h3 class="feature-title"><%= feature.title %></h3>
                        <p><%= feature.description %></p>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section id="testimonials" class="testimonials-section">
    <div class="container">
        <h2 class="section-title">What Our Students Say</h2>
        <p class="section-subtitle">Join thousands of satisfied learners who transformed their careers</p>
        <div class="row mt-5">
            <%!
                static class Testimonial {
                    String text, name, role, avatar;
                    Testimonial(String t, String n, String r, String a){ text=t; name=n; role=r; avatar=a; }
                }
            %>
            <%
                Testimonial[] testimonials = {
                    new Testimonial("This platform completely changed my career trajectory. The courses are practical, well-structured, and taught by industry experts who genuinely care about your success.","Emma Rodriguez","Full Stack Developer","https://randomuser.me/api/portraits/women/44.jpg"),
                    new Testimonial("Best investment I've made in my career! The hands-on projects gave me real experience, and I landed my dream job within 3 months of completing the bootcamp.","James Chen","Software Engineer","https://randomuser.me/api/portraits/men/32.jpg"),
                    new Testimonial("As a complete beginner, I was nervous about learning to code. But the step-by-step approach and supportive community made it so much easier than I expected!","Sarah Johnson","Web Developer","https://randomuser.me/api/portraits/women/65.jpg")
                };
                for(Testimonial testimonial : testimonials) {
            %>
                <div class="col-lg-4 col-md-6">
                    <div class="testimonial-card">
                        <p class="testimonial-text">"<%= testimonial.text %>"</p>
                        <div class="testimonial-author">
                            <img src="<%= testimonial.avatar %>" alt="<%= testimonial.name %>" class="testimonial-avatar">
                            <div class="testimonial-info">
                                <h5><%= testimonial.name %></h5>
                                <p class="testimonial-role"><%= testimonial.role %></p>
                            </div>
                            <div class="testimonial-rating">
                                <i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i>
                                <i class="fas fa-star"></i><i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <div class="cta-content">
            <h2 class="cta-title">Join Our Global Expert Team</h2>
            <p class="cta-text">Lead <%= totalStudents %>+ students by joining our team of <%= totalInstructors %>+ experts.</p>
            <a href="/instructor/register">
                <button class="btn btn-hero btn-hero-primary">Apply Now<i class="fas fa-rocket ms-2"></i></button>
            </a>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 col-md-6 mb-4">
                <h3 class="footer-title"><i class="fas fa-graduation-cap"></i> EduMaster</h3>
                <p>Empowering <%= totalStudents %>+ learners with practical, industry-relevant courses that transform careers and build professional futures.</p>
                <div class="social-icons">
                    <%
                        String[] socialIcons = {"fa-facebook-f","fa-twitter","fa-instagram","fa-linkedin-in","fa-youtube"};
                        for(String icon : socialIcons) {
                    %>
                        <a href="#" class="social-icon"><i class="fab <%= icon %>"></i></a>
                    <% } %>
                </div>
            </div>
            <div class="col-lg-2 col-md-6 mb-4">
                <h4 class="footer-title">Quick Links</h4>
                <ul class="footer-links">
                    <%
                        String[] quickLinks = {"Home","All Courses","About Us","Privacy Policy","Terms of Service"};
                        for(String link : quickLinks) {
                    %><li><a href="#"><%= link %></a></li><% } %>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <h4 class="footer-title">Popular Courses</h4>
                <ul class="footer-links">
                    <%
                        String[] popularCourses = {"Web Development","Python Programming","Data Science","Digital Marketing","UI/UX Design"};
                        for(String courseName : popularCourses) {
                    %><li><a href="#"><%= courseName %></a></li><% } %>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <h4 class="footer-title">Contact Info</h4>
                <ul class="footer-links">
                    <li><i class="fas fa-map-marker-alt me-2"></i>Silicon City, Indore</li>
                    <li><i class="fas fa-phone me-2"></i>+1 (555) 123-4567</li>
                    <li><i class="fas fa-envelope me-2"></i>info@edumaster.com</li>
                    <li><i class="fas fa-clock me-2"></i>Mon - Fri: 9AM - 6PM</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="copyright">
        <p>&copy; <%= currentYear %> EduMaster - All Rights Reserved. Built with <i class="fas fa-heart" style="color:#ff6b6b;"></i> for learners worldwide</p>
    </div>
</footer>

<!-- Razorpay Phone Modal -->
<div class="rzp-overlay" id="rzpOverlay">
  <div class="rzp-box">
    <button class="rzp-close" id="rzpClose" title="Close">&#x2715;</button>

    <div class="rzp-brand"><i class="fas fa-graduation-cap"></i>EduMaster</div>
    <div class="rzp-ctitle" id="rzp-ctitle"></div>
    <div class="rzp-price">₹<span id="rzp-cprice"></span></div>

    <div class="rzp-user-info">
      <div class="rzp-avatar" id="rzp-avatar"></div>
      <div>
        <div class="rzp-uname"  id="rzp-uname"></div>
        <div class="rzp-uemail" id="rzp-uemail"></div>
      </div>
    </div>

    <div class="rzp-label">Mobile Number</div>
    <input type="tel" class="rzp-input" id="rzp-phone"
           placeholder="Enter 10-digit mobile number"
           maxlength="10" inputmode="numeric" autocomplete="tel">
    <div class="rzp-err" id="rzp-phone-err">Please enter a valid 10-digit number</div>

    <button class="rzp-submit" id="rzpPay">
        <i class="fas fa-lock"></i>&nbsp;Proceed to Pay
    </button>
    <div class="rzp-secure">
        <i class="fas fa-shield-alt"></i> 100% Secure &nbsp;·&nbsp; Powered by Razorpay
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Navbar scroll
    window.addEventListener('scroll', function() {
        document.querySelector('.navbar').classList.toggle('scrolled', window.scrollY > 50);
    });

    // Smooth scroll
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) target.scrollIntoView({ behavior:'smooth', block:'start' });
        });
    });

    // Card animation
    const observer = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, { threshold:0.1, rootMargin:'0px 0px -100px 0px' });
    document.querySelectorAll('.course-card-new, .feature-card, .testimonial-card').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'all 0.6s ease';
        observer.observe(el);
    });

    // Counter animation
    function animateCounter(el, target) {
        let current = 0;
        const inc = target / 80;
        const timer = setInterval(() => {
            current += inc;
            if (current >= target) { el.textContent = target + '+'; clearInterval(timer); }
            else el.textContent = Math.floor(current) + '+';
        }, 20);
    }
    const statsObs = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const n = entry.target.querySelector('.stat-number');
                const v = parseInt(n.textContent);
                if (!isNaN(v)) animateCounter(n, v);
                statsObs.unobserve(entry.target);
            }
        });
    }, { threshold:0.5 });
    document.querySelectorAll('.stat-card').forEach(c => statsObs.observe(c));


 // ── Payment verify (form submit) ──
    function verifyPayment(response) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '/payment/verify';

        // CSRF token add karo
        const csrf = document.createElement('input');
        csrf.type  = 'hidden';
        csrf.name  = '${_csrf.parameterName}';
        csrf.value = '${_csrf.token}';
        form.appendChild(csrf);

        [
            ['razorpay_order_id',   response.razorpay_order_id],
            ['razorpay_payment_id', response.razorpay_payment_id],
            ['razorpay_signature',  response.razorpay_signature]
        ].forEach(([k, v]) => {
            const inp = document.createElement('input');
            inp.type = 'hidden'; inp.name = k; inp.value = v;
            form.appendChild(inp);
        });

        document.body.appendChild(form);
        form.submit();
    }
    // ── BUY NOW click ──
    document.querySelectorAll('.buy-now-btn').forEach(function(btn) {
        btn.addEventListener('click', async function() {
            const courseId    = this.dataset.courseId;
            const courseTitle = this.dataset.courseTitle;
            const name        = this.dataset.name;
            const email       = this.dataset.email;
            const phone       = this.dataset.phone;

            this.disabled  = true;
            const origHtml = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>&nbsp;Please wait…';
            const btnRef   = this;

            try {
                // Step 1: Order create karo
                const res = await fetch('/payment/create-order', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: 'courseId=' + courseId
                });

                if (!res.ok) throw new Error('Server error: ' + res.status);
                const order = await res.json();
                if (order.error) throw new Error(order.error);

                // Step 2: Razorpay popup directly open karo
                const rzp = new Razorpay({
                    key:         order.keyId,
                    amount:      order.amount,
                    currency:    'INR',
                    name:        'EduMaster',
                    description: courseTitle,
                    order_id:    order.razorpayOrderId,
                    prefill: {
                        name:    name,
                        email:   email,
                        contact: phone && phone.trim().length === 10 ? phone.trim() : ''
                    },
                    theme: { color: '#4f46e5' },
                    handler: function(response) {
                        verifyPayment(response);
                    },
                    modal: {
                        ondismiss: function() {
                            btnRef.disabled  = false;
                            btnRef.innerHTML = origHtml;
                        }
                    }
                });
                rzp.open();

            } catch(err) {
                console.error('Payment error:', err);
                alert('Payment failed: ' + err.message);
                btnRef.disabled  = false;
                btnRef.innerHTML = origHtml;
            }
        });
    });
    (function() {
        const btn  = document.getElementById('eduProfileBtn');
        const menu = document.getElementById('eduDropdown');
        if (!btn || !menu) return;
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            menu.classList.toggle('open');
        });
        document.addEventListener('click', function(e) {
            if (!menu.contains(e.target) && e.target !== btn) {
                menu.classList.remove('open');
            }
        });
    })();
</script>
</body>
</html>




