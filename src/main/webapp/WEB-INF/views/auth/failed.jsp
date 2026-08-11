<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Payment Failed &ndash; EduMaster</title>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
  <style>
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}

    body{
      background: linear-gradient(135deg, #f87171 0%, #dc2626 100%);
      min-height:100vh;
      font-family:'Poppins',sans-serif;
      display:flex;flex-direction:column;
      align-items:center;justify-content:center;
      padding:32px 16px;
      overflow:hidden;
    }

    .circle{
      position:fixed;border-radius:50%;
      background:linear-gradient(to right, rgba(255,255,255,0.25), rgba(255,255,255,0.06));
      z-index:0;animation:floatUp 6s ease-in-out infinite;
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
      box-shadow:0px 10px 30px rgba(0,0,0,0.08);
    }
    .card::before{
      content:'';position:absolute;top:0;left:0;right:0;height:4px;
      background:linear-gradient(90deg,#ef4444,#f97316,#fbbf24);
    }

    .brand{
      display:flex;align-items:center;justify-content:center;gap:8px;
      margin-bottom:24px;font-size:15px;font-weight:800;
      background:linear-gradient(135deg,#4f46e5,#7c3aed);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
    }
    .brand i{-webkit-text-fill-color:#7c3aed;font-size:18px;}

    /* X circle */
    .x-wrap{width:76px;height:76px;margin:0 auto 20px;}
    .x-ring{
      width:76px;height:76px;border-radius:50%;
      background:#fef2f2;border:2px solid #fca5a5;
      display:flex;align-items:center;justify-content:center;
      animation:pop 0.5s cubic-bezier(.34,1.56,.64,1) both;
    }
    @keyframes pop{from{transform:scale(0.3);opacity:0}to{transform:scale(1);opacity:1}}
    .x-icon{width:34px;height:34px;stroke:#dc2626;stroke-width:2.8;fill:none;stroke-linecap:round;stroke-linejoin:round;}
    .x-path{stroke-dasharray:50;stroke-dashoffset:50;animation:draw 0.4s ease 0.45s forwards;}
    @keyframes draw{to{stroke-dashoffset:0}}

    .badge{
      display:inline-flex;align-items:center;gap:7px;
      background:#dc2626;color:#ffffff;
      font-size:11px;font-weight:700;
      letter-spacing:0.07em;text-transform:uppercase;
      padding:6px 15px;border-radius:100px;margin-bottom:16px;
      box-shadow:0 3px 14px rgba(220,38,38,0.40);
    }
    .badge-dot{width:5px;height:5px;border-radius:50%;background:rgba(255,255,255,0.75);animation:blink 1.8s ease infinite;}
    @keyframes blink{0%,100%{opacity:1}50%{opacity:0.25}}

    .headline{font-size:27px;font-weight:800;color:#0f172a;line-height:1.25;letter-spacing:-0.02em;margin-bottom:9px;}
    .headline span{
      background:linear-gradient(135deg,#dc2626,#f97316);
      -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
    }
    .subtext{font-size:13.5px;color:#64748b;line-height:1.6;margin-bottom:26px;}

    /* Error reason box */
    .reason-box{
      background:#fef2f2;border:1.5px solid #fecaca;
      border-radius:14px;padding:14px 18px;
      display:flex;align-items:flex-start;gap:12px;
      text-align:left;margin-bottom:22px;
    }
    .reason-box i{color:#ef4444;font-size:16px;margin-top:2px;flex-shrink:0;}
    .reason-text{font-size:13px;color:#991b1b;font-weight:600;line-height:1.5;}
    .reason-sub{font-size:11.5px;color:#b91c1c;font-weight:500;margin-top:3px;}

    .divider{border:none;border-top:1.5px solid #f1f4fb;margin:0 0 20px;}

    .details{display:flex;flex-direction:column;gap:12px;margin-bottom:26px;text-align:left;}
    .detail-row{display:flex;align-items:center;justify-content:space-between;}
    .detail-label{font-size:12.5px;color:#64748b;display:flex;align-items:center;gap:7px;}
    .detail-label i{font-size:14px;}
    .detail-val{font-size:12.5px;font-weight:700;color:#1e293b;}
    .detail-val.fail{color:#dc2626;}

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
    .btn-retry{
      background:linear-gradient(135deg,#ef4444,#dc2626);color:#fff;
      box-shadow:0 4px 18px rgba(220,38,38,0.35);
    }
    .btn-home{background:transparent;color:#64748b;border:1.5px solid #e0e4f8;}
    .btn-home:hover{color:#4f46e5;border-color:#a5b4fc;opacity:1;}

    .help-text{
      margin-top:16px;font-size:11.5px;color:#94a3b8;
      display:flex;align-items:center;justify-content:center;gap:5px;flex-wrap:wrap;
    }
    .help-text a{color:#6366f1;font-weight:600;text-decoration:none;}
    .help-text a:hover{text-decoration:underline;}

    .foot{margin-top:10px;font-size:11px;color:#94a3b8;display:flex;align-items:center;justify-content:center;gap:5px;}
    .foot i{font-size:12px;}

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

  <div class="x-wrap">
    <div class="x-ring">
      <svg class="x-icon" viewBox="0 0 24 24">
        <line class="x-path" x1="6" y1="6" x2="18" y2="18"/>
        <line style="stroke-dasharray:50;stroke-dashoffset:50;animation:draw 0.4s ease 0.7s forwards;" x1="18" y1="6" x2="6" y2="18"/>
      </svg>
    </div>
  </div>

  <div class="badge"><span class="badge-dot"></span>Payment Failed</div>

  <h1 class="headline">Oops! <span>Payment unsuccessful.</span></h1>
  <p class="subtext">Don't worry — your money is safe. No amount has been deducted.</p>

  <%-- Error reason --%>
  <div class="reason-box">
    <i class="fas fa-exclamation-circle"></i>
    <div>
      <div class="reason-text">
        <c:choose>
          <c:when test="${not empty error}">${error}</c:when>
          <c:otherwise>Payment verification failed or was cancelled.</c:otherwise>
        </c:choose>
      </div>
      <div class="reason-sub">Please try again or use a different payment method.</div>
    </div>
  </div>

  <hr class="divider"/>

  <div class="details">
    <div class="detail-row">
      <span class="detail-label"><i class="far fa-calendar"></i> Date</span>
      <span class="detail-val">
        <%-- Current date --%>
        <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %>
      </span>
    </div>
    <div class="detail-row">
      <span class="detail-label"><i class="fas fa-shield-alt"></i> Status</span>
      <span class="detail-val fail"><i class="fas fa-times-circle"></i>&nbsp; Failed</span>
    </div>
    <div class="detail-row">
      <span class="detail-label"><i class="fas fa-wallet"></i> Amount Charged</span>
      <span class="detail-val" style="color:#059669;"><i class="fas fa-check-circle"></i>&nbsp; ₹0 (Safe)</span>
    </div>
  </div>

  <div class="btn-group">
    <a href="/" class="btn btn-retry">
      <i class="fas fa-redo"></i> Try Again
    </a>
    <a href="/" class="btn btn-home">Browse Courses</a>
  </div>

  <p class="help-text">
    Need help? <a href="mailto:support@edumaster.com">Contact Support</a>
    &nbsp;&middot;&nbsp; We'll resolve it within 24 hours.
  </p>

  <p class="foot">
    <i class="fas fa-lock"></i>
    Secured by Razorpay &nbsp;&middot;&nbsp; EduMaster
  </p>

</div>
</body>
</html>
