<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - EduMaster</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --primary: #6366f1;
            --secondary: #8b5cf6;
            --accent: #ec4899;
            --orange: #ff9500;
            --success: #10b981;
            --dark: #1e293b;
            --light: #f8fafc;
            --transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            overflow-x: hidden;
            color: var(--dark);
            background: var(--light);
        }
        
        /* Modern Navbar */
        .navbar {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            padding: 1rem 0;
            box-shadow: 0 4px 30px rgba(0,0,0,0.08);
            transition: var(--transition);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }
        
        .navbar.scrolled {
            padding: 0.5rem 0;
            box-shadow: 0 8px 40px rgba(0,0,0,0.12);
        }
        
        .navbar-brand {
            font-size: 1.75rem;
            font-weight: 900;
            background: linear-gradient(135deg, #6366f1, #8b5cf6, #ec4899);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .nav-link {
            color: var(--dark) !important;
            font-weight: 600;
            margin: 0 0.5rem;
            padding: 0.6rem 1rem !important;
            transition: var(--transition);
            border-radius: 10px;
            position: relative;
        }
        
        .nav-link:hover, .nav-link.active {
            color: var(--primary) !important;
            background: rgba(99, 102, 241, 0.08);
        }
        
        .btn-start {
            background: linear-gradient(135deg, #6366f1, #8b5cf6, #ec4899);
            color: white !important;
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 700;
            border: none;
            transition: var(--transition);
            box-shadow: 0 8px 25px rgba(99, 102, 241, 0.35);
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-start:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(99, 102, 241, 0.45);
        }
        
        /* Hero Section - Redesigned */
        .about-hero {
            position: relative;
            padding: 180px 0 100px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            overflow: hidden;
            margin-top: 70px;
        }
        
        .about-hero::before {
            content: '';
            position: absolute;
            width: 800px;
            height: 800px;
            background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 70%);
            border-radius: 50%;
            top: -400px;
            right: -200px;
            animation: pulse 8s ease-in-out infinite;
        }
        
        .about-hero::after {
            content: '';
            position: absolute;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
            bottom: -300px;
            left: -150px;
            animation: pulse 8s ease-in-out infinite reverse;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.1); opacity: 0.8; }
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
        }
        
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            padding: 12px 28px;
            border-radius: 50px;
            margin-bottom: 25px;
            font-weight: 600;
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: fadeInDown 0.8s ease;
        }
        
        .hero-content h1 {
            font-size: clamp(2.5rem, 6vw, 4.5rem);
            font-weight: 900;
            margin-bottom: 25px;
            line-height: 1.2;
            animation: fadeInUp 0.8s ease 0.2s both;
        }
        
        .hero-content p {
            font-size: clamp(1.1rem, 2vw, 1.3rem);
            max-width: 800px;
            margin: 0 auto 40px;
            opacity: 0.95;
            line-height: 1.8;
            animation: fadeInUp 0.8s ease 0.4s both;
        }
        
        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 60px;
            flex-wrap: wrap;
            margin-top: 50px;
            animation: fadeInUp 0.8s ease 0.6s both;
        }
        
        .hero-stat {
            text-align: center;
        }
        
        .hero-stat-number {
            font-size: 3rem;
            font-weight: 900;
            display: block;
            margin-bottom: 8px;
        }
        
        .hero-stat-label {
            font-size: 1rem;
            opacity: 0.9;
            font-weight: 500;
        }
        
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Story Section - New */
        .story-section {
            padding: 100px 0;
            background: white;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 70px;
        }
        
        .section-badge {
            display: inline-block;
            padding: 8px 20px;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1));
            color: var(--primary);
            border-radius: 50px;
            font-weight: 700;
            font-size: 0.9rem;
            margin-bottom: 20px;
            border: 2px solid rgba(99, 102, 241, 0.2);
        }
        
        .section-title {
            font-size: clamp(2.5rem, 4vw, 3.5rem);
            font-weight: 900;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .section-subtitle {
            font-size: 1.2rem;
            color: #64748b;
            max-width: 700px;
            margin: 0 auto;
            line-height: 1.8;
        }
        
        .story-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 80px;
            align-items: center;
        }
        
        .story-image {
            position: relative;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0,0,0,0.15);
        }
        
        .story-image img {
            width: 100%;
            height: 500px;
            object-fit: cover;
            display: block;
        }
        
        .story-image::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.3), rgba(236, 72, 153, 0.3));
            z-index: 1;
        }
        
        .story-text h3 {
            font-size: 2.2rem;
            font-weight: 800;
            margin-bottom: 25px;
            color: var(--dark);
        }
        
        .story-text p {
            font-size: 1.1rem;
            line-height: 1.9;
            color: #64748b;
            margin-bottom: 20px;
        }
        
        /* Mission Cards - Redesigned */
        .mission-section {
            padding: 100px 0;
            background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
        }
        
        .mission-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 40px;
            margin-top: 60px;
        }
        
        .mission-card {
            background: white;
            padding: 50px 40px;
            border-radius: 24px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.06);
            transition: var(--transition);
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
        }
        
        .mission-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            transform: scaleX(0);
            transition: var(--transition);
        }
        
        .mission-card:hover::before {
            transform: scaleX(1);
        }
        
        .mission-card:hover {
            transform: translateY(-15px);
            box-shadow: 0 25px 60px rgba(99, 102, 241, 0.2);
            border-color: rgba(99, 102, 241, 0.3);
        }
        
        .mission-icon {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.8rem;
            color: white;
            margin-bottom: 30px;
            box-shadow: 0 15px 35px rgba(99, 102, 241, 0.25);
            transition: var(--transition);
        }
        
        .mission-card:hover .mission-icon {
            transform: rotateY(360deg);
        }
        
        .mission-card h3 {
            font-size: 1.8rem;
            font-weight: 800;
            margin-bottom: 20px;
            color: var(--dark);
        }
        
        .mission-card p {
            font-size: 1.05rem;
            line-height: 1.8;
            color: #64748b;
        }
        
        /* Team Section - Completely Redesigned */
        .team-section {
            padding: 100px 0;
            background: white;
        }
        
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
            margin-top: 60px;
        }
        
        .team-card {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            transition: var(--transition);
            border: 2px solid #f1f5f9;
            position: relative;
        }
        
        .team-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 25px 60px rgba(99, 102, 241, 0.2);
            border-color: var(--primary);
        }
        
        .team-image {
            position: relative;
            height: 350px;
            overflow: hidden;
        }
        
        .team-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }
        
        .team-card:hover .team-image img {
            transform: scale(1.1);
        }
        
        .team-image::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.3) 100%);
            z-index: 1;
        }
        
        .team-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.95);
            padding: 8px 18px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--primary);
            z-index: 3;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .team-info {
            padding: 35px 30px;
            text-align: center;
        }
        
        .team-name {
            font-size: 1.6rem;
            font-weight: 800;
            margin-bottom: 8px;
            color: var(--dark);
        }
        
        .team-role {
            font-size: 1.05rem;
            color: var(--primary);
            font-weight: 600;
            margin-bottom: 20px;
        }
        
        .team-bio {
            font-size: 1rem;
            color: #64748b;
            line-height: 1.7;
            margin-bottom: 25px;
        }
        
        .team-social {
            display: flex;
            gap: 12px;
            justify-content: center;
        }
        
        .social-link {
            width: 42px;
            height: 42px;
            background: #f8fafc;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            transition: var(--transition);
            text-decoration: none;
            font-size: 1.1rem;
        }
        
        .social-link:hover {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            transform: translateY(-5px) scale(1.1);
        }
        
        /* Timeline Section - New Addition */
        .timeline-section {
            padding: 100px 0;
            background: linear-gradient(180deg, #f8fafc 0%, #ffffff 100%);
        }
        
        .timeline {
            position: relative;
            max-width: 900px;
            margin: 60px auto 0;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, var(--primary), var(--secondary));
            border-radius: 2px;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 60px;
            display: flex;
            align-items: center;
        }
        
        .timeline-item:nth-child(odd) {
            flex-direction: row-reverse;
        }
        
        .timeline-content {
            width: calc(50% - 40px);
            background: white;
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            border: 2px solid #f1f5f9;
            transition: var(--transition);
        }
        
        .timeline-item:nth-child(odd) .timeline-content {
            text-align: right;
        }
        
        .timeline-content:hover {
            transform: scale(1.05);
            box-shadow: 0 20px 50px rgba(99, 102, 241, 0.15);
            border-color: var(--primary);
        }
        
        .timeline-year {
            font-size: 1.3rem;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 12px;
        }
        
        .timeline-content h4 {
            font-size: 1.4rem;
            font-weight: 800;
            margin-bottom: 12px;
            color: var(--dark);
        }
        
        .timeline-content p {
            font-size: 1rem;
            color: #64748b;
            line-height: 1.7;
        }
        
        .timeline-dot {
            width: 24px;
            height: 24px;
            background: white;
            border: 6px solid var(--primary);
            border-radius: 50%;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            z-index: 2;
            box-shadow: 0 0 0 8px rgba(99, 102, 241, 0.15);
        }
        
        /* CTA Section - Enhanced */
        .cta-section {
            padding: 100px 0;
            background: var(--dark);
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .cta-section::before {
            content: '';
            position: absolute;
            width: 800px;
            height: 800px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            top: -400px;
            left: 50%;
            transform: translateX(-50%);
        }
        
        .cta-content {
            position: relative;
            z-index: 2;
        }
        
        .cta-content h2 {
            font-size: clamp(2.5rem, 5vw, 4rem);
            font-weight: 900;
            margin-bottom: 25px;
            line-height: 1.2;
        }
        
        .cta-content p {
            font-size: 1.3rem;
            margin-bottom: 50px;
            opacity: 0.95;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        
        .cta-buttons {
            display: flex;
            gap: 25px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-cta {
            padding: 18px 50px;
            border-radius: 50px;
            font-weight: 800;
            font-size: 1.1rem;
            transition: var(--transition);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-cta-primary {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            border: none;
            box-shadow: 0 15px 40px rgba(99, 102, 241, 0.4);
        }
        
        .btn-cta-primary:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 20px 50px rgba(99, 102, 241, 0.6);
            color: white;
        }
        
        .btn-cta-secondary {
            background: transparent;
            color: white;
            border: 3px solid white;
        }
        
        .btn-cta-secondary:hover {
            background: white;
            color: var(--primary);
            transform: translateY(-5px) scale(1.05);
        }
        
        /* Footer - Modern */
        .footer {
            background: #0f172a;
            color: white;
            padding: 80px 0 30px;
        }
        
        .footer-brand {
            font-size: 1.8rem;
            font-weight: 900;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .footer-brand i {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .footer-description {
            color: rgba(255,255,255,0.7);
            line-height: 1.8;
            margin-bottom: 25px;
        }
        
        .footer-title {
            font-size: 1.3rem;
            font-weight: 800;
            margin-bottom: 25px;
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
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .footer-links a:hover {
            color: white;
            padding-left: 5px;
        }
        
        .footer-social {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }
        
        .social-icon {
            width: 48px;
            height: 48px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            transition: var(--transition);
            text-decoration: none;
        }
        
        .social-icon:hover {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            transform: translateY(-5px) scale(1.1);
        }
        
        .copyright {
            text-align: center;
            padding-top: 40px;
            margin-top: 60px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.6);
        }
        
        /* Responsive Design */
        @media (max-width: 992px) {
            .story-content {
                grid-template-columns: 1fr;
                gap: 50px;
            }
            
            .mission-grid {
                grid-template-columns: 1fr;
            }
            
            .timeline::before {
                left: 20px;
            }
            
            .timeline-item,
            .timeline-item:nth-child(odd) {
                flex-direction: row;
            }
            
            .timeline-content,
            .timeline-item:nth-child(odd) .timeline-content {
                width: calc(100% - 60px);
                margin-left: 60px;
                text-align: left;
            }
            
            .timeline-dot {
                left: 20px;
                transform: translateX(-50%);
            }
        }
        
        @media (max-width: 768px) {
            .hero-stats {
                gap: 30px;
            }
            
            .hero-stat-number {
                font-size: 2.5rem;
            }
            
            .team-grid {
                grid-template-columns: 1fr;
            }
            
            .cta-buttons {
                flex-direction: column;
            }
            
            .btn-cta {
                width: 100%;
                justify-content: center;
            }
        }
        
        /* Scroll Animations */
        .fade-in {
            opacity: 0;
            transform: translateY(40px);
            transition: opacity 0.8s ease, transform 0.8s ease;
        }
        
        .fade-in.visible {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg">
        <div class="container">
            <a class="navbar-brand" href="/"><i class="fas fa-graduation-cap"></i> EduMaster</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="/">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="/courses">Courses</a></li>
                    <li class="nav-item"><a class="nav-link active" href="/about">About</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Instructors</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Pricing</a></li>
                    <li class="nav-item"><a class="nav-link" href="/Contact">Contact</a></li>
                </ul>
                <a href="/login">
                    <button class="btn btn-start"></button>
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="about-hero">
        <div class="container">
            <div class="hero-content">
                <div class="hero-badge">
                    <i class="fas fa-star"></i> Trusted by 50,000+ Learners
                </div>
                <h1>Empowering Through Education</h1>
                <p>We're transforming lives through accessible, high-quality online education that empowers learners worldwide to achieve their dreams and build successful careers.</p>
                
                <div class="hero-stats">
                    <div class="hero-stat">
                        <span class="hero-stat-number">50K+</span>
                        <span class="hero-stat-label">Active Students</span>
                    </div>
                    <div class="hero-stat">
                        <span class="hero-stat-number">500+</span>
                        <span class="hero-stat-label">Expert Courses</span>
                    </div>
                    <div class="hero-stat">
                        <span class="hero-stat-number">100+</span>
                        <span class="hero-stat-label">Top Instructors</span>
                    </div>
                    <div class="hero-stat">
                        <span class="hero-stat-number">150+</span>
                        <span class="hero-stat-label">Countries</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Story Section -->
    <section class="story-section">
        <div class="container">
            <div class="story-content fade-in">
                <div class="story-image">
                    <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800&h=600&fit=crop" alt="Our Story">
                </div>
                <div class="story-text">
                    <h3>Our Journey Began With A Simple Belief</h3>
                    <p>Founded in 2020, EduMaster started with a vision to democratize education and make world-class learning accessible to everyone, regardless of their location or background.</p>
                    <p>What began as a small team of passionate educators has grown into a thriving community of over 50,000 students and 100+ expert instructors spanning 150 countries.</p>
                    <p>Today, we're proud to be at the forefront of online education, continuously innovating and expanding our course offerings to meet the evolving needs of learners worldwide.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Mission Section -->
    <section class="mission-section">
        <div class="container">
            <div class="section-header fade-in">
                <span class="section-badge">OUR MISSION</span>
                <h2 class="section-title">What Drives Us Forward</h2>
                <p class="section-subtitle">We're committed to creating transformative learning experiences that empower individuals to reach their full potential and build the careers they've always dreamed of.</p>
            </div>
            
            <div class="mission-grid">
                <div class="mission-card fade-in">
                    <div class="mission-icon">
                        <i class="fas fa-rocket"></i>
                    </div>
                    <h3>Innovation First</h3>
                    <p>We leverage cutting-edge technology and pedagogical approaches to create engaging, effective learning experiences that keep pace with the rapidly evolving digital landscape.</p>
                </div>
                
                <div class="mission-card fade-in">
                    <div class="mission-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h3>Accessibility for All</h3>
                    <p>Quality education should know no boundaries. We're breaking down barriers and making premium learning resources available to anyone with an internet connection.</p>
                </div>
                
                <div class="mission-card fade-in">
                    <div class="mission-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>Excellence Always</h3>
                    <p>We partner with industry leaders and subject matter experts to ensure every course meets the highest standards of quality, relevance, and practical application.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Timeline Section -->
    <section class="timeline-section">
        <div class="container">
            <div class="section-header fade-in">
                <span class="section-badge">OUR JOURNEY</span>
                <h2 class="section-title">Milestones That Matter</h2>
                <p class="section-subtitle">From humble beginnings to global impact - here's our story of growth and achievement.</p>
            </div>
            
            <div class="timeline">
                <div class="timeline-item fade-in">
                    <div class="timeline-content">
                        <div class="timeline-year">2020</div>
                        <h4>The Beginning</h4>
                        <p>EduMaster was founded with just 5 courses and a dream to change education forever.</p>
                    </div>
                    <div class="timeline-dot"></div>
                </div>
                
                <div class="timeline-item fade-in">
                    <div class="timeline-content">
                        <div class="timeline-year">2021</div>
                        <h4>Rapid Growth</h4>
                        <p>Reached 10,000 students and expanded our course catalog to 100+ offerings across multiple disciplines.</p>
                    </div>
                    <div class="timeline-dot"></div>
                </div>
                
                <div class="timeline-item fade-in">
                    <div class="timeline-content">
                        <div class="timeline-year">2023</div>
                        <h4>Global Expansion</h4>
                        <p>Launched in 150+ countries, partnered with 50+ universities, and introduced advanced certification programs.</p>
                    </div>
                    <div class="timeline-dot"></div>
                </div>
                
                <div class="timeline-item fade-in">
                    <div class="timeline-content">
                        <div class="timeline-year">2025</div>
                        <h4>Innovation Hub</h4>
                        <p>Introduced AI-powered learning paths, launched mobile app, and crossed 50,000 active learners milestone.</p>
                    </div>
                    <div class="timeline-dot"></div>
                </div>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="team-section">
        <div class="container">
            <div class="section-header fade-in">
                <span class="section-badge">OUR TEAM</span>
                <h2 class="section-title">Meet The Visionaries</h2>
                <p class="section-subtitle">Passionate innovators and educators dedicated to revolutionizing online learning experiences.</p>
            </div>
            
            <div class="team-grid">
                <div class="team-card fade-in">
                    <div class="team-image">
                        <img src="https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&h=400&fit=crop" alt="John Doe">
                        <div class="team-badge">Founder</div>
                    </div>
                    <div class="team-info">
                        <h3 class="team-name">John Doe</h3>
                        <div class="team-role">CEO & Founder</div>
                        <p class="team-bio">Visionary entrepreneur with 15+ years in EdTech, passionate about making quality education accessible to all.</p>
                        <div class="team-social">
                            <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-link"><i class="fas fa-envelope"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="team-card fade-in">
                    <div class="team-image">
                        <img src="https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&h=400&fit=crop" alt="Sarah Miller">
                        <div class="team-badge">CLO</div>
                    </div>
                    <div class="team-info">
                        <h3 class="team-name">Sarah Miller</h3>
                        <div class="team-role">Chief Learning Officer</div>
                        <p class="team-bio">Former university professor with expertise in curriculum design and innovative teaching methodologies.</p>
                        <div class="team-social">
                            <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-link"><i class="fas fa-envelope"></i></a>
                        </div>
                    </div>
                </div>
                
                <div class="team-card fade-in">
                    <div class="team-image">
                        <img src="https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=400&h=400&fit=crop" alt="Mike Johnson">
                        <div class="team-badge">CTO</div>
                    </div>
                    <div class="team-info">
                        <h3 class="team-name">Mike Johnson</h3>
                        <div class="team-role">Head of Technology</div>
                        <p class="team-bio">Tech innovator building scalable, user-friendly platforms that enhance the learning experience.</p>
                        <div class="team-social">
                            <a href="#" class="social-link"><i class="fab fa-linkedin-in"></i></a>
                            <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                            <a href="#" class="social-link"><i class="fas fa-envelope"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content">
                <h2>Ready to Transform Your Future?</h2>
                <p>Join thousands of learners already building successful careers with EduMaster</p>
                <div class="cta-buttons">
                    <a href="/courses" class="btn-cta btn-cta-primary">
                        Explore Courses <i class="fas fa-arrow-right"></i>
                    </a>                    
                    <a href="/instructor/register" class="btn-cta btn-cta-secondary">
                        Become an Instructor <i class="fas fa-chalkboard-teacher"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="footer-brand">
                        <i class="fas fa-graduation-cap"></i> EduMaster
                    </div>
                    <p class="footer-description">
                        Empowering learners worldwide with quality education and expert-led courses. Transform your career and achieve your dreams.
                    </p>
                    <div class="footer-social">
                        <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h4 class="footer-title">Company</h4>
                    <ul class="footer-links">
                        <li><a href="/about"><i class="fas fa-chevron-right"></i> About Us</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Careers</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Press</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Blog</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h4 class="footer-title">Support</h4>
                    <ul class="footer-links">
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Help Center</a></li>
                        <li><a href="/Contact"><i class="fas fa-chevron-right"></i> Contact Us</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> FAQs</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Refund Policy</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h4 class="footer-title">Resources</h4>
                    <ul class="footer-links">
                        <li><a href="/courses"><i class="fas fa-chevron-right"></i> All Courses</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Instructors</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Free Resources</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Certifications</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h4 class="footer-title">Legal</h4>
                    <ul class="footer-links">
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Terms of Use</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Privacy Policy</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Cookie Policy</a></li>
                        <li><a href="#"><i class="fas fa-chevron-right"></i> Sitemap</a></li>
                    </ul>
                </div>
            </div>
            <div class="copyright">
                <p>&copy; 2025 EduMaster. All rights reserved. Made with <i class="fas fa-heart" style="color: #ec4899;"></i> for learners worldwide.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
        
        // Scroll animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                }
            });
        }, observerOptions);
        
        document.querySelectorAll('.fade-in').forEach(el => {
            observer.observe(el);
        });
        
        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    </script>
</body>
</html>
