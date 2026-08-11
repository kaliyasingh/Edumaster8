<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    String sessionName  = (String) session.getAttribute("fullName");  if(sessionName  == null) sessionName  = "Student";
    String sessionEmail = (String) session.getAttribute("email");     if(sessionEmail == null) sessionEmail = "";
    String sessionPhone = (String) session.getAttribute("phone");     if(sessionPhone == null) sessionPhone = "";
    String profilePic   = (String) session.getAttribute("profilePictureUrl");
    String firstLetter  = sessionName.isEmpty() ? "S" : String.valueOf(sessionName.charAt(0)).toUpperCase();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>EduMaster - My Profile</title>
  <style>
    :root{
      --bg1:#edf0ff;
      --bg2:#f7eefe;
      --sidebar:#070d1d;
      --sidebar2:#0c1327;
      --card:rgba(255,255,255,.74);
      --card2:rgba(255,255,255,.9);
      --text:#1b2434;
      --muted:#7a8092;
      --purple:#6d5efc;
      --purple2:#8b6cff;
      --line:rgba(40,40,80,.08);
      --shadow:0 18px 50px rgba(20,20,60,.14);
      --radius:24px;
    }

    [data-theme="dark"]{
      --bg1:#0a0f1d;
      --bg2:#11162a;
      --card:rgba(16,20,36,.72);
      --card2:rgba(20,26,46,.9);
      --text:#edf1ff;
      --muted:#a1a8bd;
      --line:rgba(255,255,255,.08);
      --shadow:0 18px 50px rgba(0,0,0,.28);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    body{
      font-family:Inter, Arial, Helvetica, sans-serif;
      color:var(--text);
      min-height:100vh;
      overflow-x:hidden;
      background:
        radial-gradient(circle at 82% 18%, rgba(255,182,255,.55), transparent 20%),
        radial-gradient(circle at 58% 82%, rgba(170,150,255,.35), transparent 22%),
        linear-gradient(135deg, var(--bg1) 0%, var(--bg2) 100%);
      transition:background .3s ease,color .3s ease;
    }

    body::before{
      content:"";
      position:fixed;
      inset:0;
      background:
        radial-gradient(circle at 20% 30%, rgba(109,94,252,.08) 0%, transparent 40%),
        radial-gradient(circle at 80% 60%, rgba(255,102,222,.06) 0%, transparent 40%);
      animation:bgFloat 22s linear infinite alternate;
      pointer-events:none;
      z-index:-1;
    }

    @keyframes bgFloat{
      from{transform:translate3d(0,0,0) scale(1)}
      to{transform:translate3d(12px,-12px,0) scale(1.02)}
    }

    .app{display:flex;min-height:100vh}
    .sidebar{
      width:290px;
      background:linear-gradient(180deg, var(--sidebar) 0%, var(--sidebar2) 100%);
      color:#fff;
      padding:24px 20px;
      display:flex;
      flex-direction:column;
      justify-content:space-between;
      box-shadow:inset -1px 0 0 rgba(255,255,255,.05);
      transition:.3s ease;
    }

    .sidebar.collapsed{width:92px}
    .sidebar.collapsed .brand-text,
    .sidebar.collapsed .nav-text,
    .sidebar.collapsed .sidebar-footer,
    .sidebar.collapsed .nav-title{display:none}
    .sidebar.collapsed .nav a{justify-content:center}
    .sidebar.collapsed .brand{justify-content:center}
    .sidebar.collapsed .brand .logo{margin-right:0}

    .brand{display:flex;align-items:center;gap:12px;margin-bottom:34px}
    .logo{
      width:44px;height:44px;border-radius:16px;
      background:linear-gradient(135deg, #7b61ff, #ff5edb);
      display:grid;place-items:center;
      font-size:22px;
      box-shadow:0 12px 30px rgba(123,97,255,.35);
      animation:logoFloat 3s ease-in-out infinite alternate;
      flex:0 0 auto;
    }

    @keyframes logoFloat{
      from{transform:translateY(0)}
      to{transform:translateY(-5px)}
    }

    .brand h1{font-size:24px;line-height:1}
    .brand p{margin-top:4px;color:rgba(255,255,255,.62);font-size:13px}

    .nav-title{
      color:rgba(255,255,255,.35);
      font-weight:700;
      letter-spacing:.12em;
      font-size:12px;
      margin:18px 0 14px;
    }

    .nav a{
      display:flex;
      align-items:center;
      gap:12px;
      color:rgba(255,255,255,.86);
      text-decoration:none;
      padding:12px 14px;
      border-radius:14px;
      margin-bottom:8px;
      font-size:15px;
      transition:.25s ease;
      position:relative;
      overflow:hidden;
    }

    .nav a.active{
      background:linear-gradient(90deg, #6d5efc, #875fff);
      box-shadow:0 10px 24px rgba(109,94,252,.35);
    }

    .nav a:hover{background:rgba(255,255,255,.08);transform:translateX(4px)}
    .nav a span.icon{width:22px;text-align:center;font-size:16px;opacity:.95}
    .sidebar-footer{
      border-top:1px solid rgba(255,255,255,.1);
      padding-top:16px;
      color:rgba(255,255,255,.65);
      font-size:14px;
    }

    .main{
      flex:1;
      padding:22px;
      background:rgba(255,255,255,.35);
      backdrop-filter:blur(12px);
      margin:12px;
      border-radius:24px 0 0 0;
      box-shadow:0 18px 50px rgba(20,20,60,.1);
    }

    .topbar{
      display:grid;
      grid-template-columns:1.2fr 1fr auto;
      gap:16px;
      align-items:center;
      margin-bottom:16px;
    }

    .welcome h2{font-size:26px;line-height:1.05;margin-bottom:5px}
    .welcome p{color:var(--muted);font-size:14px}

    .controls{
      display:flex;
      gap:10px;
      flex-wrap:wrap;
    }

    .btn{
      border:0;
      background:linear-gradient(135deg, #6d5efc, #8b6cff);
      color:#fff;
      padding:10px 16px;
      border-radius:999px;
      font-size:13px;
      cursor:pointer;
      transition:.2s ease;
      font-family:inherit;
      font-weight:700;
    }

    .btn:hover{transform:scale(1.05)}
    .btn.ghost{
      background:rgba(255,255,255,.78);
      color:var(--text);
      border:1px solid var(--line);
    }

    .user{display:flex;align-items:center;gap:10px;justify-content:flex-end}
    .tool{
      width:42px;height:42px;border-radius:50%;
      background:rgba(255,255,255,.72);
      box-shadow:var(--shadow);
      display:grid;place-items:center;
      font-size:18px;
      cursor:pointer;
      transition:.2s ease;
    }

    .tool:hover{transform:scale(1.07)}
    .profile{display:flex;align-items:center;gap:10px;margin-left:6px}
    .profile .txt{text-align:right}
    .profile .txt strong{display:block;font-size:15px}
    .profile .txt span{color:var(--muted);font-size:12px}
    .avatar{
      width:44px;height:44px;border-radius:50%;
      background:linear-gradient(135deg,#f5c4b7,#c78cff);
      border:3px solid rgba(255,255,255,.8);
      box-shadow:var(--shadow);
      object-fit:cover;
      display:flex;align-items:center;justify-content:center;
      color:#fff;font-weight:700;font-size:16px;
    }

    .card,.panel{
      background:var(--card);
      border:1px solid var(--line);
      box-shadow:var(--shadow);
      border-radius:var(--radius);
      backdrop-filter:blur(18px);
    }

    /* Success Alert */
    .alert-success{
      background:rgba(53,199,89,.12);
      border:1px solid rgba(53,199,89,.3);
      color:#1f7a45;
      padding:13px 18px;
      border-radius:16px;
      font-size:13px;
      font-weight:600;
      display:flex;align-items:center;gap:10px;
      margin-bottom:16px;
      animation:slideIn .3s ease;
    }
    [data-theme="dark"] .alert-success{ color:#7be8a4; }
    @keyframes slideIn{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}

    /* Profile Header */
    .profile-head{
      padding:22px;
      display:flex;
      align-items:center;
      gap:24px;
      flex-wrap:wrap;
      margin-bottom:16px;
      animation:cardPop .7s ease both;
    }

    @keyframes cardPop{
      from{opacity:0;transform:translateY(18px) scale(.98)}
      to{opacity:1;transform:translateY(0) scale(1)}
    }

    .ph-avatar-wrap{ position:relative; flex-shrink:0; }
    .ph-avatar{
      width:96px;height:96px;border-radius:28px;
      object-fit:cover;
      background:linear-gradient(135deg,#f5c4b7,#c78cff);
      border:4px solid rgba(255,255,255,.85);
      box-shadow:var(--shadow);
      display:flex;align-items:center;justify-content:center;
      color:#fff;font-weight:800;font-size:2.2rem;
    }
    .ph-edit-btn{
      position:absolute; bottom:-6px; right:-6px;
      width:32px;height:32px;border-radius:12px;
      background:linear-gradient(135deg,#6d5efc,#8b6cff);
      display:flex;align-items:center;justify-content:center;
      color:#fff;font-size:.8rem;cursor:pointer;
      border:3px solid var(--card2);
      box-shadow:0 6px 16px rgba(109,94,252,.4);
      text-decoration:none;
    }
    .ph-info h2{ margin:0; font-size:24px; }
    .ph-info .ph-email{
      margin-top:5px; color:var(--muted); font-size:13px;
      display:flex; align-items:center; gap:6px;
    }
    .ph-badge{
      display:inline-flex; align-items:center; gap:6px;
      margin-top:10px;
      background:rgba(109,94,252,.12); color:#6d5efc;
      padding:6px 14px; border-radius:999px;
      font-size:12px; font-weight:700;
    }
    .ph-actions{ margin-left:auto; display:flex; gap:10px; flex-wrap:wrap; }

    /* Stats Row */
    .stats{
      display:grid;
      grid-template-columns:repeat(4,1fr);
      gap:14px;
      margin-bottom:16px;
    }

    .stat{
      padding:14px;
      min-height:112px;
      position:relative;
      overflow:hidden;
      transition:.2s ease;
      animation:cardPop .7s ease both;
    }
    .stat:hover{transform:translateY(-4px)}
    .stat h4{font-size:14px;color:var(--muted);font-weight:500}
    .stat .value{margin-top:7px;font-size:24px;font-weight:800;line-height:1}
    .stat p{margin-top:6px;color:var(--muted);font-size:12px}
    .ring{
      position:absolute;
      right:16px;top:24px;
      width:52px;height:52px;border-radius:50%;
      background:conic-gradient(#6d5efc 0 280deg,#e7e7ef 280deg 360deg);
      display:grid;place-items:center;
      animation:ringSpin 5s ease-in-out infinite alternate;
    }
    @keyframes ringSpin{
      from{transform:rotate(0deg)}
      to{transform:rotate(10deg)}
    }
    .ring::after{
      content:"";
      width:38px;height:38px;border-radius:50%;
      background:var(--card2);
      position:absolute;
    }

    /* Section Head */
    .section-head{
      display:flex;
      justify-content:space-between;
      align-items:end;
      margin:8px 0 12px;
    }
    .section-head h3{font-size:22px;margin:0}
    .section-head p{margin-top:4px;color:var(--muted);font-size:13px}
    .section-head a{
      color:#6d5efc;
      text-decoration:none;
      font-size:14px;
      font-weight:600;
    }

    /* Panels */
    .panel{
      padding:22px;
      margin-bottom:16px;
      animation:cardPop .7s ease .05s both;
    }

    /* Form Grid */
    .form-grid{
      display:grid;
      grid-template-columns: repeat(2, 1fr);
      gap:16px;
    }
    .form-field{ display:flex; flex-direction:column; gap:6px; }
    .form-field.full{ grid-column: 1 / -1; }
    .form-field label{
      font-size:12px; font-weight:700; color:var(--muted);
      text-transform:uppercase; letter-spacing:.06em;
    }
    .form-field input,
    .form-field select,
    .form-field textarea{
      border:1px solid var(--line);
      background:rgba(255,255,255,.85);
      border-radius:14px;
      padding:12px 14px;
      font-size:14px;
      color:var(--text);
      font-family:inherit;
      outline:0;
      transition:.2s;
      resize:none;
    }
    [data-theme="dark"] .form-field input,
    [data-theme="dark"] .form-field select,
    [data-theme="dark"] .form-field textarea{
      background:rgba(255,255,255,.06);
      color:var(--text);
    }
    .form-field input:focus,
    .form-field select:focus,
    .form-field textarea:focus{
      border-color:#6d5efc;
      box-shadow:0 0 0 3px rgba(109,94,252,.12);
    }
    .pw-wrap{ position:relative; }
    .pw-wrap input{ padding-right:42px; }
    .pw-toggle{
      position:absolute; right:13px; top:50%; transform:translateY(-50%);
      cursor:pointer; color:#9aa0b4; font-size:1rem; transition:.2s;
    }
    .pw-toggle:hover{ color:#6d5efc; }

    .save-row{
      display:flex; justify-content:flex-end; gap:10px; margin-top:18px;
    }

    /* Enrolled Courses Mini */
    .course-mini{
      display:flex; align-items:center; gap:14px;
      padding:14px; border-radius:18px;
      background:rgba(255,255,255,.74);
      border:1px solid var(--line);
      margin-bottom:10px;
      transition:.2s;
    }
    [data-theme="dark"] .course-mini{ background:rgba(255,255,255,.04); }
    .course-mini:hover{ box-shadow:var(--shadow); transform:translateY(-2px); }
    .cm-thumb{
      width:54px;height:54px;border-radius:14px;
      object-fit:cover; flex-shrink:0;
      background:linear-gradient(135deg,#6d5efc,#b06cff);
      display:flex;align-items:center;justify-content:center;
      color:rgba(255,255,255,.6); font-size:1.3rem;
    }
    .cm-thumb img{ width:100%;height:100%;object-fit:cover;border-radius:14px; }
    .cm-info{ flex:1; min-width:0; }
    .cm-info h4{ margin:0 0 4px; font-size:14px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .cm-info span{ color:var(--muted); font-size:12px; }
    .cm-bar{ margin-top:6px; height:5px; border-radius:999px; background:#e9e8f3; overflow:hidden; }
    [data-theme="dark"] .cm-bar{ background:rgba(255,255,255,.08); }
    .cm-bar > span{ display:block; height:100%; border-radius:999px; background:linear-gradient(90deg,#6d5efc,#b06cff); }
    .cm-pct{
      font-size:12px; font-weight:800; color:#6d5efc;
      background:rgba(109,94,252,.1); padding:5px 12px; border-radius:999px;
      flex-shrink:0;
    }
    .cm-pct.done{ color:#1f7a45; background:rgba(53,199,89,.12); }
    [data-theme="dark"] .cm-pct.done{ color:#7be8a4; }

    .empty-mini{
      text-align:center; padding:30px 10px; color:var(--muted);
    }
    .empty-mini i{ font-size:2rem; display:block; margin-bottom:8px; opacity:.5; }
    .empty-mini a{ color:#6d5efc; font-weight:700; text-decoration:none; font-size:13px; }

    @media (max-width: 1200px){
      .app{flex-direction:column}
      .sidebar{width:100%}
      .topbar{grid-template-columns:1fr}
      .user{justify-content:flex-start}
      .stats{grid-template-columns:1fr 1fr}
      .form-grid{grid-template-columns:1fr}
    }

    @media (max-width: 700px){
      .main{padding:14px}
      .stats{grid-template-columns:1fr}
      .welcome h2{font-size:22px}
      .profile-head{flex-direction:column; text-align:center;}
      .ph-actions{margin-left:0; width:100%; justify-content:center;}
    }
  </style>
</head>
<body>
  <div class="app">
    <aside class="sidebar" id="sidebar">
      <div>
        <div class="brand">
          <div class="logo">⚡</div>
          <div class="brand-text">
            <h1>EduMaster</h1>
            <p>Student Workspace</p>
          </div>
        </div>

        <div class="nav-title">MAIN</div>
        <nav class="nav">
          <a href="${pageContext.request.contextPath}/student/dashboard"><span class="icon">▦</span><span class="nav-text">Dashboard</span></a>
          <a href="${pageContext.request.contextPath}/student/profile" class="active"><span class="icon">👤</span><span class="nav-text">My Profile</span></a>
          <a href="${pageContext.request.contextPath}/student/my-courses"><span class="icon">🎓</span><span class="nav-text">Enrolled Courses</span></a>
          <a href="${pageContext.request.contextPath}/student/assignments"><span class="icon">📄</span><span class="nav-text">Assignments</span></a>
          <a href="${pageContext.request.contextPath}/student/certificates"><span class="icon">🏅</span><span class="nav-text">Certificates</span></a>
          <a href="${pageContext.request.contextPath}/student/settings"><span class="icon">⚙️</span><span class="nav-text">Settings</span></a>
        </nav>
      </div>

      <div class="sidebar-footer">
        <div>Today: ${streakDays != null ? streakDays : 0} days streak 🔥</div>
        <div>Keep learning!</div>
      </div>
    </aside>

    <main class="main">
      <div class="topbar">
        <div class="welcome">
          <h2>My Profile 👤</h2>
          <p>Manage your personal information and account settings.</p>
        </div>

        <div class="controls">
          <button class="btn ghost" id="sidebarBtn">☰ Menu</button>
          <button class="btn ghost" id="themeBtn">☾ Dark Mode</button>
        </div>

        <div class="user">
          <div class="tool">🔔</div>
          <div class="profile">
            <div class="txt">
              <strong><%= sessionName %></strong>
              <span>Student<c:if test="${not empty studentSpecialization}"> · ${studentSpecialization}</c:if></span>
            </div>
            <% if (profilePic != null && !profilePic.isEmpty()) { %>
                <img src="<%= profilePic %>" alt="" class="avatar">
            <% } else { %>
                <div class="avatar"><%= firstLetter %></div>
            <% } %>
          </div>
        </div>
      </div>

      <!-- Success Alert -->
      <c:if test="${not empty success}">
        <div class="alert-success" id="successAlert">
          ✅ ${success}
        </div>
      </c:if>

      <!-- Profile Header -->
      <div class="card profile-head">
        <div class="ph-avatar-wrap">
          <% if (profilePic != null && !profilePic.isEmpty()) { %>
              <img src="<%= profilePic %>" alt="Avatar" class="ph-avatar">
          <% } else { %>
              <div class="ph-avatar"><%= firstLetter %></div>
          <% } %>
          <a href="#uploadPhoto" class="ph-edit-btn" title="Change photo">📷</a>
        </div>
        <div class="ph-info">
          <h2><%= sessionName %></h2>
          <div class="ph-email">✉️ <%= sessionEmail %></div>
          <span class="ph-badge">🎓 Student<c:if test="${not empty studentSpecialization}"> · ${studentSpecialization}</c:if></span>
        </div>
        <div class="ph-actions">
          <button class="btn ghost" type="button" onclick="document.getElementById('profileForm').scrollIntoView({behavior:'smooth'})">✏️ Edit Profile</button>
        </div>
      </div>

      <!-- Stats Row -->
      <div class="stats">
        <div class="card stat">
          <h4>Enrolled courses</h4>
          <div class="value">${enrolledCount != null ? enrolledCount : 0}</div>
          <p>All enrolled courses</p>
          <div class="ring"></div>
        </div>
        <div class="card stat">
          <h4>Completed</h4>
          <div class="value">${completedCount != null ? completedCount : 0}</div>
          <p>Courses completed</p>
          <div class="ring" style="background:conic-gradient(#35c759 0 270deg,#e7e7ef 270deg 360deg)"></div>
        </div>
        <div class="card stat">
          <h4>Certificates</h4>
          <div class="value">${certificateCount != null ? certificateCount : 0}</div>
          <p>Certificates earned</p>
          <div class="ring" style="background:conic-gradient(#5aa8ff 0 250deg,#e7e7ef 250deg 360deg)"></div>
        </div>
        <div class="card stat">
          <h4>Wishlist</h4>
          <div class="value">${wishlistCount != null ? wishlistCount : 0}</div>
          <p>Saved for later</p>
          <div class="ring" style="background:conic-gradient(#ff8a1f 0 300deg,#e7e7ef 300deg 360deg)"></div>
        </div>
      </div>

      <!-- Personal Info Form -->
      <section class="panel" id="profileForm">
        <div class="section-head">
          <div>
            <h3>Personal Information</h3>
            <p>Update your photo and personal details here.</p>
          </div>
        </div>

        <form action="${pageContext.request.contextPath}/student/profile/update" method="post" enctype="multipart/form-data">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

          <!-- Photo Upload -->
          <div class="form-field full" id="uploadPhoto" style="margin-bottom:6px;">
            <label>Profile Photo</label>
            <div style="display:flex;align-items:center;gap:16px;flex-wrap:wrap;">
              <% if (profilePic != null && !profilePic.isEmpty()) { %>
                  <img src="<%= profilePic %>" style="width:58px;height:58px;border-radius:16px;object-fit:cover;border:3px solid rgba(255,255,255,.85);box-shadow:var(--shadow);">
              <% } else { %>
                  <div style="width:58px;height:58px;border-radius:16px;background:linear-gradient(135deg,#6d5efc,#b06cff);display:flex;align-items:center;justify-content:center;color:#fff;font-size:1.4rem;font-weight:800;"><%= firstLetter %></div>
              <% } %>
              <div>
                <input type="file" name="profilePhoto" id="photoInput" accept="image/*" style="display:none;" onchange="previewPhoto(this)">
                <button type="button" class="btn ghost" onclick="document.getElementById('photoInput').click()">⬆️ Upload Photo</button>
                <p style="font-size:11px;color:var(--muted);margin:6px 0 0;">JPG, PNG up to 2MB</p>
              </div>
            </div>
          </div>

          <div class="form-grid" style="margin-top:14px;">
            <div class="form-field">
              <label>Full Name</label>
              <input type="text" name="fullName" value="<%= sessionName %>" placeholder="Your full name">
            </div>
            <div class="form-field">
              <label>Email Address</label>
              <input type="email" name="email" value="<%= sessionEmail %>" placeholder="your@email.com">
            </div>
            <div class="form-field">
              <label>Phone Number</label>
              <input type="tel" name="phone" value="<%= sessionPhone %>" placeholder="+91 XXXXX XXXXX">
            </div>
            <div class="form-field">
              <label>Date of Birth</label>
              <input type="date" name="dob" value="${studentProfile.dob}">
            </div>
            <div class="form-field">
              <label>Gender</label>
              <select name="gender">
                <option value="">Select gender</option>
                <option value="male"   ${studentProfile.gender == 'male'   ? 'selected' : ''}>Male</option>
                <option value="female" ${studentProfile.gender == 'female' ? 'selected' : ''}>Female</option>
                <option value="other"  ${studentProfile.gender == 'other'  ? 'selected' : ''}>Other</option>
              </select>
            </div>
            <div class="form-field">
              <label>Location</label>
              <input type="text" name="location" value="${studentProfile.location}" placeholder="City, Country">
            </div>
            <div class="form-field full">
              <label>Bio</label>
              <textarea name="bio" rows="3" placeholder="Tell us a bit about yourself...">${studentProfile.bio}</textarea>
            </div>
            <div class="form-field">
              <label>LinkedIn</label>
              <input type="url" name="linkedin" value="${studentProfile.linkedin}" placeholder="https://linkedin.com/in/...">
            </div>
            <div class="form-field">
              <label>Website / Portfolio</label>
              <input type="url" name="website" value="${studentProfile.website}" placeholder="https://yoursite.com">
            </div>
          </div>

          <div class="save-row">
            <button type="button" class="btn ghost" onclick="history.back()">Cancel</button>
            <button type="submit" class="btn">💾 Save Changes</button>
          </div>
        </form>
      </section>

      <!-- Change Password -->
      <section class="panel">
        <div class="section-head">
          <div>
            <h3>Change Password</h3>
            <p>Make sure your new password is at least 8 characters.</p>
          </div>
        </div>

        <form action="${pageContext.request.contextPath}/student/profile/change-password" method="post">
          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
          <div class="form-grid">
            <div class="form-field">
              <label>Current Password</label>
              <div class="pw-wrap">
                <input type="password" name="currentPassword" id="pw1" placeholder="Current password">
                <span class="pw-toggle" onclick="togglePw('pw1', this)">👁️</span>
              </div>
            </div>
            <div class="form-field">
              <label>New Password</label>
              <div class="pw-wrap">
                <input type="password" name="newPassword" id="pw2" placeholder="New password">
                <span class="pw-toggle" onclick="togglePw('pw2', this)">👁️</span>
              </div>
            </div>
            <div class="form-field" style="grid-column: 1 / -1; max-width:calc(50% - 8px);">
              <label>Confirm Password</label>
              <div class="pw-wrap">
                <input type="password" name="confirmPassword" id="pw3" placeholder="Confirm password">
                <span class="pw-toggle" onclick="togglePw('pw3', this)">👁️</span>
              </div>
            </div>
          </div>
          <div class="save-row">
            <button type="submit" class="btn">🔑 Update Password</button>
          </div>
        </form>
      </section>

      <!-- Enrolled Courses Quick View -->
      <section class="panel" style="margin-bottom:0;">
        <div class="section-head">
          <div>
            <h3>Enrolled Courses</h3>
            <p>Continue where you left off.</p>
          </div>
          <a href="${pageContext.request.contextPath}/student/my-courses">View all</a>
        </div>

        <c:choose>
          <c:when test="${not empty enrolledCourses}">
            <c:forEach var="ec" items="${enrolledCourses}" varStatus="vs">
              <c:if test="${vs.index < 3}">
              <div class="course-mini">
                <div class="cm-thumb">
                  <c:choose>
                    <c:when test="${not empty ec.course.thumbnailUrl}">
                      <img src="${ec.course.thumbnailUrl}" alt="${ec.course.title}">
                    </c:when>
                    <c:otherwise>🎓</c:otherwise>
                  </c:choose>
                </div>
                <div class="cm-info">
                  <h4>${ec.course.title}</h4>
                  <span>${ec.course.instructor.fullName}</span>
                  <div class="cm-bar"><span style="width:${ec.progressPercent != null ? ec.progressPercent : 0}%"></span></div>
                </div>
                <c:choose>
                  <c:when test="${ec.progressPercent >= 100}">
                    <span class="cm-pct done">✅ Done</span>
                  </c:when>
                  <c:otherwise>
                    <span class="cm-pct">${ec.progressPercent != null ? ec.progressPercent : 0}%</span>
                  </c:otherwise>
                </c:choose>
              </div>
              </c:if>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div class="empty-mini">
              <i>📚</i>
              <p style="margin-bottom:8px;">No courses enrolled yet.</p>
              <a href="${pageContext.request.contextPath}/courses">Browse Courses →</a>
            </div>
          </c:otherwise>
        </c:choose>
      </section>

    </main>
  </div>

  <script>
    const sidebar = document.getElementById('sidebar');
    const sidebarBtn = document.getElementById('sidebarBtn');
    const themeBtn = document.getElementById('themeBtn');

    sidebarBtn.addEventListener('click', () => {
      sidebar.classList.toggle('collapsed');
    });

    themeBtn.addEventListener('click', () => {
      const dark = document.body.getAttribute('data-theme') === 'dark';
      document.body.setAttribute('data-theme', dark ? '' : 'dark');
      themeBtn.textContent = dark ? '☾ Dark Mode' : '☀ Light Mode';
    });

    function togglePw(id, icon) {
      const input = document.getElementById(id);
      const isHidden = input.type === 'password';
      input.type = isHidden ? 'text' : 'password';
      icon.style.opacity = isHidden ? '1' : '.6';
    }

    function previewPhoto(input) {
      if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = e => {
          document.querySelectorAll('.ph-avatar, .ph-avatar-wrap > div').forEach(el => {
            if (el.tagName === 'IMG') {
              el.src = e.target.result;
            } else if (el.classList.contains('ph-avatar')) {
              const img = document.createElement('img');
              img.src = e.target.result;
              img.className = 'ph-avatar';
              el.replaceWith(img);
            }
          });
        };
        reader.readAsDataURL(input.files[0]);
      }
    }

    const alertBox = document.getElementById('successAlert');
    if (alertBox) setTimeout(() => alertBox.style.display = 'none', 4000);
  </script>
</body>
</html>
