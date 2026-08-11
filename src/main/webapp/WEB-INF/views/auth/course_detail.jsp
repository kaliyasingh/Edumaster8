<%--
  ===========================================================================
  course-detail.jsp
  Dynamic version of the static "Explore Course" page.

  UPDATED IN THIS VERSION:
  1. Navbar replaced with index.jsp-style navbar (Bootstrap-based profile
     dropdown with avatar, name, My Dashboard / My Courses / Logout links)
     instead of the old plain ".profile" div.
  2. learningPoints split logic fixed to correctly handle literal "\n"
     text stored in the DB (backslash + n, not a real newline) as well as
     real newlines and bullet characters.
  3. "Prerequisites" and "Who this course is for" sections removed from
     the Overview tab.
  4. Bootstrap CSS added (needed for the new navbar/dropdown), plus the
     dropdown-toggle JS at the bottom.

  ASSUMPTIONS (please check these against your real code before deploying):
  1. A controller (Servlet/Spring @Controller) resolves the course by id
     (e.g. GET /courses/{id}) and puts it on the request as:
         request.setAttribute("course", courseObj);          // com.vp.entity.Course
     If not found, it should forward here with course == null, and this
     page shows a "Course not found" state.
  2. course.getInstructor() returns a com.vp.entity.User (possibly a
     com.vp.entity.Instructor subclass, same pattern as your index.jsp).
     I only used fields I actually saw in your code: getFullName(),
     getEmail(), getProfilePictureUrl(), and (if Instructor) getSpecialization().
     If Instructor has bio / totalCourses / totalStudents / avgRating fields,
     tell me their exact getter names and I'll wire the "Meet your instructor"
     stats row back in — right now that block is hidden.
  3. course.getSections() -> List<CourseSection>, each with getContents()
     -> List<CourseContent>. I don't have CourseContent.java, so I'm calling
     getTitle() and getDurationMinutes() defensively. If those getter names
     are wrong, tell me the real ones (title/name, duration/durationMinutes,
     isPreview, contentType, etc.) and I'll fix the lesson row markup.
  4. Reviews: TEMPORARILY DISABLED (removed for now to fix a duplicate
     variable compile error — see note near "panel-reviews" below). When
     you're ready to wire it back in, tell me and I'll re-add the loop
     using the real Review entity fields (studentName, studentInitials,
     rating, comment, date, verified, replied, reply).
  5. Buy Now / wishlist wiring reuses the same pattern as your index.jsp
     (POST /payment/create-order, Razorpay checkout, POST /payment/verify),
     including the pendingCourseId auto-click-after-login trick.
  6. Navbar dropdown assumes session attributes "userRole" and
     "profilePictureUrl" exist (same as index.jsp). Dashboard/My-Courses
     URLs branch on role: admin / instructor / student.
  ===========================================================================
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.text.*, com.vp.entity.*" %>
<%@ page import="com.vp.entity.Review" %>

<%
    // ---- resolve pending "buy now after login" course id (same pattern as index.jsp) ----
    Long pendingCourse = (Long) session.getAttribute("pendingCourseId");
    if (pendingCourse != null) session.removeAttribute("pendingCourseId");

    // ---- the course this page is showing ----
    Course course = (Course) request.getAttribute("course");
%>
<% if (course == null) { %>
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><title>Course not found — EduMaster</title></head>
<body style="font-family:sans-serif; text-align:center; padding:80px 20px;">
    <h1>Course not found</h1>
    <p>The course you're looking for doesn't exist or is no longer available.</p>
    <a href="<%= request.getContextPath() %>/courses">&larr; Back to courses</a>
</body></html>
<%
    return; // stop rendering the rest of the page
}
%>
<%
    // ==================== session / user context ====================
    Long sessionUid     = (Long)   session.getAttribute("userId");
    String sessionName  = (String) session.getAttribute("fullName"); if (sessionName  == null) sessionName  = "";
    String sessionEmail = (String) session.getAttribute("email");    if (sessionEmail == null) sessionEmail = "";
    String sessionPhone = (String) session.getAttribute("phone");    if (sessionPhone == null) sessionPhone = "";

    java.util.Set<Long> enrolledIds = new java.util.HashSet<>();
    if (sessionUid != null) {
        Object rawEnrolled = session.getAttribute("enrolledCourseIds");
        if (rawEnrolled instanceof java.util.Set) {
            enrolledIds = (java.util.Set<Long>) rawEnrolled;
        }
    }
    boolean isEnrolled = enrolledIds.contains(course.getId());

    // ==================== course display fields ====================
    String cTitle    = course.getTitle()    != null ? course.getTitle()    : "Untitled Course";
    String cSubtitle = course.getSubtitle() != null ? course.getSubtitle() : "";
    String cCategory = course.getCategory() != null ? course.getCategory() : "General";
    String cLevel    = course.getLevel()    != null ? course.getLevel()    : "Beginner";
    String cThumb    = course.getThumbnailUrl() != null ? course.getThumbnailUrl()
                        : "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=900&auto=format&fit=crop";

    String cDescription = course.getDescription() != null ? course.getDescription() : "";
    String cLearningObj = course.getLearningObjectives() != null ? course.getLearningObjectives() : "";

    // learningObjectives may be stored as literal "\n" text (backslash-n, not a
    // real newline), real newlines, and/or bullet characters — normalize all of
    // these before splitting into list items.
    List<String> learningPoints = new ArrayList<>();
    if (!cLearningObj.isEmpty()) {
        String normalized = cLearningObj.replace("\\n", "\n").replace("•", "\n•");
        for (String line : normalized.split("\\r?\\n")) {
            String clean = line.replaceFirst("^[•\\-\\*]\\s*", "").trim();
            if (!clean.isEmpty()) learningPoints.add(clean);
        }
    }

    course.calculateTotalDuration();
    String cTotalDuration = course.getTotalDuration() != null ? course.getTotalDuration() : "";
    Double cRating  = course.getAverageRating() != null ? course.getAverageRating() : 0.0;
    Integer cReviewCount = course.getTotalReviews() != null ? course.getTotalReviews() : 0;
    Integer cStudents    = course.getStudentsEnrolled() != null ? course.getStudentsEnrolled() : 0;

    boolean hasDisc = course.hasDiscount();
    double  cPrice     = course.getPrice() != null ? course.getPrice() : 0.0;
    double  cDiscount  = course.getDiscountPrice() != null ? course.getDiscountPrice() : 0.0;
    double  finalPrice = course.getEffectivePrice() != null ? course.getEffectivePrice() : cPrice;
    boolean isFree     = finalPrice <= 0;
    int     discPct    = hasDisc ? (int) Math.round((1 - cDiscount / cPrice) * 100) : 0;
    long    priceInPaise = (long) (finalPrice * 100);

    String currency = course.getCurrency() != null ? course.getCurrency() : "INR";
    String currencySymbol = "INR".equalsIgnoreCase(currency) ? "\u20B9" : currency + " ";

    // ==================== instructor ====================
    User instructor = course.getInstructor();
    String instrName   = "Expert Instructor";
    String instrEmail  = "";
    String instrAvatar = "";
    String instrRole   = "Instructor";

    if (instructor != null) {
        if (instructor.getFullName() != null && !instructor.getFullName().trim().isEmpty()) {
            instrName = instructor.getFullName().trim();
        } else if (instructor.getEmail() != null) {
            instrName = instructor.getEmail().split("@")[0];
        }
        instrEmail = instructor.getEmail() != null ? instructor.getEmail() : "";
        if (instructor.getProfilePictureUrl() != null && !instructor.getProfilePictureUrl().isEmpty()) {
            instrAvatar = instructor.getProfilePictureUrl();
        } else if (course.getInstructorPhotoUrl() != null && !course.getInstructorPhotoUrl().isEmpty()) {
            instrAvatar = course.getInstructorPhotoUrl();
        }
        if (instructor instanceof Instructor) {
            Instructor ins = (Instructor) instructor;
            if (ins.getSpecialization() != null && !ins.getSpecialization().isEmpty()) {
                instrRole = ins.getSpecialization();
            }
        }
    } else if (course.getInstructorPhotoUrl() != null && !course.getInstructorPhotoUrl().isEmpty()) {
        instrAvatar = course.getInstructorPhotoUrl();
    }
    String instrInitial = instrName.isEmpty() ? "?" : String.valueOf(instrName.charAt(0)).toUpperCase();

    // ==================== curriculum ====================
    List<CourseSection> sections = course.getSections() != null ? course.getSections() : new ArrayList<>();
    int totalLessons = 0;
    for (CourseSection s : sections) {
        if (s.getContents() != null) totalLessons += s.getContents().size();
    }

    // ==================== reviews ====================
    // NOTE: Review rendering is temporarily disabled (see panel-reviews below).
    // Do NOT re-declare a "reviews" variable anywhere else on this page —
    // that caused a "duplicate local variable" compile error before.

    String exploreThisUrl = request.getContextPath() + "/courses/" + course.getId();
    String enrollUrl      = request.getContextPath() + "/enroll/"  + course.getId();
    String loginUrl       = request.getContextPath() + "/login?redirectTo=checkout&courseId=" + course.getId();

    // ==================== navbar / profile dropdown context ====================
    String navRole = (String) session.getAttribute("userRole");
    String dashUrl      = "admin".equals(navRole)      ? request.getContextPath() + "/admin/dashboard"
                        : "instructor".equals(navRole) ? request.getContextPath() + "/instructor/instructordashboard"
                        : request.getContextPath() + "/student/dashboard";
    String myCoursesUrl = "instructor".equals(navRole) ? request.getContextPath() + "/instructor/my-courses"
                        : request.getContextPath() + "/student/my-courses";
    String navFirstLetter = !sessionName.isEmpty() ? String.valueOf(sessionName.charAt(0)).toUpperCase() : "U";
    String navFirstName   = sessionName.contains(" ") ? sessionName.split(" ")[0] : sessionName;
    String navProfilePic  = (String) session.getAttribute("profilePictureUrl");
%>
<% if (pendingCourse != null && pendingCourse.equals(course.getId())) { %>
<script>
    window.addEventListener('load', function() {
        setTimeout(function() {
            const btn = document.querySelector('.buy-now-btn[data-course-id="<%= pendingCourse %>"]');
            if (btn) btn.click();
        }, 600);
    });
</script>
<% } %>
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= cTitle %> — EduMaster</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@500;600;700;800&family=Inter:wght@400;500;600;700&display=swap');

  :root{
    --indigo:#4F46E5; --purple:#9333EA; --ink:#1A1B2E; --ink-soft:#585a72;
    --paper:#FAFAFF; --card:#ffffff; --line:#ECEAF7; --amber:#F5A623; --amber-ink:#5c3d00;
    --off:#EF4444; --green:#10B981; --radius:16px; --shadow:0 4px 24px rgba(79,70,229,0.08);
  }
  *{box-sizing:border-box;}
  html{scroll-behavior:smooth;}
  body{margin:0; font-family:'Inter',sans-serif; background:var(--paper); color:var(--ink); -webkit-font-smoothing:antialiased;}
  h1,h2,h3,h4{font-family:'Poppins',sans-serif; margin:0; font-weight:bold; font-weight:620}
  a{text-decoration:none; color:inherit;}
  button{font-family:inherit; cursor:pointer;}
  .grad-text{background:linear-gradient(90deg,var(--indigo),var(--purple)); -webkit-background-clip:text; background-clip:text; color:transparent;}

  .crumb{max-width:1200px; margin:24px auto 0; padding:0 48px; font-size:14px; color:var(--ink-soft); display:flex; gap:8px; align-items:center;}
  .crumb a{color:var(--indigo); font-weight:600;}
  .crumb .sep{opacity:.5;}

  .hero{max-width:1200px; margin:20px auto 0; padding:0 48px; display:grid; grid-template-columns:1.15fr .85fr; gap:48px; align-items:center;}
  .badge{display:inline-block; background:var(--amber); color:var(--amber-ink); font-weight:700; font-size:12px; letter-spacing:.06em; padding:6px 14px; border-radius:999px; margin-bottom:16px;}
  .hero h1{font-size:38px; line-height:1.2; margin-bottom:14px; max-width:560px;}
  .hero-sub{color:var(--ink-soft); font-size:16px; line-height:1.7; max-width:540px; margin-bottom:22px;}
  .meta-row{display:flex; gap:26px; flex-wrap:wrap; margin-bottom:22px;}
  .meta-item{display:flex; align-items:center; gap:8px; font-size:14px; font-weight:600; color:var(--ink-soft);}
  .meta-item b{color:var(--ink);}
  .stars{color:var(--amber); letter-spacing:2px;}
  .hero-instructor{display:flex; align-items:center; gap:12px; padding-top:18px; border-top:1px solid var(--line);}
  .hero-instructor img, .hero-instructor .avatar-initial{width:46px; height:46px; border-radius:50%; object-fit:cover;}
  .hero-instructor .avatar-initial{background:linear-gradient(135deg,var(--indigo),var(--purple)); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700;}
  .hero-instructor .name{font-weight:700; font-size:15px;}
  .hero-instructor .role{font-size:13px; color:var(--ink-soft);}

  .hero-media{position:relative; border-radius:var(--radius); overflow:hidden; box-shadow:var(--shadow);}
  .hero-media img{width:100%; display:block; aspect-ratio:4/3; object-fit:cover;}
  .off-tag{position:absolute; top:16px; left:16px; background:var(--off); color:#fff; font-weight:800; font-size:13px; padding:8px 14px; border-radius:10px;}
  .cat-tag{position:absolute; top:16px; right:16px; background:var(--amber); color:var(--amber-ink); font-weight:800; font-size:12px; padding:8px 14px; border-radius:10px; letter-spacing:.04em; text-transform:uppercase;}

  .body-wrap{max-width:1200px; margin:48px auto; padding:0 48px; display:grid; grid-template-columns:1.55fr .95fr; gap:48px; align-items:start;}

  .tabs{display:flex; gap:8px; border-bottom:1px solid var(--line); margin-bottom:28px;}
  .tab-btn{background:none; border:none; padding:12px 4px; margin-right:28px; font-weight:600; font-size:15px; color:var(--ink-soft); border-bottom:3px solid transparent; transition:all .2s;}
  .tab-btn.active{color:var(--indigo); border-color:var(--indigo);}
  .tab-panel{display:none; animation:fade .25s ease;}
  .tab-panel.active{display:block;}
  @keyframes fade{from{opacity:0; transform:translateY(6px);} to{opacity:1; transform:translateY(0);}}

  .section-title{font-size:20px; margin:36px 0 14px;}
  .section-title:first-child{margin-top:0;}
  .prose{color:var(--ink-soft); line-height:1.8; font-size:15px; margin-bottom:24px; white-space:pre-line;}
  .empty-note{color:var(--ink-soft); font-size:14px; padding:20px; background:#fff; border:1px dashed var(--line); border-radius:12px; text-align:center;}

  .points-grid{display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-bottom:8px;}
  .point{display:flex; gap:10px; font-size:14.5px; color:var(--ink); align-items:flex-start;}
  .point .tick{flex:none; width:20px; height:20px; border-radius:50%; background:rgba(79,70,229,.1); color:var(--indigo); display:flex; align-items:center; justify-content:center; font-size:12px; font-weight:800;}

  .curr-item{border:1px solid var(--line); border-radius:12px; margin-bottom:12px; overflow:hidden; background:#fff;}
  .curr-head{display:flex; align-items:center; justify-content:space-between; padding:16px 18px; cursor:pointer;}
  .curr-head .left{display:flex; align-items:center; gap:12px;}
  .curr-num{width:30px; height:30px; border-radius:8px; background:linear-gradient(135deg,var(--indigo),var(--purple)); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:13px; flex:none;}
  .curr-head .title{font-weight:600; font-size:14.5px;}
  .curr-head .sub{font-size:12.5px; color:var(--ink-soft); margin-top:2px;}
  .chev{transition:transform .25s; color:var(--ink-soft);}
  .curr-item.open .chev{transform:rotate(180deg);}
  .curr-body{max-height:0; overflow:hidden; transition:max-height .3s ease;}
  .curr-item.open .curr-body{border-top:1px solid var(--line);}
  .lesson{display:flex; align-items:center; justify-content:space-between; padding:11px 18px 11px 60px; font-size:13.5px; color:var(--ink-soft);}
  .lesson:nth-child(even){background:#FBFAFF;}
  .lesson .lname{display:flex; align-items:center; gap:10px; color:var(--ink);}
  .dot{width:6px; height:6px; border-radius:50%; background:var(--indigo);}

  .instr-card{display:flex; gap:20px; align-items:flex-start; margin-bottom:20px;}
  .instr-card img, .instr-card .avatar-initial-lg{width:88px; height:88px; border-radius:16px; object-fit:cover;}
  .instr-card .avatar-initial-lg{background:linear-gradient(135deg,var(--indigo),var(--purple)); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:800; font-size:32px;}

  .review{border-bottom:1px solid var(--line); padding:18px 0; display:flex; gap:14px;}
  .review img, .review .avatar-initial-sm{width:42px; height:42px; border-radius:50%; object-fit:cover; flex:none;}
  .review .avatar-initial-sm{background:linear-gradient(135deg,var(--indigo),var(--purple)); color:#fff; display:flex; align-items:center; justify-content:center; font-weight:700;}
  .review .rname{font-weight:700; font-size:14px;}
  .review .rstars{color:var(--amber); font-size:12px; margin:2px 0 6px;}
  .review p{margin:0; font-size:13.5px; color:var(--ink-soft); line-height:1.6;}
  .rating-summary{display:flex; align-items:center; gap:20px; margin-bottom:24px; padding:20px; background:#fff; border:1px solid var(--line); border-radius:14px;}
  .rating-big{font-family:'Poppins'; font-size:44px; font-weight:800;}

  .sidebar{position:sticky; top:84px; align-self:start; z-index:10;}
  .buy-card{background:#fff; border:1px solid var(--line); border-radius:var(--radius); padding:26px; box-shadow:var(--shadow);}
  .price-row{display:flex; align-items:baseline; gap:10px; margin-bottom:2px;}
  .price-now{font-family:'Poppins'; font-size:32px; font-weight:800;}
  .price-old{font-size:15px; color:#a3a3b8; text-decoration:line-through;}
  .price-note{color:var(--off); font-size:12.5px; font-weight:700; margin-bottom:18px;}
  .btn{width:100%; padding:14px; border-radius:10px; border:none; font-weight:700; font-size:15px; display:flex; align-items:center; justify-content:center; gap:8px; margin-bottom:10px; transition:transform .15s, box-shadow .15s;}
  .btn:active{transform:scale(.98);}
  .btn:disabled{opacity:.6; cursor:not-allowed;}
  .btn-primary{background:linear-gradient(90deg,var(--indigo),var(--purple)); color:#fff; box-shadow:0 8px 20px rgba(79,70,229,.28);}
  .btn-primary:hover{box-shadow:0 10px 26px rgba(79,70,229,.4);}
  .btn-outline{background:#fff; color:var(--indigo); border:1.5px solid var(--indigo);}
  .btn-outline:hover{background:rgba(79,70,229,.06);}
  .btn-enrolled{background:linear-gradient(135deg,#10b981,#059669); color:#fff;}
  .includes{margin-top:18px; padding-top:18px; border-top:1px solid var(--line);}
  .includes h4{font-size:13.5px; margin-bottom:12px; color:var(--ink);}
  .includes li{list-style:none; display:flex; gap:10px; align-items:center; font-size:13.5px; color:var(--ink-soft); margin-bottom:10px;}
  .includes ul{margin:0; padding:0;}
  .ico{color:var(--indigo); flex:none;}

  /* Razorpay phone modal */
  .rzp-overlay{display:none; position:fixed; inset:0; z-index:9999; background:rgba(10,10,30,0.6); backdrop-filter:blur(6px); align-items:center; justify-content:center; padding:16px;}
  .rzp-overlay.open{display:flex;}
  .rzp-box{background:#fff; border-radius:20px; padding:36px 32px; width:100%; max-width:400px; box-shadow:0 30px 80px rgba(0,0,0,0.3); position:relative;}
  .rzp-close{position:absolute; top:14px; right:18px; background:none; border:none; font-size:1.2rem; color:#94a3b8; cursor:pointer; border-radius:6px; padding:4px 8px;}
  .rzp-close:hover{color:#1e293b; background:#f1f5f9;}

  /* ==================== index.jsp-style navbar ==================== */
  .navbar-fix{background:#fff; padding:14px 0; box-shadow:0 2px 10px rgba(99,102,241,0.08); position:sticky; top:0; z-index:999; border-bottom:1px solid rgba(99,102,241,.08);}
  .navbar-fix .container{display:flex; align-items:center; justify-content:space-between; max-width:1200px; margin:0 auto; padding:0 48px; position:relative;}
  .navbar-brand2{font-size:1.5rem; font-weight:800; background:linear-gradient(135deg,#6366f1,#8b5cf6,#ec4899); -webkit-background-clip:text; -webkit-text-fill-color:transparent; display:flex; align-items:center; gap:8px;}
  .nav-links2{display:flex; gap:8px; align-items:center;}
  .nav-links2 a{color:#334155; font-weight:500; padding:8px 14px; border-radius:8px; transition:.2s; font-size:14.5px;}
  .nav-links2 a:hover{color:#6366f1; background:rgba(99,102,241,.06);}
  .btn-start2{background:linear-gradient(135deg,#6366f1,#8b5cf6,#ec4899); color:#fff!important; padding:9px 22px; border-radius:50px; font-weight:600; border:none; font-size:14px;}

  .edu-profile-btn{background:linear-gradient(135deg,#6366f1,#8b5cf6,#ec4899); color:#fff; border:none; border-radius:50px; padding:7px 18px 7px 7px; display:flex; align-items:center; gap:9px; font-weight:600; font-size:.9rem; cursor:pointer; box-shadow:0 4px 20px rgba(99,102,241,.3);}
  .edu-btn-circle{width:28px; height:28px; border-radius:50%; background:rgba(255,255,255,.25); border:2px solid rgba(255,255,255,.7); display:flex; align-items:center; justify-content:center; font-weight:800; font-size:.9rem;}
  .edu-dropdown{position:absolute; top:calc(100% + 12px); right:48px; width:260px; background:#f4f7fe; border-radius:16px; box-shadow:0 10px 25px -5px rgba(0,0,0,.1),0 8px 10px -6px rgba(0,0,0,.1); border:1px solid #e5e7eb; overflow:hidden; display:none; z-index:9999;}
  .edu-dropdown.open{display:block;}
  .edu-drop-header{padding:20px; border-bottom:1px solid #e5e7eb; display:flex; flex-direction:column; align-items:center; text-align:center; background:#f4f7fe;}
  .edu-drop-avatar{width:50px; height:50px; background:linear-gradient(135deg,#7148fc,#d42ad3); color:#fff; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:20px; font-weight:700; margin-bottom:10px;}
  .edu-drop-header h3{color:#111827; font-size:1rem; font-weight:600; margin:0 0 3px;}
  .edu-drop-header p{color:#6b7280; font-size:.75rem; margin:0;}
  .edu-drop-menu{list-style:none; padding:8px; margin:0;}
  .edu-drop-menu li a{display:flex; align-items:center; gap:12px; padding:10px 12px; text-decoration:none; color:#374151; font-size:.875rem; font-weight:500; border-radius:10px; transition:.2s;}
  .edu-drop-menu li a:hover{background:#f3f4f6; color:#6366f1;}
  .edu-drop-icon{width:32px; height:32px; border-radius:8px; display:flex; align-items:center; justify-content:center; font-size:.875rem; flex-shrink:0;}
  .edu-drop-divider{border-top:1px solid #f3f4f6; margin:4px 0;}
  .edu-drop-logout{color:#dc2626!important; padding-top:12px!important;}
  .edu-drop-logout:hover{background:#fef2f2!important; color:#dc2626!important;}

  @media (max-width: 900px){
    .nav-links2{display:none;}
    .navbar-fix .container{padding:0 20px;}
    .hero{grid-template-columns:1fr; padding:0 20px;}
    .body-wrap{grid-template-columns:1fr; padding:0 20px;}
    .sidebar{position:static;}
    .points-grid{grid-template-columns:1fr;}
    .crumb{padding:0 20px;}
  }
</style>
</head>
<body>

<nav class="navbar-fix">
  <div class="container">
    <a class="navbar-brand2" href="<%= request.getContextPath() %>/index.jsp">
      <i class="fas fa-graduation-cap"></i> EduMaster
    </a>
    <div class="nav-links2">
      <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
      <a href="<%= request.getContextPath() %>/courses">Courses</a>
      <a href="#">About</a><a href="#">Instructor</a><a href="#">Pricing &amp; FAQ</a><a href="#">Contact</a>
    </div>

    <% if (sessionUid != null) { %>
      <button class="edu-profile-btn" id="eduProfileBtn" type="button">
        <% if (navProfilePic != null && !navProfilePic.isEmpty()) { %>
          <img src="<%= navProfilePic %>" alt="<%= navFirstName %>" style="width:28px;height:28px;border-radius:50%;object-fit:cover;border:2px solid rgba(255,255,255,0.7);">
        <% } else { %>
          <div class="edu-btn-circle"><%= navFirstLetter %></div>
        <% } %>
        <span><%= navFirstName %></span>
        <i class="fas fa-chevron-down" style="font-size:11px;"></i>
      </button>
      <div class="edu-dropdown" id="eduDropdown">
        <div class="edu-drop-header">
          <% if (navProfilePic != null && !navProfilePic.isEmpty()) { %>
            <img src="<%= navProfilePic %>" alt="<%= navFirstName %>" style="width:50px;height:50px;border-radius:50%;object-fit:cover;margin-bottom:10px;">
          <% } else { %>
            <div class="edu-drop-avatar"><%= navFirstLetter %></div>
          <% } %>
          <h3><%= sessionName %></h3>
          <p><%= sessionEmail %></p>
        </div>
        <ul class="edu-drop-menu">
          <li><a href="<%= dashUrl %>">
            <div class="edu-drop-icon" style="background:#e0e7ff;color:#4f46e5;"><i class="fas fa-chart-line"></i></div>
            My Dashboard
          </a></li>
          <li><a href="<%= myCoursesUrl %>">
            <div class="edu-drop-icon" style="background:#dcfce7;color:#16a34a;"><i class="fas fa-book-open"></i></div>
            My Courses
          </a></li>
          <li class="edu-drop-divider"></li>
          <li><a href="<%= request.getContextPath() %>/logout" class="edu-drop-logout">
            <div class="edu-drop-icon" style="background:#fee2e2;color:#dc2626;"><i class="fas fa-sign-out-alt"></i></div>
            Logout Account
          </a></li>
        </ul>
      </div>
    <% } else { %>
      <a href="<%= request.getContextPath() %>/login"><button class="btn-start2">Login</button></a>
    <% } %>
  </div>
</nav>

<div class="crumb">
  <a href="<%= request.getContextPath() %>/courses">Courses</a><span class="sep">/</span>
  <span><%= cCategory %></span><span class="sep">/</span><span><%= cTitle %></span>
</div>

<section class="hero">
  <div>
    <span class="badge"><%= cCategory.toUpperCase() %></span>
    <h1><%= cTitle %></h1>
    <p class="hero-sub"><%= cSubtitle %></p>
    <div class="meta-row">
      <div class="meta-item"><span class="stars">★★★★★</span> <b><%= String.format("%.1f", cRating) %></b> (<span><%= cReviewCount %></span> reviews)</div>
      <div class="meta-item">👥 <b><%= cStudents %></b> students</div>
      <div class="meta-item">🕒 <b><%= cTotalDuration %></b></div>
      <div class="meta-item">📶 <b><%= cLevel %></b></div>
    </div>
    <div class="hero-instructor">
      <% if (!instrAvatar.isEmpty()) { %>
        <img src="<%= instrAvatar %>" alt="<%= instrName %>">
      <% } else { %>
        <div class="avatar-initial"><%= instrInitial %></div>
      <% } %>
      <div>
        <div class="name"><%= instrName %></div>
        <div class="role"><%= instrRole %> · Instructor</div>
      </div>
    </div>
  </div>
  <div class="hero-media">
    <img src="<%= cThumb %>" alt="<%= cTitle %>">
    <% if (hasDisc) { %><span class="off-tag"><%= discPct %>% OFF</span><% } %>
    <span class="cat-tag"><%= cCategory %></span>
  </div>
</section>

<div class="body-wrap">
  <div class="main-col">
    <div class="tabs">
      <button class="tab-btn active" data-tab="overview">Overview</button>
      <button class="tab-btn" data-tab="curriculum">Curriculum</button>
      <button class="tab-btn" data-tab="instructor">Instructor</button>
      <button class="tab-btn" data-tab="reviews">Reviews</button>
    </div>

    <div class="tab-panel active" id="panel-overview">
      <h3 class="section-title">About this course</h3>
      <p class="prose"><%= cDescription.isEmpty() ? "No description provided yet." : cDescription %></p>

      <% if (!learningPoints.isEmpty()) { %>
        <h3 class="section-title">What you'll learn</h3>
        <div class="points-grid">
          <% for (String p : learningPoints) { %>
            <div class="point"><span class="tick">✓</span><%= p %></div>
          <% } %>
        </div>
      <% } %>
    </div>

    <div class="tab-panel" id="panel-curriculum">
      <h3 class="section-title">Course curriculum</h3>
      <p class="prose" style="margin-bottom:16px;"><%= sections.size() %> modules · <%= totalLessons %> lessons · <%= cTotalDuration %></p>

      <% if (sections.isEmpty()) { %>
        <div class="empty-note">Curriculum coming soon.</div>
      <% } else {
           int modIndex = 0;
           for (CourseSection sec : sections) {
               modIndex++;
               List<CourseContent> contents = sec.getContents() != null ? sec.getContents() : new ArrayList<CourseContent>();
      %>
        <div class="curr-item">
          <div class="curr-head" onclick="toggleCurr(this)">
            <div class="left">
              <div class="curr-num"><%= String.format("%02d", modIndex) %></div>
              <div>
                <div class="title"><%= sec.getTitle() %></div>
                <div class="sub"><%= contents.size() %> lessons</div>
              </div>
            </div>
            <span class="chev">▾</span>
          </div>
          <div class="curr-body">
            <% for (CourseContent lesson : contents) { %>
              <div class="lesson">
                <span class="lname"><span class="dot"></span><%= lesson.getTitle() %></span>
                <span>▶</span>
              </div>
            <% } %>
          </div>
        </div>
      <% } } %>
    </div>

    <div class="tab-panel" id="panel-instructor">
      <h3 class="section-title">Meet your instructor</h3>
      <div class="instr-card">
        <% if (!instrAvatar.isEmpty()) { %>
          <img src="<%= instrAvatar %>" alt="<%= instrName %>">
        <% } else { %>
          <div class="avatar-initial-lg"><%= instrInitial %></div>
        <% } %>
        <div>
          <h4 style="font-size:18px;"><%= instrName %></h4>
          <p class="prose" style="margin:6px 0 0;"><%= instrRole %><% if (!instrEmail.isEmpty()) { %> · <%= instrEmail %><% } %></p>
          <%-- Instructor bio / totalCourses / totalStudents / avgRating stats aren't
               in the entity fields I have — tell me the getter names and I'll add
               the stats row back here, same as the index.jsp instructor card. --%>
        </div>
      </div>
    </div>

    <div class="tab-panel" id="panel-reviews">
      <h3 class="section-title">Student reviews</h3>
      <div class="rating-summary">
        <div class="rating-big"><%= String.format("%.1f", cRating) %></div>
        <div>
          <div class="stars" style="font-size:18px;">★★★★★</div>
          <div style="color:var(--ink-soft); font-size:13px; margin-top:4px;">Based on <span><%= cReviewCount %></span> reviews</div>
        </div>
      </div>

      <%-- Review list temporarily removed to fix a duplicate-variable compile
           error. Tell me when you want it wired back in and I'll re-add the
           loop using the real Review entity fields. --%>
      <div class="empty-note">Reviews coming soon.</div>
    </div>
  </div>

  <aside class="sidebar">
    <div class="buy-card">
      <div class="price-row">
        <span class="price-now"><%= isFree ? "Free" : currencySymbol + String.format("%,.0f", finalPrice) %></span>
        <% if (hasDisc) { %><span class="price-old"><%= currencySymbol %><%= String.format("%,.0f", cPrice) %></span><% } %>
      </div>
      <% if (hasDisc) { %><div class="price-note">Limited time offer!</div><% } %>

      <% if (isEnrolled) { %>
        <a href="<%= request.getContextPath() %>/student/my-courses">
          <button class="btn btn-enrolled"><i class="fas fa-check-circle"></i> Go to course</button>
        </a>
      <% } else if (isFree) { %>
        <a href="<%= sessionUid != null ? enrollUrl : loginUrl %>">
          <button class="btn btn-primary">🎓 Enroll Free</button>
        </a>
      <% } else if (sessionUid == null) { %>
        <a href="<%= loginUrl %>">
          <button class="btn btn-primary">🛒 Buy Now</button>
        </a>
      <% } else { %>
        <button class="btn btn-primary buy-now-btn"
            data-course-id="<%= course.getId() %>"
            data-course-title="<%= cTitle.replace("\"","&quot;") %>"
            data-amount="<%= priceInPaise %>"
            data-price-display="<%= String.format("%,.0f", finalPrice) %>"
            data-name="<%= sessionName %>"
            data-email="<%= sessionEmail %>"
            data-phone="<%= sessionPhone %>">
            🛒 Buy Now
        </button>
      <% } %>

      <button class="btn btn-outline" id="wishlistBtn">Add to Wishlist</button>

      <div class="includes">
        <h4>This course includes</h4>
        <ul>
          <li><span class="ico">🎬</span> (<%= totalLessons %> lessons) on-demand video</li>
          <li><span class="ico">📄</span> Downloadable resources &amp; source code</li>
          <li><span class="ico">♾️</span> Full lifetime access</li>
          <li><span class="ico">🏆</span> Certificate of completion</li>
        </ul>
      </div>
    </div>
  </aside>
</div>

<!-- Razorpay Phone Modal -->
<div class="rzp-overlay" id="rzpOverlay">
  <div class="rzp-box">
    <button class="rzp-close" id="rzpClose">&#x2715;</button>
    <div style="font-weight:800; margin-bottom:4px;">EduMaster</div>
    <div id="rzp-ctitle" style="color:var(--ink-soft); font-size:0.85rem; margin-bottom:12px;"></div>
    <button class="btn btn-primary" id="rzpPay"><i class="fas fa-lock"></i> Proceed to Pay</button>
  </div>
</div>

<script>
document.querySelectorAll('.tab-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.tab-btn').forEach(b=>b.classList.remove('active'));
    document.querySelectorAll('.tab-panel').forEach(p=>p.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('panel-' + btn.dataset.tab).classList.add('active');
  });
});

function toggleCurr(headEl){
  const item = headEl.closest('.curr-item');
  const body = item.querySelector('.curr-body');
  const isOpen = item.classList.contains('open');
  document.querySelectorAll('.curr-item.open').forEach(o => {
    o.classList.remove('open');
    o.querySelector('.curr-body').style.maxHeight = null;
  });
  if(!isOpen){
    item.classList.add('open');
    body.style.maxHeight = body.scrollHeight + "px";
  }
}

document.getElementById('wishlistBtn')?.addEventListener('click', (e) => {
  e.target.textContent = "✓ Added to Wishlist";
  setTimeout(()=> e.target.textContent = "Add to Wishlist", 1600);
});

// ── Profile dropdown toggle (index.jsp-style navbar) ──
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

// ── Payment verify (form submit) — same pattern as index.jsp ──
function verifyPayment(response) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '<%= request.getContextPath() %>/payment/verify';
    const csrf = document.createElement('input');
    csrf.type = 'hidden'; csrf.name = '${_csrf.parameterName}'; csrf.value = '${_csrf.token}';
    form.appendChild(csrf);
    [
        ['razorpay_order_id',   response.razorpay_order_id],
        ['razorpay_payment_id', response.razorpay_payment_id],
        ['razorpay_signature',  response.razorpay_signature]
    ].forEach(([k, v]) => {
        const inp = document.createElement('input');
        inp.type = 'hidden'; inp.name = k; inp.value = v;
        form.appendChild(inp);
    });
    document.body.appendChild(form);
    form.submit();
}

document.querySelectorAll('.buy-now-btn').forEach(function(btn) {
    btn.addEventListener('click', async function() {
        const courseId    = this.dataset.courseId;
        const courseTitle = this.dataset.courseTitle;
        const name        = this.dataset.name;
        const email       = this.dataset.email;
        const phone       = this.dataset.phone;

        this.disabled  = true;
        const origHtml = this.innerHTML;
        this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>&nbsp;Please wait…';
        const btnRef   = this;

        try {
            const res = await fetch('<%= request.getContextPath() %>/payment/create-order', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'courseId=' + courseId
            });
            if (!res.ok) throw new Error('Server error: ' + res.status);
            const order = await res.json();
            if (order.error) throw new Error(order.error);

            const rzp = new Razorpay({
                key:         order.keyId,
                amount:      order.amount,
                currency:    'INR',
                name:        'EduMaster',
                description: courseTitle,
                order_id:    order.razorpayOrderId,
                prefill: {
                    name:    name,
                    email:   email,
                    contact: phone && phone.trim().length === 10 ? phone.trim() : ''
                },
                theme: { color: '#4f46e5' },
                handler: function(response) { verifyPayment(response); },
                modal: {
                    ondismiss: function() {
                        btnRef.disabled  = false;
                        btnRef.innerHTML = origHtml;
                    }
                }
            });
            rzp.open();
        } catch(err) {
            console.error('Payment error:', err);
            alert('Payment failed: ' + err.message);
            btnRef.disabled  = false;
            btnRef.innerHTML = origHtml;
        }
    });
});
</script>
</body>
</html>
