<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings | EduMaster</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #0a0e1a; color: #e2e8f0; overflow-x: hidden; }
        
        .animated-bg { position: fixed; inset: 0; z-index: 0; pointer-events: none; background: radial-gradient(circle at 20% 50%, rgba(99,102,241,0.08) 0%, transparent 50%), radial-gradient(circle at 80% 80%, rgba(139,92,246,0.08) 0%, transparent 50%); }
        
        .sidebar { width: 280px; position: fixed; top: 0; left: 0; bottom: 0; background: linear-gradient(180deg, rgba(30,41,59,0.95) 0%, rgba(15,23,42,0.95) 100%); backdrop-filter: blur(20px); z-index: 1000; overflow-y: auto; box-shadow: 4px 0 40px rgba(0,0,0,0.5); border-right: 1px solid rgba(99,102,241,0.2); transition: margin-left 0.3s; }
        .sidebar-brand { padding: 2rem 1.5rem; font-weight: 800; font-size: 1.5rem; border-bottom: 1px solid rgba(99,102,241,0.2); display: flex; align-items: center; gap: 0.75rem; background: linear-gradient(135deg, rgba(99,102,241,0.2), rgba(139,92,246,0.2)); }
        .sidebar-brand i { font-size: 1.8rem; background: linear-gradient(135deg, #6366f1, #8b5cf6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; animation: pulse 2s ease-in-out infinite; }
        @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.1); } }
        
        .nav-section { padding: 1.5rem 0; }
        .nav-link { color: #94a3b8; padding: 1rem 1.5rem; font-weight: 500; display: flex; align-items: center; text-decoration: none; border-left: 3px solid transparent; transition: all 0.3s; position: relative; }
        .nav-link::before { content: ''; position: absolute; left: 0; top: 0; bottom: 0; width: 0; background: linear-gradient(90deg, rgba(99,102,241,0.2), transparent); transition: width 0.3s; }
        .nav-link:hover::before { width: 100%; }
        .nav-link:hover { color: #fff; border-left-color: #6366f1; transform: translateX(4px); }
        .nav-link.active { color: #fff; background: rgba(99,102,241,0.15); border-left-color: #6366f1; box-shadow: 0 0 30px rgba(99,102,241,0.3); }
        .nav-link i { width: 28px; margin-right: 0.85rem; transition: transform 0.3s; }
        .nav-link:hover i { transform: scale(1.2); }
        
        .menu-toggle { display: none; position: fixed; top: 1.5rem; left: 1.5rem; z-index: 1001; background: rgba(30,41,59,0.9); backdrop-filter: blur(10px); border: 2px solid rgba(99,102,241,0.3); color: #e2e8f0; padding: 0.85rem; border-radius: 12px; cursor: pointer; font-size: 1.3rem; box-shadow: 0 4px 20px rgba(0,0,0,0.3); }
        
        .main-content { margin-left: 280px; padding: 0; min-height: 100vh; position: relative; z-index: 1; transition: margin-left 0.3s; }
        
        .top-bar { background: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(139,92,246,0.1)); backdrop-filter: blur(20px); padding: 2rem 3rem; border-bottom: 1px solid rgba(99,102,241,0.2); box-shadow: 0 4px 30px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 100; animation: slideDown 0.6s; }
        @keyframes slideDown { from { opacity: 0; transform: translateY(-30px); } to { opacity: 1; transform: translateY(0); } }
        .page-title h1 { font-size: 2.2rem; font-weight: 800; background: linear-gradient(135deg, #fff, #a5b4fc); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 0.5rem; }
        .page-title p { color: #94a3b8; font-size: 1.05rem; }
        
        .content-wrapper { max-width: 1400px; margin: 0 auto; padding: 2.5rem 3rem; }
        
        .tabs-container { display: flex; gap: 1rem; margin-bottom: 2.5rem; border-bottom: 2px solid rgba(99,102,241,0.2); overflow-x: auto; }
        .tab-button { padding: 1rem 1.75rem; background: transparent; border: none; color: #94a3b8; font-weight: 600; font-size: 1rem; cursor: pointer; transition: all 0.3s; border-bottom: 3px solid transparent; white-space: nowrap; display: flex; align-items: center; gap: 0.5rem; font-family: 'Inter', sans-serif; }
        .tab-button:hover { color: #e2e8f0; }
        .tab-button.active { color: #fff; border-bottom-color: #6366f1; }
        .tab-button i { font-size: 1.1rem; }
        
        .settings-content { animation: fadeIn 0.6s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        
        .settings-section { background: rgba(30,41,59,0.5); backdrop-filter: blur(20px); border-radius: 20px; padding: 2.5rem; border: 1px solid rgba(99,102,241,0.2); box-shadow: 0 8px 32px rgba(0,0,0,0.3); display: none; }
        .settings-section.active { display: block; }
        
        .section-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid rgba(99,102,241,0.2); }
        .section-header h2 { font-size: 1.75rem; font-weight: 700; margin-bottom: 0.5rem; }
        .section-header p { color: #94a3b8; font-size: 0.95rem; }
        
        .subsection-divider { margin: 2.5rem 0; padding-top: 2rem; border-top: 2px solid rgba(99,102,241,0.15); }
        .subsection-divider h3 { font-size: 1.3rem; margin-bottom: 0.5rem; color: #e2e8f0; }
        .subsection-divider p { color: #94a3b8; font-size: 0.9rem; margin-bottom: 1.5rem; }
        
        .form-group { margin-bottom: 2rem; }
        .form-label { display: block; margin-bottom: 0.75rem; color: #a5b4fc; font-weight: 600; font-size: 0.9rem; }
        .form-input, .form-select { width: 100%; padding: 1rem 1.25rem; border: 2px solid rgba(99,102,241,0.3); border-radius: 12px; background: rgba(15,23,42,0.6); color: #e2e8f0; font-size: 1rem; transition: all 0.3s; font-family: 'Inter', sans-serif; }
        .form-input:focus, .form-select:focus { outline: none; border-color: #6366f1; box-shadow: 0 0 0 4px rgba(99,102,241,0.2); }
        .form-textarea { min-height: 120px; resize: vertical; }
        .form-help { color: #64748b; font-size: 0.85rem; margin-top: 0.5rem; }
        
        .profile-photo-section { display: flex; align-items: center; gap: 2rem; padding: 2rem; background: rgba(99,102,241,0.05); border-radius: 16px; border: 2px dashed rgba(99,102,241,0.3); margin-bottom: 2rem; }
        .profile-avatar { width: 120px; height: 120px; border-radius: 50%; background: linear-gradient(135deg, #6366f1, #8b5cf6); display: flex; align-items: center; justify-content: center; font-size: 3rem; color: white; font-weight: 700; box-shadow: 0 8px 30px rgba(99,102,241,0.4); overflow: hidden; }
        .profile-avatar img { width: 100%; height: 100%; object-fit: cover; }
        .profile-photo-actions { flex: 1; }
        .profile-photo-actions h3 { font-size: 1.1rem; margin-bottom: 0.5rem; }
        .profile-photo-actions p { color: #94a3b8; font-size: 0.9rem; margin-bottom: 1.5rem; }
        .photo-buttons { display: flex; gap: 1rem; }
        
        .btn-primary { padding: 0.85rem 1.75rem; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.3s; font-family: 'Inter', sans-serif; display: inline-flex; align-items: center; gap: 0.5rem; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(99,102,241,0.5); }
        
        .btn-secondary { padding: 0.85rem 1.75rem; background: rgba(100,116,139,0.2); border: 2px solid rgba(100,116,139,0.3); color: #94a3b8; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.3s; font-family: 'Inter', sans-serif; display: inline-flex; align-items: center; gap: 0.5rem; }
        .btn-secondary:hover { background: rgba(100,116,139,0.3); }
        
        .password-strength { margin-top: 1rem; }
        .strength-bar { height: 6px; background: rgba(100,116,139,0.3); border-radius: 3px; overflow: hidden; }
        .strength-fill { height: 100%; background: linear-gradient(90deg, #ef4444, #f59e0b, #10b981); width: 0%; transition: width 0.3s; }
        .strength-text { font-size: 0.85rem; margin-top: 0.5rem; color: #94a3b8; }
        
        .two-column-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; }
        
        .alert { padding: 1.25rem 2rem; border-radius: 14px; margin-bottom: 2rem; font-weight: 600; font-size: 1rem; }
        .alert-success { background: linear-gradient(135deg, rgba(16,185,129,0.2), rgba(5,150,105,0.2)); border: 2px solid rgba(16,185,129,0.3); color: #10b981; }
        .alert-error { background: linear-gradient(135deg, rgba(239,68,68,0.2), rgba(220,38,38,0.2)); border: 2px solid rgba(239,68,68,0.3); color: #ef4444; }
        
        .info-box { background: rgba(99,102,241,0.05); border: 2px solid rgba(99,102,241,0.2); border-radius: 12px; padding: 1.5rem; margin-bottom: 2rem; }
        .info-box h4 { margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.5rem; }
        .info-box h4 i { color: #6366f1; }
        .info-box p { color: #94a3b8; font-size: 0.9rem; }
        
        @media (max-width: 768px) { 
            .menu-toggle { display: block; }
            .sidebar { margin-left: -280px; }
            .sidebar.active { margin-left: 0; }
            .main-content { margin-left: 0; }
            .content-wrapper { padding: 1.5rem; }
            .top-bar { padding: 1.5rem; }
            .profile-photo-section { flex-direction: column; text-align: center; }
            .photo-buttons { flex-direction: column; }
            .two-column-grid { grid-template-columns: 1fr; }
            .tabs-container { padding-bottom: 0.5rem; }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>

    <button class="menu-toggle" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>

    <!-- Include Sidebar -->
    <jsp:include page="sidebar.jsp"/>

    <main class="main-content">
        <div class="top-bar">
            <div class="page-title">
                <h1>Settings</h1>
                <p>Manage your profile, security, and payout preferences</p>
            </div>
        </div>

        <div class="content-wrapper">
            <!-- Success/Error Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>

            <div class="tabs-container">
                <button class="tab-button active" onclick="switchTab('profile')">
                    <i class="fas fa-user"></i> Profile
                </button>
                <button class="tab-button" onclick="switchTab('education')">
                    <i class="fas fa-graduation-cap"></i> Education & Experience
                </button>
                <button class="tab-button" onclick="switchTab('credentials')">
                    <i class="fas fa-certificate"></i> Credentials
                </button>
                <button class="tab-button" onclick="switchTab('security')">
                    <i class="fas fa-lock"></i> Security
                </button>
                <button class="tab-button" onclick="switchTab('payout')">
                    <i class="fas fa-university"></i> Payout
                </button>
            </div>

            <div class="settings-content">
                <!-- Profile Section -->
                <div class="settings-section active" id="profile-section">
                    <div class="section-header">
                        <h2>Profile Information</h2>
                        <p>Update your personal details and profile photo</p>
                    </div>

                    <div class="profile-photo-section">
                        <div class="profile-avatar">
                            <c:choose>
                                <c:when test="${not empty instructor.profilePictureUrl}">
                                    <img src="${pageContext.request.contextPath}${instructor.profilePictureUrl}" alt="Profile">
                                </c:when>
                                <c:otherwise>
                                    ${instructor.fullName.substring(0, 1).toUpperCase()}
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="profile-photo-actions">
                            <h3>Profile Photo</h3>
                            <p>Update your profile picture. JPG, PNG or GIF. Max size 5MB.</p>
                            <form action="${pageContext.request.contextPath}/instructor/settings/upload-photo" 
                                  method="post" enctype="multipart/form-data" id="photoForm">
                                <div class="photo-buttons">
                                    <label for="photoInput" class="btn-primary" style="cursor: pointer;">
                                        <i class="fas fa-upload"></i> Upload New
                                        <input type="file" id="photoInput" name="photo" accept="image/*" 
                                               style="display: none;" onchange="document.getElementById('photoForm').submit();">
                                    </label>
                                    <c:if test="${not empty instructor.profilePictureUrl}">
                                        <form action="${pageContext.request.contextPath}/instructor/settings/remove-photo" 
                                              method="post" style="display: inline;">
                                            <button type="submit" class="btn-secondary" onclick="return confirm('Remove profile photo?');">
                                                <i class="fas fa-trash"></i> Remove
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </form>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/instructor/settings/profile" method="post">
                        <div class="form-group">
                            <label class="form-label">Full Name *</label>
                            <input type="text" name="fullName" class="form-input" 
                                   value="${instructor.fullName}" placeholder="Enter your full name" required>
                        </div>

                        <div class="two-column-grid">
                            <div class="form-group">
                                <label class="form-label">Email Address *</label>
                                <input type="email" name="email" class="form-input" 
                                       value="${instructor.email}" placeholder="Enter your email" required>
                                <p class="form-help">This email will be used for all communications</p>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Phone Number</label>
                                <input type="tel" name="phone" class="form-input" 
                                       value="${instructor.phone}" placeholder="Enter your phone">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Bio</label>
                            <textarea name="bio" class="form-input form-textarea" 
                                      placeholder="Tell students about yourself...">${instructor.bio}</textarea>
                            <p class="form-help">Brief description for your instructor profile (max 500 characters)</p>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Specialization</label>
                            <input type="text" name="specialization" class="form-input" 
                                   value="${instructor.specialization}" placeholder="e.g., Full Stack Development, Java, UI/UX">
                        </div>

                        <div class="two-column-grid">
                            <div class="form-group">
                                <label class="form-label">Portfolio URL</label>
                                <input type="url" name="portfolioUrl" class="form-input" 
                                       value="${instructor.portfolioUrl}" placeholder="https://yourportfolio.com">
                            </div>

                            <div class="form-group">
                                <label class="form-label">LinkedIn URL</label>
                                <input type="url" name="linkedInUrl" class="form-input" 
                                       value="${instructor.linkedInUrl}" placeholder="https://linkedin.com/in/yourprofile">
                            </div>
                        </div>

                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save"></i> Save Profile
                        </button>
                    </form>
                </div>

                <!-- Education & Experience Section (COMBINED) -->
                <div class="settings-section" id="education-section">
                    <div class="section-header">
                        <h2>Education & Experience</h2>
                        <p>Add your educational qualifications and professional background</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/instructor/settings/profile" method="post">
                        <!-- Education Details -->
                        <div class="form-group">
                            <label class="form-label">Highest Degree</label>
                            <input type="text" name="highestDegree" class="form-input" 
                                   value="${instructor.highestDegree}" placeholder="e.g., B.Tech in Computer Science, MCA, MBA">
                            <p class="form-help">Enter your highest educational qualification</p>
                        </div>

                        <div class="two-column-grid">
                            <div class="form-group">
                                <label class="form-label">University/College</label>
                                <input type="text" name="university" class="form-input" 
                                       value="${instructor.university}" placeholder="Enter university or college name">
                            </div>

                            <div class="form-group">
                                <label class="form-label">Graduation Year</label>
                                <input type="number" name="graduationYear" class="form-input" 
                                       value="${instructor.graduationYear}" placeholder="e.g., 2020" min="1950" max="2030">
                            </div>
                        </div>

                        <!-- Professional Experience -->
                        <div class="subsection-divider">
                            <h3>Professional Experience</h3>
                            <p>Share your work experience and expertise</p>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Professional Experience</label>
                            <textarea name="experience" class="form-input form-textarea" style="min-height: 140px;"
                                      placeholder="Describe your professional journey and expertise...

Example: 
• 8+ years in Full Stack Development
• Expert in Java, Spring Boot, React, and AWS
• Led teams of 10+ developers">${instructor.experience}</textarea>
                            <p class="form-help">Share your professional journey and expertise</p>
                        </div>

                        <div class="info-box">
                            <h4>
                                <i class="fas fa-lightbulb"></i>
                                Profile Tips
                            </h4>
                            <p>
                                <strong>Education:</strong> Include your degree, institution, and specialization for better visibility.<br>
                                <strong>Experience:</strong> Mention years of experience, companies, technologies, and key achievements with specific numbers.
                            </p>
                        </div>

                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save"></i> Save Education & Experience
                        </button>
                    </form>
                </div>

                <!-- Credentials Section -->
                <div class="settings-section" id="credentials-section">
                    <div class="section-header">
                        <h2>Certifications & Credentials</h2>
                        <p>Showcase your certifications and professional credentials</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/instructor/settings/profile" method="post">
                        <div class="form-group">
                            <label class="form-label">Certifications</label>
                            <textarea name="certifications" class="form-input form-textarea" style="min-height: 150px;"
                                      placeholder="List your certifications (comma-separated or line by line)

Examples:
• AWS Certified Solutions Architect - Professional
• Oracle Certified Java SE 11 Developer
• Microsoft Azure Developer Associate
">${instructor.certifications}</textarea>
                            <p class="form-help">List all your professional certifications</p>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Credential Verification URL</label>
                            <input type="url" name="credentialUrl" class="form-input" 
                                   value="${instructor.credentialUrl}" placeholder="https://verify-credentials.com/your-profile">
                            <p class="form-help">Link where students can verify your credentials (e.g., Credly, LinkedIn, Coursera)</p>
                        </div>

                        <div class="subsection-divider">
                            <h3>Sample Teaching Video</h3>
                            <p>Upload a sample video to showcase your teaching style</p>
                        </div>

                        <div class="two-column-grid">
                            <div class="form-group">
                                <label class="form-label">Sample Video URL</label>
                                <input type="url" name="sampleVideoUrl" class="form-input" 
                                       value="${instructor.sampleVideoUrl}" placeholder="https://youtube.com/watch?v=...">
                                <p class="form-help">YouTube or Vimeo link</p>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Sample Video Title</label>
                                <input type="text" name="sampleVideoTitle" class="form-input" 
                                       value="${instructor.sampleVideoTitle}" placeholder="e.g., Introduction to Java Programming">
                            </div>
                        </div>

                        <div class="info-box">
                            <h4>
                                <i class="fas fa-video"></i>
                                Sample Video Guidelines
                            </h4>
                            <p>
                                • Keep it 5-10 minutes long<br>
                                • Show your teaching style and communication skills<br>
                                • Use good audio and video quality<br>
                                • Make it engaging and informative
                            </p>
                        </div>

                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save"></i> Save Credentials
                        </button>
                    </form>
                </div>

                <!-- Security Section -->
                <div class="settings-section" id="security-section">
                    <div class="section-header">
                        <h2>Account Security</h2>
                        <p>Update your password to keep your account secure</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/instructor/settings/change-password" method="post" onsubmit="return validatePassword()">
                        <div class="form-group">
                            <label class="form-label">Current Password *</label>
                            <input type="password" name="currentPassword" id="currentPassword" class="form-input" 
                                   placeholder="Enter your current password" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">New Password *</label>
                            <input type="password" name="newPassword" id="newPassword" class="form-input" 
                                   placeholder="Enter new password (min. 8 characters)" oninput="checkPasswordStrength(this.value)" required>
                            <div class="password-strength">
                                <div class="strength-bar">
                                    <div class="strength-fill" id="strengthFill"></div>
                                </div>
                                <p class="strength-text" id="strengthText">Password strength: Not set</p>
                            </div>
                            <p class="form-help">Use at least 8 characters with a mix of letters, numbers & symbols</p>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Confirm New Password *</label>
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-input" 
                                   placeholder="Re-enter new password" required>
                        </div>

                        <button type="submit" class="btn-primary">
                            <i class="fas fa-shield-alt"></i> Update Password
                        </button>
                    </form>
                </div>

                <!-- Payout Section -->
                <div class="settings-section" id="payout-section">
                    <div class="section-header">
                        <h2>Payout Settings</h2>
                        <p>Configure where you want to receive your earnings</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/instructor/settings/payout" method="post">
                        <div class="form-group">
                            <label class="form-label">Payout Method *</label>
                            <select name="payoutMethod" class="form-input form-select" required>
                                <option value="">Select payout method</option>
                                <option value="BANK_TRANSFER" ${instructor.payoutMethod == 'BANK_TRANSFER' ? 'selected' : ''}>Bank Transfer</option>
                                <option value="PAYPAL" ${instructor.payoutMethod == 'PAYPAL' ? 'selected' : ''}>PayPal</option>
                                <option value="UPI" ${instructor.payoutMethod == 'UPI' ? 'selected' : ''}>UPI (India)</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Account Holder Name *</label>
                            <input type="text" name="accountHolderName" class="form-input" 
                                   value="${instructor.accountHolderName}" placeholder="Enter name as per bank records" required>
                        </div>

                        <div class="two-column-grid">
                            <div class="form-group">
                                <label class="form-label">Bank Name *</label>
                                <input type="text" name="bankName" class="form-input" 
                                       value="${instructor.bankName}" placeholder="Enter your bank name" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Account Number *</label>
                                <input type="text" name="accountNumber" class="form-input" 
                                       value="${instructor.accountNumber}" placeholder="Enter account number" required>
                            </div>
                        </div>

                        <div class="two-column-grid">
                            <div class="form-group">
                                <label class="form-label">IFSC Code *</label>
                                <input type="text" name="ifscCode" class="form-input" 
                                       value="${instructor.ifscCode}" placeholder="Enter IFSC code" required>
                                <p class="form-help">11-character code (e.g., SBIN0001234)</p>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Minimum Payout Threshold</label>
                                <select name="minPayoutThreshold" class="form-input form-select">
                                    <option value="1000" ${instructor.minPayoutThreshold == 1000 ? 'selected' : ''}>₹1,000</option>
                                    <option value="2500" ${instructor.minPayoutThreshold == 2500 ? 'selected' : ''}>₹2,500</option>
                                    <option value="5000" ${instructor.minPayoutThreshold == 5000 ? 'selected' : ''}>₹5,000</option>
                                    <option value="10000" ${instructor.minPayoutThreshold == 10000 ? 'selected' : ''}>₹10,000</option>
                                </select>
                                <p class="form-help">Minimum balance required for payout</p>
                            </div>
                        </div>

                        <div class="info-box">
                            <h4>
                                <i class="fas fa-info-circle"></i>
                                Payout Schedule
                            </h4>
                            <p>
                                Payouts are processed on the 1st and 15th of each month. Funds will be transferred to your account within 3-5 business days.
                            </p>
                        </div>

                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save"></i> Save Payout Settings
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <script>
        function switchTab(tab) {
            document.querySelectorAll('.settings-section').forEach(el => {
                el.classList.remove('active');
            });
            document.querySelectorAll('.tab-button').forEach(el => {
                el.classList.remove('active');
            });

            document.getElementById(tab + '-section').classList.add('active');
            event.target.closest('.tab-button').classList.add('active');
        }

        function validatePassword() {
            const newPass = document.getElementById('newPassword').value;
            const confirmPass = document.getElementById('confirmPassword').value;
            
            if (newPass !== confirmPass) {
                alert('Passwords do not match!');
                return false;
            }
            
            if (newPass.length < 8) {
                alert('Password must be at least 8 characters!');
                return false;
            }
            
            return true;
        }

        function checkPasswordStrength(password) {
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');
            
            let strength = 0;
            if (password.length >= 8) strength += 25;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength += 25;
            if (password.match(/[0-9]/)) strength += 25;
            if (password.match(/[^a-zA-Z0-9]/)) strength += 25;
            
            strengthFill.style.width = strength + '%';
            
            if (strength === 0) {
                strengthText.textContent = 'Password strength: Not set';
                strengthText.style.color = '#94a3b8';
            } else if (strength <= 25) {
                strengthText.textContent = 'Password strength: Weak';
                strengthText.style.color = '#ef4444';
            } else if (strength <= 50) {
                strengthText.textContent = 'Password strength: Fair';
                strengthText.style.color = '#f59e0b';
            } else if (strength <= 75) {
                strengthText.textContent = 'Password strength: Good';
                strengthText.style.color = '#3b82f6';
            } else {
                strengthText.textContent = 'Password strength: Strong';
                strengthText.style.color = '#10b981';
            }
        }

        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('active');
        }

        document.addEventListener('click', function(event) {
            const sidebar = document.getElementById('sidebar');
            const menuToggle = document.querySelector('.menu-toggle');
            
            if (window.innerWidth <= 768) {
                if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                    sidebar.classList.remove('active');
                }
            }
        });

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transition = 'opacity 0.5s';
                    setTimeout(() => alert.remove(), 500);
                }, 5000);
            });
        });
    </script>
</body>
</html>