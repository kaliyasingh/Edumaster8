<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduMaster - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
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
            object-position: center;
            animation: smoothZoom 25s ease-in-out infinite;
        }

        @keyframes smoothZoom {
            0% { transform: scale(1) translateX(0); }
            25% { transform: scale(1.08) translateX(-3%); }
            50% { transform: scale(1.12) translateY(-3%); }
            75% { transform: scale(1.08) translateX(3%); }
            100% { transform: scale(1) translateX(0); }
        }

        .content-overlay {
            position: relative;
            z-index: 2;
            padding: 40px;
            background: linear-gradient(135deg, rgba(102,126,234,0.95), rgba(118,75,162,0.95));
            margin-top: auto;
        }

        .visual-side h2 {
            font-size: 2.2rem;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .visual-side p {
            opacity: 0.9;
            font-size: 1rem;
        }

        .form-side {
            flex: 1;
            padding: 40px 50px;
            background: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow-y: auto;
            max-height: 650px;
        }

        .form-header {
            margin-bottom: 20px;
        }

        .form-header h3 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #111827;
            margin-bottom: 6px;
        }

        .form-header p {
            color: #6b7280;
            font-size: 0.95rem;
        }

        .input-group {
            position: relative;
            margin-bottom: 16px;
        }

        .input-group input {
            width: 100%;
            padding: 14px 15px;
            border: 1px solid #e1e4e8;
            border-radius: 10px;
            outline: none;
            background: #f9fafb;
            font-size: 0.95rem;
            transition: 0.25s;
        }

        .input-group label {
            position: absolute;
            left: 15px;
            top: 14px;
            color: #94a3b8;
            pointer-events: none;
            transition: 0.25s;
            font-size: 0.95rem;
        }

        .input-group input:focus,
        .input-group input:not(:placeholder-shown) {
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }

        .input-group input:focus + label,
        .input-group input:not(:placeholder-shown) + label {
            top: -10px;
            left: 10px;
            font-size: 0.75rem;
            color: #4f46e5;
            font-weight: 600;
            background: #fff;
            padding: 0 5px;
            border-radius: 4px;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 14px;
            cursor: pointer;
            color: #9ca3af;
            transition: 0.25s;
        }

        .password-toggle.active {
            color: #4f46e5;
        }

        .password-toggle:hover {
            color: #4f46e5;
        }

        .alert {
            margin-bottom: 16px;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.3s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .alert i { font-size: 1.1rem; }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none;
            border-radius: 10px;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 8px;
            transition: 0.25s;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.45);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 22px rgba(99, 102, 241, 0.6);
        }

        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .switch-link {
            text-align: center;
            margin-top: 18px;
            font-size: 0.95rem;
            color: #4b5563;
        }

        .switch-link a {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 700;
        }

        .switch-link a:hover { text-decoration: underline; }

        .otp-container {
            display: flex;
            gap: 10px;
            margin-bottom: 18px;
        }

        .btn-otp {
            padding: 14px 20px;
            background: transparent;
            border: 1px solid #667eea;
            color: #667eea;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.25s;
            white-space: nowrap;
            font-size: 0.9rem;
        }

        .btn-otp:hover:not(:disabled) {
            background: #667eea;
            color: #fff;
        }

        .btn-otp:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        @media (max-width: 900px) {
            .glass-container { flex-direction: column; height: auto; }
            .visual-side { height: 210px; }
            .form-side { padding: 40px 30px; max-height: none; }
        }
    </style>
</head>
<body>
<div class="circle circle-1"></div>
<div class="circle circle-2"></div>
<div class="circle circle-3"></div>

<div class="glass-container">
    <div class="visual-side">
        <img src="https://images.unsplash.com/photo-1523240795612-9a054b0db644?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
             alt="Students" class="hero-image">
        <div class="content-overlay">
            <h2>Join EduMaster Today</h2>
            <p>Connect with millions of learners around the world.</p>
        </div>
    </div>

    <div class="form-side">
        <div class="form-header">
            <h3>Create Account</h3>
            <p>Use your email to sign up in a few seconds.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" id="errorAlert" role="alert">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/adduser" method="post" id="registerForm" autocomplete="off">
            <!-- ✅ UPDATED: Changed from STUDENT to INSTRUCTOR -->
            <input type="hidden" name="role" value="ADMIN">
            
            <div class="input-group">
                <input type="text" name="cName" id="cName" placeholder=" " required value="${cName}">
                <label>Full Name</label>
            </div>

            <div class="input-group">
                <input type="email" name="email" id="email" placeholder=" " required value="${email}">
                <label>Email Address</label>
            </div>

            <div class="input-group">
                <input type="password" name="password" id="password" placeholder=" " required minlength="6">
                <label>Password</label>
                <i class="fas fa-eye password-toggle" id="passwordToggle"></i>
            </div>

            <div class="otp-container">
                <div class="input-group" style="flex-grow:1; margin-bottom:0;">
                    <input type="text" name="otp" id="otp" placeholder=" " maxlength="6" pattern="[0-9]{6}" disabled>
                    <label>Enter OTP</label>
                </div>
                <button type="button" class="btn-otp" id="sendOtpBtn" disabled>Send OTP</button>
            </div>

            <button type="submit" class="btn-submit" id="registerBtn">Sign Up</button>
        </form>

        <div class="switch-link">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
</div>

<script>
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

    const nameInput = document.getElementById('cName');
    const emailInput = document.getElementById('email');
    const otpInput = document.getElementById('otp');
    const sendOtpBtn = document.getElementById('sendOtpBtn');

    function canEnableOtp() {
        return nameInput.value.trim() && emailInput.value.trim();
    }

    function updateOtpState() {
        const enable = canEnableOtp();
        sendOtpBtn.disabled = !enable;
        otpInput.disabled = !enable;
    }

    nameInput.addEventListener('input', updateOtpState);
    emailInput.addEventListener('input', updateOtpState);

    sendOtpBtn.addEventListener('click', function () {
        const cName = nameInput.value.trim();
        const email = emailInput.value.trim();
        const btn = this;

        if (!cName || !email) return;

        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            alert('Please enter a valid email address');
            return;
        }

        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
        btn.disabled = true;

        fetch('${pageContext.request.contextPath}/sendOtp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'cName=' + encodeURIComponent(cName) + '&email=' + encodeURIComponent(email)
        })
            .then(response => response.text())
            .then(data => {
                if (data === 'SUCCESS') {
                    btn.textContent = 'OTP Sent!';
                    btn.style.background = '#10b981';
                    btn.style.color = '#fff';
                    btn.style.borderColor = '#10b981';
                    otpInput.disabled = false;
                    otpInput.focus();
                    alert('OTP sent successfully to ' + email);

                    setTimeout(() => {
                        btn.textContent = 'Resend OTP';
                        btn.style.background = 'transparent';
                        btn.style.color = '#667eea';
                        btn.style.borderColor = '#667eea';
                        btn.disabled = false;
                    }, 3000);
                } else if (data === 'EMAIL_EXISTS') {
                    alert('This email is already registered. Please login.');
                    btn.textContent = 'Send OTP';
                    btn.disabled = false;
                } else {
                    alert('Failed to send OTP. Please try again.');
                    btn.textContent = 'Send OTP';
                    btn.disabled = false;
                }
            })
            .catch(error => {
                alert('Error: ' + error);
                btn.textContent = 'Send OTP';
                btn.disabled = false;
            });
    });

    document.getElementById('registerForm').addEventListener('submit', function (e) {
        const otp = otpInput.value.trim();
        if (!otp || otp.length !== 6) {
            e.preventDefault();
            alert('Please enter the 6-digit OTP');
        }
    });

    const errorAlert = document.querySelector('.alert-danger');
    if (errorAlert) {
        setTimeout(() => {
            errorAlert.style.opacity = '0';
            setTimeout(() => errorAlert.style.display = 'none', 300);
        }, 4000);
    }
</script>
</body>
</html>
