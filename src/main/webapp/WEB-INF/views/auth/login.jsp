<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String rTo = request.getParameter("redirectTo");
    String cId = request.getParameter("courseId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduMaster - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .circle {
            position: absolute;
            border-radius: 50%;
            background: linear-gradient(to right, rgba(255,255,255,0.4), rgba(255,255,255,0.1));
            z-index: 0;
            animation: float 6s ease-in-out infinite;
        }
        .circle-1 { top: 5%; left: 10%; width: 250px; height: 250px; }
        .circle-2 { bottom: 5%; right: 10%; width: 350px; height: 350px; animation-delay: 2s; }
        .circle-3 { top: 50%; left: 5%; width: 150px; height: 150px; animation-delay: 4s; }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        .glass-container {
            position: relative;
            display: flex;
            width: 1000px;
            max-width: 95%;
            height: 650px;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 20px;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            z-index: 1;
            overflow: hidden;
        }

        .visual-side {
            flex: 1;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            color: #fff;
            overflow: hidden;
        }

        .hero-image {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 70%;
            object-fit: cover;
            object-position: center top;
            animation: smoothZoom 25s ease-in-out infinite;
        }

        @keyframes smoothZoom {
            0%   { transform: scale(1) translateX(0); }
            25%  { transform: scale(1.08) translateX(-3%); }
            50%  { transform: scale(1.12) translateY(-3%); }
            75%  { transform: scale(1.08) translateX(3%); }
            100% { transform: scale(1) translateX(0); }
        }

        .content-overlay {
            position: relative;
            z-index: 2;
            padding: 40px;
            background: linear-gradient(135deg, rgba(102,126,234,0.95), rgba(118,75,162,0.95));
            margin-top: auto;
        }

        .visual-side h2 { font-size: 2.2rem; margin-bottom: 10px; font-weight: 700; }
        .visual-side p  { opacity: 0.9; font-size: 1rem; }

        .form-side {
            flex: 1;
            padding: 50px;
            background: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow-y: auto;
        }

        .form-header { margin-bottom: 8px; }
        .form-header h3 { font-size: 1.8rem; font-weight: 700; color: #111827; margin-bottom: 6px; }
        .form-header p  { color: #6b7280; font-size: 0.95rem; }

        .role-label { font-size: 0.8rem; color: #6b7280; margin-bottom: 8px; }

        .role-segment {
            display: inline-flex;
            background: #f3f4f6;
            border-radius: 999px;
            padding: 6px 8px;
            gap: 6px;
            margin-bottom: 18px;
            position: relative;
        }

        .role-pill-bg {
            position: absolute;
            top: 6px; left: 8px;
            width: 44px; height: 44px;
            border-radius: 999px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            box-shadow: 0 4px 12px rgba(79,70,229,0.4);
            transition: transform 0.25s ease;
            z-index: 0;
        }

        .role-btn {
            border: none; background: transparent;
            width: 44px; height: 44px; border-radius: 999px;
            display: inline-flex; align-items: center; justify-content: center;
            cursor: pointer; transition: 0.2s;
            opacity: 0.55; position: relative;
        }
        .role-btn i { font-size: 1.15rem; color: #9ca3af; }
        .role-btn[data-role="instructor"] i,
        .role-btn[data-role="admin"] i    { color: #60a5fa; }
        .role-btn.active { opacity: 1; transform: scale(1.08); }
        .role-btn.active i { color: #f9fafb; }
        .role-btn:hover { opacity: 0.9; }
        .role-btn span { display: none; }

        .input-group { position: relative; margin-bottom: 18px; }
        .input-group input {
            width: 100%; padding: 14px 15px;
            border: 1px solid #e1e4e8; border-radius: 10px;
            outline: none; background: #f9fafb;
            font-size: 0.95rem; transition: 0.25s;
        }
        .input-group label {
            position: absolute; left: 15px; top: 14px;
            color: #94a3b8; pointer-events: none;
            transition: 0.25s; font-size: 0.95rem;
        }
        .input-group input:focus,
        .input-group input:not(:placeholder-shown) {
            border-color: #667eea; background: #fff;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }
        .input-group input:focus + label,
        .input-group input:not(:placeholder-shown) + label {
            top: -10px; left: 10px; font-size: 0.75rem;
            color: #4f46e5; font-weight: 600;
            background: #fff; padding: 0 5px; border-radius: 4px;
        }

        .password-toggle {
            position: absolute; right: 15px; top: 14px;
            cursor: pointer; color: #9ca3af; transition: 0.25s;
        }
        .password-toggle.active { color: #4f46e5; }
        .password-toggle:hover  { color: #4f46e5; }

        .alert {
            margin-bottom: 18px; border-radius: 10px;
            padding: 12px 16px; font-size: 0.9rem;
            display: flex; align-items: center; gap: 10px;
            animation: slideIn 0.3s ease-out;
        }
        @keyframes slideIn  { from{opacity:0;transform:translateY(-10px)} to{opacity:1;transform:translateY(0)} }
        @keyframes slideOut { from{opacity:1;transform:translateY(0)} to{opacity:0;transform:translateY(-10px)} }
        .alert.fade-out { animation: slideOut 0.3s ease-out forwards; }
        .alert-success { background:#dcfce7; color:#166534; border:1px solid #86efac; }
        .alert-danger  { background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; }
        .alert i { font-size: 1.1rem; }

        .btn-submit {
            width: 100%; padding: 16px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none; border-radius: 10px;
            color: white; font-size: 1rem; font-weight: 600;
            cursor: pointer; margin-top: 10px; transition: 0.25s;
            box-shadow: 0 4px 15px rgba(99,102,241,0.45);
        }
        .btn-submit:hover    { transform: translateY(-2px); box-shadow: 0 6px 22px rgba(99,102,241,0.6); }
        .btn-submit:disabled { opacity: 0.6; cursor: not-allowed; transform: none; box-shadow: none; }

        .form-options {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 4px; margin-bottom: 18px;
            font-size: 0.85rem; color: #6b7280;
        }
        .form-options a { color: #4f46e5; text-decoration: none; font-weight: 500; }
        .form-options a:hover { text-decoration: underline; }

        .switch-link { text-align: center; margin-top: 22px; font-size: 0.95rem; color: #4b5563; }
        .switch-link a { color: #4f46e5; text-decoration: none; font-weight: 700; }
        .switch-link a:hover { text-decoration: underline; }

        @media (max-width: 900px) {
            .glass-container { flex-direction: column; height: auto; }
            .visual-side { height: 230px; }
            .visual-side h2 { font-size: 1.6rem; }
            .form-side { padding: 40px 30px; }
        }
    </style>
</head>
<body>
<div class="circle circle-1"></div>
<div class="circle circle-2"></div>
<div class="circle circle-3"></div>

<div class="glass-container">
    <div class="visual-side">
    
    
        <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
             alt="Students" class="hero-image">
        <div class="content-overlay">
            <h2>Start Learning Today!</h2>
            <p>Unlock thousands of expert-led courses and transform your career.</p>
        </div>
    </div>

    <div class="form-side">
    <!-- Yeh add karo sabse pehle -->
    <!-- Logo as Home Link -->
    <a href="${pageContext.request.contextPath}/" 
   style="text-decoration:none; display:inline-flex; align-items:center; 
          gap:8px; margin-bottom:20px; align-self:flex-start;">
        <i class="fas fa-graduation-cap" 
           style="font-size:1.6rem; color:#6366f1;"></i>
        <span style="font-size:1.3rem; font-weight:800;
                     background:linear-gradient(135deg,#6366f1,#8b5cf6);
                     -webkit-background-clip:text; -webkit-text-fill-color:transparent;
                     background-clip:text;">
            EduMaster
        </span>
    </a>
        <div class="form-header">
            <h3>Welcome Back!</h3>
            <p>Choose your role and login with your email.</p>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success" id="successAlert" role="alert">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger" id="errorAlert" role="alert">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Role selector -->
        <div class="role-label">Login as</div>
        <div class="role-segment" id="roleSegment">
            <div class="role-pill-bg" id="rolePill"></div>
            <button type="button" class="role-btn active" data-role="student"     data-index="0"><i class="fas fa-user-graduate"></i></button>
            <button type="button" class="role-btn"        data-role="instructor"  data-index="1"><i class="fas fa-chalkboard-teacher"></i></button>
            <button type="button" class="role-btn"        data-role="admin"       data-index="2"><i class="fas fa-user-shield"></i></button>
        </div>

        <!-- Login form -->
        <form action="${pageContext.request.contextPath}/checkuser" method="post" id="loginForm" autocomplete="off">

            <!-- Role hidden field -->
            <input type="hidden" name="role" id="roleInput" value="student"/>

            <!-- ✅ redirectTo + courseId — BUY NOW flow ke liye -->
            <% if (rTo != null && !rTo.isEmpty()) { %>
                <input type="hidden" name="redirectTo" value="<%= rTo %>">
                <input type="hidden" name="courseId"   value="<%= cId != null ? cId : "" %>">
            <% } %>

            <div class="input-group">
                <input type="email" name="email" id="email" placeholder=" " required autocomplete="email"
                       value="${not empty email ? email : ''}">
                <label>Email address</label>
            </div>

            <div class="input-group">
                <input type="password" name="password" id="password" placeholder=" " required autocomplete="current-password">
                <label>Password</label>
                <i class="fas fa-eye password-toggle" id="passwordToggle"></i>
            </div>

            <div class="form-options">
                <label><input type="checkbox" name="rememberMe"> Remember me</label>
                <a href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a>
            </div>

            <button type="submit" class="btn-submit" id="loginBtn">Login</button>
        </form>

        <div class="switch-link">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/reg">Register now</a>
        </div>
    </div>
</div>

<script>
    // Password toggle
    const passwordInput = document.getElementById('password');
    const toggle = document.getElementById('passwordToggle');
    if (toggle) {
        toggle.addEventListener('click', () => {
            const isHidden = passwordInput.type === 'password';
            passwordInput.type = isHidden ? 'text' : 'password';
            toggle.classList.toggle('fa-eye', !isHidden);
            toggle.classList.toggle('fa-eye-slash', isHidden);
            toggle.classList.toggle('active', isHidden);
        });
    }

    // Role selector
    const roleButtons = document.querySelectorAll('.role-btn');
    const roleInput   = document.getElementById('roleInput');
    const rolePill    = document.getElementById('rolePill');

    function movePill(index) {
        rolePill.style.transform = 'translateX(' + (index * 50) + 'px)';
    }

    roleButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            roleButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            roleInput.value = btn.getAttribute('data-role');
            movePill(parseInt(btn.getAttribute('data-index'), 10) || 0);
        });
    });

    movePill(0);

    // URL ?role= se auto-select
    const urlRole = new URLSearchParams(window.location.search).get('role');
    if (urlRole) {
        roleButtons.forEach(btn => {
            if (btn.getAttribute('data-role') === urlRole) btn.click();
        });
    }

    // Loading state on submit
    document.getElementById('loginForm').addEventListener('submit', function() {
        const btn = document.getElementById('loginBtn');
        btn.disabled = true;
        btn.textContent = 'Logging in...';
    });

    // Auto-hide alerts
    ['successAlert','errorAlert'].forEach(id => {
        const el = document.getElementById(id);
        if (el) setTimeout(() => {
            el.classList.add('fade-out');
            setTimeout(() => el.style.display = 'none', 300);
        }, 3000);
    });
</script>
</body>
</html>
