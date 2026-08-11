<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - EduMaster</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary-color: #6366f1;
            --secondary-color: #8b5cf6;
            --accent-color: #ec4899;
            --dark-color: #1e293b;
            --light-color: #f8fafc;
            --text-dark: #334155;
            --text-light: #64748b;
            --gradient-primary: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #ec4899 100%);
            --orange-color: #ff9500;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
            color: var(--text-dark);
            background: white;
        }
        
        /* Navbar Styles */
        .navbar {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .navbar-brand {
            font-size: 1.75rem;
            font-weight: 800;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .nav-link {
            color: var(--text-dark) !important;
            font-weight: 500;
            margin: 0 0.25rem;
            padding: 0.5rem 0.75rem !important;
            transition: all 0.3s ease;
            border-radius: 8px;
        }
        
        .nav-link:hover, .nav-link.active {
            color: var(--primary-color) !important;
            background: rgba(99, 102, 241, 0.05);
        }
        
        .btn-start {
            background: var(--gradient-primary);
            color: white !important;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(99, 102, 241, 0.3);
        }
        
        .btn-start:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(99, 102, 241, 0.4);
        }
        
        /* Hero Section with Background Image */
        .contact-hero {
            position: relative;
            height: 500px;
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1600&h=600&fit=crop');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-top: 76px;
        }
        
        .contact-hero-content {
            text-align: center;
            z-index: 2;
        }
        
        .contact-hero h1 {
            font-size: clamp(3rem, 8vw, 5rem);
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 10px rgba(0,0,0,0.3);
        }
        
        .contact-hero p {
            font-size: clamp(1rem, 2vw, 1.3rem);
            max-width: 700px;
            margin: 0 auto;
            opacity: 0.95;
        }
        
        /* Contact Section */
        .contact-section {
            padding: 100px 0;
            background: #f5f5f5;
        }
        
        .contact-left {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        }
        
        .contact-left h2 {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--dark-color);
            margin-bottom: 15px;
        }
        
        .orange-line {
            width: 80px;
            height: 4px;
            background: var(--orange-color);
            margin-bottom: 30px;
        }
        
        .contact-description {
            color: var(--text-light);
            line-height: 1.8;
            margin-bottom: 30px;
        }
        
        .contact-item {
            display: flex;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .contact-icon {
            width: 24px;
            height: 24px;
            color: var(--text-dark);
            font-size: 1.2rem;
            flex-shrink: 0;
            margin-top: 3px;
        }
        
        .contact-text p {
            margin: 0;
            color: var(--text-dark);
            font-weight: 500;
        }
        
        .contact-text a {
            color: var(--text-dark);
            text-decoration: none;
        }
        
        .contact-text a:hover {
            color: var(--primary-color);
        }
        
        .social-section h5 {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 15px;
            margin-top: 30px;
        }
        
        .social-icons-list {
            display: flex;
            gap: 12px;
        }
        
        .social-link {
            width: 40px;
            height: 40px;
            background: #f5f5f5;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-dark);
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .social-link:hover {
            background: var(--gradient-primary);
            color: white;
            transform: translateY(-3px);
        }
        
        /* Map Section */
        .map-container {
            margin-top: 30px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            height: 200px;
        }
        
        .map-container iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        
        /* Right Side - Form */
        .contact-form-card {
            background: white;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        }
        
        .contact-form-card h3 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 15px;
        }
        
        .form-subtitle {
            color: var(--text-light);
            margin-bottom: 35px;
        }
        
        .form-control {
            padding: 14px 20px;
            border: 2px solid #e5e5e5;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(99, 102, 241, 0.1);
            outline: none;
        }
        
        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }
        
        .btn-send {
            background: var(--orange-color);
            color: white;
            padding: 16px 50px;
            border-radius: 50px;
            font-weight: 700;
            border: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 20px rgba(255, 149, 0, 0.3);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .btn-send:hover {
            background: #e68600;
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(255, 149, 0, 0.4);
        }
        
        /* Alert Messages */
        .alert-custom {
            position: fixed;
            top: 100px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            animation: slideIn 0.5s ease;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* FAQ Section */
        .faq-section {
            padding: 100px 0;
            background: white;
        }
        
        .section-title {
            font-size: clamp(2rem, 5vw, 3rem);
            font-weight: 800;
            text-align: center;
            margin-bottom: 20px;
            color: var(--dark-color);
        }
        
        .section-subtitle {
            text-align: center;
            color: var(--text-light);
            font-size: 1.1rem;
            margin-bottom: 60px;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .accordion-item {
            background: white;
            border: 1px solid #e5e5e5;
            border-radius: 15px;
            margin-bottom: 15px;
            overflow: hidden;
        }
        
        .accordion-button {
            padding: 25px 30px;
            font-weight: 600;
            font-size: 1.1rem;
            color: var(--dark-color);
            background: white;
            border: none;
        }
        
        .accordion-button:not(.collapsed) {
            background: rgba(99, 102, 241, 0.05);
            color: var(--primary-color);
        }
        
        .accordion-button:focus {
            box-shadow: none;
        }
        
        .accordion-body {
            padding: 20px 30px 30px;
            color: var(--text-light);
            line-height: 1.7;
        }
        
        /* Footer */
        .footer {
            background: var(--dark-color);
            color: white;
            padding: 80px 0 30px;
        }
        
        .footer-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 25px;
            color: white;
        }
        
        .footer-links {
            list-style: none;
            padding: 0;
        }
        
        .footer-links li {
            margin-bottom: 12px;
        }
        
        .footer-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .footer-links a:hover {
            color: white;
            padding-left: 5px;
        }
        
        .footer-social {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }
        
        .social-icon {
            width: 45px;
            height: 45px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        
        .social-icon:hover {
            background: var(--gradient-primary);
            color: white;
            transform: translateY(-5px);
        }
        
        .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 50px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.6);
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .contact-left, .contact-form-card {
                margin-bottom: 30px;
            }
        }
        
        @media (max-width: 768px) {
            .contact-left, .contact-form-card {
                padding: 30px 20px;
            }
            
            .contact-hero {
                height: 400px;
            }
        }
    </style>
</head>
<body>
    <%
        // JSP Variables and Form Processing
        String message = "";
        String messageType = "";
        
        // Check if form was submitted
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String subject = request.getParameter("subject");
            String userMessage = request.getParameter("message");
            
            // Basic validation
            if (name != null && !name.trim().isEmpty() && 
                email != null && !email.trim().isEmpty() && 
                subject != null && !subject.trim().isEmpty() && 
                userMessage != null && !userMessage.trim().isEmpty()) {
                
                // Here you would typically:
                // 1. Save to database
                // 2. Send email notification
                // 3. Log the contact request
                
                message = "Thank you, " + name + "! Your message has been sent successfully. We'll get back to you at " + email + " soon.";
                messageType = "success";
                
                // You could also store in session for redirect pattern
                session.setAttribute("contactMessage", message);
                session.setAttribute("contactMessageType", messageType);
            } else {
                message = "Please fill in all required fields.";
                messageType = "danger";
            }
        }
        
        // Get current date for footer
        SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
        String currentYear = yearFormat.format(new Date());
    %>
    
    <!-- Display Alert Message if exists -->
    <% if (!message.isEmpty()) { %>
        <div class="alert alert-<%= messageType %> alert-dismissible fade show alert-custom" role="alert">
            <strong><%= messageType.equals("success") ? "Success!" : "Error!" %></strong> <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <script>
            // Auto-dismiss after 5 seconds
            setTimeout(function() {
                var alert = document.querySelector('.alert-custom');
                if (alert) {
                    var bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }
            }, 5000);
        </script>
    <% } %>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp"><i class="fas fa-graduation-cap"></i> EduMaster</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="courses">Courses</a></li>
                    <li class="nav-item"><a class="nav-link" href="#about">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="#instructor">Instructor</a></li>
                    <li class="nav-item"><a class="nav-link" href="#pricing-faq">Pricing & FAQ</a></li>
                    <li class="nav-item"><a class="nav-link active" href="contact">Contact</a></li>
                </ul>
                <button class="btn btn-start">Start Learning</button>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="contact-hero">
        <div class="container">
            <div class="contact-hero-content">
                <h1>Get in Touch</h1>
                <p>We're here to answer your questions and guide you through your learning journey. Reach out anytime and our team will respond with the support you need.</p>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="contact-section">
        <div class="container">
            <div class="row">
                <!-- Left Side -->
                <div class="col-lg-5">
                    <div class="contact-left">
                        <h2>Contact Us</h2>
                        <div class="orange-line"></div>
                        <p class="contact-description">Have questions or need assistance? We're always ready to help. Send us a message and our support team will get back to you shortly.</p>
                        
                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="contact-text">
                                <p>123 Fifth Avenue, New York, NY 10160</p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="contact-text">
                                <p><a href="mailto:contact@example.com">contact@example.com</a></p>
                            </div>
                        </div>

                        <div class="contact-item">
                            <div class="contact-icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="contact-text">
                                <p><a href="tel:+12345678900">1 234 567 890</a></p>
                            </div>
                        </div>

                        <!-- Map -->
                        <div class="map-container">
                            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3022.9663095343008!2d-74.00425878428698!3d40.74076684379132!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c259bf5c1654f3%3A0xc80f9cfce5383d5d!2sGoogle!5e0!3m2!1sen!2sus!4v1547732240477" allowfullscreen="" loading="lazy"></iframe>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Form -->
                <div class="col-lg-7">
                    <div class="contact-form-card">
                        <h3>Have Questions?</h3>
                        <p class="form-subtitle">Fill out the form below, and we'll get back to you as soon as possible.</p>
                        <form id="contactForm" method="post" action="contact.jsp">
                            <input type="text" name="name" class="form-control" placeholder="Name" required 
                                   value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
                            <input type="email" name="email" class="form-control" placeholder="Email Address" required
                                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                            <input type="text" name="subject" class="form-control" placeholder="Subject" required
                                   value="<%= request.getParameter("subject") != null ? request.getParameter("subject") : "" %>">
                            <textarea name="message" class="form-control" placeholder="Your Message" required><%= request.getParameter("message") != null ? request.getParameter("message") : "" %></textarea>
                            <button type="submit" class="btn-send">SEND MESSAGE</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section class="faq-section">
        <div class="container">
            <h2 class="section-title">Frequently Asked Questions</h2>
            <p class="section-subtitle">Find answers to common questions about our courses and platform</p>
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <div class="accordion" id="faqAccordion">
                        <%
                            // You can dynamically generate FAQs from database or array
                            String[][] faqs = {
                                {"faq2", "Do I get a certificate after completing a course?", "Yes! Upon successful completion of any course, you'll receive a verified certificate that you can share on LinkedIn, add to your resume, or showcase in your portfolio."},
                                {"faq3", "What is your refund policy?", "We offer a 30-day money-back guarantee. If you're not satisfied with your course for any reason within the first 30 days, contact our support team for a full refund."},
                                {"faq4", "Can I access courses on mobile devices?", "Absolutely! Our platform is fully responsive and works seamlessly on all devices including smartphones, tablets, and desktop computers. Learn anytime, anywhere."},
                                {"faq5", "How do I enroll in a course?", "Simply browse our course catalog, select the course you're interested in, and click the \"Enroll Now\" button. You'll be guided through a quick registration process and can start learning immediately after payment."}
                            };
                            
                            for (int i = 0; i < faqs.length; i++) {
                        %>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#<%= faqs[i][0] %>">
                                    <%= faqs[i][1] %>
                                </button>
                            </h2>
                            <div id="<%= faqs[i][0] %>" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    <%= faqs[i][2] %>
                                </div>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <h3 class="footer-title"><i class="fas fa-graduation-cap"></i> EduMaster</h3>
                    <p>Empowering learners worldwide with practical, industry-relevant courses that transform careers and build futures.</p>
                    <div class="footer-social">
                        <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6 mb-4">
                    <h4 class="footer-title">Quick Links</h4>
                    <ul class="footer-links">
                        <li><a href="#">Home</a></li>
                        <li><a href="#">All Courses</a></li>
                        <li><a href="#">About Us</a></li>
                        <li><a href="#">Instructors</a></li>
                        <li><a href="#">Blog</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <h4 class="footer-title">Popular Courses</h4>
                    <ul class="footer-links">
                        <li><a href="#">Web Development</a></li>
                        <li><a href="#">Python Programming</a></li>
                        <li><a href="#">Data Science</a></li>
                        <li><a href="#">Digital Marketing</a></li>
                        <li><a href="#">UI/UX Design</a></li>
                    </ul>
                </div>
                <div class="col-lg-3 col-md-6 mb-4">
                    <h4 class="footer-title">Contact Info</h4>
                    <ul class="footer-links">
                        <li><i class="fas fa-map-marker-alt me-2"></i> 123 Learning Street, Tech City</li>
                        <li><i class="fas fa-phone me-2"></i> +1 (555) 123-4567</li>
                        <li><i class="fas fa-envelope me-2"></i> info@edumaster.com</li>
                        <li><i class="fas fa-clock me-2"></i> Mon - Fri: 9AM - 6PM</li>
                    </ul>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; <%= currentYear %> EduMaster - All Rights Reserved. Built with <i class="fas fa-heart" style="color: #ff6b6b;"></i> for learners worldwide</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
