<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduMaster - Forgot Password</title>
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
            width: 500px;
            max-width: 95%;
            background: rgba(255, 255, 255, 0.25);
            border-radius: 20px;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
            z-index: 1;
            overflow: hidden;
        }

        .form-container {
            padding: 50px;
            background: #fff;
        }

        .icon-wrapper {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }

        .icon-wrapper i {
            font-size: 2rem;
            color: white;
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-header h3 {
            font-size: 1.8rem;
            font-weight: 700;
            color: #111827;
            margin-bottom: 8px;
        }

        .form-header p {
            color: #6b7280;
            font-size: 0.95rem;
            line-height: 1.5;
        }

        .step-indicator {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
        }

        .step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #9ca3af;
            transition: 0.3s;
            position: relative;
        }

        .step.active {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .step.completed {
            background: #10b981;
            color: white;
        }

        .step.completed i {
            font-size: 1rem;
        }

        .input-group {
            position: relative;
            margin-bottom: 20px;
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

        .password-toggle:hover,
        .password-toggle.active {
            color: #4f46e5;
        }

        .otp-inputs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            justify-content: center;
        }

        .otp-input {
            width: 50px;
            height: 55px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 600;
            border: 2px solid #e1e4e8;
            border-radius: 10px;
            outline: none;
            transition: 0.25s;
            background: #f9fafb;
        }

        .otp-input:focus {
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }

        .alert {
            margin-bottom: 20px;
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
            to { opacity: 1; transform: translateY(0); }
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
            transition: 0.25s;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.45);
            margin-top: 10px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 22px rgba(99, 102, 241, 0.6);
        }

        .btn-submit:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .resend-link {
            text-align: center;
            margin-top: 15px;
            font-size: 0.9rem;
            color: #6b7280;
        }

        .resend-link a {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 600;
            cursor: pointer;
        }

        .resend-link a:hover {
            text-decoration: underline;
        }

        .switch-link {
            text-align: center;
            margin-top: 20px;
            font-size: 0.95rem;
            color: #6b7280;
        }

        .switch-link a {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 700;
        }

        .switch-link a:hover {
            text-decoration: underline;
        }

        .step-content {
            display: none;
        }

        .step-content.active {
            display: block;
            animation: fadeIn 0.3s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @media (max-width: 600px) {
            .form-container { padding: 40px 30px; }
            .otp-input { width: 45px; height: 50px; font-size: 1.3rem; }
        }
    </style>
</head>
<body>
<div class="circle circle-1"></div>
<div class="circle circle-2"></div>
<div class="circle circle-3"></div>

<div class="glass-container">
    <div class="form-container">
        <div class="icon-wrapper">
            <i class="fas fa-lock"></i>
        </div>

        <div class="form-header">
            <h3>Reset Password</h3>
            <p>Enter your email to receive a verification code</p>
        </div>

        <!-- Step Indicator -->
        <div class="step-indicator">
            <div class="step active" id="step1">1</div>
            <div class="step" id="step2">2</div>
            <div class="step" id="step3">3</div>
        </div>

        <c:if test="${not empty success}">
            <div class="alert alert-success" id="successAlert">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" id="errorAlert">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Step 1: Enter Email -->
        <div class="step-content active" id="content-step1">
            <form id="emailForm">
                <div class="input-group">
                    <input type="email" id="email" placeholder=" " required>
                    <label>Email Address</label>
                </div>

                <button type="submit" class="btn-submit" id="sendOtpBtn">
                    <i class="fas fa-paper-plane"></i> Send Verification Code
                </button>
            </form>
        </div>

        <!-- Step 2: Enter OTP -->
        <div class="step-content" id="content-step2">
            <p style="text-align: center; color: #6b7280; margin-bottom: 20px; font-size: 0.9rem;">
                Enter the 6-digit code sent to <strong id="userEmail"></strong>
            </p>

            <form id="otpForm">
                <div class="otp-inputs">
                    <input type="text" maxlength="1" class="otp-input" id="otp1" required>
                    <input type="text" maxlength="1" class="otp-input" id="otp2" required>
                    <input type="text" maxlength="1" class="otp-input" id="otp3" required>
                    <input type="text" maxlength="1" class="otp-input" id="otp4" required>
                    <input type="text" maxlength="1" class="otp-input" id="otp5" required>
                    <input type="text" maxlength="1" class="otp-input" id="otp6" required>
                </div>

                <div class="resend-link">
                    Didn't receive code? <a id="resendOtpLink">Resend OTP</a>
                </div>

                <button type="submit" class="btn-submit" id="verifyOtpBtn">
                    <i class="fas fa-check"></i> Verify Code
                </button>
            </form>
        </div>

        <!-- Step 3: Reset Password -->
        <div class="step-content" id="content-step3">
            <form action="${pageContext.request.contextPath}/auth/reset-password" method="post" id="resetForm">
                <input type="hidden" name="email" id="hiddenEmail">

                <div class="input-group">
                    <input type="password" name="newPassword" id="newPassword" placeholder=" " required minlength="6">
                    <label>New Password</label>
                    <i class="fas fa-eye password-toggle" id="passwordToggle1"></i>
                </div>

                <div class="input-group">
                    <input type="password" name="confirmPassword" id="confirmPassword" placeholder=" " required minlength="6">
                    <label>Confirm Password</label>
                    <i class="fas fa-eye password-toggle" id="passwordToggle2"></i>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-key"></i> Reset Password
                </button>
            </form>
        </div>

        <div class="switch-link">
            <a href="${pageContext.request.contextPath}/login">
                <i class="fas fa-arrow-left"></i> Back to Login
            </a>
        </div>
    </div>
</div>

<script>
    let currentStep = 1;
    let userEmailValue = '';

    // Password toggle functionality
    function setupPasswordToggle(inputId, toggleId) {
        const input = document.getElementById(inputId);
        const toggle = document.getElementById(toggleId);

        if (toggle) {
            toggle.addEventListener('click', () => {
                const isHidden = input.type === 'password';
                input.type = isHidden ? 'text' : 'password';
                toggle.classList.toggle('fa-eye', !isHidden);
                toggle.classList.toggle('fa-eye-slash', isHidden);
                toggle.classList.toggle('active', isHidden);
            });
        }
    }

    setupPasswordToggle('newPassword', 'passwordToggle1');
    setupPasswordToggle('confirmPassword', 'passwordToggle2');

    // Navigate to step
    function goToStep(step) {
        // Hide all steps
        document.querySelectorAll('.step-content').forEach(content => {
            content.classList.remove('active');
        });

        // Show current step
        document.getElementById('content-step' + step).classList.add('active');

        // Update step indicators
        document.querySelectorAll('.step').forEach((stepEl, index) => {
            stepEl.classList.remove('active', 'completed');
            if (index + 1 < step) {
                stepEl.classList.add('completed');
                stepEl.innerHTML = '<i class="fas fa-check"></i>';
            } else if (index + 1 === step) {
                stepEl.classList.add('active');
                stepEl.textContent = index + 1;
            } else {
                stepEl.textContent = index + 1;
            }
        });

        currentStep = step;
    }

    // Step 1: Send OTP
    document.getElementById('emailForm').addEventListener('submit', (e) => {
        e.preventDefault();

        const email = document.getElementById('email').value.trim();
        const btn = document.getElementById('sendOtpBtn');

        if (!email) {
            alert('Please enter your email address');
            return;
        }

        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
        btn.disabled = true;

        console.log('Sending OTP request to:', '${pageContext.request.contextPath}/auth/forgot-password/send-otp');

        fetch('${pageContext.request.contextPath}/auth/forgot-password/send-otp', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'email=' + encodeURIComponent(email)
        })
        .then(response => {
            console.log('Response status:', response.status);
            return response.text();
        })
        .then(data => {
            console.log('Response data:', data);
            if (data === 'SUCCESS') {
                userEmailValue = email;
                document.getElementById('userEmail').textContent = email;
                document.getElementById('hiddenEmail').value = email;
                goToStep(2);
                document.getElementById('otp1').focus();
            } else if (data === 'NOT_FOUND') {
                alert('Email address not found. Please register first.');
                btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Verification Code';
                btn.disabled = false;
            } else {
                alert('Failed to send OTP. Please try again.');
                btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Verification Code';
                btn.disabled = false;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Network error: ' + error.message);
            btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send Verification Code';
            btn.disabled = false;
        });
    });

    // OTP Input Auto-focus
    const otpInputs = document.querySelectorAll('.otp-input');
    otpInputs.forEach((input, index) => {
        input.addEventListener('input', (e) => {
            if (e.target.value.length === 1 && index < otpInputs.length - 1) {
                otpInputs[index + 1].focus();
            }
        });

        input.addEventListener('keydown', (e) => {
            if (e.key === 'Backspace' && e.target.value === '' && index > 0) {
                otpInputs[index - 1].focus();
            }
        });

        // Allow only numbers
        input.addEventListener('keypress', (e) => {
            if (!/[0-9]/.test(e.key)) {
                e.preventDefault();
            }
        });
    });

    // Step 2: Verify OTP
    document.getElementById('otpForm').addEventListener('submit', (e) => {
        e.preventDefault();

        const otp = Array.from(otpInputs).map(input => input.value).join('');
        const btn = document.getElementById('verifyOtpBtn');

        if (otp.length !== 6) {
            alert('Please enter the complete 6-digit code');
            return;
        }

        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verifying...';
        btn.disabled = true;

        console.log('Verifying OTP:', otp);

        fetch('${pageContext.request.contextPath}/auth/forgot-password/verify-otp', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'email=' + encodeURIComponent(userEmailValue) + '&otp=' + otp
        })
        .then(response => {
            console.log('Verify response status:', response.status);
            return response.text();
        })
        .then(data => {
            console.log('Verify response data:', data);
            if (data === 'SUCCESS') {
                goToStep(3);
                document.getElementById('newPassword').focus();
            } else if (data === 'INVALID') {
                alert('Invalid OTP. Please try again.');
                otpInputs.forEach(input => input.value = '');
                otpInputs[0].focus();
                btn.innerHTML = '<i class="fas fa-check"></i> Verify Code';
                btn.disabled = false;
            } else if (data === 'EXPIRED') {
                alert('OTP has expired. Please request a new one.');
                goToStep(1);
                btn.innerHTML = '<i class="fas fa-check"></i> Verify Code';
                btn.disabled = false;
            } else {
                alert('Verification failed. Please try again.');
                btn.innerHTML = '<i class="fas fa-check"></i> Verify Code';
                btn.disabled = false;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Network error: ' + error.message);
            btn.innerHTML = '<i class="fas fa-check"></i> Verify Code';
            btn.disabled = false;
        });
    });

    // Resend OTP
    document.getElementById('resendOtpLink').addEventListener('click', (e) => {
        e.preventDefault();

        if (!userEmailValue) {
            alert('Please start from step 1');
            return;
        }

        const link = e.target;
        link.style.pointerEvents = 'none';
        link.style.opacity = '0.6';
        link.textContent = 'Sending...';

        fetch('${pageContext.request.contextPath}/auth/forgot-password/send-otp', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'email=' + encodeURIComponent(userEmailValue)
        })
        .then(response => response.text())
        .then(data => {
            if (data === 'SUCCESS') {
                alert('New OTP sent to ' + userEmailValue);
                otpInputs.forEach(input => input.value = '');
                otpInputs[0].focus();
            } else {
                alert('Failed to resend OTP. Please try again.');
            }
            link.style.pointerEvents = 'auto';
            link.style.opacity = '1';
            link.textContent = 'Resend OTP';
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Network error: ' + error.message);
            link.style.pointerEvents = 'auto';
            link.style.opacity = '1';
            link.textContent = 'Resend OTP';
        });
    });

    // Step 3: Reset Password Validation
    document.getElementById('resetForm').addEventListener('submit', (e) => {
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;

        if (newPassword !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match!');
            return false;
        }

        if (newPassword.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long!');
            return false;
        }
    });

    // Auto-hide alerts
    const successAlert = document.getElementById('successAlert');
    if (successAlert) {
        setTimeout(() => {
            successAlert.style.opacity = '0';
            setTimeout(() => successAlert.style.display = 'none', 300);
        }, 3000);
    }

    const errorAlert = document.getElementById('errorAlert');
    if (errorAlert) {
        setTimeout(() => {
            errorAlert.style.opacity = '0';
            setTimeout(() => errorAlert.style.display = 'none', 300);
        }, 3000);
    }
</script>
</body>
</html>