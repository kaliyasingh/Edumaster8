<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Instructor Management - EduMaster</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --primary: #6366f1; --primary-hover: #4f46e5;
      --bg-body: #0f172a; --bg-card: #1e293b; --bg-hover: #334155;
      --text-main: #f8fafc; --text-muted: #94a3b8; --border: #334155;
      --success-bg: #064e3b; --success-text: #6ee7b7;
      --warning-bg: #713f12; --warning-text: #fbbf24;
      --danger-bg: #7f1d1d;  --danger-text: #fca5a5;
      --currency-color: #6ee7b7;
    }
    * { margin:0; padding:0; box-sizing:border-box; font-family:'Inter',sans-serif; }
    body { background:var(--bg-body); color:var(--text-main); display:flex; min-height:100vh; }

    /* SIDEBAR */
    .sidebar { width:260px; background:#0f172a; color:#fff; padding:20px 0; position:fixed; height:100vh; overflow-y:auto; z-index:50; border-right:1px solid var(--border); }
    .logo { display:flex; align-items:center; gap:12px; padding:0 20px 30px; font-size:24px; font-weight:700; }
    .logo-icon { width:40px; height:40px; background:linear-gradient(135deg,#6366f1,#8b5cf6); border-radius:10px; display:flex; align-items:center; justify-content:center; font-size:20px; }
    .menu-section { margin-bottom:24px; }
    .menu-title { font-size:11px; text-transform:uppercase; color:#64748b; padding:0 20px 8px; font-weight:600; letter-spacing:.5px; }
    .menu-item { display:flex; align-items:center; gap:12px; padding:12px 20px; color:#94a3b8; transition:all .2s; border-left:3px solid transparent; text-decoration:none; }
    .menu-item:hover { background:var(--bg-hover); color:#fff; }
    .menu-item.active { background:#3b82f6; color:#fff; border-left-color:#fff; }
    .menu-icon { width:20px; text-align:center; }

    /* MAIN */
    .main { margin-left:260px; flex:1; display:flex; flex-direction:column; width:calc(100% - 260px); }
    .header { background:var(--bg-card); height:70px; padding:0 32px; border-bottom:1px solid var(--border); display:flex; justify-content:space-between; align-items:center; position:sticky; top:0; z-index:40; }
    .breadcrumb { display:flex; align-items:center; gap:8px; font-size:.9rem; color:var(--text-muted); }
    .breadcrumb a { color:var(--text-muted); text-decoration:none; }
    .breadcrumb a:hover { color:var(--primary); }
    .breadcrumb-sep { color:var(--border); }
    .breadcrumb-current { color:var(--text-main); font-weight:600; }
    .header-right { display:flex; align-items:center; gap:16px; }
    .admin-label { text-align:right; margin-right:12px; }
    .admin-label-title { font-size:.85rem; font-weight:600; }
    .admin-label-role  { font-size:.75rem; color:var(--text-muted); }
    .avatar-circle { width:40px; height:40px; border-radius:50%; background:var(--primary); color:white; display:flex; align-items:center; justify-content:center; font-weight:600; font-size:.9rem; cursor:pointer; }

    .content { padding:32px; }
    .page-heading-row { display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:24px; }
    .page-title h1 { font-size:1.75rem; font-weight:700; letter-spacing:-.025em; }
    .page-title p  { color:var(--text-muted); margin-top:4px; font-size:.95rem; }

    .btn { padding:10px 20px; border-radius:8px; font-weight:600; font-size:.9rem; cursor:pointer; border:1px solid transparent; display:inline-flex; align-items:center; gap:8px; transition:.2s; }
    .btn-outline { background:transparent; border-color:var(--border); color:var(--text-main); }
    .btn-outline:hover { background:var(--bg-hover); border-color:var(--primary); }
    .btn-danger  { background:#dc2626; color:white; }
    .btn-danger:hover  { background:#b91c1c; }
    .btn-success { background:#16a34a; color:white; }
    .btn-success:hover { background:#15803d; }

    /* STATS */
    .stats-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(240px,1fr)); gap:20px; margin-bottom:32px; }
    .stat-card { background:var(--bg-card); padding:24px; border-radius:12px; border:1px solid var(--border); box-shadow:0 4px 12px rgba(0,0,0,.2); transition:.3s; }
    .stat-card:hover { transform:translateY(-4px); box-shadow:0 8px 24px rgba(0,0,0,.3); }
    .stat-header { display:flex; justify-content:space-between; margin-bottom:12px; }
    .stat-icon { width:48px; height:48px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:1.3rem; }
    .stat-value { font-size:2.25rem; font-weight:700; line-height:1; margin-bottom:6px; }
    .stat-label { color:var(--text-muted); font-size:.85rem; font-weight:500; text-transform:uppercase; letter-spacing:.05em; }

    /* TABLE */
    .table-wrapper { background:var(--bg-card); border-radius:12px; border:1px solid var(--border); overflow:hidden; }
    .toolbar { padding:20px 24px; border-bottom:1px solid var(--border); display:flex; flex-wrap:wrap; gap:16px; justify-content:space-between; align-items:center; }
    .toolbar-left { display:flex; gap:12px; flex:1; max-width:500px; }
    .toolbar-right { display:flex; gap:12px; }
    .search-box { position:relative; flex:1; min-width:280px; }
    .search-box input { width:100%; padding:10px 12px 10px 40px; border:1px solid var(--border); border-radius:8px; font-size:.9rem; background:var(--bg-body); color:var(--text-main); }
    .search-box input:focus { border-color:var(--primary); outline:none; box-shadow:0 0 0 3px rgba(99,102,241,.2); }
    .search-box input::placeholder { color:var(--text-muted); }
    .search-box i { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--text-muted); }
    .filter-select { padding:10px 14px; border:1px solid var(--border); border-radius:8px; font-size:.9rem; color:var(--text-main); background:var(--bg-body); cursor:pointer; }
    .filter-select:focus { border-color:var(--primary); outline:none; }

    table { width:100%; border-collapse:collapse; }
    th { text-align:left; padding:16px 24px; background:var(--bg-body); font-size:.75rem; text-transform:uppercase; letter-spacing:.05em; color:var(--text-muted); font-weight:600; border-bottom:1px solid var(--border); }
    th input[type="checkbox"] { cursor:pointer; width:18px; height:18px; accent-color:var(--primary); }
    td { padding:18px 24px; border-bottom:1px solid var(--border); font-size:.9rem; vertical-align:middle; }
    tr:hover td { background:var(--bg-hover); }
    tr:last-child td { border-bottom:none; }

    .instructor-info-cell { display:flex; align-items:center; gap:14px; }
    .avatar-img { width:48px; height:48px; border-radius:50%; display:flex; align-items:center; justify-content:center; color:white; font-weight:600; font-size:1rem; flex-shrink:0; }
    .instructor-text h4 { font-size:.95rem; font-weight:600; margin:0; }
    .instructor-text span { font-size:.8rem; color:var(--text-muted); }
    .revenue-cell  { font-weight:600; color:var(--currency-color); }
    .revenue-zero  { color:var(--text-muted); font-style:italic; }

    .badge { padding:6px 12px; border-radius:20px; font-size:.75rem; font-weight:700; display:inline-block; text-transform:capitalize; }
    .badge.active    { background:var(--success-bg); color:var(--success-text); }
    .badge.pending   { background:var(--warning-bg); color:var(--warning-text); }
    .badge.rejected  { background:var(--danger-bg);  color:var(--danger-text);  }
    .badge.suspended { background:#1e3a5f; color:#60a5fa; border:1px solid #1d4ed8; }
    .action-btn.suspend:hover { border-color:#f59e0b; color:#f59e0b; background:rgba(245,158,11,.1); }

    .actions-cell { display:flex; gap:8px; justify-content:flex-end; }
    .action-btn { width:34px; height:34px; border-radius:8px; border:1px solid var(--border); background:var(--bg-body); color:var(--text-muted); display:flex; align-items:center; justify-content:center; cursor:pointer; transition:.2s; font-size:.9rem; }
    .action-btn:hover        { border-color:var(--primary); color:var(--primary); background:rgba(99,102,241,.1); transform:translateY(-2px); }
    .action-btn.view:hover   { border-color:#06b6d4; color:#06b6d4; background:rgba(6,182,212,.1); }
    .action-btn.delete:hover { border-color:#ef4444; color:#ef4444; background:rgba(239,68,68,.1); }

    .pagination { padding:16px 24px; display:flex; justify-content:space-between; align-items:center; border-top:1px solid var(--border); }
    .page-info { font-size:.85rem; color:var(--text-muted); }

    /* BULK BAR */
    .bulk-action-bar { position:fixed; bottom:30px; left:50%; transform:translateX(-50%) translateY(100px); background:linear-gradient(135deg,#1e293b,#334155); color:white; padding:14px 28px; border-radius:50px; box-shadow:0 12px 30px rgba(0,0,0,.5); display:flex; align-items:center; gap:24px; z-index:100; transition:.4s; opacity:0; pointer-events:none; border:1px solid var(--border); }
    .bulk-action-bar.visible { transform:translateX(-50%) translateY(0); opacity:1; pointer-events:all; }
    .bulk-count { font-weight:700; border-right:1px solid rgba(255,255,255,.2); padding-right:20px; margin-right:8px; }
    .bulk-btn { background:rgba(255,255,255,.1); border:1px solid rgba(255,255,255,.2); color:white; padding:8px 18px; border-radius:20px; font-size:.85rem; cursor:pointer; transition:.2s; display:flex; align-items:center; gap:6px; font-weight:600; }
    .bulk-btn:hover { background:rgba(255,255,255,.2); transform:translateY(-2px); }
    .bulk-btn.danger:hover { background:#ef4444; border-color:#ef4444; }

    /* VERIFICATION MODAL */
    .modal { display:none; position:fixed; inset:0; background:rgba(0,0,0,.85); align-items:center; justify-content:center; z-index:200; backdrop-filter:blur(12px); padding:20px; }
    .modal.active { display:flex; animation:fadeIn .3s ease; }
    @keyframes fadeIn { from{opacity:0} to{opacity:1} }
    .modal-content { background:var(--bg-card); border-radius:24px; border:1px solid var(--border); width:100%; max-width:920px; max-height:90vh; overflow-y:auto; box-shadow:0 30px 60px rgba(0,0,0,.9); animation:slideUp .4s ease; }
    @keyframes slideUp { from{transform:translateY(40px);opacity:0} to{transform:translateY(0);opacity:1} }
    .modal-content::-webkit-scrollbar { width:8px; }
    .modal-content::-webkit-scrollbar-track { background:var(--bg-body); }
    .modal-content::-webkit-scrollbar-thumb { background:var(--primary); border-radius:10px; }
    .modal-header { padding:24px 28px; display:flex; justify-content:space-between; align-items:center; background:linear-gradient(135deg,#667eea,#764ba2); color:white; border-radius:24px 24px 0 0; }
    .modal-header-content h2 { font-size:1.5rem; font-weight:800; margin-bottom:4px; }
    .modal-header-content p  { font-size:.9rem; opacity:.9; }
    .close-btn { width:40px; height:40px; border-radius:50%; background:rgba(255,255,255,.2); border:none; color:white; cursor:pointer; display:flex; align-items:center; justify-content:center; font-size:1.1rem; transition:.3s; }
    .close-btn:hover { background:rgba(255,255,255,.35); transform:rotate(90deg); }
    .modal-body { padding:24px; }
    .profile-card { background:linear-gradient(135deg,#1e293b,#334155); padding:20px; border-radius:16px; margin-bottom:20px; border:1px solid var(--border); display:flex; align-items:center; gap:20px; }
    .profile-avatar { width:72px; height:72px; border-radius:50%; display:flex; align-items:center; justify-content:center; color:white; font-weight:800; font-size:1.8rem; border:4px solid rgba(255,255,255,.1); flex-shrink:0; }
    .profile-info h3 { font-size:1.3rem; font-weight:800; margin-bottom:6px; }
    .profile-detail { font-size:.88rem; color:var(--text-muted); margin:4px 0; display:flex; align-items:center; gap:8px; }
    .profile-detail i { color:var(--primary); width:16px; }
    .info-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:16px; margin-bottom:20px; }
    .info-card { background:var(--bg-body); padding:18px; border-radius:14px; border:2px solid var(--border); transition:.3s; }
    .info-card:hover { border-color:var(--primary); box-shadow:0 8px 24px rgba(99,102,241,.2); transform:translateY(-3px); }
    .full-card { grid-column:1/-1; }
    .card-header { display:flex; align-items:center; gap:10px; margin-bottom:14px; }
    .card-icon { width:36px; height:36px; border-radius:10px; background:linear-gradient(135deg,#667eea,#764ba2); display:flex; align-items:center; justify-content:center; color:white; font-size:1rem; }
    .card-title { font-size:.72rem; text-transform:uppercase; color:var(--text-muted); font-weight:800; letter-spacing:.1em; }
    .card-content { font-size:.9rem; line-height:1.6; color:var(--text-main); }
    .info-list { display:flex; flex-direction:column; gap:10px; }
    .info-item { display:flex; align-items:flex-start; gap:10px; padding:12px; background:rgba(255,255,255,.03); border-radius:8px; border:1px solid rgba(255,255,255,.05); }
    .info-item i { color:var(--primary); width:18px; margin-top:2px; }
    .info-label { font-size:.68rem; text-transform:uppercase; color:var(--text-muted); font-weight:700; margin-bottom:3px; letter-spacing:.05em; }
    .info-value { font-size:.93rem; font-weight:600; color:var(--text-main); }
    .skill-tags { display:flex; flex-wrap:wrap; gap:10px; }
    .skill-tag  { padding:7px 14px; background:linear-gradient(135deg,#667eea,#764ba2); color:white; border-radius:20px; font-size:.8rem; font-weight:600; }
    .no-data-tag { padding:7px 14px; background:rgba(255,255,255,.04); color:var(--text-muted); border-radius:20px; font-size:.8rem; border:1px dashed var(--border); }
    .verify-item { display:flex; align-items:center; gap:14px; padding:14px 16px; border-radius:10px; margin-bottom:10px; }
    .verify-item:last-child { margin-bottom:0; }
    .verify-item.verified   { background:rgba(6,78,59,.7);   border:1px solid #16a34a; }
    .verify-item.unverified { background:rgba(127,29,29,.5); border:1px solid #dc2626; }
    .verify-icon { width:36px; height:36px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:1rem; flex-shrink:0; }
    .verify-item.verified   .verify-icon { background:#16a34a; color:white; }
    .verify-item.unverified .verify-icon { background:#dc2626; color:white; }
    .verify-title { font-size:.9rem; font-weight:700; color:var(--text-main); }
    .verify-sub   { font-size:.8rem; color:var(--text-muted); margin-top:2px; }
    .cert-list { display:flex; flex-wrap:wrap; gap:10px; }
    .cert-item { padding:10px 14px; background:rgba(99,102,241,.1); border:1px solid var(--primary); border-radius:8px; font-size:.82rem; font-weight:600; display:flex; align-items:center; gap:8px; }
    .cert-item i { color:var(--primary); }
    .rejection-section { margin-top:20px; padding:20px; background:var(--danger-bg); border-radius:14px; border:2px solid #ef4444; display:none; }
    .rejection-section.active { display:block; animation:slideDown .3s ease; }
    @keyframes slideDown { from{opacity:0;transform:translateY(-10px)} to{opacity:1;transform:translateY(0)} }
    .rejection-section label { display:block; margin-bottom:10px; font-weight:700; color:var(--danger-text); }
    .rejection-section textarea { width:100%; padding:12px; border-radius:10px; border:2px solid #fca5a5; font-size:.9rem; resize:vertical; min-height:90px; font-family:'Inter',sans-serif; background:var(--bg-body); color:var(--text-main); }
    .rejection-section textarea:focus { border-color:#ef4444; outline:none; }
    .modal-footer { padding:20px 24px; border-top:1px solid var(--border); display:flex; justify-content:flex-end; gap:10px; background:var(--bg-body); border-radius:0 0 24px 24px; }

    /* ========================
       SIDE PANEL (VIEW DETAILS)
       ======================== */
    .side-panel-overlay {
      position:fixed; inset:0; background:rgba(0,0,0,.6); z-index:150;
      opacity:0; visibility:hidden; transition:.3s; backdrop-filter:blur(6px);
    }
    .side-panel-overlay.open { opacity:1; visibility:visible; }

    .side-panel {
      position:fixed; top:0; right:0; height:100vh; width:480px;
      background:var(--bg-card); z-index:151;
      box-shadow:-12px 0 50px rgba(0,0,0,.6);
      transform:translateX(100%); transition:.4s cubic-bezier(.4,0,.2,1);
      display:flex; flex-direction:column; border-left:1px solid var(--border);
    }
    .side-panel.open { transform:translateX(0); }

    .panel-header {
      padding:18px 20px; border-bottom:1px solid var(--border);
      display:flex; justify-content:space-between; align-items:center;
      background:var(--bg-body); flex-shrink:0;
    }
    .panel-header h2 { font-size:1rem; font-weight:700; color:var(--text-main); }

    .panel-body { flex:1; overflow-y:auto; }
    .panel-body::-webkit-scrollbar { width:6px; }
    .panel-body::-webkit-scrollbar-thumb { background:var(--primary); border-radius:10px; }

    /* Panel hero */
    .panel-hero {
      padding:32px 24px 24px;
      background:linear-gradient(160deg,#312e81 0%,#1e1b4b 50%,#0f172a 100%);
      text-align:center; position:relative; overflow:hidden;
    }
    .panel-hero::before {
      content:''; position:absolute; inset:0;
      background:url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%236366f1' fill-opacity='0.08'%3E%3Ccircle cx='30' cy='30' r='4'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
      opacity:.5;
    }
    .panel-avatar-large {
      width:90px; height:90px; border-radius:50%;
      display:flex; align-items:center; justify-content:center;
      font-size:2.2rem; font-weight:800; margin:0 auto 16px;
      box-shadow:0 16px 40px rgba(0,0,0,.5);
      border:4px solid rgba(255,255,255,.15);
      position:relative; z-index:1;
    }
    .panel-name  { font-size:1.4rem; font-weight:800; color:#fff; margin-bottom:4px; position:relative; z-index:1; }
    .panel-email { color:rgba(255,255,255,.7); font-size:.85rem; margin-bottom:14px; position:relative; z-index:1; }
    .panel-badges { display:flex; gap:8px; justify-content:center; position:relative; z-index:1; }

    /* Tabs */
    .tab-nav {
      display:flex; border-bottom:1px solid var(--border);
      background:var(--bg-card); padding:0 20px; flex-shrink:0;
    }
    .tab-btn {
      padding:13px 16px; border:none; background:none; color:var(--text-muted);
      font-weight:500; cursor:pointer; position:relative; transition:.2s; font-size:.85rem;
    }
    .tab-btn:hover { color:var(--text-main); }
    .tab-btn.active { color:var(--primary); font-weight:700; }
    .tab-btn.active::after {
      content:''; position:absolute; bottom:0; left:0; right:0;
      height:3px; background:var(--primary); border-radius:3px 3px 0 0;
    }
    .tab-pane { display:none; padding:24px; }
    .tab-pane.active { display:block; }

    /* Panel grid */
    .panel-stat-grid { display:grid; grid-template-columns:repeat(2,1fr); gap:12px; margin-bottom:24px; }
    .panel-stat-card {
      background:var(--bg-body); padding:16px; border-radius:12px;
      border:1px solid var(--border); transition:.2s;
    }
    .panel-stat-card:hover { border-color:var(--primary); }
    .panel-stat-label { font-size:.65rem; text-transform:uppercase; color:var(--text-muted); font-weight:700; margin-bottom:6px; letter-spacing:.05em; }
    .panel-stat-value { font-size:1.6rem; font-weight:800; color:var(--text-main); line-height:1; }

    .panel-section-title { font-size:.7rem; text-transform:uppercase; color:var(--text-muted); font-weight:700; margin-bottom:12px; letter-spacing:.08em; display:flex; align-items:center; gap:8px; }
    .panel-section-title::after { content:''; flex:1; height:1px; background:var(--border); }

    .panel-bio {
      padding:16px; font-size:.88rem; line-height:1.7; color:var(--text-muted);
      background:var(--bg-body); border-radius:10px; border:1px solid var(--border);
      margin-bottom:24px;
    }

    .panel-skill-tags { display:flex; flex-wrap:wrap; gap:8px; }
    .panel-skill-tag {
      padding:6px 12px; background:rgba(99,102,241,.15); color:#818cf8;
      border-radius:20px; font-size:.75rem; font-weight:600;
      border:1px solid rgba(99,102,241,.3);
    }

    /* Panel info rows */
    .panel-info-row {
      display:flex; align-items:center; gap:14px; padding:14px;
      background:var(--bg-body); border-radius:10px; border:1px solid var(--border);
      margin-bottom:10px;
    }
    .panel-info-row i { color:var(--primary); width:18px; text-align:center; flex-shrink:0; }
    .panel-info-row-label { font-size:.68rem; text-transform:uppercase; color:var(--text-muted); font-weight:700; margin-bottom:2px; letter-spacing:.05em; }
    .panel-info-row-value { font-size:.92rem; font-weight:600; color:var(--text-main); }

    /* Panel loading skeleton */
    .panel-skeleton { padding:24px; }
    .skel { background:linear-gradient(90deg,var(--bg-hover) 25%,var(--bg-card) 50%,var(--bg-hover) 75%); background-size:200% 100%; animation:shimmer 1.5s infinite; border-radius:8px; }
    @keyframes shimmer { 0%{background-position:200% 0} 100%{background-position:-200% 0} }
    .skel-circle { width:90px; height:90px; border-radius:50%; margin:0 auto 16px; }
    .skel-line   { height:14px; margin-bottom:10px; }
    .skel-sm { width:60%; }
    .skel-md { width:80%; }
    .skel-lg { width:100%; }

    /* Loading */
    .loading-overlay { display:none; position:fixed; inset:0; background:rgba(0,0,0,.8); z-index:300; align-items:center; justify-content:center; }
    .loading-overlay.active { display:flex; }
    .spinner { width:50px; height:50px; border:4px solid rgba(255,255,255,.2); border-top-color:var(--primary); border-radius:50%; animation:spin .8s linear infinite; }
    @keyframes spin { to{transform:rotate(360deg)} }

    .empty-state { text-align:center; padding:60px 20px; color:var(--text-muted); }
    .empty-state i { font-size:4rem; opacity:.3; margin-bottom:16px; display:block; }
    .empty-state h3 { font-size:1.2rem; margin-bottom:8px; color:var(--text-main); }

    @media(max-width:768px) {
      .sidebar { position:static; width:100%; height:auto; }
      .main { margin-left:0; width:100%; }
      .content { padding:16px; }
      .info-grid { grid-template-columns:1fr; }
      .side-panel { width:100%; }
      .modal-footer { flex-direction:column; }
      .btn { width:100%; justify-content:center; }
    }
  </style>
</head>
<body>

  <c:set var="contextPath" value="${pageContext.request.contextPath}" />

  <aside class="sidebar">
    <div class="logo">
      <div class="logo-icon">&#127891;</div>
      <span>EduMaster</span>
    </div>
    <div class="menu-section">
      <div class="menu-title">Main</div>
      <a href="${contextPath}/admin/dashboard" class="menu-item">
        <span class="menu-icon"><i class="fas fa-chart-line"></i></span><span>Dashboard</span>
      </a>
    </div>
    <div class="menu-section">
      <div class="menu-title">Management</div>
      <a href="${contextPath}/admin/instructors" class="menu-item active">
        <span class="menu-icon"><i class="fas fa-chalkboard-teacher"></i></span><span>Instructors</span>
      </a>
    </div>
    <div class="menu-section">
      <div class="menu-title">Finance</div>
      <a href="${contextPath}/admin/transactions" class="menu-item">
        <span class="menu-icon"><i class="fas fa-credit-card"></i></span><span>Transactions</span>
      </a>
      <a href="${contextPath}/admin/payouts" class="menu-item">
        <span class="menu-icon"><i class="fas fa-hand-holding-usd"></i></span><span>Payouts</span>
      </a>
    </div>
    <div class="menu-section">
      <div class="menu-title">System</div>
      <a href="${contextPath}/admin/settings" class="menu-item">
        <span class="menu-icon"><i class="fas fa-cog"></i></span><span>Settings</span>
      </a>
    </div>
  </aside>

  <main class="main">
    <header class="header">
      <div class="breadcrumb">
        <a href="${contextPath}/admin/dashboard"><i class="fas fa-home"></i></a>
        <span class="breadcrumb-sep">/</span>
        <span class="breadcrumb-current">Instructor Management</span>
      </div>
      <div class="header-right">
        <div class="admin-label">
          <div class="admin-label-title">${user.fullName}</div>
          <div class="admin-label-role">Admin</div>
        </div>
        <div class="avatar-circle">
          <c:choose>
            <c:when test="${not empty user.fullName}">${fn:substring(user.fullName,0,1)}</c:when>
            <c:otherwise>AD</c:otherwise>
          </c:choose>
        </div>
      </div>
    </header>

    <div class="content">
      <div class="page-heading-row">
        <div class="page-title">
          <h1>Instructor Management</h1>
          <p>Monitor and manage instructor profiles, verification, and performance metrics.</p>
        </div>
        <button class="btn btn-outline" onclick="exportData()">
          <i class="fas fa-download"></i> Export
        </button>
      </div>

      <!-- Stats -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background:rgba(99,102,241,.2);color:#818cf8;"><i class="fas fa-graduation-cap"></i></div>
          </div>
          <div class="stat-value">${totalInstructors}</div>
          <div class="stat-label">Total Instructors</div>
        </div>
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background:rgba(110,231,183,.2);color:#6ee7b7;"><i class="fas fa-check-circle"></i></div>
          </div>
          <div class="stat-value">${activeInstructors} / ${pendingInstructors}</div>
          <div class="stat-label">Active &bull; Pending</div>
        </div>
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background:rgba(251,191,36,.2);color:#fbbf24;"><i class="fas fa-clock"></i></div>
          </div>
          <div class="stat-value">${pendingInstructors}</div>
          <div class="stat-label">Pending Approval</div>
        </div>
        <div class="stat-card">
          <div class="stat-header">
            <div class="stat-icon" style="background:rgba(110,231,183,.2);color:#6ee7b7;"><i class="fas fa-dollar-sign"></i></div>
          </div>
          <div class="stat-value">$<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="0" groupingUsed="true"/></div>
          <div class="stat-label">Total Revenue</div>
        </div>
      </div>

      <!-- Table -->
      <div class="table-wrapper">
        <div class="toolbar">
          <div class="toolbar-left">
            <div class="search-box">
              <i class="fas fa-search"></i>
              <input type="text" id="searchInput" placeholder="Search by name, email, or specialization..." onkeyup="applyFilters()">
            </div>
          </div>
          <div class="toolbar-right">
            <select class="filter-select" id="specFilter" onchange="applyFilters()">
              <option value="">All Specializations</option>
              <option value="Development">Development</option>
              <option value="Design">Design</option>
              <option value="Marketing">Marketing</option>
              <option value="Data Science">Data Science</option>
              <option value="Business">Business</option>
            </select>
            <select class="filter-select" id="statusFilter" onchange="applyFilters()">
              <option value="">All Status</option>
              <option value="active">Active</option>
              <option value="pending">Pending</option>
              <option value="rejected">Rejected</option>
              <option value="suspended">Suspended</option>
            </select>
          </div>
        </div>

        <table>
          <thead>
            <tr>
              <th><input type="checkbox" id="selectAll" onchange="toggleSelectAll()"></th>
              <th>Instructor</th>
              <th>Specialization</th>
              <th>Students</th>
              <th>Courses</th>
              <th>Revenue</th>
              <th>Status</th>
              <th style="text-align:right;">Actions</th>
            </tr>
          </thead>
          <tbody id="instructorTable">
            <c:choose>
              <c:when test="${empty allInstructors}">
                <tr><td colspan="8">
                  <div class="empty-state">
                    <i class="fas fa-users-slash"></i>
                    <h3>No Instructors Found</h3>
                    <p>No instructor records available.</p>
                  </div>
                </td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="inst" items="${allInstructors}">
                  <%-- Avatar color --%>
                  <c:set var="ci" value="${inst.id % 8}" />
                  <c:choose>
                    <c:when test="${ci==0}"><c:set var="ac" value="#e91e63"/></c:when>
                    <c:when test="${ci==1}"><c:set var="ac" value="#3f51b5"/></c:when>
                    <c:when test="${ci==2}"><c:set var="ac" value="#ff9800"/></c:when>
                    <c:when test="${ci==3}"><c:set var="ac" value="#4caf50"/></c:when>
                    <c:when test="${ci==4}"><c:set var="ac" value="#9c27b0"/></c:when>
                    <c:when test="${ci==5}"><c:set var="ac" value="#00bcd4"/></c:when>
                    <c:when test="${ci==6}"><c:set var="ac" value="#f44336"/></c:when>
                    <c:otherwise><c:set var="ac" value="#795548"/></c:otherwise>
                  </c:choose>

                  <%--
                    STATUS LOGIC — matches backend exactly:
                    - pending   : not verified AND not rejected
                    - active    : instructorVerified=true AND rejectedAt=null
                    - suspended : rejectedAt!=null AND rejectionReason starts with "Suspended"
                    - rejected  : rejectedAt!=null AND any other reason
                  --%>
                  <c:set var="rs" value="pending"/>
                  <c:if test="${inst.instructorVerified == true and inst.rejectedAt == null}">
                    <c:set var="rs" value="active"/>
                  </c:if>
                  <c:if test="${inst.rejectedAt != null}">
                    <c:choose>
                      <c:when test="${not empty inst.rejectionReason and fn:startsWith(inst.rejectionReason, 'Suspended')}">
                        <c:set var="rs" value="suspended"/>
                      </c:when>
                      <c:otherwise>
                        <c:set var="rs" value="rejected"/>
                      </c:otherwise>
                    </c:choose>
                  </c:if>

                  <%-- Initial --%>
                  <c:set var="displayInitial" value="?"/>
                  <c:if test="${not empty inst.fullName}"><c:set var="displayInitial" value="${fn:substring(inst.fullName,0,1)}"/></c:if>

                  <%-- Revenue --%>
                  <c:set var="revenueVal" value="0"/>
                  <c:if test="${not empty inst.totalRevenue}"><c:set var="revenueVal" value="${inst.totalRevenue}"/></c:if>

                  <tr data-id="${inst.id}"
                      data-name="${inst.fullName}"
                      data-email="${inst.email}"
                      data-spec="${inst.specialization}"
                      data-status="${rs}">

                    <td><input type="checkbox" class="row-checkbox" data-id="${inst.id}" onchange="toggleSelect(${inst.id})"></td>

                    <td>
                      <div class="instructor-info-cell">
                        <div class="avatar-img" style="background:${ac};">${displayInitial}</div>
                        <div class="instructor-text">
                          <h4><c:out value="${inst.fullName}" default="Unknown"/></h4>
                          <span><c:out value="${inst.email}" default="-"/></span>
                        </div>
                      </div>
                    </td>

                    <td><c:out value="${empty inst.specialization ? 'N/A' : inst.specialization}"/></td>
                    <td><fmt:formatNumber value="${empty inst.totalStudents ? 0 : inst.totalStudents}" groupingUsed="true"/></td>
                    <td>${empty inst.totalCourses ? 0 : inst.totalCourses}</td>

                    <td>
                      <c:choose>
                        <c:when test="${revenueVal > 0}">
                          <span class="revenue-cell">$<fmt:formatNumber value="${revenueVal}" maxFractionDigits="0" groupingUsed="true"/></span>
                        </c:when>
                        <c:otherwise><span class="revenue-zero">$0</span></c:otherwise>
                      </c:choose>
                    </td>

                    <td><span class="badge ${rs}">${rs}</span></td>

                    <td>
                      <div class="actions-cell">
                        <c:if test="${rs == 'pending'}">
                          <button class="action-btn" onclick="openVerification(${inst.id})" title="Verify Instructor">
                            <i class="fas fa-shield-alt"></i>
                          </button>
                        </c:if>
                        <button class="action-btn view" onclick="openPanel(${inst.id})" title="View Details">
                          <i class="fas fa-eye"></i>
                        </button>
                        <button class="action-btn delete" onclick="deleteInstructor(${inst.id})" title="Delete">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>

        <div class="pagination">
          <div class="page-info" id="pageInfo">
            Showing ${not empty allInstructors ? allInstructors.size() : 0} instructor(s)
          </div>
        </div>
      </div>
    </div>
  </main>

  <!-- BULK BAR -->
  <div class="bulk-action-bar" id="bulkBar">
    <div class="bulk-count"><span id="selectedCount">0</span> selected</div>
    <button class="bulk-btn" onclick="bulkApprove()"><i class="fas fa-check"></i> Approve</button>
    <button class="bulk-btn" onclick="bulkSuspend()" style="border-color:rgba(245,158,11,.4);"><i class="fas fa-ban"></i> Suspend</button>
    <button class="bulk-btn danger" onclick="bulkDelete()"><i class="fas fa-trash"></i> Delete</button>
  </div>

  <!-- VERIFICATION MODAL -->
  <div class="modal" id="verificationModal">
    <div class="modal-content">
      <div class="modal-header">
        <div class="modal-header-content">
          <h2>Instructor Verification</h2>
          <p>Review details before making an approval decision</p>
        </div>
        <button class="close-btn" onclick="closeVerification()"><i class="fas fa-times"></i></button>
      </div>
      <div class="modal-body">
        <div class="profile-card">
          <div class="profile-avatar" id="modalAvatar">?</div>
          <div class="profile-info">
            <h3 id="modalName">Loading...</h3>
            <div class="profile-detail"><i class="fas fa-envelope"></i><span id="modalEmail">-</span></div>
            <div class="profile-detail"><i class="fas fa-phone"></i><span id="modalPhone">-</span></div>
            <div class="profile-detail"><i class="fas fa-briefcase"></i><span id="modalExperience">-</span></div>
            <div style="margin-top:8px;"><span class="badge pending" id="modalStatus">Pending Approval</span></div>
          </div>
        </div>
        <div class="info-grid">
          <div class="info-card">
            <div class="card-header"><div class="card-icon"><i class="fas fa-user-circle"></i></div><div class="card-title">Professional Bio</div></div>
            <div class="card-content" id="modalBio">-</div>
          </div>
          <div class="info-card">
            <div class="card-header"><div class="card-icon"><i class="fas fa-graduation-cap"></i></div><div class="card-title">Education</div></div>
            <div class="info-list">
              <div class="info-item"><i class="fas fa-certificate"></i><div><div class="info-label">Degree</div><div class="info-value" id="modalDegree">-</div></div></div>
              <div class="info-item"><i class="fas fa-university"></i><div><div class="info-label">University</div><div class="info-value" id="modalUniversity">-</div></div></div>
            </div>
          </div>
          <div class="info-card">
            <div class="card-header"><div class="card-icon"><i class="fas fa-lightbulb"></i></div><div class="card-title">Key Skills</div></div>
            <div class="skill-tags" id="modalSkills"></div>
          </div>
          <div class="info-card">
            <div class="card-header"><div class="card-icon"><i class="fas fa-shield-alt"></i></div><div class="card-title">Verification Status</div></div>
            <div id="modalVerification"></div>
          </div>
          <div class="info-card full-card">
            <div class="card-header"><div class="card-icon"><i class="fas fa-award"></i></div><div class="card-title">Certifications &amp; Credentials</div></div>
            <div class="cert-list" id="modalCertifications"></div>
          </div>
        </div>
        <div class="rejection-section" id="rejectionSection">
          <label><i class="fas fa-exclamation-triangle"></i> Rejection Reason (Required)</label>
          <textarea id="rejectionReason" placeholder="Provide a clear reason. This will be emailed to the applicant..."></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-outline" onclick="closeVerification()"><i class="fas fa-times"></i> Cancel</button>
        <button class="btn btn-danger"  onclick="toggleRejection()"><i class="fas fa-times-circle"></i> <span id="rejectBtnText">Reject</span></button>
        <button class="btn btn-success" onclick="approveInstructor()"><i class="fas fa-check-circle"></i> Approve</button>
      </div>
    </div>
  </div>

  <!-- SIDE PANEL -->
  <div class="side-panel-overlay" id="panelOverlay" onclick="closePanel()"></div>
  <div class="side-panel" id="sidePanel">
    <div class="panel-header">
      <h2><i class="fas fa-user-circle" style="color:var(--primary);margin-right:8px;"></i>Instructor Details</h2>
      <button class="action-btn" onclick="closePanel()" title="Close"><i class="fas fa-times"></i></button>
    </div>
    <div class="panel-body" id="panelBody">
      <!-- filled dynamically -->
    </div>
  </div>

  <!-- Loading -->
  <div class="loading-overlay" id="loadingOverlay"><div class="spinner"></div></div>

  <script>
    var contextPath       = '${contextPath}';
    var AVATAR_COLORS     = ['#e91e63','#3f51b5','#ff9800','#4caf50','#9c27b0','#00bcd4','#f44336','#795548'];
    var selectedIds       = new Set();
    var currentInstructor = null;
    var panelActiveTab    = 0;

    /* ===== FILTER ===== */
    function applyFilters() {
      var search = document.getElementById('searchInput').value.toLowerCase().trim();
      var spec   = document.getElementById('specFilter').value.toLowerCase();
      var status = document.getElementById('statusFilter').value.toLowerCase();
      var count  = 0;
      document.querySelectorAll('#instructorTable tr[data-id]').forEach(function(row) {
        var ok =
          (!search || row.dataset.name.toLowerCase().indexOf(search)  > -1 ||
                      row.dataset.email.toLowerCase().indexOf(search) > -1 ||
                      (row.dataset.spec||'').toLowerCase().indexOf(search) > -1) &&
          (!spec   || (row.dataset.spec||'').toLowerCase() === spec) &&
          (!status || row.dataset.status === status);
        row.style.display = ok ? '' : 'none';
        if (ok) count++;
      });
      document.getElementById('pageInfo').textContent = 'Showing ' + count + ' instructor(s)';
    }

    /* ===== SELECTION ===== */
    function toggleSelect(id) {
      if (selectedIds.has(id)) { selectedIds.delete(id); } else { selectedIds.add(id); }
      updateBulkBar();
    }
    function toggleSelectAll() {
      var chk = document.getElementById('selectAll').checked;
      document.querySelectorAll('.row-checkbox').forEach(function(cb) {
        var id = parseInt(cb.dataset.id);
        cb.checked = chk;
        if (chk) { selectedIds.add(id); } else { selectedIds.delete(id); }
      });
      updateBulkBar();
    }
    function updateBulkBar() {
      document.getElementById('selectedCount').textContent = selectedIds.size;
      document.getElementById('bulkBar').classList.toggle('visible', selectedIds.size > 0);
    }

    /* ===== BULK ===== */
    function bulkApprove() {
      if (!selectedIds.size || !confirm('Approve ' + selectedIds.size + ' instructor(s)?')) return;
      showLoading(true);
      fetch(contextPath + '/admin/api/instructors/bulk-approve', {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify({instructorIds: Array.from(selectedIds)})
      }).then(function(r){ return r.json(); }).then(function(d) {
        showLoading(false);
        if (d.success) { alert('\u2713 ' + d.message); selectedIds.clear(); location.reload(); }
        else { alert('\u2717 ' + (d.error || 'Failed')); }
      }).catch(function(){ showLoading(false); alert('\u2717 Network error'); });
    }
    function bulkSuspend() {
      if (!selectedIds.size || !confirm('Suspend ' + selectedIds.size + ' instructor(s)?\n\nThis will temporarily disable their account and courses.')) return;
      showLoading(true);
      fetch(contextPath + '/admin/api/instructors/bulk-suspend', {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify({instructorIds: Array.from(selectedIds)})
      }).then(function(r){ return r.json(); }).then(function(d) {
        showLoading(false);
        if (d.success) { alert('\u2713 ' + d.message); selectedIds.clear(); location.reload(); }
        else { alert('\u2717 ' + (d.error || 'Failed')); }
      }).catch(function(){ showLoading(false); alert('\u2717 Network error'); });
    }
    function bulkDelete() {
      if (!selectedIds.size || !confirm('Delete ' + selectedIds.size + ' instructor(s)? Cannot be undone.')) return;
      showLoading(true);
      fetch(contextPath + '/admin/api/instructors/bulk-delete', {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify({instructorIds: Array.from(selectedIds)})
      }).then(function(r){ return r.json(); }).then(function(d) {
        showLoading(false);
        if (d.success) { alert('\u2713 ' + d.message); selectedIds.clear(); location.reload(); }
        else { alert('\u2717 ' + (d.error || 'Failed')); }
      }).catch(function(){ showLoading(false); alert('\u2717 Network error'); });
    }

    /* ===========================================
       SIDE PANEL — openPanel fetches from API
       =========================================== */
    function openPanel(id) {
      var panelBody = document.getElementById('panelBody');

      /* Show skeleton while loading */
      panelBody.innerHTML =
        '<div class="panel-skeleton">' +
          '<div class="skel skel-circle" style="margin:24px auto 16px;"></div>' +
          '<div class="skel skel-line skel-sm" style="margin:0 auto 10px;width:40%;"></div>' +
          '<div class="skel skel-line skel-md" style="margin:0 auto 24px;width:60%;"></div>' +
          '<div class="skel skel-line skel-lg" style="margin-bottom:12px;"></div>' +
          '<div class="skel skel-line skel-lg" style="margin-bottom:12px;"></div>' +
          '<div class="skel skel-line skel-md"></div>' +
        '</div>';

      document.getElementById('sidePanel').classList.add('open');
      document.getElementById('panelOverlay').classList.add('open');
      document.body.style.overflow = 'hidden';

      fetch(contextPath + '/admin/api/instructors/' + id)
        .then(function(r) { return r.json(); })
        .then(function(ins) { renderPanel(ins); })
        .catch(function() {
          panelBody.innerHTML =
            '<div class="empty-state">' +
              '<i class="fas fa-exclamation-circle"></i>' +
              '<h3>Failed to Load</h3>' +
              '<p>Could not fetch instructor data. Try again.</p>' +
            '</div>';
        });
    }

    function renderPanel(ins) {
      var color    = AVATAR_COLORS[ins.id % 8];
      var name     = ins.fullName || 'Unknown';
      var email    = ins.email    || '—';
      var spec     = ins.specialization || 'N/A';
      // Match same logic as JSTL: suspended = rejectedAt + reason starts with "Suspended"
      var status   = 'pending';
      if (ins.instructorVerified && !ins.rejectedAt) { status = 'active'; }
      if (ins.rejectedAt) {
        status = (ins.rejectionReason && ins.rejectionReason.indexOf('Suspended') === 0)
                 ? 'suspended' : 'rejected';
      }
      var students = ins.totalStudents || 0;
      var courses  = ins.totalCourses  || 0;
      var revenue  = ins.totalRevenue  || 0;
      var bio      = ins.bio || 'No bio provided.';
      var exp      = ins.experience || '';

      var nameParts = name.split(' ');
      var initials  = nameParts.map(function(n){ return n[0]; }).join('').toUpperCase().substring(0,2);
      var revStr    = revenue > 0 ? '$' + Number(revenue).toLocaleString() : '$0';

      /* Skills tags */
      var skillSrc = ins.skills || ins.specialization || '';
      var skillsHtml = '';
      if (skillSrc.trim()) {
        skillSrc.split(',').forEach(function(s) {
          s = s.trim();
          if (s) skillsHtml += '<span class="panel-skill-tag">' + escHtml(s) + '</span>';
        });
      } else {
        skillsHtml = '<span style="color:var(--text-muted);font-size:.85rem;">No skills listed</span>';
      }

      /* Certifications */
      var certsHtml = '';
      if (ins.certifications && ins.certifications.trim()) {
        ins.certifications.split(',').forEach(function(c) {
          c = c.trim();
          if (c) certsHtml += '<span class="panel-skill-tag"><i class="fas fa-award" style="margin-right:6px;color:#fbbf24;"></i>' + escHtml(c) + '</span>';
        });
      } else {
        certsHtml = '<span style="color:var(--text-muted);font-size:.85rem;">No certifications listed</span>';
      }

      /* Verification rows */
      var emailOk = ins.emailVerified === true;
      var phoneOk = !!(ins.phone && ins.phone.trim());

      document.getElementById('panelBody').innerHTML =

        /* Hero */
        '<div class="panel-hero">' +
          '<div class="panel-avatar-large" style="background:' + color + ';color:white;">' + initials + '</div>' +
          '<div class="panel-name">'  + escHtml(name)  + '</div>' +
          '<div class="panel-email">' + escHtml(email) + '</div>' +
          (exp ? '<div style="font-size:.8rem;color:rgba(255,255,255,.65);margin-bottom:10px;">' + escHtml(exp) + '</div>' : '') +
          '<div class="panel-badges"><span class="badge ' + status + '">' + status + '</span></div>' +
        '</div>' +

        /* Tabs */
        '<div class="tab-nav" id="panelTabs">' +
          '<button class="tab-btn active" onclick="switchTab(0)">Overview</button>' +
          '<button class="tab-btn" onclick="switchTab(1)">Education</button>' +
          '<button class="tab-btn" onclick="switchTab(2)">Verification</button>' +
        '</div>' +

        /* Tab 0 — Overview */
        '<div class="tab-pane active" id="panelTab0">' +
          '<div class="panel-stat-grid">' +
            '<div class="panel-stat-card"><div class="panel-stat-label">Students</div><div class="panel-stat-value">' + Number(students).toLocaleString() + '</div></div>' +
            '<div class="panel-stat-card"><div class="panel-stat-label">Courses</div><div class="panel-stat-value">' + courses + '</div></div>' +
            '<div class="panel-stat-card"><div class="panel-stat-label">Revenue</div><div class="panel-stat-value" style="color:var(--currency-color);font-size:1.2rem;">' + revStr + '</div></div>' +
            '<div class="panel-stat-card"><div class="panel-stat-label">Specialization</div><div class="panel-stat-value" style="font-size:.95rem;">' + escHtml(spec) + '</div></div>' +
          '</div>' +

          '<div class="panel-section-title">Professional Bio</div>' +
          '<div class="panel-bio">' + escHtml(bio) + '</div>' +

          '<div class="panel-section-title">Skills &amp; Expertise</div>' +
          '<div class="panel-skill-tags">' + skillsHtml + '</div>' +
        '</div>' +

        /* Tab 1 — Education */
        '<div class="tab-pane" id="panelTab1">' +
          panelInfoRow('fa-certificate',  'Highest Degree',   ins.highestDegree   || 'Not specified') +
          panelInfoRow('fa-university',   'University',       ins.university       || 'Not specified') +
          panelInfoRow('fa-calendar-alt', 'Graduation Year',  ins.graduationYear   || 'N/A') +
          panelInfoRow('fa-briefcase',    'Experience',       ins.experience       || 'Not specified') +
          '<div class="panel-section-title" style="margin-top:20px;">Certifications</div>' +
          '<div class="panel-skill-tags">' + certsHtml + '</div>' +
        '</div>' +

        /* Tab 2 — Verification */
        '<div class="tab-pane" id="panelTab2">' +
          '<div class="panel-section-title">Account Verification</div>' +
          makeVerifyRow2('fa-envelope', emailOk ? 'Email Verified' : 'Email Not Verified', email, emailOk) +
          makeVerifyRow2('fa-phone',   phoneOk ? 'Phone Added'    : 'Phone Not Added',     ins.phone || 'Not provided', phoneOk) +
          (ins.rejectedAt
            ? '<div style="margin-top:16px;padding:14px;background:var(--danger-bg);border-radius:10px;border:1px solid #ef4444;"><div style="font-size:.75rem;text-transform:uppercase;color:var(--danger-text);font-weight:700;margin-bottom:6px;">Rejected On</div><div style="font-size:.9rem;color:var(--text-main);">' + ins.rejectedAt + '</div></div>'
            : '') +
          (ins.rejectionReason
            ? '<div style="margin-top:10px;padding:14px;background:rgba(127,29,29,.3);border-radius:10px;border:1px solid #b91c1c;"><div style="font-size:.75rem;text-transform:uppercase;color:var(--danger-text);font-weight:700;margin-bottom:6px;">Rejection Reason</div><div style="font-size:.88rem;color:var(--text-muted);line-height:1.6;">' + escHtml(ins.rejectionReason) + '</div></div>'
            : '') +
        '</div>';

      panelActiveTab = 0;
    }

    function panelInfoRow(icon, label, value) {
      return '<div class="panel-info-row">' +
               '<i class="fas ' + icon + '"></i>' +
               '<div>' +
                 '<div class="panel-info-row-label">' + label + '</div>' +
                 '<div class="panel-info-row-value">' + escHtml(String(value)) + '</div>' +
               '</div>' +
             '</div>';
    }

    function makeVerifyRow2(icon, title, sub, ok) {
      return '<div class="verify-item ' + (ok ? 'verified' : 'unverified') + '" style="margin-bottom:10px;">' +
               '<div class="verify-icon"><i class="fas ' + (ok ? 'fa-check' : 'fa-times') + '"></i></div>' +
               '<div>' +
                 '<div class="verify-title"><i class="fas ' + icon + '" style="margin-right:6px;"></i>' + escHtml(title) + '</div>' +
                 '<div class="verify-sub">' + escHtml(sub) + '</div>' +
               '</div>' +
             '</div>';
    }

    function switchTab(i) {
      document.querySelectorAll('.tab-btn').forEach(function(b, idx) { b.classList.toggle('active', idx === i); });
      document.querySelectorAll('.tab-pane').forEach(function(p, idx) { p.classList.toggle('active', idx === i); });
      panelActiveTab = i;
    }

    function closePanel() {
      document.getElementById('sidePanel').classList.remove('open');
      document.getElementById('panelOverlay').classList.remove('open');
      document.body.style.overflow = 'auto';
    }

    /* ===== VERIFICATION MODAL ===== */
    function openVerification(id) {
      showLoading(true);
      fetch(contextPath + '/admin/api/instructors/' + id)
        .then(function(r) { return r.json(); })
        .then(function(ins) {
          currentInstructor = ins;
          var av = document.getElementById('modalAvatar');
          av.textContent = ins.fullName
            ? ins.fullName.split(' ').map(function(n){ return n[0]; }).join('').toUpperCase().substring(0,2) : '?';
          av.style.background = AVATAR_COLORS[ins.id % 8];

          document.getElementById('modalName').textContent       = ins.fullName  || 'N/A';
          document.getElementById('modalEmail').textContent      = ins.email     || 'N/A';
          document.getElementById('modalPhone').textContent      = ins.phone     || 'Not provided';
          document.getElementById('modalExperience').textContent =
            (ins.specialization || 'N/A') + (ins.experience ? ' \u2022 ' + ins.experience : '');
          document.getElementById('modalBio').textContent = ins.bio || 'No bio provided.';
          document.getElementById('modalDegree').textContent    = ins.highestDegree || 'Not specified';
          document.getElementById('modalUniversity').textContent =
            (ins.university || 'Not specified') + (ins.graduationYear ? ' (' + ins.graduationYear + ')' : '');

          var skillSrc = ins.skills || ins.specialization || '';
          var skillsEl = document.getElementById('modalSkills');
          skillsEl.innerHTML = '';
          if (skillSrc.trim()) {
            skillSrc.split(',').forEach(function(s) {
              s = s.trim();
              if (s) { var sp = document.createElement('span'); sp.className = 'skill-tag'; sp.textContent = s; skillsEl.appendChild(sp); }
            });
          } else {
            skillsEl.innerHTML = '<span class="no-data-tag">No skills listed</span>';
          }

          var emailOk = ins.emailVerified === true;
          var phoneOk = !!(ins.phone && ins.phone.trim());
          document.getElementById('modalVerification').innerHTML =
            makeVerifyRowModal('fa-envelope', emailOk ? 'Email Verified' : 'Email Not Verified', ins.email || '-', emailOk) +
            makeVerifyRowModal('fa-phone',   phoneOk ? 'Phone Verified'  : 'Phone Not Added',    ins.phone || 'Not provided', phoneOk);

          var certEl = document.getElementById('modalCertifications');
          certEl.innerHTML = '';
          if (ins.certifications && ins.certifications.trim()) {
            ins.certifications.split(',').forEach(function(c) {
              c = c.trim();
              if (c) certEl.innerHTML += '<div class="cert-item"><i class="fas fa-check-circle"></i> ' + escHtml(c) + '</div>';
            });
          } else {
            certEl.innerHTML = '<div class="cert-item" style="border-color:var(--border);background:rgba(255,255,255,.03);"><i class="fas fa-info-circle"></i> No certifications listed</div>';
          }

          document.getElementById('rejectionSection').classList.remove('active');
          document.getElementById('rejectBtnText').textContent = 'Reject';
          document.getElementById('rejectionReason').value = '';
          document.getElementById('verificationModal').classList.add('active');
          document.body.style.overflow = 'hidden';
          showLoading(false);
        })
        .catch(function() { showLoading(false); alert('\u2717 Failed to load instructor details'); });
    }

    function makeVerifyRowModal(icon, title, sub, ok) {
      return '<div class="verify-item ' + (ok ? 'verified' : 'unverified') + '">' +
               '<div class="verify-icon"><i class="fas ' + (ok ? 'fa-check' : 'fa-times') + '"></i></div>' +
               '<div>' +
                 '<div class="verify-title"><i class="fas ' + icon + '" style="margin-right:6px;"></i>' + escHtml(title) + '</div>' +
                 '<div class="verify-sub">' + escHtml(sub) + '</div>' +
               '</div>' +
             '</div>';
    }

    function closeVerification() {
      document.getElementById('verificationModal').classList.remove('active');
      document.getElementById('rejectionSection').classList.remove('active');
      document.getElementById('rejectBtnText').textContent = 'Reject';
      document.getElementById('rejectionReason').value = '';
      currentInstructor = null;
      document.body.style.overflow = 'auto';
    }

    function toggleRejection() {
      var sec = document.getElementById('rejectionSection');
      if (sec.classList.contains('active')) {
        var reason = document.getElementById('rejectionReason').value.trim();
        if (!reason) { alert('\u26a0\ufe0f Please provide a rejection reason.'); return; }
        doReject(reason);
      } else {
        sec.classList.add('active');
        document.getElementById('rejectBtnText').textContent = 'Confirm Rejection';
        document.getElementById('rejectionReason').focus();
      }
    }

    function approveInstructor() {
      if (!currentInstructor) return;
      if (!confirm('Approve ' + currentInstructor.fullName + ' as instructor?')) return;
      showLoading(true);
      fetch(contextPath + '/admin/api/instructors/' + currentInstructor.id + '/approve', {
        method:'POST', headers:{'Content-Type':'application/json'}
      }).then(function(r){ return r.json(); }).then(function(d) {
        showLoading(false);
        if (d.success) { alert('\u2713 Approved! Email sent.'); closeVerification(); location.reload(); }
        else { alert('\u2717 ' + (d.error || 'Failed')); }
      }).catch(function(){ showLoading(false); alert('\u2717 Network error'); });
    }

    function doReject(reason) {
      if (!currentInstructor) return;
      showLoading(true);
      fetch(contextPath + '/admin/api/instructors/' + currentInstructor.id + '/reject', {
        method:'POST', headers:{'Content-Type':'application/json'},
        body: JSON.stringify({reason: reason})
      }).then(function(r){ return r.json(); }).then(function(d) {
        showLoading(false);
        if (d.success) { alert('\u2713 Rejected. Email sent.'); closeVerification(); location.reload(); }
        else { alert('\u2717 ' + (d.error || 'Failed')); }
      }).catch(function(){ showLoading(false); alert('\u2717 Network error'); });
    }

    function deleteInstructor(id) {
      if (!confirm('Delete this instructor? Cannot be undone.')) return;
      showLoading(true);
      fetch(contextPath + '/admin/api/instructors/' + id, {method:'DELETE'})
        .then(function(r){ return r.json(); }).then(function(d) {
          showLoading(false);
          if (d.success) { alert('\u2713 Deleted.'); location.reload(); }
          else { alert('\u2717 ' + (d.error || 'Failed')); }
        }).catch(function(){ showLoading(false); alert('\u2717 Network error'); });
    }

    function showLoading(v) { document.getElementById('loadingOverlay').classList.toggle('active', v); }
    function exportData()   { alert('Export: CSV / Excel / PDF \u2014 coming soon.'); }

    function escHtml(s) {
      return String(s)
        .replace(/&/g,'&amp;').replace(/</g,'&lt;')
        .replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') { closeVerification(); closePanel(); }
    });
    document.getElementById('verificationModal').addEventListener('click', function(e) {
      if (e.target.id === 'verificationModal') closeVerification();
    });
  </script>
</body>
</html>
