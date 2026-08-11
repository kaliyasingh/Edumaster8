<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Payment Successful &ndash; EduMaster</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}

    body{
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height:100vh;
      font-family:'Poppins',sans-serif;
      display:flex;flex-direction:column;
      align-items:center;justify-content:center;
      padding:32px 16px;
      overflow:hidden;
    }

    .circle{
      position:fixed;
      border-radius:50%;
      background:linear-gradient(to right, rgba(255,255,255,0.35), rgba(255,255,255,0.08));
      z-index:0;
      animation:floatUp 6s ease-in-out infinite;
    }
    .circle-1{ top:5%;   left:10%; width:250px; height:250px; }
    .circle-2{ bottom:5%; right:10%; width:350px; height:350px; animation-delay:2s; }
    .circle-3{ top:50%;  left:5%;  width:150px; height:150px; animation-delay:4s; }
    @keyframes floatUp{
      0%,100%{ transform:translateY(0); }
      50%    { transform:translateY(-20px); }
    }

    .card{
      position:relative;z-index:1;
      background:#ffffff;
      border:1.5px solid #eaecf0;
      border-radius:24px;
      padding:48px 44px 40px;
      max-width:520px;width:100%;
      text-align:center;
      overflow:hidden;
      box-shadow:0px 10px 30px rgba(0,0,0,0.04);
    }

    .card::before{
      content:'';position:absolute;top:0;left:0;right:0;height:4px;
      background:linear-gradient(90deg,#6366f1,#8b5cf6,#a78bfa);
    }

    .brand{
      display:flex;align-items:center;justify-content:center;gap:8px;
      margin-bottom:24px;font-size:15px;font-weight:800;
      background:linear-gradient(135deg,#4f46e5,#7c3aed);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
    }
    .brand i{-webkit-text-fill-color:#7c3aed;font-size:18px;}

    .check-wrap{width:76px;height:76px;margin:0 auto 20px;}
    .check-ring{
      width:76px;height:76px;border-radius:50%;
      background:#ecfdf5;border:2px solid #6ee7b7;
      display:flex;align-items:center;justify-content:center;
      animation:pop 0.5s cubic-bezier(.34,1.56,.64,1) both;
    }
    @keyframes pop{from{transform:scale(0.3);opacity:0}to{transform:scale(1);opacity:1}}
    .check-icon{width:34px;height:34px;stroke:#059669;stroke-width:2.8;fill:none;stroke-linecap:round;stroke-linejoin:round;}
    .check-path{stroke-dasharray:40;stroke-dashoffset:40;animation:draw 0.4s ease 0.45s forwards;}
    @keyframes draw{to{stroke-dashoffset:0}}

    .badge{
      display:inline-flex;align-items:center;gap:7px;
      background:#059669;
      color:#ffffff;
      font-size:11px;font-weight:700;
      letter-spacing:0.07em;text-transform:uppercase;
      padding:6px 15px;border-radius:100px;margin-bottom:16px;
      box-shadow:0 3px 14px rgba(5,150,105,0.45);
    }
    .badge-dot{width:5px;height:5px;border-radius:50%;background:rgba(255,255,255,0.75);animation:blink 1.8s ease infinite;}
    @keyframes blink{0%,100%{opacity:1}50%{opacity:0.25}}

    .headline{font-size:27px;font-weight:800;color:#0f172a;line-height:1.25;letter-spacing:-0.02em;margin-bottom:9px;}
    .headline span{
      background:linear-gradient(135deg,#4f46e5 0%,#7c3aed 60%,#8b5cf6 100%);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
    }
    .subtext{font-size:13.5px;color:#64748b;line-height:1.6;margin-bottom:26px;}

    /* Student info row */
    .student-row{
      background:#fafbff;
      border:1.5px solid #e8eaf0;
      border-radius:16px;padding:14px 18px;
      display:flex;align-items:center;gap:14px;
      text-align:left;margin-bottom:14px;
      box-shadow:0 6px 20px rgba(0,0,0,0.05);
    }
    .avatar{
      width:44px;height:44px;border-radius:50%;
      background:linear-gradient(135deg,#4f46e5,#7c3aed);
      display:flex;align-items:center;justify-content:center;
      flex-shrink:0;font-size:18px;font-weight:800;color:#fff;
    }
    .student-meta{flex:1;min-width:0;text-align:left;}
    .student-name{font-size:14px;font-weight:800;color:#0f172a;}
    .student-email{font-size:12px;color:#64748b;margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}

    .course-row{
      background:#fafbff;
      border:1.5px solid #e8eaf0;
      border-radius:16px;padding:16px 18px;
      display:flex;align-items:center;gap:14px;
      text-align:left;margin-bottom:22px;
      box-shadow:0 6px 20px rgba(0,0,0,0.05), 0 1px 4px rgba(0,0,0,0.03);
      transition:box-shadow 0.2s,transform 0.2s;
    }
    .course-row:hover{
      box-shadow:0 10px 28px rgba(0,0,0,0.08), 0 2px 6px rgba(0,0,0,0.04);
      transform:translateY(-2px);
    }
    .course-icon{
      width:52px;height:52px;border-radius:12px;
      background:linear-gradient(135deg,#4f46e5,#7c3aed);
      display:flex;align-items:center;justify-content:center;
      flex-shrink:0;font-size:22px;
    }
    .course-meta{flex:1;min-width:0;}
    .course-eyebrow{font-size:10px;font-weight:700;color:#6d28d9;letter-spacing:0.07em;text-transform:uppercase;margin-bottom:3px;}
    .course-name{font-size:14px;font-weight:800;color:#0f172a;white-space:normal;word-break:break-word;line-height:1.4;}
    .course-instr{font-size:12px;color:#64748b;margin-top:2px;}
    .course-price{font-size:19px;font-weight:900;color:#d97706;flex-shrink:0;letter-spacing:-0.5px;}

    .divider{border:none;border-top:1.5px solid #f1f4fb;margin:0 0 20px;}

    .details{display:flex;flex-direction:column;gap:12px;margin-bottom:26px;text-align:left;}
    .detail-row{display:flex;align-items:center;justify-content:space-between;}
    .detail-label{font-size:12.5px;color:#64748b;display:flex;align-items:center;gap:7px;}
    .detail-label i{font-size:14px;}
    .detail-val{font-size:12.5px;font-weight:700;color:#1e293b;}
    .detail-val.ok{color:#047857;}

    .btn-group{display:flex;gap:10px;}
    .btn{
      flex:1;padding:13px 16px;border-radius:11px;
      font-size:13px;font-weight:700;font-family:'Poppins',sans-serif;
      cursor:pointer;border:none;
      transition:transform 0.15s,box-shadow 0.15s,opacity 0.15s;
      text-decoration:none;
      display:flex;align-items:center;justify-content:center;gap:8px;
    }
    .btn:hover{transform:translateY(-2px);opacity:0.92;}
    .btn-primary{
      background:linear-gradient(135deg,#4f46e5,#7c3aed);color:#fff;
      box-shadow:0 4px 18px rgba(79,70,229,0.35);
    }
    .btn-secondary{background:transparent;color:#64748b;border:1.5px solid #e0e4f8;}
    .btn-secondary:hover{color:#4f46e5;border-color:#a5b4fc;opacity:1;}

    .foot{margin-top:18px;font-size:11px;color:#94a3b8;display:flex;align-items:center;justify-content:center;gap:5px;}
    .foot i{font-size:12px;color:#94a3b8;}

    @media(max-width:480px){
      .card{padding:36px 22px 30px;}
      .headline{font-size:22px;}
      .btn-group{flex-direction:column;}
    }
  </style>
</head>
<body>

<div class="circle circle-1"></div>
<div class="circle circle-2"></div>
<div class="circle circle-3"></div>

<div class="card">

  <div class="brand">
    <i class="fas fa-graduation-cap"></i> EduMaster
  </div>

  <div class="check-wrap">
    <div class="check-ring">
      <svg class="check-icon" viewBox="0 0 24 24">
        <polyline class="check-path" points="4,13 9,18 20,7"/>
      </svg>
    </div>
  </div>

  <div class="badge"><span class="badge-dot"></span>Payment Confirmed</div>

  <h1 class="headline">You're in! <span>Start learning</span> today.</h1>
  <p class="subtext">Your course access is ready. Check your email for a receipt</p>



  <%-- Course Row --%>
  <div class="course-row">
    <div class="course-icon">&#127891;</div>
    <div class="course-meta">
      <div class="course-eyebrow">Enrolled Course</div>
      <div class="course-name"><c:out value="${courseName}"/></div>
      <div class="course-instr">by <c:out value="${instructorName}"/></div>
    </div>
    <div class="course-price">&#8377;<fmt:formatNumber value="${amountPaid}" type="number" maxFractionDigits="0"/></div>
  </div>

  <hr class="divider"/>

  <div class="details">
    <div class="detail-row">
      <span class="detail-label"><i class="fas fa-receipt"></i> Order ID</span>
      <span class="detail-val"><c:out value="${orderId}"/></span>
    </div>
    <div class="detail-row">
      <span class="detail-label"><i class="far fa-calendar"></i> Date</span>
      <span class="detail-val"><c:out value="${enrolledDate}"/></span>
    </div>
    <div class="detail-row">
      <span class="detail-label"><i class="fas fa-shield-alt"></i> Status</span>
      <span class="detail-val ok"><i class="fas fa-check-circle"></i>&nbsp; Verified</span>
    </div>
  </div>

  <div class="btn-group">
    <a href="/student/dashboard" class="btn btn-primary">
      <i class="fas fa-arrow-right"></i> Go to Dashboard
    </a>
    <a href="/" class="btn btn-secondary">Browse Courses</a>
  </div>

  <p class="foot">
    <i class="fas fa-lock"></i>
    Secured by Razorpay &nbsp;&middot;&nbsp; EduMaster
  </p>

</div>
</body>
</html>
