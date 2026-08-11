<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en" data-theme="theme1">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - EduMaster Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* ========== THEME VARIABLES ========== */
        
        /* THEME 1 - Dark Purple (Default) */
        :root[data-theme="theme1"] {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --primary-light: #818cf8;
            --secondary: #64748b;
            --bg-body: #0f172a;
            --bg-card: #1e293b;
            --bg-hover: #334155;
            --text-main: #e2e8f0;
            --text-muted: #94a3b8;
            --border: rgba(99,102,241,0.2);
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.3);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.4);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.5);
            --sidebar-bg: linear-gradient(180deg, rgba(30,41,59,0.95) 0%, rgba(15,23,42,0.95) 100%);
            --header-bg: #1e293b;
            
            --success-bg: #166534; --success-text: #dcfce7;
            --warning-bg: #854d0e; --warning-text: #fef9c3;
            --danger-bg: #991b1b;  --danger-text: #fee2e2;
            --info-bg: #075985;    --info-text: #e0f2fe;
        }

        /* THEME 2 - Dark Blue */
        :root[data-theme="theme2"] {
            --primary: #3b82f6;
            --primary-hover: #2563eb;
            --primary-light: #60a5fa;
            --secondary: #6b7280;
            --bg-body: #020617;
            --bg-card: #111827;
            --bg-hover: #1f2937;
            --text-main: #e5e7eb;
            --text-muted: #9ca3af;
            --border: rgba(55,65,81,0.5);
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.4);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.5);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.6);
            --sidebar-bg: radial-gradient(circle at top left, #111827 0, #020617 45%, #020617 100%);
            --header-bg: #111827;
            
            --success-bg: #166534; --success-text: #dcfce7;
            --warning-bg: #854d0e; --warning-text: #fef9c3;
            --danger-bg: #991b1b;  --danger-text: #fee2e2;
            --info-bg: #075985;    --info-text: #e0f2fe;
        }

        /* THEME 3 - Light/White */
        :root[data-theme="theme3"] {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --primary-light: #6366f1;
            --secondary: #64748b;
            --bg-body: #f1f5f9;
            --bg-card: #ffffff;
            --bg-hover: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            --sidebar-bg: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            --header-bg: #ffffff;
            
            --success-bg: #dcfce7; --success-text: #166534;
            --warning-bg: #fef9c3; --warning-text: #854d0e;
            --danger-bg: #fee2e2;  --danger-text: #991b1b;
            --info-bg: #e0f2fe;    --info-text: #075985;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; outline: none; }
        body { background: var(--bg-body); color: var(--text-main); display: flex; min-height: 100vh; overflow-x: hidden; transition: background 0.3s, color 0.3s; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* MAIN */
        .main { margin-left: 260px; flex: 1; display: flex; flex-direction: column; transition: 0.3s; width: calc(100% - 260px); }

        .header {
            background: var(--header-bg);
            height: 70px;
            padding: 0 32px;
            border-bottom: 1px solid var(--border);
            display: flex; justify-content: space-between; align-items: center;
            position: sticky; top: 0; z-index: 40;
            transition: background 0.3s;
        }

        .header-search { position: relative; width: 300px; }
        .header-search input {
            width: 100%; 
            padding: 10px 12px 10px 40px;
            border: 1px solid var(--border); 
            border-radius: 8px;
            font-size: 0.9rem; 
            background: var(--bg-body); 
            color: var(--text-main);
            transition: 0.2s;
        }
        .header-search input:focus { border-color: var(--primary); background: var(--bg-card); box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1); }
        .header-search i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }

        .user-nav { display: flex; align-items: center; gap: 20px; }
        .icon-btn-plain { background: none; border: none; font-size: 1.2rem; color: var(--text-muted); cursor: pointer; position: relative; }
        .icon-btn-plain .badge-dot { position: absolute; top: -2px; right: -2px; width: 8px; height: 8px; background: var(--danger-text); border-radius: 50%; border: 2px solid var(--header-bg); }

        .profile-dropdown { display: flex; align-items: center; gap: 12px; cursor: pointer; padding: 6px 12px; border-radius: 8px; transition: 0.2s; }
        .profile-dropdown:hover { background: var(--bg-hover); }
        .avatar-circle { 
            width: 36px; 
            height: 36px; 
            border-radius: 50%; 
            background: var(--primary); 
            color: white; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-weight: 600; 
            font-size: 0.9rem; 
        }

        .content { padding: 32px; }

        .page-heading-row { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; }
        .page-title h1 { font-size: 1.75rem; font-weight: 700; color: var(--text-main); letter-spacing: -0.025em; }
        .page-title p { color: var(--text-muted); margin-top: 4px; font-size: 0.95rem; }

        .btn { padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 0.9rem; cursor: pointer; border: 1px solid transparent; display: inline-flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-primary { background: var(--primary); color: white; box-shadow: 0 2px 5px rgba(79, 70, 229, 0.3); }
        .btn-primary:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-outline { background: var(--bg-card); border-color: var(--border); color: var(--text-main); }
        .btn-outline:hover { background: var(--bg-hover); border-color: var(--text-muted); }

        /* STATS */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 32px; }
        .stat-card { 
            background: var(--bg-card); 
            padding: 24px; 
            border-radius: 12px; 
            border: 1px solid var(--border); 
            box-shadow: var(--shadow-sm); 
            display: flex; 
            flex-direction: column;
            transition: all 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .stat-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
        .stat-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
        .stat-value { font-size: 2rem; font-weight: 700; color: var(--text-main); line-height: 1; margin-bottom: 6px; }
        .stat-label { color: var(--text-muted); font-size: 0.9rem; font-weight: 500; }

        /* TABLE */
        .table-wrapper { 
            background: var(--bg-card); 
            border-radius: 12px; 
            border: 1px solid var(--border); 
            box-shadow: var(--shadow-sm); 
            overflow: hidden;
            transition: all 0.3s;
        }
        .toolbar { 
            padding: 16px 24px; 
            border-bottom: 1px solid var(--border); 
            display: flex; 
            flex-wrap: wrap; 
            gap: 16px; 
            justify-content: space-between; 
            align-items: center; 
            background: var(--bg-card); 
        }
        .toolbar-left { display: flex; gap: 12px; flex: 1; flex-wrap: wrap; }
        .filter-select { 
            padding: 8px 12px; 
            border: 1px solid var(--border); 
            border-radius: 6px; 
            font-size: 0.9rem; 
            color: var(--text-main); 
            cursor: pointer; 
            background-color: var(--bg-card); 
        }
        .filter-select:hover { border-color: var(--text-muted); }

        table { width: 100%; border-collapse: collapse; }
        th { 
            text-align: left; 
            padding: 14px 24px; 
            background: var(--bg-hover); 
            font-size: 0.75rem; 
            text-transform: uppercase; 
            letter-spacing: 0.05em; 
            color: var(--text-muted); 
            font-weight: 600; 
            border-bottom: 1px solid var(--border); 
        }
        td { 
            padding: 16px 24px; 
            border-bottom: 1px solid var(--border); 
            font-size: 0.9rem; 
            vertical-align: middle; 
            color: var(--text-main);
        }
        tr:hover td { background: var(--bg-hover); }
        tr:last-child td { border-bottom: none; }

        .user-info-cell { display: flex; align-items: center; gap: 12px; }
        .avatar-img { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; border: 1px solid var(--border); }
        .user-text h4 { font-size: 0.9rem; font-weight: 600; color: var(--text-main); margin: 0; }
        .user-text span { font-size: 0.8rem; color: var(--text-muted); }

        .badge { padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; display: inline-block; text-transform: capitalize; }
        .badge.STUDENT { background: var(--info-bg); color: var(--info-text); }
        .badge.INSTRUCTOR { background: #f3e8ff; color: #6b21a8; }
        .badge.ADMIN { background: var(--danger-bg); color: var(--danger-text); }
        .badge.ACTIVE { background: var(--success-bg); color: var(--success-text); }
        .badge.INACTIVE { background: #64748b; color: #f1f5f9; }

        .actions-cell { display: flex; gap: 8px; justify-content: flex-end; }
        .action-btn { 
            width: 32px; 
            height: 32px; 
            border-radius: 6px; 
            border: 1px solid var(--border); 
            background: var(--bg-card); 
            color: var(--text-muted); 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            cursor: pointer; 
            transition: 0.2s; 
        }
        .action-btn:hover { border-color: var(--primary); color: var(--primary); background: rgba(79, 70, 229, 0.1); }
        .action-btn.delete:hover { border-color: #ef4444; color: #ef4444; background: var(--danger-bg); }

        .pagination { 
            padding: 14px 24px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            background: var(--bg-card); 
            border-top: 1px solid var(--border); 
        }
        .page-info { font-size: 0.85rem; color: var(--text-muted); }
        .page-controls { display: flex; gap: 5px; }
        .page-btn { 
            padding: 6px 12px; 
            border: 1px solid var(--border); 
            border-radius: 6px; 
            background: var(--bg-card); 
            color: var(--text-main);
            font-size: 0.85rem; 
            cursor: pointer; 
            transition: 0.2s; 
        }
        .page-btn:hover { background: var(--bg-hover); }
        .page-btn.active { background: var(--primary); color: white; border-color: var(--primary); }
        .page-btn:disabled { opacity: 0.5; cursor: not-allowed; }

        /* BULK ACTION BAR */
        .bulk-action-bar {
            position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%) translateY(100px);
            background: var(--bg-card); 
            color: var(--text-main); 
            padding: 12px 24px; 
            border-radius: 50px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-lg);
            display: flex; 
            align-items: center; 
            gap: 20px;
            z-index: 100; 
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
            opacity: 0; 
            pointer-events: none;
        }
        .bulk-action-bar.visible { transform: translateX(-50%) translateY(0); opacity: 1; pointer-events: all; }
        .bulk-count { 
            font-weight: 700; 
            border-right: 1px solid var(--border); 
            padding-right: 15px; 
            margin-right: 5px; 
        }
        .bulk-btn { 
            background: var(--bg-hover); 
            border: 1px solid var(--border); 
            color: var(--text-main); 
            padding: 6px 16px; 
            border-radius: 20px; 
            font-size: 0.85rem; 
            cursor: pointer; 
            transition: 0.2s; 
            display: flex; 
            align-items: center; 
            gap: 6px; 
        }
        .bulk-btn:hover { background: var(--primary); color: white; border-color: var(--primary); }
        .bulk-btn.danger:hover { background: #ef4444; border-color: #ef4444; }

        /* SIDE PANEL */
        .side-panel-overlay {
            position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 200;
            opacity: 0; visibility: hidden; transition: 0.3s; backdrop-filter: blur(2px);
        }
        .side-panel {
            position: fixed; top: 0; right: 0; height: 100vh; width: 450px;
            background: var(--bg-card); 
            z-index: 201; 
            box-shadow: -5px 0 25px rgba(0,0,0,0.3);
            transform: translateX(100%); 
            transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex; 
            flex-direction: column;
        }
        .side-panel-overlay.open { opacity: 1; visibility: visible; }
        .side-panel.open { transform: translateX(0); }

        .panel-header { 
            padding: 24px; 
            border-bottom: 1px solid var(--border); 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            background: var(--bg-hover); 
        }
        .panel-body { flex: 1; overflow-y: auto; padding: 24px; }
        .panel-footer { 
            padding: 20px 24px; 
            border-top: 1px solid var(--border); 
            background: var(--bg-hover); 
            display: flex; 
            justify-content: flex-end; 
            gap: 10px; 
        }

        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-main); margin-bottom: 8px; }
        .form-control, .form-select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: var(--bg-body);
            color: var(--text-main);
            font-size: 0.9rem;
            transition: 0.2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .detail-label { 
            font-size: 0.75rem; 
            text-transform: uppercase; 
            color: var(--text-muted); 
            font-weight: 700; 
            margin-bottom: 8px; 
            letter-spacing: 0.05em; 
        }
        .detail-value { 
            font-size: 0.95rem; 
            color: var(--text-main); 
            font-weight: 500; 
            border-bottom: 1px solid var(--border); 
            padding-bottom: 8px; 
            margin-bottom: 20px;
        }

        @media (max-width: 900px) {
            .main { margin-left: 0; width: 100%; }
            .side-panel { width: 100%; }
        }
    </style>
</head>
<body>

    <!-- INCLUDE SIDEBAR -->
    <jsp:include page="sidebar.jsp" />

    <!-- MAIN -->
    <main class="main">
        <header class="header">
            <div class="header-search">
                <i class="fas fa-search"></i>
                <input type="text" id="globalSearch" placeholder="Search users, email..." onkeyup="filterTable()">
            </div>
            <div class="user-nav">
                <button class="icon-btn-plain"><i class="far fa-bell"></i><span class="badge-dot"></span></button>
                <button class="icon-btn-plain"><i class="far fa-envelope"></i></button>
                <div class="profile-dropdown">
                    <div style="text-align: right;">
                        <div style="font-size: 0.85rem; font-weight: 600;">${fullName}</div>
                        <div style="font-size: 0.7rem; color: var(--text-muted);">${role}</div>
                    </div>
                    <div class="avatar-circle">${fn:substring(fullName, 0, 2)}</div>
                </div>
            </div>
        </header>

        <div class="content">

            <div class="page-heading-row">
                <div class="page-title">
                    <h1>User Management</h1>
                    <p>Manage access, roles, and platform activity for all registered users.</p>
                </div>
                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/admin/users/export" class="btn btn-outline">
                        <i class="fas fa-download"></i> Export
                    </a>
                    <button class="btn btn-primary" onclick="openPanel(true)">
                        <i class="fas fa-plus"></i> Add User
                    </button>
                </div>
            </div>

            <!-- KPI STATS -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: rgba(79, 70, 229, 0.2); color: var(--primary);">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: var(--success-bg); color: var(--success-text);">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                    </div>
                    <c:set var="studentCount" value="0"/>
                    <c:forEach items="${users}" var="u">
                        <c:if test="${u.role == 'STUDENT'}">
                            <c:set var="studentCount" value="${studentCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    <div class="stat-value">${studentCount}</div>
                    <div class="stat-label">Students</div>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: var(--warning-bg); color: var(--warning-text);">
                            <i class="fas fa-chalkboard-teacher"></i>
                        </div>
                    </div>
                    <c:set var="instructorCount" value="0"/>
                    <c:forEach items="${users}" var="u">
                        <c:if test="${u.role == 'INSTRUCTOR'}">
                            <c:set var="instructorCount" value="${instructorCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    <div class="stat-value">${instructorCount}</div>
                    <div class="stat-label">Instructors</div>
                </div>
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon" style="background: var(--danger-bg); color: var(--danger-text);">
                            <i class="fas fa-user-slash"></i>
                        </div>
                    </div>
                    <div class="stat-value">${inactiveUsers != null ? inactiveUsers : 0}</div>
                    <div class="stat-label">Inactive</div>
                </div>
            </div>

            <!-- TABLE -->
            <div class="table-wrapper">
                <div class="toolbar">
                    <div class="toolbar-left">
                        <select class="filter-select" id="roleFilter" onchange="filterTable()">
                            <option value="all">All Roles</option>
                            <option value="STUDENT">Student</option>
                            <option value="INSTRUCTOR">Instructor</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                        <select class="filter-select" id="statusFilter" onchange="filterTable()">
                            <option value="all">All Status</option>
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                        </select>
                    </div>
                    <div id="showingInfo" style="font-size: 0.85rem; color: var(--text-muted);">
                        Showing <strong style="color: var(--text-main);" id="showingCount">0</strong> of <strong style="color: var(--text-main);">${totalUsers != null ? totalUsers : 0}</strong>
                    </div>
                </div>

                <table id="mainTable">
                    <thead>
                        <tr>
                            <th style="width: 40px;"><input type="checkbox" id="selectAll" onchange="toggleSelectAll()"></th>
                            <th>User Profile</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Last Active</th>
                            <th>Joined Date</th>
                            <th style="text-align: right;">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <!-- Rows rendered by JavaScript -->
                    </tbody>
                </table>

                <div class="pagination">
                    <div class="page-info" id="paginationInfo">Page 1 of 1</div>
                    <div class="page-controls" id="paginationNav">
                        <!-- Pagination buttons rendered by JavaScript -->
                    </div>
                </div>
            </div>

        </div>
    </main>

    <!-- BULK ACTION BAR -->
    <div class="bulk-action-bar" id="bulkBar">
        <div class="bulk-count"><span id="selectedCount">0</span> Selected</div>
        <button class="bulk-btn" onclick="bulkAction('activate')"><i class="fas fa-check"></i> Activate</button>
        <button class="bulk-btn" onclick="bulkAction('deactivate')"><i class="fas fa-ban"></i> Deactivate</button>
        <button class="bulk-btn danger" onclick="bulkAction('delete')"><i class="fas fa-trash"></i> Delete</button>
        <button class="bulk-btn" onclick="clearSelection()" style="margin-left: 10px;">Cancel</button>
    </div>

    <!-- SIDE PANEL -->
    <div class="side-panel-overlay" id="panelOverlay" onclick="closePanel()"></div>
    <div class="side-panel" id="sidePanel">
        <div class="panel-header">
            <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-main);" id="panelTitle">User Details</h2>
            <button class="icon-btn-plain" onclick="closePanel()"><i class="fas fa-times"></i></button>
        </div>

        <div class="panel-body" id="panelBody">
            <!-- Content rendered by JavaScript -->
        </div>

        <div class="panel-footer" id="panelFooter">
            <!-- Buttons rendered by JavaScript -->
        </div>
    </div>

    <!-- HIDDEN DELETE FORM -->
    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/admin/users/delete/0" style="display:none;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
    </form>

    <script>
        var BASE = '<%= request.getContextPath() %>';
        var CSRF_NAME = '${_csrf.parameterName}';
        var CSRF_TOKEN = '${_csrf.token}';

        // Store all users data from server
        var allUsers = [
            <c:forEach var="u" items="${users}" varStatus="status">
            {
                id: ${u.id},
                name: "${fn:escapeXml(u.fullName)}",
                email: "${fn:escapeXml(u.email)}",
                role: "${u.role}",
                status: "${u.isActive ? 'ACTIVE' : 'INACTIVE'}",
                isActive: ${u.isActive},
                profilePictureUrl: "${not empty u.profilePictureUrl ? fn:escapeXml(u.profilePictureUrl) : ''}",
                lastLoginAt: "${u.lastLoginAt != null ? u.lastLoginAt : ''}",
                createdAt: "${u.createdAt != null ? u.createdAt : ''}"
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        var currentPage = 1;
        var itemsPerPage = 10;
        var filteredUsers = [];
        var selectedUsers = new Set();

        function formatDate(dateStr) {
            if (!dateStr || dateStr === '') return 'Never';
            try {
                var date = new Date(dateStr);
                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                var day = date.getDate();
                var month = months[date.getMonth()];
                var year = date.getFullYear();
                return day + ' ' + month + ' ' + year;
            } catch(e) {
                return 'Never';
            }
        }

        function renderTable() {
            var tbody = document.getElementById('tableBody');
            tbody.innerHTML = '';
            
            var startIndex = (currentPage - 1) * itemsPerPage;
            var endIndex = Math.min(startIndex + itemsPerPage, filteredUsers.length);
            var pageUsers = filteredUsers.slice(startIndex, endIndex);
            
            if (pageUsers.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;padding:48px;color:var(--text-muted);">No users found</td></tr>';
                document.getElementById('showingCount').textContent = '0';
            } else {
                pageUsers.forEach(function(u) {
                    var avatarUrl = u.profilePictureUrl || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(u.name) + '&background=random';
                    var isChecked = selectedUsers.has(u.id);
                    
                    var tr = document.createElement('tr');
                    tr.innerHTML = 
                        '<td><input type="checkbox" ' + (isChecked ? 'checked' : '') + ' onchange="toggleSelect(' + u.id + ')"></td>' +
                        '<td>' +
                            '<div class="user-info-cell">' +
                                '<img src="' + avatarUrl + '" class="avatar-img">' +
                                '<div class="user-text">' +
                                    '<h4>' + u.name + '</h4>' +
                                    '<span>' + u.email + '</span>' +
                                '</div>' +
                            '</div>' +
                        '</td>' +
                        '<td><span class="badge ' + u.role + '">' + u.role + '</span></td>' +
                        '<td><span class="badge ' + u.status + '">' + u.status + '</span></td>' +
                        '<td>' + formatDate(u.lastLoginAt) + '</td>' +
                        '<td>' + formatDate(u.createdAt) + '</td>' +
                        '<td>' +
                            '<div class="actions-cell">' +
                                '<button class="action-btn" title="View" onclick="viewUser(' + u.id + ')"><i class="far fa-eye"></i></button>' +
                                '<a href="' + BASE + '/admin/users/edit/' + u.id + '" class="action-btn" title="Edit"><i class="far fa-edit"></i></a>' +
                                '<button class="action-btn delete" title="Delete" onclick="confirmDelete(' + u.id + ',\'' + u.name.replace(/'/g, "\\'") + '\')"><i class="far fa-trash-alt"></i></button>' +
                            '</div>' +
                        '</td>';
                    
                    tbody.appendChild(tr);
                });
                
                document.getElementById('showingCount').textContent = filteredUsers.length;
            }
            
            renderPagination();
        }

        function renderPagination() {
            var totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
            var paginationInfo = document.getElementById('paginationInfo');
            var paginationNav = document.getElementById('paginationNav');
            
            paginationInfo.textContent = 'Page ' + currentPage + ' of ' + totalPages;
            paginationNav.innerHTML = '';
            
            var prevBtn = document.createElement('button');
            prevBtn.className = 'page-btn';
            prevBtn.textContent = 'Previous';
            prevBtn.disabled = currentPage === 1;
            prevBtn.onclick = function() { goToPage(currentPage - 1); };
            paginationNav.appendChild(prevBtn);
            
            var maxButtons = 5;
            var startPage = Math.max(1, currentPage - Math.floor(maxButtons / 2));
            var endPage = Math.min(totalPages, startPage + maxButtons - 1);
            
            if (endPage - startPage < maxButtons - 1) {
                startPage = Math.max(1, endPage - maxButtons + 1);
            }
            
            for (var i = startPage; i <= endPage; i++) {
                var pageBtn = document.createElement('button');
                pageBtn.className = 'page-btn' + (i === currentPage ? ' active' : '');
                pageBtn.textContent = i;
                pageBtn.onclick = (function(page) {
                    return function() { goToPage(page); };
                })(i);
                paginationNav.appendChild(pageBtn);
            }
            
            var nextBtn = document.createElement('button');
            nextBtn.className = 'page-btn';
            nextBtn.textContent = 'Next';
            nextBtn.disabled = currentPage === totalPages || totalPages === 0;
            nextBtn.onclick = function() { goToPage(currentPage + 1); };
            paginationNav.appendChild(nextBtn);
        }

        function goToPage(page) {
            var totalPages = Math.ceil(filteredUsers.length / itemsPerPage);
            if (page < 1 || page > totalPages) return;
            currentPage = page;
            renderTable();
        }

        function filterTable() {
            var search = document.getElementById('globalSearch').value.toLowerCase();
            var role = document.getElementById('roleFilter').value;
            var status = document.getElementById('statusFilter').value;
            
            filteredUsers = allUsers.filter(function(u) {
                var matchRole = role === 'all' || u.role === role;
                var matchStatus = status === 'all' || u.status === status;
                var matchSearch = !search || (u.name + ' ' + u.email).toLowerCase().includes(search);
                
                return matchRole && matchStatus && matchSearch;
            });
            
            currentPage = 1;
            renderTable();
        }

        function toggleSelect(id) {
            if (selectedUsers.has(id)) selectedUsers.delete(id);
            else selectedUsers.add(id);
            updateBulkBar();
            renderTable();
        }

        function toggleSelectAll() {
            var checked = document.getElementById('selectAll').checked;
            if (checked) {
                filteredUsers.forEach(function(u) { selectedUsers.add(u.id); });
            } else {
                selectedUsers.clear();
            }
            updateBulkBar();
            renderTable();
        }

        function updateBulkBar() {
            var bar = document.getElementById('bulkBar');
            var countSpan = document.getElementById('selectedCount');
            countSpan.innerText = selectedUsers.size;
            if (selectedUsers.size > 0) bar.classList.add('visible');
            else bar.classList.remove('visible');
        }

        function clearSelection() {
            selectedUsers.clear();
            document.getElementById('selectAll').checked = false;
            updateBulkBar();
            renderTable();
        }

        function bulkAction(type) {
            var ids = Array.from(selectedUsers);
            if(!ids.length) return;

            var label = type.charAt(0).toUpperCase() + type.slice(1);
            if(!confirm(label + ' ' + ids.length + ' user(s)?')) return;

            var body = new URLSearchParams();
            body.append('action', type);
            ids.forEach(function(id){ body.append('userIds', id); });
            body.append(CSRF_NAME, CSRF_TOKEN);

            fetch(BASE + '/admin/users/bulk-action', {
                method: 'POST',
                headers: { 'Content-Type':'application/x-www-form-urlencoded' },
                body: body.toString()
            })
            .then(function(r){
                if(!r.ok) throw new Error('Server returned ' + r.status);
                clearSelection();
                location.reload();
            })
            .catch(function(err){ alert('Bulk action failed: ' + err.message); });
        }

        function confirmDelete(id, name) {
            if(!confirm('Delete "' + name + '"?\nThis cannot be undone.')) return;
            var form = document.getElementById('deleteForm');
            form.action = BASE + '/admin/users/delete/' + id;
            form.submit();
        }

        function viewUser(id) {
            var user = allUsers.find(function(u) { return u.id === id; });
            if (!user) return;

            var title = document.getElementById('panelTitle');
            var body = document.getElementById('panelBody');
            var footer = document.getElementById('panelFooter');

            title.innerText = 'User Details';
            
            var avatarUrl = user.profilePictureUrl || 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.name) + '&background=random';
            
            body.innerHTML = 
                '<div style="text-align: center; margin-bottom: 30px;">' +
                    '<img src="' + avatarUrl + '" style="width: 80px; height: 80px; border-radius: 50%; border: 3px solid var(--bg-card); box-shadow: var(--shadow-md); margin-bottom: 15px;">' +
                    '<h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 5px;">' + user.name + '</h3>' +
                    '<span class="badge ' + user.role + '">' + user.role + '</span>' +
                '</div>' +
                '<div class="detail-label">Email</div>' +
                '<div class="detail-value">' + user.email + '</div>' +
                '<div class="detail-label">Status</div>' +
                '<div class="detail-value"><span class="badge ' + user.status + '">' + user.status + '</span></div>' +
                '<div class="detail-label">Joined</div>' +
                '<div class="detail-value">' + formatDate(user.createdAt) + '</div>' +
                '<div class="detail-label">Last Active</div>' +
                '<div class="detail-value">' + formatDate(user.lastLoginAt) + '</div>';

            footer.innerHTML =
                '<button class="btn btn-outline" style="border-color: var(--danger-bg); color: var(--danger-text);" onclick="confirmDelete(' + id + ',\'' + user.name.replace(/'/g, "\\'") + '\')">Delete</button>' +
                '<a href="' + BASE + '/admin/users/edit/' + id + '" class="btn btn-primary">Edit</a>' +
                '<button class="btn btn-outline" onclick="closePanel()">Close</button>';

            openPanel();
        }

        function openPanel(isNew) {
            if(isNew) {
                var title = document.getElementById('panelTitle');
                var body = document.getElementById('panelBody');
                var footer = document.getElementById('panelFooter');

                title.innerText = 'Add User';
                body.innerHTML =
                    '<form id="addUserForm" method="post" action="' + BASE + '/admin/users/add">' +
                      '<input type="hidden" name="' + CSRF_NAME + '" value="' + CSRF_TOKEN + '">' +
                      '<input type="hidden" name="password" value="Password123">' +
                      '<div class="form-group">' +
                        '<label class="form-label">Full Name</label>' +
                        '<input type="text" name="fullName" class="form-control" required>' +
                      '</div>' +
                      '<div class="form-group">' +
                        '<label class="form-label">Email</label>' +
                        '<input type="email" name="email" class="form-control" required>' +
                      '</div>' +
                      '<div class="form-group">' +
                        '<label class="form-label">Role</label>' +
                        '<select name="role" class="form-select" required>' +
                          '<option value="STUDENT">Student</option>' +
                          '<option value="INSTRUCTOR">Instructor</option>' +
                          '<option value="ADMIN">Admin</option>' +
                        '</select>' +
                      '</div>' +
                      '<div class="form-group">' +
                        '<label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">' +
                          '<input type="checkbox" name="active" checked style="width: 18px; height: 18px;">' +
                          '<span class="form-label" style="margin: 0;">Active</span>' +
                        '</label>' +
                      '</div>' +
                      '<div style="padding: 12px; background: var(--info-bg); border-radius: 6px; margin-top: 16px;">' +
                        '<small style="color: var(--info-text); font-size: 0.8rem;"><i class="fas fa-info-circle"></i> Default password will be set as: <strong>Password123</strong></small>' +
                      '</div>' +
                    '</form>';

                footer.innerHTML =
                    '<button class="btn btn-outline" onclick="closePanel()">Cancel</button>' +
                    '<button class="btn btn-primary" onclick="document.getElementById(\'addUserForm\').submit()">Save</button>';
            }
            
            document.getElementById('panelOverlay').classList.add('open');
            document.getElementById('sidePanel').classList.add('open');
        }

        function closePanel() {
            document.getElementById('panelOverlay').classList.remove('open');
            document.getElementById('sidePanel').classList.remove('open');
        }

        document.addEventListener('DOMContentLoaded', function() {
            filteredUsers = allUsers.slice();
            renderTable();
        });
    </script>
</body>
</html>
