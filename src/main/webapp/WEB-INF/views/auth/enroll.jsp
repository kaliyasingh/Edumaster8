<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduMaster - ${course.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: #f8f9fa; color: #111827; }

        /* ── Navbar ── */
        .navbar {
            background: #fff;
            border-bottom: 1px solid #e5e7eb;
            padding: 12px 0;
            position: sticky; top: 0; z-index: 100;
        }
        .navbar-brand { font-weight: 700; font-size: 1.4rem; color: #6366f1 !important; }
        .navbar .nav-link { color: #374151; font-size: 0.9rem; }
        .navbar .nav-link:hover { color: #6366f1; }
        .btn-nav-login {
            border: 1px solid #6366f1; color: #6366f1;
            border-radius: 8px; padding: 7px 18px; font-size: 0.88rem; font-weight: 500;
            background: transparent; transition: 0.2s;
        }
        .btn-nav-login:hover { background: #6366f1; color: #fff; }
        .btn-nav-enroll {
            background: #6366f1; color: #fff;
            border-radius: 8px; padding: 7px 18px; font-size: 0.88rem; font-weight: 500;
            border: none; transition: 0.2s;
        }
        .btn-nav-enroll:hover { background: #4f46e5; color: #fff; }

        /* ── Hero ── */
        .course-hero {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
            color: #fff;
            padding: 48px 0 40px;
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 5px;
            background: rgba(255,255,255,0.15); border-radius: 999px;
            padding: 4px 12px; font-size: 0.75rem; margin-bottom: 14px;
        }
        .course-hero h1 { font-size: 1.9rem; font-weight: 700; line-height: 1.35; margin-bottom: 14px; }
        .course-hero .desc { font-size: 0.95rem; opacity: 0.88; max-width: 600px; margin-bottom: 18px; }
        .hero-meta { display: flex; flex-wrap: wrap; gap: 16px; font-size: 0.82rem; opacity: 0.88; margin-bottom: 18px; }
        .hero-meta span { display: flex; align-items: center; gap: 6px; }
        .rating-stars { color: #fbbf24; font-size: 0.85rem; }
        .instructor-mini { display: flex; align-items: center; gap: 10px; margin-top: 6px; }
        .inst-avatar-sm {
            width: 38px; height: 38px; border-radius: 50%;
            background: rgba(255,255,255,0.25);
            display: flex; align-items: center; justify-content: center;
            font-weight: 600; font-size: 0.85rem; flex-shrink: 0;
        }
        .inst-info-sm .name { font-size: 0.88rem; font-weight: 500; }
        .inst-info-sm .role { font-size: 0.75rem; opacity: 0.75; }

        /* ── Main layout ── */
        .main-layout { display: grid; grid-template-columns: 1fr 320px; gap: 28px; padding: 36px 0; }
        @media (max-width: 900px) {
            .main-layout { grid-template-columns: 1fr; }
            .sticky-card { position: static !important; }
        }

        /* ── Section blocks ── */
        .section-block {
            background: #fff; border: 1px solid #e5e7eb; border-radius: 12px;
            padding: 24px; margin-bottom: 20px;
        }
        .section-block h2 { font-size: 1.05rem; font-weight: 600; margin-bottom: 16px; color: #111827; }

        /* ── What you'll learn ── */
        .learn-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        @media (max-width: 600px) { .learn-grid { grid-template-columns: 1fr; } }
        .learn-item { display: flex; gap: 8px; font-size: 0.85rem; color: #374151; align-items: flex-start; }
        .learn-item i { color: #6366f1; margin-top: 2px; flex-shrink: 0; }

        /* ── Curriculum ── */
        .module-card { border: 1px solid #e5e7eb; border-radius: 8px; margin-bottom: 8px; overflow: hidden; }
        .module-header {
            display: flex; justify-content: space-between; align-items: center;
            padding: 12px 16px; background: #f9fafb; cursor: pointer;
            transition: background 0.2s;
        }
        .module-header:hover { background: #f3f4f6; }
        .module-header-left { display: flex; align-items: center; gap: 10px; font-size: 0.88rem; font-weight: 500; }
        .module-header-left .chevron { color: #9ca3af; transition: transform 0.2s; font-size: 0.75rem; }
        .module-header-left .chevron.open { transform: rotate(90deg); }
        .module-meta { font-size: 0.78rem; color: #6b7280; }
        .module-body { display: none; }
        .module-body.open { display: block; }
        .lesson-row {
            display: flex; align-items: center; gap: 10px;
            padding: 9px 16px; border-top: 1px solid #f3f4f6;
            font-size: 0.82rem; color: #374151;
        }
        .lesson-row i { color: #a5b4fc; width: 16px; text-align: center; }
        .lesson-row .lesson-dur { margin-left: auto; color: #9ca3af; font-size: 0.78rem; }
        .lesson-preview { color: #6366f1; font-size: 0.75rem; margin-left: 6px; cursor: pointer; }
        .curriculum-summary { font-size: 0.82rem; color: #6b7280; margin-bottom: 14px; }

        /* ── Reviews ── */
        .rating-big { font-size: 3rem; font-weight: 700; line-height: 1; color: #111827; }
        .bar-row { display: flex; align-items: center; gap: 8px; margin-bottom: 5px; }
        .bar-track { flex: 1; height: 7px; background: #f3f4f6; border-radius: 999px; overflow: hidden; }
        .bar-fill  { height: 100%; background: #6366f1; border-radius: 999px; }
        .bar-lbl   { font-size: 0.75rem; color: #6b7280; width: 14px; text-align: right; }
        .bar-pct   { font-size: 0.75rem; color: #6b7280; width: 30px; }
        .review-card { border: 1px solid #f3f4f6; border-radius: 8px; padding: 14px; margin-top: 12px; }
        .reviewer-name { font-size: 0.88rem; font-weight: 500; }
        .reviewer-date { font-size: 0.75rem; color: #9ca3af; }
        .review-text   { font-size: 0.83rem; color: #4b5563; margin-top: 6px; line-height: 1.6; }

        /* ── Sidebar sticky card ── */
        .sticky-card { position: sticky; top: 80px; }
        .price-card {
            background: #fff; border: 1px solid #e5e7eb; border-radius: 12px;
            overflow: hidden; margin-bottom: 16px;
        }
        .price-thumb {
            height: 160px; background: #e0e7ff;
            display: flex; align-items: center; justify-content: center;
            position: relative; overflow: hidden;
        }
        .price-thumb img { width: 100%; height: 100%; object-fit: cover; }
        .price-thumb-fallback { font-size: 4rem; color: #6366f1; }
        .price-body { padding: 18px; }
        .price-row  { display: flex; align-items: baseline; gap: 10px; margin-bottom: 4px; }
        .price-main { font-size: 1.8rem; font-weight: 700; color: #111827; }
        .price-orig { font-size: 0.9rem; color: #9ca3af; text-decoration: line-through; }
        .price-disc { font-size: 0.82rem; color: #059669; font-weight: 600; }
        .price-timer {
            font-size: 0.78rem; color: #dc2626;
            display: flex; align-items: center; gap: 5px;
            margin-bottom: 14px;
        }
        .btn-enroll-main {
            width: 100%; padding: 14px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none; border-radius: 10px; color: #fff;
            font-size: 0.95rem; font-weight: 600; cursor: pointer;
            transition: 0.25s; margin-bottom: 10px;
            box-shadow: 0 4px 14px rgba(99,102,241,0.4);
        }
        .btn-enroll-main:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(99,102,241,0.55); }
        .btn-enroll-main:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }
        .btn-wishlist {
            width: 100%; padding: 11px;
            background: transparent; color: #374151;
            border: 1px solid #d1d5db; border-radius: 10px;
            font-size: 0.88rem; cursor: pointer; transition: 0.2s;
            display: flex; align-items: center; justify-content: center; gap: 7px;
        }
        .btn-wishlist:hover  { background: #f9fafb; }
        .btn-wishlist.active { color: #dc2626; border-color: #fca5a5; }
        .btn-wishlist.active i { color: #dc2626; }
        .guarantee { text-align: center; font-size: 0.75rem; color: #9ca3af; margin-top: 8px; }

        .includes-list { list-style: none; }
        .includes-list li {
            display: flex; align-items: center; gap: 8px;
            font-size: 0.82rem; color: #374151; padding: 5px 0;
            border-bottom: 1px solid #f9fafb;
        }
        .includes-list li:last-child { border-bottom: none; }
        .includes-list li i { color: #6366f1; width: 16px; text-align: center; }

        .tag-pill {
            display: inline-block; background: #eef2ff; color: #4f46e5;
            font-size: 0.75rem; padding: 4px 10px; border-radius: 999px;
            margin: 3px 2px;
        }

        /* ── Tabs ── */
        .tabs { display: flex; gap: 0; border-bottom: 2px solid #e5e7eb; margin-bottom: 20px; }
        .tab-btn {
            padding: 10px 18px; font-size: 0.88rem; font-weight: 500;
            background: none; border: none; cursor: pointer;
            color: #6b7280; border-bottom: 2px solid transparent;
            margin-bottom: -2px; transition: 0.2s;
        }
        .tab-btn.active { color: #6366f1; border-bottom-color: #6366f1; }
        .tab-btn:hover   { color: #6366f1; }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* ── Alert ── */
        .alert { border-radius: 10px; padding: 12px 16px; font-size: 0.88rem; margin-bottom: 16px; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #86efac; }
        .alert-danger  { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }

        /* ── Already enrolled banner ── */
        .enrolled-banner {
            background: #dcfce7; border: 1px solid #86efac; border-radius: 10px;
            padding: 14px 18px; display: flex; align-items: center; gap: 10px;
            font-size: 0.88rem; color: #166534; margin-bottom: 12px;
        }
        .btn-go-course {
            width: 100%; padding: 14px;
            background: #059669; border: none; border-radius: 10px;
            color: #fff; font-size: 0.95rem; font-weight: 600; cursor: pointer; transition: 0.2s;
        }
        .btn-go-course:hover { background: #047857; }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-graduation-cap me-2"></i>EduMaster
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto ms-3">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/courses">Courses</a></li>
                <li class="nav-item"><a class="nav-link" href="#">My Learning</a></li>
            </ul>
            <div class="d-flex gap-2 align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span class="me-2" style="font-size:0.88rem;color:#6b7280">Hi, <c:out value="${sessionScope.user.name}"/></span>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-nav-login">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login?redirectTo=enroll&courseId=${course.id}" class="btn-nav-login">Login</a>
                        <a href="${pageContext.request.contextPath}/reg" class="btn-nav-enroll">Sign up free</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<!-- Breadcrumb -->
<div style="background:#fff;border-bottom:1px solid #e5e7eb;padding:10px 0">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-0" style="font-size:0.8rem">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" style="color:#6366f1">Home</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses" style="color:#6366f1">Courses</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/courses?category=${course.categorySlug}" style="color:#6366f1"><c:out value="${course.category}"/></a></li>
                <li class="breadcrumb-item active"><c:out value="${course.title}"/></li>
            </ol>
        </nav>
    </div>
</div>

<!-- Hero -->
<div class="course-hero">
    <div class="container">
        <div class="hero-badge">
            <i class="fas fa-bolt"></i>
            <c:out value="${course.badge != null ? course.badge : 'Bestseller'}"/>
        </div>
        <h1><c:out value="${course.title}"/></h1>
        <p class="desc"><c:out value="${course.shortDescription}"/></p>
        <div class="hero-meta">
            <span>
                <span class="rating-stars">
                    <c:forEach begin="1" end="5" var="s">
                        <c:choose>
                            <c:when test="${s <= course.ratingFull}"><i class="fas fa-star"></i></c:when>
                            <c:when test="${s == course.ratingHalf + 1}"><i class="fas fa-star-half-alt"></i></c:when>
                            <c:otherwise><i class="far fa-star"></i></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </span>
                <strong><fmt:formatNumber value="${course.rating}" maxFractionDigits="1"/></strong>
                (<fmt:formatNumber value="${course.reviewCount}" groupingUsed="true"/> ratings)
            </span>
            <span><i class="fas fa-users"></i> <fmt:formatNumber value="${course.studentCount}" groupingUsed="true"/> students</span>
            <span><i class="fas fa-clock"></i> <c:out value="${course.totalHours}"/> hours</span>
            <span><i class="fas fa-calendar-alt"></i> Updated <c:out value="${course.updatedMonth}"/></span>
            <span><i class="fas fa-language"></i> <c:out value="${course.language}"/></span>
            <span><i class="fas fa-signal"></i> <c:out value="${course.level}"/></span>
        </div>
        <div class="instructor-mini">
            <div class="inst-avatar-sm">
                <c:out value="${course.instructorInitials}"/>
            </div>
            <div class="inst-info-sm">
                <div class="name"><c:out value="${course.instructorName}"/></div>
                <div class="role"><c:out value="${course.instructorTitle}"/></div>
            </div>
        </div>
    </div>
</div>

<!-- Alert messages -->
<c:if test="${not empty success}">
    <div class="container mt-3">
        <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i><c:out value="${success}"/></div>
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="container mt-3">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i><c:out value="${error}"/></div>
    </div>
</c:if>

<!-- Main content -->
<div class="container">
    <div class="main-layout">

        <!-- Left: course content -->
        <div class="course-content">

            <!-- Tabs -->
            <div class="tabs">
                <button class="tab-btn active" onclick="switchTab('overview', this)">Overview</button>
                <button class="tab-btn" onclick="switchTab('curriculum', this)">Curriculum</button>
                <button class="tab-btn" onclick="switchTab('instructor', this)">Instructor</button>
                <button class="tab-btn" onclick="switchTab('reviews', this)">Reviews</button>
            </div>

            <!-- Overview tab -->
            <div id="tab-overview" class="tab-panel active">
                <div class="section-block">
                    <h2><i class="fas fa-check-double me-2" style="color:#6366f1"></i>What you'll learn</h2>
                    <div class="learn-grid">
                        <c:forEach var="point" items="${course.learningPoints}">
                            <div class="learn-item">
                                <i class="fas fa-check-circle"></i>
                                <span><c:out value="${point}"/></span>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="section-block">
                    <h2><i class="fas fa-info-circle me-2" style="color:#6366f1"></i>Requirements</h2>
                    <ul style="padding-left:18px;font-size:0.88rem;color:#4b5563;line-height:2">
                        <c:forEach var="req" items="${course.requirements}">
                            <li><c:out value="${req}"/></li>
                        </c:forEach>
                    </ul>
                </div>

                <div class="section-block">
                    <h2><i class="fas fa-book-open me-2" style="color:#6366f1"></i>Course description</h2>
                    <div style="font-size:0.88rem;color:#374151;line-height:1.8" id="descFull">
                        ${course.fullDescription}
                    </div>
                </div>
            </div>

            <!-- Curriculum tab -->
            <div id="tab-curriculum" class="tab-panel">
                <div class="section-block">
                    <h2><i class="fas fa-list me-2" style="color:#6366f1"></i>Course curriculum</h2>
                    <p class="curriculum-summary">
                        ${course.moduleCount} modules &bull; ${course.lessonCount} lessons &bull; ${course.totalHours} total hours
                    </p>
                    <c:forEach var="module" items="${course.modules}" varStatus="ms">
                        <div class="module-card">
                            <div class="module-header" onclick="toggleModule('mod${ms.index}', 'arr${ms.index}')">
                                <div class="module-header-left">
                                    <i class="fas fa-chevron-right chevron" id="arr${ms.index}"></i>
                                    Module ${ms.index + 1} — <c:out value="${module.title}"/>
                                </div>
                                <div class="module-meta">
                                    ${module.lessonCount} lessons &bull; ${module.duration}
                                </div>
                            </div>
                            <div class="module-body" id="mod${ms.index}">
                                <c:forEach var="lesson" items="${module.lessons}">
                                    <div class="lesson-row">
                                        <c:choose>
                                            <c:when test="${lesson.type == 'video'}"><i class="fas fa-play-circle"></i></c:when>
                                            <c:when test="${lesson.type == 'quiz'}"><i class="fas fa-question-circle"></i></c:when>
                                            <c:when test="${lesson.type == 'article'}"><i class="fas fa-file-alt"></i></c:when>
                                            <c:otherwise><i class="fas fa-file"></i></c:otherwise>
                                        </c:choose>
                                        <span><c:out value="${lesson.title}"/></span>
                                        <c:if test="${lesson.preview}">
                                            <span class="lesson-preview" onclick="previewLesson(${lesson.id})">
                                                <i class="fas fa-eye"></i> Preview
                                            </span>
                                        </c:if>
                                        <span class="lesson-dur"><c:out value="${lesson.duration}"/></span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Instructor tab -->
            <div id="tab-instructor" class="tab-panel">
                <div class="section-block">
                    <div style="display:flex;align-items:flex-start;gap:18px;margin-bottom:16px">
                        <div style="width:72px;height:72px;border-radius:50%;background:#e0e7ff;display:flex;align-items:center;justify-content:center;font-size:1.4rem;font-weight:600;color:#4f46e5;flex-shrink:0">
                            <c:out value="${course.instructorInitials}"/>
                        </div>
                        <div>
                            <h2 style="margin-bottom:4px"><c:out value="${course.instructorName}"/></h2>
                            <p style="color:#6b7280;font-size:0.88rem;margin-bottom:8px"><c:out value="${course.instructorTitle}"/></p>
                            <div style="display:flex;flex-wrap:wrap;gap:14px;font-size:0.8rem;color:#6b7280">
                                <span><i class="fas fa-star" style="color:#fbbf24"></i> <fmt:formatNumber value="${course.instructorRating}" maxFractionDigits="1"/> instructor rating</span>
                                <span><i class="fas fa-users"></i> <fmt:formatNumber value="${course.instructorStudents}" groupingUsed="true"/> students</span>
                                <span><i class="fas fa-play-circle"></i> ${course.instructorCourseCount} courses</span>
                            </div>
                        </div>
                    </div>
                    <div style="font-size:0.88rem;color:#374151;line-height:1.8">
                        ${course.instructorBio}
                    </div>
                </div>
            </div>

            <!-- Reviews tab -->
            <div id="tab-reviews" class="tab-panel">
                <div class="section-block">
                    <h2><i class="fas fa-star me-2" style="color:#fbbf24"></i>Student reviews</h2>
                    <div style="display:flex;align-items:center;gap:24px;margin-bottom:20px">
                        <div style="text-align:center">
                            <div class="rating-big"><fmt:formatNumber value="${course.rating}" maxFractionDigits="1"/></div>
                            <div class="rating-stars" style="font-size:1rem;margin:4px 0">
                                <c:forEach begin="1" end="5"><i class="fas fa-star"></i></c:forEach>
                            </div>
                            <div style="font-size:0.75rem;color:#9ca3af">Course rating</div>
                        </div>
                        <div style="flex:1">
                            <c:forEach var="rb" items="${course.ratingBreakdown}">
                                <div class="bar-row">
                                    <span class="bar-lbl">${rb.stars}</span>
                                    <div class="bar-track"><div class="bar-fill" style="width:${rb.percent}%"></div></div>
                                    <span class="bar-pct">${rb.percent}%</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <c:forEach var="review" items="${course.reviews}">
                        <div class="review-card">
                            <div style="display:flex;align-items:center;gap:10px;margin-bottom:6px">
                                <div style="width:36px;height:36px;border-radius:50%;background:#e0e7ff;display:flex;align-items:center;justify-content:center;font-size:0.78rem;font-weight:600;color:#4f46e5;flex-shrink:0">
                                    <c:out value="${review.initials}"/>
                                </div>
                                <div>
                                    <div class="reviewer-name"><c:out value="${review.name}"/></div>
                                    <div style="display:flex;align-items:center;gap:8px">
                                        <span class="rating-stars" style="font-size:0.75rem">
                                            <c:forEach begin="1" end="${review.rating}"><i class="fas fa-star"></i></c:forEach>
                                        </span>
                                        <span class="reviewer-date"><c:out value="${review.date}"/></span>
                                    </div>
                                </div>
                            </div>
                            <div class="review-text"><c:out value="${review.text}"/></div>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div><!-- /course-content -->

        <!-- Right: sticky sidebar -->
        <div class="sticky-card">
            <div class="price-card">
                <div class="price-thumb">
                    <c:choose>
                        <c:when test="${not empty course.thumbnail}">
                            <img src="${pageContext.request.contextPath}/${course.thumbnail}" alt="Course thumbnail">
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-code price-thumb-fallback"></i>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="price-body">
                    <div class="price-row">
                        <span class="price-main">
                            <fmt:formatNumber value="${course.discountPrice}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                        </span>
                        <span class="price-orig">
                            <fmt:formatNumber value="${course.originalPrice}" type="currency" currencySymbol="₹" maxFractionDigits="0"/>
                        </span>
                        <span class="price-disc">${course.discountPercent}% off</span>
                    </div>

                    <c:if test="${not empty course.offerEndsIn}">
                        <div class="price-timer">
                            <i class="fas fa-fire"></i>
                            <strong><c:out value="${course.offerEndsIn}"/> left</strong> at this price!
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${isEnrolled}">
                            <div class="enrolled-banner">
                                <i class="fas fa-check-circle"></i>
                                You are already enrolled in this course.
                            </div>
                            <a href="${pageContext.request.contextPath}/player?courseId=${course.id}">
                                <button class="btn-go-course">
                                    <i class="fas fa-play me-2"></i>Continue learning
                                </button>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/checkout" method="get" id="enrollForm">
                                <input type="hidden" name="courseId" value="${course.id}">
                                <button type="submit" class="btn-enroll-main" id="enrollBtn">
                                    <i class="fas fa-lock me-2"></i>Enroll now
                                </button>
                            </form>
                            <button class="btn-wishlist" id="wishlistBtn" onclick="toggleWishlist(${course.id})">
                                <i class="${isWishlisted ? 'fas' : 'far'} fa-heart" id="heartIcon"></i>
                                <span id="wishlistText">${isWishlisted ? 'Wishlisted' : 'Add to wishlist'}</span>
                            </button>
                            <div class="guarantee">
                                <i class="fas fa-shield-alt me-1"></i> 30-day money-back guarantee
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="section-block" style="padding:16px">
                <h2 style="font-size:0.9rem;margin-bottom:12px">This course includes</h2>
                <ul class="includes-list">
                    <li><i class="fas fa-video"></i> ${course.totalHours} hours on-demand video</li>
                    <li><i class="fas fa-file-code"></i> ${course.exerciseCount} coding exercises</li>
                    <li><i class="fas fa-download"></i> Downloadable resources</li>
                    <li><i class="fas fa-infinity"></i> Full lifetime access</li>
                    <li><i class="fas fa-mobile-alt"></i> Access on mobile &amp; desktop</li>
                    <li><i class="fas fa-certificate"></i> Certificate of completion</li>
                </ul>
            </div>

            <div class="section-block" style="padding:16px">
                <h2 style="font-size:0.9rem;margin-bottom:10px">Tags</h2>
                <c:forEach var="tag" items="${course.tags}">
                    <span class="tag-pill"><c:out value="${tag}"/></span>
                </c:forEach>
            </div>

            <div class="section-block" style="padding:16px">
                <h2 style="font-size:0.9rem;margin-bottom:10px">Share this course</h2>
                <div style="display:flex;gap:8px">
                    <button onclick="copyLink()" style="flex:1;padding:8px;border:1px solid #e5e7eb;border-radius:8px;background:#fff;cursor:pointer;font-size:0.8rem;display:flex;align-items:center;justify-content:center;gap:5px" id="copyBtn">
                        <i class="fas fa-link"></i> Copy link
                    </button>
                    <button onclick="shareTwitter()" style="flex:1;padding:8px;border:1px solid #e5e7eb;border-radius:8px;background:#fff;cursor:pointer;font-size:0.8rem;display:flex;align-items:center;justify-content:center;gap:5px">
                        <i class="fab fa-twitter" style="color:#1d9bf0"></i> Tweet
                    </button>
                </div>
            </div>
        </div><!-- /sidebar -->

    </div><!-- /main-layout -->
</div><!-- /container -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function switchTab(id, btn) {
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.getElementById('tab-' + id).classList.add('active');
        btn.classList.add('active');
    }

    function toggleModule(bodyId, arrId) {
        const body = document.getElementById(bodyId);
        const arr  = document.getElementById(arrId);
        const open = body.classList.toggle('open');
        arr.classList.toggle('open', open);
    }

    function toggleWishlist(courseId) {
        const btn  = document.getElementById('wishlistBtn');
        const icon = document.getElementById('heartIcon');
        const txt  = document.getElementById('wishlistText');
        const isActive = btn.classList.toggle('active');
        icon.className = isActive ? 'fas fa-heart' : 'far fa-heart';
        txt.textContent = isActive ? 'Wishlisted' : 'Add to wishlist';

        fetch('${pageContext.request.contextPath}/wishlist/toggle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'courseId=' + courseId
        });
    }

    function copyLink() {
        navigator.clipboard.writeText(window.location.href).then(() => {
            const btn = document.getElementById('copyBtn');
            btn.innerHTML = '<i class="fas fa-check" style="color:#059669"></i> Copied!';
            setTimeout(() => btn.innerHTML = '<i class="fas fa-link"></i> Copy link', 2000);
        });
    }

    function shareTwitter() {
        const url = 'https://twitter.com/intent/tweet?text=' +
            encodeURIComponent('Check out this course: ${course.title}') +
            '&url=' + encodeURIComponent(window.location.href);
        window.open(url, '_blank');
    }

    function previewLesson(lessonId) {
        window.location.href = '${pageContext.request.contextPath}/preview?lessonId=' + lessonId;
    }

    document.getElementById('enrollForm') && document.getElementById('enrollForm').addEventListener('submit', function() {
        const btn = document.getElementById('enrollBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Redirecting...';
    });
</script>
</body>
</html>
