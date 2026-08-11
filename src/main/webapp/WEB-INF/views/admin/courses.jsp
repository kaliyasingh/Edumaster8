<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduMaster Admin - Course Verification</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* THEME VARIABLES - Main content area */
        :root[data-theme="theme1"] {
            --primary: #4f46e5;
            --primary-light: #818cf8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --bg-body: radial-gradient(circle at top, #111827 0, #020617 45%, #020617 100%);
            --bg-card: rgba(30,41,59,0.5);
            --bg-header: linear-gradient(135deg, rgba(99,102,241,0.1), rgba(139,92,246,0.1));
            --text-main: #e2e8f0;
            --text-light: #94a3b8;
            --border: rgba(99,102,241,0.2);
            --shadow: 0 8px 32px rgba(0,0,0,0.3);
            --animated-bg: radial-gradient(circle at 20% 50%, rgba(99,102,241,0.08) 0%, transparent 50%),
                          radial-gradient(circle at 80% 80%, rgba(139,92,246,0.08) 0%, transparent 50%);
        }

        :root[data-theme="theme2"] {
            --primary: #4f46e5;
            --primary-light: #818cf8;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --bg-body: radial-gradient(circle at top, #111827 0, #020617 45%, #020617 100%);
            --bg-card: radial-gradient(circle at top left, #111827, #020617);
            --bg-header: rgba(15,23,42,0.96);
            --text-main: #e5e7eb;
            --text-light: #9ca3af;
            --border: rgba(55,65,81,0.9);
            --shadow: 0 18px 45px rgba(0,0,0,0.75);
            --animated-bg: none;
        }

        :root[data-theme="theme3"] {
            --primary: #4f46e5;
            --primary-light: #6366f1;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --bg-body: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            --bg-card: #ffffff;
            --bg-header: rgba(255,255,255,0.95);
            --text-main: #1e293b;
            --text-light: #64748b;
            --border: #e2e8f0;
            --shadow: 0 4px 20px rgba(0,0,0,0.08);
            --animated-bg: radial-gradient(circle at 20% 50%, rgba(99,102,241,0.03) 0%, transparent 50%),
                          radial-gradient(circle at 80% 80%, rgba(139,92,246,0.03) 0%, transparent 50%);
        }

        /* Sidebar theme variables */
        :root[data-sidebar="normal"] {
            --sidebar-bg: linear-gradient(180deg, rgba(30,41,59,0.95) 0%, rgba(15,23,42,0.95) 100%);
            --sidebar-text: #e2e8f0;
            --sidebar-text-light: #94a3b8;
            --sidebar-border: rgba(99,102,241,0.2);
            --sidebar-section-title: #64748b;
            --sidebar-primary: #4f46e5;
            --sidebar-primary-light: #818cf8;
        }
        
        :root[data-sidebar="dark"] {
            --sidebar-bg: linear-gradient(180deg, rgba(15,23,42,0.98) 0%, rgba(2,6,23,0.98) 100%);
            --sidebar-text: #cbd5e1;
            --sidebar-text-light: #64748b;
            --sidebar-border: rgba(99,102,241,0.15);
            --sidebar-section-title: #475569;
            --sidebar-primary: #6366f1;
            --sidebar-primary-light: #818cf8;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-body);
            color: var(--text-main);
            margin-left: 280px;
            transition: background 0.3s ease, color 0.3s ease;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 10px;
            height: 10px;
        }

        ::-webkit-scrollbar-track {
            background: var(--bg-card);
        }

        ::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, var(--primary), var(--primary-light));
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(180deg, var(--primary-light), var(--primary));
        }

        /* SIDEBAR STYLES */
        .sidebar {
            width: 280px;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            background: var(--sidebar-bg);
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--sidebar-border);
            z-index: 1000;
            overflow-y: auto;
            box-shadow: 4px 0 40px rgba(0,0,0,0.1);
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
        }

        .sidebar::-webkit-scrollbar { width: 6px; }
        .sidebar::-webkit-scrollbar-track { background: transparent; }
        .sidebar::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, #6366f1, #8b5cf6);
            border-radius: 10px;
        }

        .sidebar-brand {
            padding: 1.75rem 1.5rem;
            border-bottom: 1px solid var(--sidebar-border);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 800;
            font-size: 1.45rem;
            background: linear-gradient(135deg, rgba(99,102,241,0.15), rgba(139,92,246,0.15));
            color: var(--sidebar-text);
            transition: all 0.3s;
        }

        .sidebar-brand i {
            font-size: 2rem;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-section {
            padding: 1.25rem 0 0.4rem 0;
            flex: 1;
        }

        .nav-section-title {
            color: var(--sidebar-section-title);
            font-size: 0.68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.09em;
            padding: 0.6rem 1.5rem 0.4rem 1.5rem;
            margin-top: 0.75rem;
        }

        .nav-section-title:first-child {
            margin-top: 0;
        }

        .nav-link {
            color: var(--sidebar-text-light);
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            font-size: 0.92rem;
            display: flex;
            align-items: center;
            text-decoration: none;
            border-left: 3px solid transparent;
            transition: all 0.3s;
            position: relative;
            cursor: pointer;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 0;
            background: linear-gradient(90deg, rgba(99,102,241,0.2), transparent);
            transition: width 0.3s;
        }

        .nav-link:hover::before { width: 100%; }

        .nav-link:hover {
            color: var(--sidebar-text);
            border-left-color: #6366f1;
            transform: translateX(4px);
        }

        .nav-link.active {
            color: var(--sidebar-text);
            background: rgba(99,102,241,0.15);
            border-left-color: #6366f1;
            box-shadow: 0 0 30px rgba(99,102,241,0.2);
        }

        .nav-link i {
            width: 28px;
            font-size: 1.05rem;
            margin-right: 0.85rem;
            transition: transform 0.3s;
        }

        .nav-link:hover i { transform: scale(1.2); }

        .theme-switcher {
            padding: 0.95rem 1.5rem;
            border-top: 1px solid var(--sidebar-border);
            margin-top: auto;
        }

        .theme-label {
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 0.09em;
            color: var(--sidebar-text-light);
            margin-bottom: 0.65rem;
            font-weight: 600;
        }

        .theme-row {
            display: flex;
            gap: 0.48rem;
        }

        .theme-btn {
            flex: 1;
            padding: 0.55rem;
            border-radius: 8px;
            border: 2px solid var(--sidebar-border);
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--sidebar-text-light);
            background: transparent;
        }

        .theme-btn:hover {
            border-color: var(--sidebar-primary);
            transform: translateY(-2px);
        }

        .theme-btn.active {
            border-color: var(--sidebar-primary);
            background: rgba(99,102,241,0.15);
            color: var(--sidebar-primary-light);
        }
        
        .sidebar-theme-btn {
            flex: 1;
            padding: 0.45rem;
            border-radius: 6px;
            border: 2px solid var(--sidebar-border);
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            font-size: 0.65rem;
            font-weight: 600;
            color: var(--sidebar-text-light);
            background: transparent;
        }
        
        .sidebar-theme-btn:hover {
            border-color: var(--sidebar-primary);
            transform: translateY(-2px);
        }
        
        .sidebar-theme-btn.active {
            border-color: var(--sidebar-primary);
            background: rgba(99,102,241,0.15);
            color: var(--sidebar-primary-light);
        }

        /* MAIN CONTENT STYLES */
        .main-content {
            padding: 30px;
            max-width: 100%;
        }

        .top-bar {
            background: var(--bg-card);
            padding: 16px 24px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 1px solid var(--border);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .top-bar::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, rgba(99,102,241,0.05), transparent);
            opacity: 0;
            transition: opacity 0.3s;
            pointer-events: none;
        }

        .top-bar:hover::before {
            opacity: 1;
        }

        .top-bar:hover {
            box-shadow: 0 4px 20px rgba(99,102,241,0.15);
        }

        .breadcrumb {
            color: var(--text-light);
            font-size: 14px;
        }

        .breadcrumb span {
            color: var(--text-main);
            font-weight: 500;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 24px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            inset: -40%;
            background: radial-gradient(circle at top left, rgba(99,102,241,0.15), transparent 60%);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .stat-card:hover::before {
            opacity: 1;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 40px rgba(99,102,241,0.2);
        }

        .stat-card:active {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(99,102,241,0.15);
        }

        .stat-label {
            font-size: 13px;
            color: var(--text-light);
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-main);
        }

        .filter-bar {
            background: var(--bg-card);
            padding: 16px 24px;
            border-radius: 12px 12px 0 0;
            border: 1px solid var(--border);
            border-bottom: none;
            display: flex;
            gap: 16px;
            align-items: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .filter-bar::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, rgba(99,102,241,0.05), transparent);
            opacity: 0;
            transition: opacity 0.3s;
            pointer-events: none;
        }

        .filter-bar:hover::before {
            opacity: 1;
        }

        .search-box {
            flex: 1;
        }

        .search-box input {
            width: 100%;
            padding: 10px 16px;
            background: var(--bg-body);
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text-main);
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-box input::placeholder {
            color: var(--text-light);
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        select {
            padding: 10px 16px;
            background: var(--bg-body);
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text-main);
            font-size: 14px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        select:hover {
            border-color: var(--primary-light);
            box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.05);
        }

        select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        select option {
            background: var(--bg-card);
            color: var(--text-main);
            padding: 8px;
        }

        .table-container {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 0 0 12px 12px;
            overflow-x: auto;
            transition: all 0.3s ease;
            position: relative;
        }

        .table-container:hover {
            box-shadow: 0 12px 40px rgba(99,102,241,0.2);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: var(--bg-header);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        th {
            padding: 16px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: var(--text-light);
            text-transform: uppercase;
            white-space: nowrap;
        }

        td {
            padding: 16px;
            border-top: 1px solid var(--border);
            font-size: 14px;
            color: var(--text-main);
            white-space: nowrap;
        }

        tbody tr:hover {
            background: rgba(99,102,241,0.05);
            transform: scale(1.001);
            box-shadow: 0 2px 8px rgba(99,102,241,0.1);
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        .course-info {
            display: flex;
            gap: 12px;
            align-items: center;
            min-width: 350px;
        }

        .course-thumb {
            width: 80px;
            height: 50px;
            border-radius: 6px;
            object-fit: cover;
            transition: all 0.3s ease;
            cursor: pointer;
            flex-shrink: 0;
        }

        .course-thumb:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
            z-index: 10;
        }

        .course-id {
            font-size: 11px;
            color: var(--text-light);
            font-family: monospace;
        }

        .course-title {
            font-weight: 600;
            color: var(--text-main);
            margin: 4px 0;
            max-width: 220px;
            white-space: normal;
            line-height: 1.3;
        }

        .category-badge {
            display: inline-block;
            padding: 4px 10px;
            background: rgba(99, 102, 241, 0.15);
            color: var(--primary-light);
            border-radius: 4px;
            font-size: 11px;
            transition: all 0.2s ease;
            cursor: default;
        }

        .category-badge:hover {
            background: rgba(99, 102, 241, 0.25);
            transform: scale(1.05);
        }

        .instructor-info {
            display: flex;
            gap: 10px;
            align-items: center;
            min-width: 200px;
        }

        .instructor-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            transition: all 0.3s ease;
            flex-shrink: 0;
        }

        .instructor-info:hover .instructor-avatar {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
        }

        .instructor-name {
            font-weight: 600;
            color: var(--text-main);
            white-space: normal;
            max-width: 140px;
            line-height: 1.3;
        }

        .metadata-cell {
            min-width: 120px;
        }

        .submitted-cell {
            min-width: 130px;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            transition: all 0.2s ease;
            cursor: default;
        }

        .status-badge:hover {
            transform: scale(1.05);
        }

        .status-pending, .status-draft {
            background: rgba(245, 158, 11, 0.15);
            color: var(--warning);
        }

        .status-approved {
            background: rgba(16, 185, 129, 0.15);
            color: var(--success);
        }

        .status-rejected {
            background: rgba(239, 68, 68, 0.15);
            color: var(--danger);
        }

        .btn-review {
            background: var(--primary);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            position: relative;
            overflow: hidden;
        }

        .btn-review::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }

        .btn-review:hover::before {
            transform: translateX(100%);
        }

        .btn-review:hover {
            background: var(--primary-light);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4);
        }

        .btn-review:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.3);
        }

        .btn-review i {
            transition: transform 0.3s ease;
        }

        .btn-review:hover i {
            transform: scale(1.2);
        }

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            backdrop-filter: blur(4px);
            z-index: 1001;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .review-modal {
            background: var(--bg-card);
            width: 90%;
            max-width: 1000px;
            max-height: 90vh;
            border-radius: 16px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            border: 1px solid var(--border);
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
        }

        .modal-header {
            padding: 24px;
            border-bottom: 1px solid var(--border);
        }

        .modal-header h2 {
            color: var(--text-main);
        }

        .modal-body {
            padding: 24px;
            overflow-y: auto;
            flex: 1;
            color: var(--text-main);
        }

        .modal-body h3 {
            color: var(--text-main);
            margin-bottom: 16px;
            margin-top: 24px;
        }

        .modal-body h3:first-child {
            margin-top: 0;
        }

        .modal-body p {
            color: var(--text-light);
            line-height: 1.6;
            margin-bottom: 12px;
        }

        .modal-body strong {
            color: var(--text-main);
        }

        .verification-checklist {
            background: rgba(99, 102, 241, 0.05);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }

        .checklist-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 8px;
        }

        .checklist-subtitle {
            font-size: 13px;
            color: var(--text-light);
            margin-bottom: 16px;
        }

        .checklist-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 8px;
            margin-bottom: 8px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .checklist-item:hover {
            background: rgba(99, 102, 241, 0.05);
            border-color: var(--primary);
        }

        .checklist-item input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: var(--primary);
        }

        .checklist-item label {
            flex: 1;
            cursor: pointer;
            color: var(--text-main);
            font-size: 14px;
        }

        .modal-footer {
            padding: 24px;
            border-top: 1px solid var(--border);
            display: flex;
            gap: 12px;
        }

        .btn-approve {
            flex: 1;
            background: var(--success);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
            overflow: hidden;
        }

        .btn-approve::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }

        .btn-approve:hover::before {
            transform: translateX(100%);
        }

        .btn-approve:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.4);
        }

        .btn-approve:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.3);
        }

        .btn-reject {
            flex: 1;
            background: var(--danger);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
            overflow: hidden;
        }

        .btn-reject::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }

        .btn-reject:hover::before {
            transform: translateX(100%);
        }

        .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        }

        .btn-reject:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
        }

        .btn-close {
            background: #64748b;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
            overflow: hidden;
        }

        .btn-close::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
            transform: translateX(-100%);
            transition: transform 0.6s;
        }

        .btn-close:hover::before {
            transform: translateX(100%);
        }

        .btn-close:hover {
            background: #475569;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(100, 116, 139, 0.4);
        }

        .btn-close:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(100, 116, 139, 0.3);
        }

        @media (max-width: 900px) {
            .sidebar {
                margin-left: -280px;
            }
            .sidebar.open {
                margin-left: 0;
            }
            body {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <!-- SIDEBAR -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-brand">
            <i class="fas fa-graduation-cap"></i>
            <span>EduMaster</span>
        </div>
        
        <div class="nav-section">
            <!-- Dashboard -->
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                <i class="fas fa-th-large"></i> Dashboard
            </a>

            <!-- MANAGEMENT Section -->
            <div class="nav-section-title">Management</div>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                <i class="fas fa-users"></i> User Management
            </a>
            <a href="${pageContext.request.contextPath}/admin/courses" class="nav-link active">
                <i class="fas fa-book-open"></i> Course Approval
            </a>
            <a href="${pageContext.request.contextPath}/admin/instructors" class="nav-link">
                <i class="fas fa-chalkboard-teacher"></i> Instructors
            </a>

            <!-- FINANCE Section -->
            <div class="nav-section-title">Finance</div>
            <a href="${pageContext.request.contextPath}/admin/transactions" class="nav-link">
                <i class="fas fa-exchange-alt"></i> Transactions
            </a>
            <a href="${pageContext.request.contextPath}/admin/payouts" class="nav-link">
                <i class="fas fa-wallet"></i> Payouts
            </a>
            <a href="${pageContext.request.contextPath}/admin/refunds" class="nav-link">
                <i class="fas fa-undo"></i> Refunds
            </a>

            <!-- SYSTEM Section -->
            <div class="nav-section-title">System</div>
            <a href="${pageContext.request.contextPath}/admin/settings" class="nav-link">
                <i class="fas fa-cog"></i> Settings
            </a>
            <a href="${pageContext.request.contextPath}/admin/audit-logs" class="nav-link">
                <i class="fas fa-history"></i> Audit Logs
            </a>
        </div>
        
        <!-- THEME SWITCHER -->
        <div class="theme-switcher">
            <!-- Page Theme -->
            <div class="theme-label">Page Theme</div>
            <div class="theme-row">
                <button class="theme-btn" data-theme="theme1" onclick="setTheme('theme1', this)">
                    <i class="fas fa-moon"></i>
                </button>
                <button class="theme-btn" data-theme="theme2" onclick="setTheme('theme2', this)">
                    <i class="fas fa-star"></i>
                </button>
                <button class="theme-btn" data-theme="theme3" onclick="setTheme('theme3', this)">
                    <i class="fas fa-sun"></i>
                </button>
            </div>
            
            <!-- Sidebar Theme -->
            <div class="theme-label" style="margin-top: 0.75rem;">Sidebar</div>
            <div class="theme-row">
                <button class="sidebar-theme-btn" data-sidebar="normal" onclick="setSidebarTheme('normal', this)">
                    Normal
                </button>
                <button class="sidebar-theme-btn" data-sidebar="dark" onclick="setSidebarTheme('dark', this)">
                    Extra Dark
                </button>
            </div>
        </div>
    </nav>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="top-bar">
            <div class="breadcrumb">Management / <span>Course Verification</span></div>
            <div>Admin Dashboard</div>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Pending Approval</div>
                <div class="stat-value">${pendingCourses}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Published</div>
                <div class="stat-value">${approvedCourses}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Courses</div>
                <div class="stat-value">${totalCount}</div>
            </div>
        </div>

        <div class="filter-bar">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search by course ID, title or instructor...">
            </div>
            <select id="statusFilter" onchange="filterByStatus()">
                <option value="ALL">Status: All</option>
                <option value="DRAFT">Pending</option>
                <option value="APPROVED">Approved</option>
                <option value="REJECTED">Rejected</option>
            </select>
            <select id="categoryFilter" onchange="filterByCategory()">
                <option value="ALL">Category: All</option>
                <option value="Development">Development</option>
                <option value="Design">Design</option>
                <option value="Data Science">Data Science</option>
            </select>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>COURSE DETAILS</th>
                        <th>INSTRUCTOR</th>
                        <th>METADATA</th>
                        <th>SUBMITTED</th>
                        <th>STATUS</th>
                        <th>ACTION</th>
                    </tr>
                </thead>
                <tbody id="courseTableBody">
                <c:forEach var="course" items="${courses}">
				   <c:if test="${course.status != 'DRAFT'}">
				   <tr data-course-id="${course.id}" data-status="${course.status}" data-category="${course.category}">            
                            <td>
                                <div class="course-info">
                                    <img src="${course.thumbnailUrl}" class="course-thumb" alt="${course.title}">
                                    <div>
                                        <div class="course-id">#CRS-${course.id}</div>
                                        <div class="course-title">${course.title}</div>
                                        <span class="category-badge">${course.category}</span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="instructor-info">
                                    <c:choose>
                                        <c:when test="${not empty course.instructorPhotoUrl}">
                                            <img src="${course.instructorPhotoUrl}" class="instructor-avatar" alt="Instructor">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="instructor-avatar" style="background:#7c3aed; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold; font-size:14px;">
                                                ${fn:toUpperCase(fn:substring(course.instructorName, 0, 2))}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="instructor-name">${course.instructorName}</div>
                                </div>
                            </td>
                            <td class="metadata-cell">
                                <div><strong>${course.lecturesCount != null ? course.lecturesCount : 0}</strong> Lectures</div>
                                <div style="color:var(--text-light);">${course.totalDuration != null ? course.totalDuration : '0h 0m'}</div>
                            </td>
                            <td class="submitted-cell">
                                <div style="font-weight:500;">
                                    ${fn:substring(course.createdAt, 0, 10)}
                                </div>
                                <div style="color:var(--text-light); font-size:12px;">
                                    ${fn:substring(course.createdAt, 11, 16)}
                                </div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${course.status == 'DRAFT'}">
                                        <span class="status-badge status-pending">Pending</span>
                                    </c:when>
                                    <c:when test="${course.status == 'APPROVED'}">
                                        <span class="status-badge status-approved">Approved</span>
                                    </c:when>
                                    <c:when test="${course.status == 'REJECTED'}">
                                        <span class="status-badge status-rejected">Rejected</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-draft">${course.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button class="btn-review" onclick="openReview(${course.id})">
                                    <i class="fa-solid fa-eye"></i> Review
                                </button>
                            </td>
                        </tr>
                       </c:if>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Review Modal -->
    <div id="reviewModal" class="modal-overlay">
        <div class="review-modal">
            <div class="modal-header">
                <h2 id="modalTitle">Course Review</h2>
            </div>
            <div class="modal-body" id="modalBody">
                <p>Loading course details...</p>
            </div>
            <div class="modal-footer">
                <button class="btn-close" onclick="closeModal()">Close</button>
                <button class="btn-reject" onclick="rejectCourse()">Reject</button>
                <button class="btn-approve" onclick="approveCourse()">Approve</button>
            </div>
        </div>
    </div>

    <script>
        let currentCourseId = null;

        // Theme Functions
        function setTheme(theme, btn) {
            document.documentElement.setAttribute('data-theme', theme);
            localStorage.setItem('edumaster-theme', theme);
            
            document.querySelectorAll('.theme-btn').forEach(function(b) { b.classList.remove('active'); });
            if(btn) btn.classList.add('active');
        }
        
        function setSidebarTheme(sidebarTheme, btn) {
            document.documentElement.setAttribute('data-sidebar', sidebarTheme);
            localStorage.setItem('edumaster-sidebar-theme', sidebarTheme);
            
            document.querySelectorAll('.sidebar-theme-btn').forEach(function(b) { b.classList.remove('active'); });
            if(btn) btn.classList.add('active');
        }

        // Load saved themes on page load
        (function() {
            var savedTheme = localStorage.getItem('edumaster-theme') || 'theme1';
            document.documentElement.setAttribute('data-theme', savedTheme);
            
            document.querySelectorAll('.theme-btn').forEach(function(btn) {
                if (btn.dataset.theme === savedTheme) {
                    btn.classList.add('active');
                }
            });
            
            var savedSidebarTheme = localStorage.getItem('edumaster-sidebar-theme') || 'normal';
            document.documentElement.setAttribute('data-sidebar', savedSidebarTheme);
            
            document.querySelectorAll('.sidebar-theme-btn').forEach(function(btn) {
                if (btn.dataset.sidebar === savedSidebarTheme) {
                    btn.classList.add('active');
                }
            });
        })();

        // Helper function to extract YouTube video ID
        function getYouTubeVideoId(url) {
            if (!url) return null;
            
            // Handle different YouTube URL formats
            var patterns = [
                /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^&\n?#]+)/,
                /youtube\.com\/watch\?.*v=([^&\n?#]+)/
            ];
            
            for (var i = 0; i < patterns.length; i++) {
                var match = url.match(patterns[i]);
                if (match && match[1]) {
                    return match[1];
                }
            }
            return null;
        }

        // Course Review Functions
        function openReview(courseId) {
            currentCourseId = courseId;
            fetch('/admin/courses/' + courseId)
                .then(function(response) { return response.json(); })
                .then(function(course) {
                    document.getElementById('modalTitle').textContent = course.title;
                    
                    // Extract YouTube video ID
                    var videoId = getYouTubeVideoId(course.previewVideoUrl);
                    var videoPreview = '';
                    
                    if (videoId) {
                        videoPreview = '<div style="margin-bottom: 24px;">' +
                            '<h3 style="margin-bottom: 12px;">Video Preview</h3>' +
                            '<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; border-radius: 12px; background: #000;">' +
                                '<iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; border: 0;" ' +
                                    'src="https://www.youtube.com/embed/' + videoId + '" ' +
                                    'frameborder="0" ' +
                                    'allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" ' +
                                    'allowfullscreen>' +
                                '</iframe>' +
                            '</div>' +
                        '</div>';
                    }
                    
                    var modalContent = videoPreview +
                        '<div class="verification-checklist">' +
                            '<div class="checklist-title">Verification Checklist</div>' +
                            '<div class="checklist-subtitle">Mandatory checks before approval</div>' +
                            '<div class="checklist-item">' +
                                '<input type="checkbox" id="check1">' +
                                '<label for="check1">Video Audio Quality > 128kbps</label>' +
                            '</div>' +
                            '<div class="checklist-item">' +
                                '<input type="checkbox" id="check2">' +
                                '<label for="check2">Resolution 1080p or Higher</label>' +
                            '</div>' +
                            '<div class="checklist-item">' +
                                '<input type="checkbox" id="check3">' +
                                '<label for="check3">No Offensive Content</label>' +
                            '</div>' +
                            '<div class="checklist-item">' +
                                '<input type="checkbox" id="check4">' +
                                '<label for="check4">Thumbnail follows guidelines</label>' +
                            '</div>' +
                        '</div>' +
                        '<h3>Course Information</h3>' +
                        '<p><strong>Category:</strong> ' + course.category + '</p>' +
                        '<p><strong>Level:</strong> ' + course.level + '</p>' +
                        '<p><strong>Language:</strong> ' + course.language + '</p>' +
                        '<p><strong>Price:</strong> ' + course.currency + ' ' + course.price + '</p>' +
                        '<p><strong>Instructor:</strong> ' + course.instructorName + '</p>';
                    
                    if (course.learningOutcomes) {
                        modalContent += '<p><strong>Learning Outcomes:</strong></p>' +
                            '<p style="white-space: pre-line;">' + course.learningOutcomes + '</p>';
                    }
                    
                    if (course.prerequisites) {
                        modalContent += '<p><strong>Prerequisites:</strong></p>' +
                            '<p style="white-space: pre-line;">' + course.prerequisites + '</p>';
                    }
                    
                    if (course.targetAudience) {
                        modalContent += '<p><strong>Target Audience:</strong></p>' +
                            '<p style="white-space: pre-line;">' + course.targetAudience + '</p>';
                    }
                    
                    modalContent += '<p><strong>Description:</strong></p>' +
                        '<p>' + course.description + '</p>';
                    
                    document.getElementById('modalBody').innerHTML = modalContent;
                    document.getElementById('reviewModal').style.display = 'flex';
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    alert('Failed to load course details');
                });
        }

        function closeModal() {
            document.getElementById('reviewModal').style.display = 'none';
            currentCourseId = null;
        }

        function approveCourse() {
            if(!confirm('Are you sure you want to approve this course?')) return;
            
            fetch('/admin/courses/' + currentCourseId + '/approve', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' }
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if(data.success) {
                    alert('Course approved successfully!');
                    location.reload();
                } else {
                    alert('Failed to approve course');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                alert('Failed to approve course');
            });
        }

        function rejectCourse() {
            var reason = prompt('Enter rejection reason:');
            if(!reason) return;
            
            fetch('/admin/courses/' + currentCourseId + '/reject', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ reason: reason })
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if(data.success) {
                    alert('Course rejected successfully!');
                    location.reload();
                } else {
                    alert('Failed to reject course');
                }
            })
            .catch(function(error) {
                console.error('Error:', error);
                alert('Failed to reject course');
            });
        }

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            var searchTerm = e.target.value.toLowerCase();
            var rows = document.querySelectorAll('#courseTableBody tr');
            
            rows.forEach(function(row) {
                var text = row.textContent.toLowerCase();
                row.style.display = text.indexOf(searchTerm) !== -1 ? '' : 'none';
            });
        });

        function filterByStatus() {
            var status = document.getElementById('statusFilter').value;
            var rows = document.querySelectorAll('#courseTableBody tr');
            
            rows.forEach(function(row) {
                if(status === 'ALL' || row.dataset.status === status) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function filterByCategory() {
            var category = document.getElementById('categoryFilter').value;
            var rows = document.querySelectorAll('#courseTableBody tr');
            
            rows.forEach(function(row) {
                if(category === 'ALL' || row.dataset.category === category) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('reviewModal')) {
                closeModal();
            }
        }
    </script>
</body>
</html>
