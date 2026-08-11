<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout | EduMaster</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Inter', sans-serif; 
            background: #0a0e1a; 
            color: #e2e8f0; 
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            position: relative;
        }
        
        .animated-bg { 
            position: fixed; 
            inset: 0; 
            z-index: 0; 
            pointer-events: none; 
            background: radial-gradient(circle at 20% 50%, rgba(99,102,241,0.1) 0%, transparent 50%), 
                        radial-gradient(circle at 80% 80%, rgba(139,92,246,0.1) 0%, transparent 50%);
        }

        .floating-particles {
            position: fixed;
            inset: 0;
            z-index: 1;
            pointer-events: none;
            overflow: hidden;
        }

        .particle {
            position: absolute;
            width: 3px;
            height: 3px;
            background: #6366f1;
            border-radius: 50%;
            opacity: 0.3;
            animation: float 15s infinite ease-in-out;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0) translateX(0); }
            50% { transform: translateY(-100vh) translateX(50px); }
        }

        .logout-container {
            position: relative;
            z-index: 10;
            width: 90%;
            max-width: 500px;
            background: rgba(15,23,42,0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            border: 1px solid rgba(99,102,241,0.3);
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
            padding: 3rem;
            text-align: center;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px) scale(0.95); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }

        .logo {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 70px;
            height: 70px;
            background: rgba(99,102,241,0.15);
            border-radius: 16px;
            margin-bottom: 1.5rem;
        }

        .logo i {
            font-size: 2rem;
            color: #6366f1;
        }

        .logout-icon {
            font-size: 3.5rem;
            color: #6366f1;
            margin-bottom: 1.5rem;
        }

        h1 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #e2e8f0;
            margin-bottom: 0.75rem;
        }

        .subtitle {
            color: #94a3b8;
            font-size: 0.95rem;
            margin-bottom: 2rem;
            line-height: 1.5;
        }

        .user-info {
            background: rgba(99,102,241,0.08);
            border: 1px solid rgba(99,102,241,0.2);
            border-radius: 16px;
            padding: 1.25rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.25rem;
            color: white;
            flex-shrink: 0;
        }

        .user-details {
            text-align: left;
            flex: 1;
        }

        .user-name {
            font-weight: 600;
            font-size: 1rem;
            color: #e2e8f0;
            margin-bottom: 0.25rem;
        }

        .user-email {
            color: #94a3b8;
            font-size: 0.85rem;
        }

        .button-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .btn {
            padding: 0.85rem 1.75rem;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-family: 'Inter', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 0.95rem;
        }

        .btn-logout {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            box-shadow: 0 4px 15px rgba(99,102,241,0.3);
        }

        .btn-logout:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99,102,241,0.4);
        }

        .btn-cancel {
            background: rgba(100,116,139,0.15);
            border: 1px solid rgba(100,116,139,0.3);
            color: #cbd5e1;
        }

        .btn-cancel:hover {
            background: rgba(100,116,139,0.25);
            color: #e2e8f0;
            transform: translateY(-2px);
        }

        .session-info {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(99,102,241,0.2);
            display: flex;
            justify-content: space-around;
            font-size: 0.8rem;
            color: #94a3b8;
        }

        .session-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.5rem;
        }

        .session-item i {
            font-size: 1.1rem;
            color: #6366f1;
        }

        .loading-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.9);
            backdrop-filter: blur(10px);
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            gap: 2rem;
        }

        .loading-overlay.active {
            display: flex;
            animation: fadeIn 0.3s;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(99,102,241,0.2);
            border-top-color: #6366f1;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .loading-text {
            font-size: 1.2rem;
            font-weight: 600;
            color: #e2e8f0;
        }

        .success-icon {
            font-size: 4rem;
            color: #22c55e;
            animation: scaleIn 0.5s ease-out;
        }

        @keyframes scaleIn {
            from { transform: scale(0); }
            to { transform: scale(1); }
        }

        @media (max-width: 768px) {
            .logout-container {
                padding: 2rem 1.5rem;
                margin: 1rem;
            }

            h1 {
                font-size: 1.5rem;
            }

            .subtitle {
                font-size: 0.95rem;
            }

            .button-group {
                grid-template-columns: 1fr;
            }

            .session-info {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    
    <div class="floating-particles" id="particles"></div>

    <div class="logout-container">
        <div class="logo">
            <i class="fas fa-graduation-cap"></i>
        </div>

        <div class="logout-icon">
            <i class="fas fa-door-open"></i>
        </div>

        <h1>Ready to Leave?</h1>
        <p class="subtitle">Are you sure you want to logout from your instructor account? All your unsaved work will be preserved.</p>

        <div class="user-info">
            <div class="user-avatar">
                <c:choose>
                    <c:when test="${not empty user.fullName}">
                        ${user.fullName.substring(0,1)}${user.fullName.contains(' ') ? user.fullName.substring(user.fullName.indexOf(' ')+1, user.fullName.indexOf(' ')+2) : ''}
                    </c:when>
                    <c:otherwise>U</c:otherwise>
                </c:choose>
            </div>
            <div class="user-details">
                <div class="user-name">
                    <c:out value="${user.fullName}" default="User" />
                </div>
                <div class="user-email">
                    <c:out value="${user.email}" default="user@edumaster.com" />
                </div>
            </div>
        </div>

        <form id="logoutForm" method="POST" action="${pageContext.request.contextPath}/logout">
            <div class="button-group">
                <button type="button" class="btn btn-cancel" onclick="goBack()">
                    <i class="fas fa-arrow-left"></i>
                    Stay Logged In
                </button>
                <button type="button" class="btn btn-logout" onclick="confirmLogout()">
                    <i class="fas fa-sign-out-alt"></i>
                    Yes, Logout
                </button>
            </div>
        </form>

        <div class="session-info">
            <div class="session-item">
                <i class="fas fa-clock"></i>
                <span id="sessionTime">Session: 2h 34m</span>
            </div>
            <div class="session-item">
                <i class="fas fa-shield-alt"></i>
                <span>Secure Connection</span>
            </div>
            <div class="session-item">
                <i class="fas fa-laptop"></i>
                <span id="browserInfo">Loading...</span>
            </div>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
        <div class="loading-text" id="loadingText">Logging out securely...</div>
    </div>

    <script>
        // Generate floating particles
        function createParticles() {
            const particlesContainer = document.getElementById('particles');
            const particleCount = 30;

            for (let i = 0; i < particleCount; i++) {
                const particle = document.createElement('div');
                particle.className = 'particle';
                particle.style.left = Math.random() * 100 + '%';
                particle.style.top = Math.random() * 100 + '%';
                particle.style.animationDelay = Math.random() * 15 + 's';
                particle.style.animationDuration = (10 + Math.random() * 10) + 's';
                particlesContainer.appendChild(particle);
            }
        }

        function goBack() {
            window.history.back();
        }

        function confirmLogout() {
            const overlay = document.getElementById('loadingOverlay');
            const loadingText = document.getElementById('loadingText');
            
            overlay.classList.add('active');

            // Simulate logout process
            setTimeout(function() {
                loadingText.innerHTML = '<i class="fas fa-check-circle success-icon"></i><br>Logged out successfully!';
                
                setTimeout(function() {
                    document.getElementById('logoutForm').submit();
                }, 1500);
            }, 2000);
        }

        // Keyboard shortcut: ESC to cancel
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                goBack();
            }
        });

        // Detect browser and OS
        function detectBrowser() {
            const ua = navigator.userAgent;
            let browser = 'Browser';
            let os = 'Unknown';

            // Detect browser
            if (ua.indexOf('Firefox') > -1) browser = 'Firefox';
            else if (ua.indexOf('Edg') > -1) browser = 'Edge';
            else if (ua.indexOf('Chrome') > -1) browser = 'Chrome';
            else if (ua.indexOf('Safari') > -1) browser = 'Safari';

            // Detect OS
            if (ua.indexOf('Win') > -1) os = 'Windows';
            else if (ua.indexOf('Mac') > -1) os = 'macOS';
            else if (ua.indexOf('Linux') > -1) os = 'Linux';
            else if (ua.indexOf('Android') > -1) os = 'Android';
            else if (ua.indexOf('iOS') > -1) os = 'iOS';

            document.getElementById('browserInfo').textContent = browser + ' • ' + os;
        }

        // Initialize
        createParticles();
        detectBrowser();

        // Optional: Auto-update session time (if you pass session start time)
        let sessionMinutes = 154; // Default value
        setInterval(function() {
            sessionMinutes++;
            const hours = Math.floor(sessionMinutes / 60);
            const mins = sessionMinutes % 60;
            document.getElementById('sessionTime').textContent = 'Session: ' + hours + 'h ' + mins + 'm';
        }, 60000);
    </script>
</body>
</html>