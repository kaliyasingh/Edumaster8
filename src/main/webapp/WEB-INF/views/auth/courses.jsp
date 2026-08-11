<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ page import="java.util.*, java.text.*" %>
<%@ page import="com.vp.entity.Course, com.vp.entity.User, com.vp.entity.Instructor" %>
<%!
    // Small helper to safely embed Java strings inside the JS array we build below.
    String jsEscape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", " ")
                .replace("\n", " ");
    }
%>
<%
    /* ===================== SESSION (same pattern as index.jsp) ===================== */
    Long sessionUid     = (Long)   session.getAttribute("userId");
    String sessionName  = (String) session.getAttribute("fullName"); if (sessionName  == null) sessionName  = "";
    String sessionEmail = (String) session.getAttribute("email");    if (sessionEmail == null) sessionEmail = "";
    String sessionPhone = (String) session.getAttribute("phone");    if (sessionPhone == null) sessionPhone = "";
    String sessionRole  = (String) session.getAttribute("userRole");
    String profilePic   = (String) session.getAttribute("profilePictureUrl");

    String firstName = sessionName != null && sessionName.contains(" ") ? sessionName.split(" ")[0] : sessionName;
    String firstLetter = sessionName != null && !sessionName.isEmpty()
            ? String.valueOf(sessionName.charAt(0)).toUpperCase() : "U";

    String dashUrl      = "admin".equals(sessionRole)      ? request.getContextPath() + "/admin/dashboard"
                        : "instructor".equals(sessionRole) ? request.getContextPath() + "/instructor/instructordashboard"
                        : request.getContextPath() + "/student/dashboard";
    String myCoursesUrl = "instructor".equals(sessionRole) ? request.getContextPath() + "/instructor/my-courses"
                        : request.getContextPath() + "/student/my-courses";

    // Enrolled course ids (used to flip Buy -> Enrolled on cards, same as index.jsp)
    java.util.Set<Long> enrolledIds = new java.util.HashSet<>();
    if (sessionUid != null) {
        Object rawEnrolled = session.getAttribute("enrolledCourseIds");
        if (rawEnrolled instanceof java.util.Set) {
            enrolledIds = (java.util.Set<Long>) rawEnrolled;
        }
    }

    /* ===================== CATALOG DATA (from controller/servlet) ===================== */
    // Expected request attribute set by your controller before forwarding to this JSP:
    //   request.setAttribute("allCourses", courseService.findAllPublished());
    java.util.List<Course> allCourses =
            (java.util.List<Course>) request.getAttribute("allCourses");
    if (allCourses == null) allCourses = new java.util.ArrayList<Course>();

    // Header tallies - pass real numbers from the controller if you have them,
    // otherwise fall back to counting what we were given.
    Object totalCoursesAttr     = request.getAttribute("totalCourses");
    Object totalInstructorsAttr = request.getAttribute("totalInstructors");
    Object totalStudentsAttr    = request.getAttribute("totalStudents");

    int totalCourses     = totalCoursesAttr     != null ? (Integer) totalCoursesAttr     : allCourses.size();
    int totalInstructors = totalInstructorsAttr != null ? (Integer) totalInstructorsAttr : 10;
    int totalStudents    = totalStudentsAttr    != null ? (Integer) totalStudentsAttr    : 50;

    // Build the JS array that the existing client-side search/sort/filter code consumes.
    StringBuilder coursesJson = new StringBuilder("[\n");
    for (int i = 0; i < allCourses.size(); i++) {
        Course c = allCourses.get(i);

        String cTitle   = c.getTitle()        != null ? c.getTitle()       : "Untitled Course";
        String cDesc    = c.getDescription()  != null ? c.getDescription() :
                          (c.getSubtitle()    != null ? c.getSubtitle()    : "No description available.");
        String cThumb   = c.getThumbnailUrl() != null ? c.getThumbnailUrl() : "";
        String cCat     = c.getCategory()     != null ? c.getCategory()    : "General";
        String cLevel   = c.getLevel()        != null ? c.getLevel()       : "Self-Paced";
        String cDuration= c.getTotalDuration()!= null ? c.getTotalDuration(): "";
        double cPrice   = c.getPrice()        != null ? c.getPrice()       : 0.0;
        double cDisc    = c.getDiscountPrice()!= null ? c.getDiscountPrice(): 0.0;
        double cRating  = c.getAverageRating()!= null ? c.getAverageRating(): 0.0;

        // TODO: rename these two getters to whatever your Course entity actually exposes
        // (e.g. getReviewsCount() / getEnrolledCount()) — left as safe fallbacks for now.
        int cReviews  = 0;
        int cStudents = 0;
        try { cReviews  = (Integer) Course.class.getMethod("getReviewsCount").invoke(c); } catch (Exception ignore) {}
        try { cStudents = (Integer) Course.class.getMethod("getEnrolledCount").invoke(c); } catch (Exception ignore) {}

        String instrName   = "Expert Instructor";
        String instrSkill  = cCat;
        String instrAvatar = "";
        User cIU = c.getInstructor();
        if (cIU != null) {
            if (cIU.getFullName() != null && !cIU.getFullName().trim().isEmpty()) {
                instrName = cIU.getFullName().trim();
            } else if (cIU.getEmail() != null) {
                instrName = cIU.getEmail().split("@")[0];
            }
            if (cIU.getProfilePictureUrl() != null && !cIU.getProfilePictureUrl().isEmpty()) {
                instrAvatar = cIU.getProfilePictureUrl();
            }
            if (cIU instanceof Instructor) {
                Instructor ci = (Instructor) cIU;
                if (ci.getSpecialization() != null && !ci.getSpecialization().isEmpty()) {
                    instrSkill = ci.getSpecialization();
                }
            }
        }
        if (instrAvatar.isEmpty()) {
            instrAvatar = "https://i.pravatar.cc/80?u=" + c.getId();
        }

        boolean hasDisc  = cDisc > 0 && cDisc < cPrice;
        double  priceNow = hasDisc ? cDisc : cPrice;
        double  priceOld = hasDisc ? cPrice : 0.0;
        boolean isEnrolled = enrolledIds.contains(c.getId());

        coursesJson.append("  {")
            .append("id:").append(c.getId()).append(",")
            .append("title:\"").append(jsEscape(cTitle)).append("\",")
            .append("category:\"").append(jsEscape(cCat)).append("\",")
            .append("desc:\"").append(jsEscape(cDesc)).append("\",")
            .append("thumb:\"").append(jsEscape(cThumb)).append("\",")
            .append("instructor:\"").append(jsEscape(instrName)).append("\",")
            .append("skill:\"").append(jsEscape(instrSkill)).append("\",")
            .append("instrImg:\"").append(jsEscape(instrAvatar)).append("\",")
            .append("rating:").append(cRating).append(",")
            .append("reviews:").append(cReviews).append(",")
            .append("students:").append(cStudents).append(",")
            .append("duration:\"").append(jsEscape(cDuration)).append("\",")
            .append("level:\"").append(jsEscape(cLevel)).append("\",")
            .append("price:").append(priceNow).append(",")
            .append("oldPrice:").append(priceOld).append(",")
            .append("enrolled:").append(isEnrolled)
            .append("}");
        if (i < allCourses.size() - 1) coursesJson.append(",");
        coursesJson.append("\n");
    }
    coursesJson.append("]");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Courses — EduMaster</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<style>
  @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700;800&family=Inter:wght@400;500;600;700&family=Caveat:wght@600;700&display=swap');

 :root{
  --board:#7C3AED; --board-2:#8B5CF6; --chalk:#F4EFE1;
  --paper:#FBF7ED; --paper-edge:#E7DEC4; --rule:#D9CFAF;
  --ink:#20261D; --ink-soft:#5B6152;
  --highlighter:#FFCB47; --marker:#EC4899; --moss:#A855F7;
  --radius:14px; --card-shadow:0 10px 24px rgba(124,58,237,.10), 0 2px 6px rgba(124,58,237,.08);
}
  *{box-sizing:border-box;}
  html{scroll-behavior:smooth;}
  body{margin:0; font-family:'Inter',sans-serif; background:var(--paper); color:var(--ink); -webkit-font-smoothing:antialiased;}
  h1,h2,h3,h4{font-family:'Space Grotesk',sans-serif; margin:0;}
  a{text-decoration:none; color:inherit;}
  button{font-family:inherit; cursor:pointer;}
  .script{font-family:'Caveat',cursive; font-weight:700;}

  /* ==================== navbar (matches index.jsp) ==================== */
  .navbar{
    background:rgba(255,255,255,0.98);
    backdrop-filter:blur(20px);
    padding:16px 0;
    position:sticky; top:0; z-index:999;
    box-shadow:0 2px 10px rgba(99,102,241,0.1);
    border-bottom:1px solid rgba(99,102,241,0.1);
    transition:.3s;
  }
  .navbar.scrolled{ padding:10px 0; box-shadow:0 8px 30px rgba(99,102,241,0.15); }
  .navbar .container{display:flex; align-items:center; justify-content:space-between; max-width:1280px; margin:0 auto; padding:0 48px; position:relative;}

  .brand{
    display:flex; align-items:center; gap:10px; font-size:1.75rem; font-weight:800;
    background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);
    -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
  }
  .brand i{ -webkit-text-fill-color:#6366f1; color:#6366f1; font-size:1.4rem; }

  .nav-links{display:flex; gap:6px; align-items:center;}
  .nav-links a{color:#334155; opacity:1; font-weight:500; padding:9px 16px; border-radius:8px; font-size:15px; position:relative; transition:.2s;}
  .nav-links a:hover{color:#6366f1; background:rgba(99,102,241,.06);}
  .nav-links a.active{color:#6366f1; background:rgba(99,102,241,.08); font-weight:600;}
  .nav-links a.active::after{content:none;}

  .btn-chalk{
    background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);
    color:#fff; border:none; padding:12px 28px; border-radius:50px; font-weight:600; font-size:14.5px;
    box-shadow:0 4px 20px rgba(99,102,241,.3); transition:.3s;
  }
  .btn-chalk:hover{ transform:translateY(-3px); box-shadow:0 8px 30px rgba(99,102,241,.4); }

  .nav-toggle{display:none; background:none; border:none; font-size:20px; color:#334155;}
  @media (max-width:900px){ .nav-links{display:none;} .nav-toggle{display:block;} .navbar .container{padding:0 20px;} }

  /* ==================== profile dropdown (ported from index.jsp, same look) ==================== */
  .edu-profile-btn{
    background:linear-gradient(135deg,#6366f1 0%,#8b5cf6 50%,#ec4899 100%);
    color:#fff; border:none; border-radius:50px; padding:7px 18px 7px 7px;
    display:flex; align-items:center; gap:9px; font-family:'Inter',sans-serif; font-weight:600; font-size:.90rem;
    cursor:pointer; box-shadow:0 4px 20px rgba(99,102,241,.3); transition:.3s; position:relative;
  }
  .edu-profile-btn:hover{ transform:translateY(-2px); box-shadow:0 8px 28px rgba(99,102,241,.4); }
  .edu-btn-circle{
    width:28px; height:28px; border-radius:50%; background:rgba(255,255,255,.25);
    border:2px solid rgba(255,255,255,.7); display:flex; align-items:center; justify-content:center;
    font-weight:800; font-size:.90rem;
  }
  .edu-dropdown{
    position:absolute; top:calc(100% + 12px); right:0; width:260px; background:#f4f7fe;
    border-radius:16px; box-shadow:0 10px 25px -5px rgba(0,0,0,.1), 0 8px 10px -6px rgba(0,0,0,.1);
    border:1px solid #e5e7eb; overflow:hidden; display:none; transform-origin:top right;
    animation:eduDropIn .25s cubic-bezier(.4,0,.2,1); z-index:9999;
  }
  .edu-dropdown.open{ display:block; }
  @keyframes eduDropIn{ from{opacity:0; transform:scale(.95) translateY(-8px);} to{opacity:1; transform:scale(1) translateY(0);} }
  .edu-drop-header{ padding:20px; border-bottom:1px solid #e5e7eb; display:flex; flex-direction:column; align-items:center; text-align:center; background:#f4f7fe; }
  .edu-drop-avatar{ width:50px; height:50px; background:linear-gradient(135deg,#7148fc 0%,#d42ad3 100%); color:#fff; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:20px; font-weight:700; margin-bottom:10px; }
  .edu-drop-header h3{ color:#111827; font-size:1rem; font-weight:600; margin:0 0 3px; }
  .edu-drop-header p{ color:#6b7280; font-size:.75rem; margin:0; }
  .edu-drop-menu{ list-style:none; padding:8px; margin:0; }
  .edu-drop-menu li a{ display:flex; align-items:center; gap:12px; padding:10px 12px; text-decoration:none; color:#374151; font-size:.875rem; font-weight:500; border-radius:10px; transition:all .2s; }
  .edu-drop-menu li a:hover{ background:#f3f4f6; color:#6366f1; }
  .edu-drop-icon{ width:32px; height:32px; border-radius:8px; display:flex; align-items:center; justify-content:center; font-size:.875rem; flex-shrink:0; }
  .edu-drop-divider{ border-top:1px solid #f3f4f6; margin:4px 0; }
  .edu-drop-logout{ color:#dc2626 !important; padding-top:12px !important; }
  .edu-drop-logout:hover{ background:#fef2f2 !important; color:#dc2626 !important; }

  /* ==================== hero on chalkboard ==================== */
  .hero{background:var(--board); color:var(--chalk); padding:56px 48px 70px; text-align:center; position:relative; overflow:hidden;}
  .hero::after{content:""; position:absolute; left:0; right:0; bottom:0; height:18px; background:linear-gradient(180deg, transparent, rgba(0,0,0,.18));}
  .hero .tally{display:inline-flex; gap:18px; margin-bottom:18px; font-size:13px; color:rgba(244,239,225,.7); font-weight:600; letter-spacing:.03em;}
  .hero .tally span{display:inline-flex; align-items:center; gap:6px;}
  .hero .tally i{color:var(--highlighter);}
  .hero h1{font-size:44px; line-height:1.18; font-weight:700; max-width:680px; margin:0 auto 14px;}
  .hero h1 .script{color:var(--highlighter); font-size:1.25em; display:inline-block; transform:rotate(-2deg);}
  .hero p{color:rgba(244,239,225,.72); font-size:15.5px; max-width:480px; margin:0 auto 30px;}

  .catalog-search{max-width:620px; margin:0 auto; background:var(--paper); border-radius:12px; padding:6px; display:flex; gap:6px; box-shadow:0 14px 30px rgba(0,0,0,.25);}
  .catalog-search input{flex:1; border:none; background:transparent; padding:12px 16px; font-family:inherit; font-size:14.5px; color:var(--ink);}
  .catalog-search input:focus{outline:none;}
  .catalog-search select{border:none; background:var(--rule); color:var(--ink); font-weight:600; font-size:13px; padding:0 14px; border-radius:8px; cursor:pointer;}
  .catalog-search button.go{background:var(--moss); color:#fff; border:none; padding:0 20px; border-radius:8px; font-weight:700; font-size:14px;}

  /* ==================== folder tabs ==================== */
  .tab-strip{max-width:1280px; margin:-1px auto 0; padding:0 48px; display:flex; gap:8px; overflow-x:auto; position:relative; top:0;}
  .tab{flex:none; background:var(--rule); color:var(--ink-soft); font-weight:700; font-size:13.5px; padding:14px 22px 12px; border-radius:10px 10px 0 0; border:1px solid var(--paper-edge); border-bottom:none; margin-top:14px; transition:.2s;}
  .tab.active{background:var(--paper); color:var(--ink); margin-top:0; padding-top:18px; box-shadow:0 -4px 10px rgba(23,61,43,.06);}
  .tab:hover:not(.active){background:#e3dabc;}

  .catalog-body{background:var(--paper); border-top:1px solid var(--paper-edge);}
  .result-count{max-width:1280px; margin:0 auto; padding:22px 48px 4px; color:var(--ink-soft); font-size:13px; font-weight:600; display:flex; align-items:center; gap:8px;}
  .result-count i{color:var(--moss);}

  /* ==================== index-card grid ==================== */
  .grid-wrap{max-width:1280px; margin:0 auto; padding:16px 48px 90px;}
  .grid{display:grid; grid-template-columns:repeat(3,1fr); gap:30px;}

  .card{background:#fff; border:1px solid var(--paper-edge); border-radius:10px; box-shadow:var(--card-shadow); display:flex; flex-direction:column; position:relative; opacity:0; animation:rise .4s ease forwards;}
  @keyframes rise{from{opacity:0; transform:translateY(8px);} to{opacity:1; transform:translateY(0);}}

  .stamp{position:absolute; top:-12px; left:18px; z-index:3; background:var(--paper); border:2px dashed #e1573f; color:#e1573f; font-family:'Space Grotesk'; font-weight:700; font-size:11px; letter-spacing:.05em; text-transform:uppercase; padding:5px 12px; border-radius:999px; transform:rotate(-4deg); box-shadow:0 3px 6px rgba(0,0,0,.08);}

  .card-media{position:relative; aspect-ratio:16/10; overflow:hidden; border-radius:10px 10px 0 0; margin-top:0;}
  .card-media img{width:100%; height:100%; object-fit:cover; display:block; filter:saturate(.94);}
  .tape{position:absolute; top:-8px; width:70px; height:26px; background:rgba(244,239,225,.75); border:1px solid rgba(0,0,0,.05); box-shadow:0 2px 4px rgba(0,0,0,.12);}
  .tape.left{left:14px; transform:rotate(-6deg);}
  .tape.right{right:14px; transform:rotate(5deg);}
  .off-tag{position:absolute; bottom:12px; left:12px; background:#e1573f; color:#fff; font-weight:700; font-size:11.5px; padding:5px 11px; border-radius:6px; transform:rotate(-2deg);}
  .wish-btn{position:absolute; bottom:12px; right:12px; width:32px; height:32px; border-radius:50%; background:rgba(255,255,255,.92); border:none; display:flex; align-items:center; justify-content:center; color:#9a9587; font-size:13px; box-shadow:0 3px 8px rgba(0,0,0,.15); transition:.2s;}
  .wish-btn.active{color:var(--marker);}
  .wish-btn:hover{transform:scale(1.08);}

  .card-body{padding:22px 20px 20px; display:flex; flex-direction:column; flex:1;}
  .card-title{font-size:17.5px; font-weight:700; line-height:1.32; margin-bottom:8px; min-height:46px;}
  .card-desc{color:var(--ink-soft); font-size:13.3px; line-height:1.62; margin-bottom:14px; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden;}

  .rule{border:none; border-top:1px dashed var(--rule); margin:0 0 14px;}

  .card-instructor{display:flex; align-items:center; gap:10px; margin-bottom:14px;}
  .card-instructor img{width:34px; height:34px; border-radius:6px; object-fit:cover; flex:none; border:2px solid #fff; box-shadow:0 2px 5px rgba(0,0,0,.15); transform:rotate(-3deg);}
  .card-instructor .iname{font-weight:700; font-size:12.8px;}
  .card-instructor .iskill{font-size:11px; color:var(--ink-soft);}
  .card-rating{margin-left:auto; display:flex; align-items:center; gap:4px; color:var(--ink); font-weight:700; font-size:12.5px;}
  .card-rating i{color:var(--highlighter); text-shadow:0 0 0 var(--marker);}
  .card-rating .fa-star{color:#E8A93B;}

  .card-meta{display:flex; gap:14px; font-size:11.8px; color:var(--ink-soft); font-weight:600; margin-bottom:16px;}
  .card-meta span{display:flex; align-items:center; gap:5px;}
  .card-meta i{color:var(--moss);}

  .card-footer{margin-top:auto; display:flex; align-items:center; justify-content:space-between; gap:10px;}
  .price-sticker{background:var(--chalk); border:1px dashed var(--ink-soft); border-radius:8px; padding:6px 12px; text-align:center; transform:rotate(-1.5deg);}
  .price-now{font-family:'Space Grotesk'; font-size:17px; font-weight:800; display:block;}
  .price-old{font-size:11px; color:#a39c86; text-decoration:line-through;}
  .card-actions{display:flex; gap:8px;}
  .btn{padding:10px 14px; border-radius:8px; font-weight:700; font-size:12.5px; display:flex; align-items:center; gap:6px; transition:transform .15s; border:none;}
  .btn:active{transform:scale(.95);}
  .btn-primary{background:var(--board); color:var(--chalk); border:2px solid var(--board);}
  .btn-primary:hover{background:var(--board-2);}
  .btn-primary.enrolled{background:#10b981; border-color:#10b981;}
  .btn-outline{background:transparent; color:var(--board); border:2px solid var(--board);}
  .btn-outline:hover{background:rgba(23,61,43,.06);}

  .empty-state{grid-column:1/-1; text-align:center; padding:70px 20px; color:var(--ink-soft);}
  .empty-state i{font-size:36px; color:var(--rule); margin-bottom:14px;}
  .empty-state h3{font-size:18px; margin-bottom:6px; color:var(--ink); font-family:'Space Grotesk';}
  .empty-state button{margin-top:16px; background:var(--board); color:var(--chalk); border:none; padding:10px 22px; border-radius:999px; font-weight:700; font-size:13.5px;}

/* ==================== footer (matches index.jsp) ==================== */
/* ==================== footer (matches index.jsp) ==================== */
  .site-footer{background:#111a30; color:rgba(255,255,255,.7); padding:80px 48px 30px;}
  .footer-grid{max-width:1280px; margin:0 auto; display:grid; grid-template-columns:2fr 1fr 1.3fr 1.3fr; gap:36px; padding-bottom:20px;}
  .footer-title{font-size:1.3rem; font-weight:700; margin-bottom:25px; color:#fff; font-family:'Poppins',sans-serif; display:flex; align-items:center; gap:8px;}
  .footer-about p{font-size:14px; line-height:1.6; color:rgba(255,255,255,.7); margin-bottom:20px;}
  .social-icons{display:flex; gap:15px; flex-wrap:wrap; margin-top:20px;}
  .social-icon{width:45px; height:45px; background:rgba(255,255,255,.1); border-radius:50%; display:flex; align-items:center; justify-content:center; color:#fff; font-size:1.2rem; transition:.3s; border:1px solid rgba(255,255,255,.2);}
  .social-icon:hover{background:linear-gradient(135deg,#6366f1,#8b5cf6,#ec4899); transform:translateY(-5px); border-color:transparent;}
  .footer-links{list-style:none; padding:0; margin:0;}
  .footer-links li{margin-bottom:12px;}
  .footer-links a{color:rgba(255,255,255,.7); text-decoration:none; font-size:14px; transition:.3s; display:inline-block;}
  .footer-links a:hover{color:#fff; transform:translateX(5px);}
  .footer-links li i{margin-right:8px; color:#8b5cf6; width:14px;}
  .footer-copyright{text-align:center; padding-top:30px; margin-top:50px; border-top:1px solid rgba(255,255,255,.1); color:rgba(255,255,255,.6); font-size:13px;}
  .footer-copyright .fa-heart{color:#ec4899;}
  
  @media (max-width:1100px){ .grid{grid-template-columns:repeat(2,1fr);} }
  @media (max-width:700px){
    .grid{grid-template-columns:1fr;}
    .hero{padding:44px 20px 60px;}
    .hero h1{font-size:30px;}
    .tab-strip, .result-count, .grid-wrap{padding-left:20px; padding-right:20px;}
    .catalog-search{flex-wrap:wrap;}
    .catalog-search select{flex:1;}
  }
</style>
</head>
<body>

<nav class="navbar">
  <div class="container">
    <a class="brand" href="<%= request.getContextPath() %>/index.jsp"><i class="fas fa-graduation-cap"></i> EduMaster</a>
    <div class="nav-links">
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
      <a href="<%= request.getContextPath() %>/courses" class="active">Courses</a>
      <a href="<%= request.getContextPath() %>/index.jsp#about">About</a>
      <a href="<%= request.getContextPath() %>/index.jsp#instructor">Instructor</a>
      <a href="<%= request.getContextPath() %>/index.jsp#pricing-faq">Pricing &amp; FAQ</a>
      <a href="<%= request.getContextPath() %>/contact">Contact</a>
    </div>

    <% if (sessionUid != null) { %>
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
              <div class="edu-drop-icon" style="background:#e0e7ff;color:#4f46e5;"><i class="fas fa-chart-line"></i></div>
              My Dashboard
            </a>
          </li>
          <li>
            <a href="<%= myCoursesUrl %>">
              <div class="edu-drop-icon" style="background:#dcfce7;color:#16a34a;"><i class="fas fa-book-open"></i></div>
              My Courses
            </a>
          </li>
          <li class="edu-drop-divider"></li>
          <li>
            <a href="<%= request.getContextPath() %>/logout" class="edu-drop-logout">
              <div class="edu-drop-icon" style="background:#fee2e2;color:#dc2626;"><i class="fas fa-sign-out-alt"></i></div>
              Logout Account
            </a>
          </li>
        </ul>
      </div>
    <% } else { %>
      <a href="<%= request.getContextPath() %>/login"><button class="btn-chalk" type="button">Login</button></a>
    <% } %>
  </div>
</nav>

<header class="hero">
  <div class="tally">
    <span><i class="fas fa-book"></i> <%= totalCourses %>+ courses</span>
    <span><i class="fas fa-chalkboard-user"></i> <%= totalInstructors %> instructors</span>
    <span><i class="fas fa-user-group"></i> <%= totalStudents %>+ students</span>
  </div>
  <h1>Pick your next <span class="script">lesson</span>, straight off the shelf</h1>
  <p>A catalog of hands-on, project-based courses — browse by subject, check the reviews, and start today.</p>

  <div class="catalog-search">
    <input type="text" id="searchInput" placeholder="Search Courses, instructors, topics...">
    <select id="sortSelect">
      <option value="popular">Most popular</option>
      <option value="rating">Highest rated</option>
      <option value="price-low">Price: low to high</option>
      <option value="price-high">Price: high to low</option>
    </select>
    <button class="go" type="button" onclick="document.getElementById('courseGrid').scrollIntoView({behavior:'smooth'})">Browse</button>
  </div>
</header>

<div class="tab-strip" id="filterRow">
  <button class="tab active" data-cat="all">All Shelves</button>
  <button class="tab" data-cat="Development">Development</button>
  <button class="tab" data-cat="Design">Design</button>
  <button class="tab" data-cat="Data Science">Data Science</button>
  <button class="tab" data-cat="Marketing">Marketing</button>
  <button class="tab" data-cat="Business">Business</button>
</div>

<div class="catalog-body">
  <p class="result-count" id="resultCount"><i class="fas fa-thumbtack"></i> <span></span></p>
  <main class="grid-wrap">
    <div class="grid" id="courseGrid"></div>
  </main>
</div>

<footer class="site-footer">
  <div class="footer-grid">
    <div class="footer-about">
      <h3 class="footer-title"><i class="fas fa-graduation-cap"></i> EduMaster</h3>
      <p>Empowering <%= totalStudents %>+ learners with practical, industry-relevant courses that transform careers and build professional futures.</p>
      <div class="social-icons">
        <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
        <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
        <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
      </div>
    </div>

    <div>
      <h4 class="footer-title">Quick Links</h4>
      <ul class="footer-links">
        <li><a href="<%= request.getContextPath() %>/index.jsp">Home</a></li>
        <li><a href="<%= request.getContextPath() %>/courses">All Courses</a></li>
        <li><a href="<%= request.getContextPath() %>/index.jsp#about">About Us</a></li>
        <li><a href="#">Privacy Policy</a></li>
        <li><a href="#">Terms of Service</a></li>
      </ul>
    </div>

    <div>
      <h4 class="footer-title">Popular Courses</h4>
      <ul class="footer-links">
        <li><a href="#">Web Development</a></li>
        <li><a href="#">Python Programming</a></li>
        <li><a href="#">Data Science</a></li>
        <li><a href="#">Digital Marketing</a></li>
        <li><a href="#">UI/UX Design</a></li>
      </ul>
    </div>

    <div>
      <h4 class="footer-title">Contact Info</h4>
      <ul class="footer-links">
        <li><i class="fas fa-map-marker-alt"></i>Silicon City, Indore</li>
        <li><i class="fas fa-phone"></i>+1 (555) 123-4567</li>
        <li><i class="fas fa-envelope"></i>info@edumaster.com</li>
        <li><i class="fas fa-clock"></i>Mon - Fri: 9AM - 6PM</li>
      </ul>
    </div>
  </div>

  <div class="footer-copyright">
    &copy; <%= new SimpleDateFormat("yyyy").format(new Date()) %> EduMaster - All Rights Reserved. Built with <i class="fas fa-heart"></i> for learners worldwide
  </div>
</footer>
<script>
  const CONTEXT_PATH = "<%= request.getContextPath() %>";
  const IS_LOGGED_IN = <%= sessionUid != null %>;

  // Data rendered server-side from the Course entity list (request attribute "allCourses").
  const COURSES = <%= coursesJson.toString() %>;

  let activeCat = 'all';
  let activeSort = 'popular';
  let searchTerm = '';
  const wishlist = new Set();

  function currency(n){ return '\u20B9' + Number(n).toLocaleString('en-IN'); }

  function cardHTML(c){
    const discPct = c.oldPrice ? Math.round((1 - c.price / c.oldPrice) * 100) : 0;
    const isWished = wishlist.has(c.id);
    const buyBtn = c.enrolled
      ? `<a class="btn btn-primary enrolled" href="${CONTEXT_PATH}/student/my-courses"><i class="fas fa-check-circle"></i> Enrolled</a>`
      : `<button class="btn btn-primary" data-buy="${c.id}"><i class="fas fa-cart-shopping"></i> Buy</button>`;
    return `
      <article class="card" data-id="${c.id}">
        <span class="stamp">${c.category}</span>
        <div class="card-media">
          <span class="tape left"></span>
          <span class="tape right"></span>
          <img src="${c.thumb}" alt="${c.title}" loading="lazy">
          ${discPct ? `<span class="off-tag">${discPct}% off</span>` : ''}
          <button class="wish-btn ${isWished ? 'active' : ''}" data-wish="${c.id}" aria-label="Add to wishlist">
            <i class="${isWished ? 'fas' : 'far'} fa-heart"></i>
          </button>
        </div>
        <div class="card-body">
          <h3 class="card-title">${c.title}</h3>
          <p class="card-desc">${c.desc}</p>
          <hr class="rule">
          <div class="card-instructor">
            <img src="${c.instrImg}" alt="${c.instructor}">
            <div>
              <div class="iname">${c.instructor}</div>
              <div class="iskill">${c.skill}</div>
            </div>
            <div class="card-rating"><i class="fas fa-star"></i> ${Number(c.rating).toFixed(1)}</div>
          </div>
          <div class="card-meta">
            <span><i class="fas fa-clock"></i> ${c.duration || 'Self-paced'}</span>
            <span><i class="fas fa-signal"></i> ${c.level}</span>
            <span><i class="fas fa-users"></i> ${Number(c.students).toLocaleString('en-IN')}</span>
          </div>
          <div class="card-footer">
            <div class="price-sticker">
              <span class="price-now">${c.price > 0 ? currency(c.price) : 'Free'}</span>
              ${c.oldPrice ? `<span class="price-old">${currency(c.oldPrice)}</span>` : ''}
            </div>
            <div class="card-actions">
              <button class="btn btn-outline" data-explore="${c.id}">Explore</button>
              ${buyBtn}
            </div>
          </div>
        </div>
      </article>
    `;
  }

  function getFiltered(){
    let list = COURSES.filter(c => activeCat === 'all' || c.category === activeCat);
    if (searchTerm.trim()){
      const q = searchTerm.trim().toLowerCase();
      list = list.filter(c =>
        c.title.toLowerCase().includes(q) ||
        c.instructor.toLowerCase().includes(q) ||
        c.category.toLowerCase().includes(q) ||
        c.skill.toLowerCase().includes(q)
      );
    }
    switch(activeSort){
      case 'rating': list = list.sort((a,b) => b.rating - a.rating); break;
      case 'price-low': list = list.sort((a,b) => a.price - b.price); break;
      case 'price-high': list = list.sort((a,b) => b.price - a.price); break;
      default: list = list.sort((a,b) => b.students - a.students);
    }
    return list;
  }

  function render(){
    const grid = document.getElementById('courseGrid');
    const list = getFiltered();
    const countEl = document.querySelector('#resultCount span');
    countEl.textContent = list.length + (list.length === 1 ? ' course on the shelf' : ' courses on the shelf');

    if (!list.length){
      grid.innerHTML = `
        <div class="empty-state">
          <i class="fas fa-box-open"></i>
          <h3>This shelf is empty</h3>
          <p>Try a different keyword or clear the filters.</p>
          <button id="clearFilters">Clear filters</button>
        </div>`;
      document.getElementById('clearFilters').addEventListener('click', () => {
        activeCat = 'all'; searchTerm = '';
        document.getElementById('searchInput').value = '';
        document.querySelectorAll('.tab').forEach(t => t.classList.toggle('active', t.dataset.cat === 'all'));
        render();
      });
      return;
    }

    grid.innerHTML = list.map(cardHTML).join('');
  }

  document.getElementById('filterRow').addEventListener('click', (e) => {
    const tab = e.target.closest('.tab');
    if (!tab) return;
    activeCat = tab.dataset.cat;
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    tab.classList.add('active');
    render();
  });

  document.getElementById('searchInput').addEventListener('input', (e) => {
    searchTerm = e.target.value;
    render();
  });

  document.getElementById('sortSelect').addEventListener('change', (e) => {
    activeSort = e.target.value;
    render();
  });

  document.getElementById('courseGrid').addEventListener('click', (e) => {
    const wishBtn = e.target.closest('[data-wish]');
    if (wishBtn){
      const id = Number(wishBtn.dataset.wish);
      wishlist.has(id) ? wishlist.delete(id) : wishlist.add(id);
      render();
      return;
    }
    const buyBtn = e.target.closest('[data-buy]');
    if (buyBtn){
      const id = buyBtn.dataset.buy;
      // Same pattern as the homepage: send guests to login, then straight to checkout.
      window.location.href = IS_LOGGED_IN
        ? CONTEXT_PATH + '/enroll/' + id
        : CONTEXT_PATH + '/login?redirectTo=checkout&courseId=' + id;
      return;
    }
    const exploreBtn = e.target.closest('[data-explore]');
    if (exploreBtn){
      window.location.href = CONTEXT_PATH + '/courses/' + exploreBtn.dataset.explore;
    }
  });

  render();

  // Navbar scroll shadow (matches index.jsp)
  window.addEventListener('scroll', function() {
    document.querySelector('.navbar').classList.toggle('scrolled', window.scrollY > 50);
  });

  // Profile dropdown toggle (matches index.jsp)
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
