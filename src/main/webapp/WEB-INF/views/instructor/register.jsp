<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduMaster - Instructor Registration</title>
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
            width: 1100px;
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
            flex: 1.2;
            padding: 40px 50px;
            background: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow-y: auto;
            max-height: 700px;
        }

        /* Progress Indicator */
        .progress-container {
            margin-bottom: 30px;
        }

        .progress-steps {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
            margin-bottom: 10px;
        }

        .progress-line {
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            height: 3px;
            background: #e5e7eb;
            z-index: 0;
        }

        .progress-line-fill {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            transition: width 0.4s ease;
            z-index: 1;
        }

        .step {
            position: relative;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
        }

        .step-circle {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #fff;
            border: 3px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            color: #9ca3af;
            transition: all 0.3s;
        }

        .step.active .step-circle {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .step.completed .step-circle {
            border-color: #10b981;
            background: #10b981;
            color: #fff;
        }

        .step-label {
            margin-top: 8px;
            font-size: 0.75rem;
            color: #9ca3af;
            font-weight: 500;
            text-align: center;
        }

        .step.active .step-label {
            color: #667eea;
            font-weight: 600;
        }

        .step.completed .step-label {
            color: #10b981;
        }

        .form-header {
            margin-bottom: 25px;
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

        /* Form Step Containers */
        .form-step {
            display: none;
        }

        .form-step.active {
            display: block;
            animation: fadeIn 0.4s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateX(20px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .input-group {
            position: relative;
            margin-bottom: 16px;
        }

        .input-group input,
        .input-group select,
        .input-group textarea {
            width: 100%;
            padding: 14px 15px;
            border: 1px solid #e1e4e8;
            border-radius: 10px;
            outline: none;
            background: #f9fafb;
            font-size: 0.95rem;
            transition: 0.25s;
            font-family: 'Poppins', sans-serif;
        }

        .input-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .input-group label {
            position: absolute;
            left: 15px;
            top: 14px;
            color: #94a3b8;
            pointer-events: none;
            transition: 0.25s;
            font-size: 0.95rem;
            background: transparent;
        }

        .input-group input:focus,
        .input-group select:focus,
        .input-group textarea:focus,
        .input-group input:not(:placeholder-shown),
        .input-group textarea:not(:placeholder-shown),
        .input-group select:valid {
            border-color: #667eea;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }

        .input-group input:focus + label,
        .input-group select:focus + label,
        .input-group textarea:focus + label,
        .input-group input:not(:placeholder-shown) + label,
        .input-group textarea:not(:placeholder-shown) + label,
        .input-group select:valid + label {
            top: -10px;
            left: 10px;
            font-size: 0.75rem;
            color: #4f46e5;
            font-weight: 600;
            background: #fff;
            padding: 0 5px;
            border-radius: 4px;
        }

        /* Special handling for select */
        .input-group select {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%2394a3b8' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }

        .input-group select option {
            padding: 10px;
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

        /* Buttons */
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }

        .btn-navigation {
            flex: 1;
            padding: 16px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: 0.25s;
        }

        .btn-prev {
            background: #f3f4f6;
            color: #374151;
        }

        .btn-prev:hover {
            background: #e5e7eb;
            transform: translateY(-2px);
        }

        .btn-next,
        .btn-submit {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.45);
        }

        .btn-next:hover,
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 22px rgba(99, 102, 241, 0.6);
        }

        .btn-navigation:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* Skills/Certifications Tag Input */
        .tags-container {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            padding: 12px;
            border: 1px solid #e1e4e8;
            border-radius: 10px;
            background: #f9fafb;
            min-height: 50px;
            cursor: text;
        }

        .tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .tag-remove {
            cursor: pointer;
            font-size: 1rem;
            opacity: 0.8;
            transition: 0.2s;
        }

        .tag-remove:hover {
            opacity: 1;
            transform: scale(1.2);
        }

        .tag-input {
            border: none;
            outline: none;
            background: transparent;
            flex: 1;
            min-width: 150px;
            padding: 6px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
        }

        .tags-label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.85rem;
            color: #4b5563;
            font-weight: 600;
        }

        .form-note {
            font-size: 0.8rem;
            color: #6b7280;
            margin-top: 4px;
            font-style: italic;
        }

        @media (max-width: 900px) {
            .glass-container { 
                flex-direction: column; 
                height: auto; 
            }
            .visual-side { 
                height: 210px; 
            }
            .form-side { 
                padding: 40px 30px; 
                max-height: none; 
            }
            .step-label {
                font-size: 0.65rem;
            }
            .step-circle {
                width: 36px;
                height: 36px;
                font-size: 0.8rem;
            }
        }
    </style>
</head>
<body>
<div class="circle circle-1"></div>
<div class="circle circle-2"></div>
<div class="circle circle-3"></div>

<div class="glass-container">
    <div class="visual-side">
        <img src="https://images.unsplash.com/photo-1524178232363-1fb2b075b655?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80"
             alt="Teaching" class="hero-image">
        <div class="content-overlay">
            <h2>Become an Instructor</h2>
            <p>Share your knowledge and inspire learners worldwide.</p>
        </div>
    </div>

    <div class="form-side">
        <!-- Progress Indicator -->
        <div class="progress-container">
            <div class="progress-steps">
                <div class="progress-line">
                    <div class="progress-line-fill" id="progressFill"></div>
                </div>
                <div class="step active" data-step="1">
                    <div class="step-circle">1</div>
                    <div class="step-label">Account</div>
                </div>
                <div class="step" data-step="2">
                    <div class="step-circle">2</div>
                    <div class="step-label">Professional</div>
                </div>
                <div class="step" data-step="3">
                    <div class="step-circle">3</div>
                    <div class="step-label">Education</div>
                </div>
                <div class="step" data-step="4">
                    <div class="step-circle">4</div>
                    <div class="step-label">Verification</div>
                </div>
            </div>
        </div>

        <div class="form-header">
            <h3 id="stepTitle">Create Your Account</h3>
            <p id="stepDescription">Enter your basic information</p>
        </div>

        <form action="${pageContext.request.contextPath}/instructor/adduser" method="post" id="registerForm" autocomplete="off">
            <input type="hidden" name="role" value="INSTRUCTOR">
            <input type="hidden" name="skills" id="skillsHidden">
            <input type="hidden" name="certifications" id="certificationsHidden">
            
            <!-- Step 1: Account Information -->
            <div class="form-step active" data-step="1">
                <div class="input-group">
                    <input type="text" name="firstName" id="firstName" placeholder=" " required>
                    <label>First Name</label>
                </div>

                <div class="input-group">
                    <input type="text" name="lastName" id="lastName" placeholder=" " required>
                    <label>Last Name</label>
                </div>

                <div class="input-group">
                    <input type="email" name="email" id="email" placeholder=" " required>
                    <label>Email Address</label>
                </div>

                <div class="input-group">
                    <input type="password" name="password" id="password" placeholder=" " required minlength="6">
                    <label>Password</label>
                    <i class="fas fa-eye password-toggle" id="passwordToggle"></i>
                </div>

                <div class="input-group">
                    <input type="tel" name="phone" id="phone" placeholder=" " required pattern="[0-9+\-\s()]{10,15}">
                    <label>Phone Number</label>
                </div>

                <div class="button-group">
                    <button type="button" class="btn-navigation btn-next" onclick="goToStep(2)">
                        Next <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <!-- Step 2: Professional Information -->
            <div class="form-step" data-step="2">
                <div class="input-group">
                    <select name="specialization" id="specialization" required>
                        <option value="" disabled selected></option>
                        <option value="Marketing">Marketing</option>
                        <option value="Software Development">Software Development</option>
                        <option value="Data Science">Data Science</option>
                        <option value="Business Management">Business Management</option>
                        <option value="Design">Design</option>
                        <option value="Engineering">Engineering</option>
                    </select>
                    <label>Area of Specialization</label>
                </div>

                <div class="input-group">
                    <select name="experienceYears" id="experienceYears" required>
                        <option value="" disabled selected></option>
                        <option value="1-3">1-3 years</option>
                        <option value="3-5">3-5 years</option>
                        <option value="5-7">5-7 years</option>
                    </select>
                    <label>Years of Experience</label>
                </div>

                <div class="input-group">
                    <textarea name="bio" id="bio" placeholder=" " required maxlength="500"></textarea>
                    <label>Professional Bio</label>
                </div>

                <div>
                    <label class="tags-label">Key Skills (Press Enter to add)</label>
                    <div class="tags-container" id="skillsContainer">
                        <input type="text" class="tag-input" id="skillInput" placeholder="e.g., SEO, Content Marketing...">
                    </div>
                </div>

                <div class="button-group">
                    <button type="button" class="btn-navigation btn-prev" onclick="goToStep(1)">
                        <i class="fas fa-arrow-left"></i> Back
                    </button>
                    <button type="button" class="btn-navigation btn-next" onclick="goToStep(3)">
                        Next <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <!-- Step 3: Education & Credentials -->
            <div class="form-step" data-step="3">
                <div class="input-group">
                    <select name="highestDegree" id="highestDegree" required>
                        <option value="" disabled selected></option>
                        <option value="Bachelor">Bachelor's Degree</option>
                        <option value="MBA">MBA</option>
                        <option value="Master">Master's Degree</option>
                        <option value="Professional">Professional Certificate</option>
                        <option value="Other">Other</option>
                    </select>
                    <label>Highest Degree</label>
                </div>

                <div class="input-group">
                    <input type="text" name="university" id="university" placeholder=" " required>
                    <label>University/Institution</label>
                </div>

                <div class="input-group">
                    <input type="number" name="graduationYear" id="graduationYear" placeholder=" " 
                           min="1960" max="2025" required>
                    <label>Graduation Year</label>
                </div>

                <div>
                    <label class="tags-label">Certifications (Press Enter to add)</label>
                    <div class="tags-container" id="certificationsContainer">
                        <input type="text" class="tag-input" id="certificationInput" 
                               placeholder="e.g., Google Ads Certified...">
                    </div>
                </div>

                <div class="button-group">
                    <button type="button" class="btn-navigation btn-prev" onclick="goToStep(2)">
                        <i class="fas fa-arrow-left"></i> Back
                    </button>
                    <button type="button" class="btn-navigation btn-next" onclick="goToStep(4)">
                        Next <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <!-- Step 4: Verification -->
            <div class="form-step" data-step="4">
                <div class="otp-container">
                    <div class="input-group" style="flex-grow:1; margin-bottom:0;">
                        <input type="text" name="otp" id="otp" placeholder=" " maxlength="6" 
                               pattern="[0-9]{6}" required>
                        <label>Enter OTP</label>
                    </div>
                    <button type="button" class="btn-otp" id="sendOtpBtn">Send OTP</button>
                </div>
                <p class="form-note">We'll send a verification code to your email address</p>

                <div class="button-group">
                    <button type="button" class="btn-navigation btn-prev" onclick="goToStep(3)">
                        <i class="fas fa-arrow-left"></i> Back
                    </button>
                    <button type="submit" class="btn-navigation btn-submit" id="registerBtn">
                        <i class="fas fa-check-circle"></i> Complete Registration
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // Global variables
    let currentStep = 1;
    const totalSteps = 4;
    let skills = [];
    let certifications = [];
    
    const stepTitles = {
        1: "Create Your Account",
        2: "Professional Information",
        3: "Education & Credentials",
        4: "Email Verification"
    };
    
    const stepDescriptions = {
        1: "Enter your basic information",
        2: "Tell us about your expertise",
        3: "Add your educational background",
        4: "Verify your email address"
    };

    // Update progress bar and step indicators
    function updateProgress() {
        const progressFill = document.getElementById('progressFill');
        const percentage = ((currentStep - 1) / (totalSteps - 1)) * 100;
        progressFill.style.width = percentage + '%';

        document.querySelectorAll('.step').forEach((step, index) => {
            const stepNum = index + 1;
            step.classList.remove('active', 'completed');
            
            if (stepNum < currentStep) {
                step.classList.add('completed');
                step.querySelector('.step-circle').innerHTML = '<i class="fas fa-check"></i>';
            } else if (stepNum === currentStep) {
                step.classList.add('active');
                step.querySelector('.step-circle').textContent = stepNum;
            } else {
                step.querySelector('.step-circle').textContent = stepNum;
            }
        });

        document.getElementById('stepTitle').textContent = stepTitles[currentStep];
        document.getElementById('stepDescription').textContent = stepDescriptions[currentStep];
    }

    // Navigate to a specific step
    function goToStep(step) {
        // Validate current step before moving forward
        if (step > currentStep && !validateStep(currentStep)) {
            return;
        }

        // Hide all steps
        document.querySelectorAll('.form-step').forEach(s => s.classList.remove('active'));
        
        // Show target step
        document.querySelector('.form-step[data-step="' + step + '"]').classList.add('active');
        
        currentStep = step;
        updateProgress();
    }

    // Validate step fields
    function validateStep(step) {
        const stepElement = document.querySelector('.form-step[data-step="' + step + '"]');
        const inputs = stepElement.querySelectorAll('input[required], select[required], textarea[required]');
        
        for (let input of inputs) {
            if (!input.value.trim()) {
                input.focus();
                alert('Please fill in all required fields');
                return false;
            }
            
            if (input.type === 'email' && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(input.value)) {
                input.focus();
                alert('Please enter a valid email address');
                return false;
            }
            
            if (input.type === 'password' && input.value.length < 6) {
                input.focus();
                alert('Password must be at least 6 characters');
                return false;
            }
        }
        
        return true;
    }

    // Handle select dropdown changes
    function handleSelectChange(select) {
        if (select.value) {
            select.classList.add('has-value');
        } else {
            select.classList.remove('has-value');
        }
    }

    // Password toggle
    document.getElementById('passwordToggle').addEventListener('click', function() {
        const passwordInput = document.getElementById('password');
        const isHidden = passwordInput.type === 'password';
        passwordInput.type = isHidden ? 'text' : 'password';
        this.classList.toggle('fa-eye', !isHidden);
        this.classList.toggle('fa-eye-slash', isHidden);
        this.classList.toggle('active', isHidden);
    });

    // Skills management - NOW USING COMMA-SEPARATED FORMAT
    function addSkill(skill) {
        skill = skill.trim();
        if (skill && !skills.includes(skill) && skills.length < 10) {
            skills.push(skill);
            renderSkills();
            // Changed to comma-separated format
            document.getElementById('skillsHidden').value = skills.join(', ');
        }
    }

    function removeSkill(skill) {
        skills = skills.filter(s => s !== skill);
        renderSkills();
        // Changed to comma-separated format
        document.getElementById('skillsHidden').value = skills.join(', ');
    }

    function renderSkills() {
        const container = document.getElementById('skillsContainer');
        const input = container.querySelector('.tag-input');
        
        const tags = skills.map(skill => 
            '<span class="tag">' + skill + '<i class="fas fa-times tag-remove" onclick="removeSkill(\'' + skill + '\')"></i></span>'
        ).join('');
        
        container.innerHTML = tags;
        container.appendChild(input);
        input.value = '';
    }

    document.getElementById('skillInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            addSkill(this.value);
        }
    });

    document.getElementById('skillsContainer').addEventListener('click', function() {
        document.getElementById('skillInput').focus();
    });

    // Certifications management - NOW USING COMMA-SEPARATED FORMAT
    function addCertification(cert) {
        cert = cert.trim();
        if (cert && !certifications.includes(cert) && certifications.length < 10) {
            certifications.push(cert);
            renderCertifications();
            // Changed to comma-separated format
            document.getElementById('certificationsHidden').value = certifications.join(', ');
        }
    }

    function removeCertification(cert) {
        certifications = certifications.filter(c => c !== cert);
        renderCertifications();
        // Changed to comma-separated format
        document.getElementById('certificationsHidden').value = certifications.join(', ');
    }

    function renderCertifications() {
        const container = document.getElementById('certificationsContainer');
        const input = container.querySelector('.tag-input');
        
        const tags = certifications.map(cert => 
            '<span class="tag">' + cert + '<i class="fas fa-times tag-remove" onclick="removeCertification(\'' + cert + '\')"></i></span>'
        ).join('');
        
        container.innerHTML = tags;
        container.appendChild(input);
        input.value = '';
    }

    document.getElementById('certificationInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            addCertification(this.value);
        }
    });

    document.getElementById('certificationsContainer').addEventListener('click', function() {
        document.getElementById('certificationInput').focus();
    });

    // OTP functionality
    document.getElementById('sendOtpBtn').addEventListener('click', function() {
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const email = document.getElementById('email').value.trim();
        const btn = this;

        if (!firstName || !lastName || !email) {
            alert('Please complete all previous steps first');
            goToStep(1);
            return;
        }

        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            alert('Please enter a valid email address');
            goToStep(1);
            document.getElementById('email').focus();
            return;
        }

        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
        btn.disabled = true;

        const cName = firstName + ' ' + lastName;

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
                document.getElementById('otp').focus();
                alert('OTP sent successfully to ' + email);

                setTimeout(() => {
                    btn.textContent = 'Resend OTP';
                    btn.style.background = 'transparent';
                    btn.style.color = '#667eea';
                    btn.style.borderColor = '#667eea';
                    btn.disabled = false;
                }, 30000);
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

    // Form submission
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const otp = document.getElementById('otp').value.trim();
        if (!otp || otp.length !== 6) {
            e.preventDefault();
            alert('Please enter the 6-digit OTP');
            return;
        }

        if (skills.length < 1) {
            e.preventDefault();
            alert('Please add at least 1 skill');
            goToStep(2);
            return;
        }
    });

    // Initialize
    updateProgress();
</script>
</body>
</html>
