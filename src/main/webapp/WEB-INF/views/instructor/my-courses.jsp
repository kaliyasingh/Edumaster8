<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="my-courses" scope="request"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Courses | EduMaster</title>

    <!-- FOUC Prevention: hide until CSS ready -->
    <style>html{visibility:hidden}</style>

    <!-- Inter font: only weights actually used, display=swap prevents FOIT -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"></noscript>

    <!-- Font Awesome: load async — icons appear after page, no page-block -->
    <link rel="preload" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"></noscript>

    <style>
        :root {
            --bg:#0f172a;
            --surface:rgba(30,41,59,0.6);
            --surface2:rgba(15,23,42,0.6);
            --border:rgba(99,102,241,0.15);
            --accent:#6366f1; --accent2:#818cf8;
            --green:#10b981; --amber:#f59e0b; --red:#ef4444;
            --slate:#64748b; --text:#e2e8f0; --muted:#94a3b8;
        }
        *{margin:0;padding:0;box-sizing:border-box}
        body{font-family:'Inter',sans-serif;background:#0f172a;color:var(--text);overflow-x:hidden}
        .animated-bg{position:fixed;inset:0;z-index:0;pointer-events:none}
        .animated-bg::before,.animated-bg::after{content:'';position:absolute;border-radius:50%;animation:float 20s ease-in-out infinite}
        .animated-bg::before{width:500px;height:500px;background:radial-gradient(circle,rgba(99,102,241,0.15) 0%,transparent 70%);top:-250px;right:-250px}
        .animated-bg::after{width:400px;height:400px;background:radial-gradient(circle,rgba(16,185,129,0.1) 0%,transparent 70%);bottom:-200px;left:-200px;animation-duration:15s;animation-direction:reverse}
        @keyframes float{0%,100%{transform:translate(0,0) scale(1)}33%{transform:translate(100px,-100px) scale(1.1)}66%{transform:translate(-50px,100px) scale(0.9)}}
        

        /* ── Sidebar — loaded via sidebar.jsp ── */

        /* ── Main ── */
        .main-content{margin-left:280px;padding:2rem 2.5rem;min-height:100vh;position:relative;z-index:1}
        .page-header{background:linear-gradient(135deg,#312e81 0%,#1e1b4b 60%,#0f172a 100%);border-radius:20px;padding:2.25rem 2.5rem;margin-bottom:2rem;border:1px solid rgba(99,102,241,0.25);position:relative;overflow:hidden;animation:slideDown 0.5s ease}
        @keyframes slideDown{from{opacity:0;transform:translateY(-20px)}to{opacity:1;transform:translateY(0)}}
        .page-header::after{content:'';position:absolute;right:-80px;top:-80px;width:280px;height:280px;background:radial-gradient(circle,rgba(99,102,241,0.25) 0%,transparent 70%);border-radius:50%}
        .header-content{position:relative;z-index:1;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:1rem}
        .header-title{font-size:2rem;font-weight:800;letter-spacing:-0.03em;margin-bottom:0.35rem}
        .header-sub{color:#a5b4fc;font-size:0.95rem}
        .btn-primary{padding:0.8rem 1.5rem;background:linear-gradient(135deg,#6366f1,#4f46e5);color:white;border:none;border-radius:12px;font-weight:600;cursor:pointer;transition:all 0.3s;display:flex;align-items:center;gap:0.5rem;font-family:'Inter',sans-serif;font-size:0.9rem;box-shadow:0 4px 15px rgba(99,102,241,0.4);text-decoration:none}
        .btn-primary:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(99,102,241,0.5)}

        /* ── Stats ── */
        .stats-row{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:1.25rem;margin-bottom:2rem}
        .stat-card{background:var(--surface);border-radius:16px;padding:1.5rem;border:1px solid var(--border);transition:all 0.35s;animation:fadeUp 0.6s ease both}
        .stat-card:nth-child(1){animation-delay:.05s}.stat-card:nth-child(2){animation-delay:.1s}.stat-card:nth-child(3){animation-delay:.15s}.stat-card:nth-child(4){animation-delay:.2s}
        @keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
        .stat-card:hover{border-color:var(--accent);transform:translateY(-5px);box-shadow:0 10px 30px rgba(99,102,241,0.25)}
        .stat-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:1rem}
        .stat-icon{width:48px;height:48px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.35rem}
        .stat-number{font-size:1.6rem;font-weight:800;letter-spacing:-0.03em}
        .stat-label{color:var(--muted);font-size:0.8rem;font-weight:600;text-transform:uppercase;letter-spacing:0.08em;margin-top:0.2rem}
        .stat-trend{font-size:0.8rem;margin-top:0.75rem;display:inline-flex;align-items:center;gap:0.3rem;padding:0.2rem 0.65rem;border-radius:20px}
        .trend-up{background:rgba(16,185,129,0.15);color:#34d399}
        .trend-info{background:rgba(245,158,11,0.15);color:#fbbf24}

        /* ── Filter ── */
        .filter-bar{background:var(--surface);border-radius:16px;padding:1.25rem 1.5rem;margin-bottom:2rem;border:1px solid var(--border);animation:fadeUp 0.6s 0.25s both}
        .filter-group{display:flex;gap:1rem;align-items:center;flex-wrap:wrap}
        .search-wrapper{position:relative;flex:1;min-width:240px}
        .search-icon{position:absolute;left:1rem;top:50%;transform:translateY(-50%);color:var(--slate);pointer-events:none;font-size:0.85rem}
        .search-input{width:100%;padding:0.8rem 1rem 0.8rem 2.75rem;border:1px solid var(--border);border-radius:10px;background:var(--bg);color:var(--text);transition:all 0.25s;font-family:'Inter',sans-serif;font-size:0.9rem}
        .search-input:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px rgba(99,102,241,0.15)}
        .search-input::placeholder{color:var(--slate)}
        .filter-select{padding:0.8rem 1rem;border:1px solid var(--border);border-radius:10px;background:var(--bg);color:var(--text);font-weight:500;transition:all 0.25s;cursor:pointer;font-family:'Inter',sans-serif;font-size:0.875rem}
        .filter-select:focus{outline:none;border-color:var(--accent)}

        /* ── Legend ── */
        .status-legend{display:flex;gap:1.5rem;align-items:center;flex-wrap:wrap;margin-bottom:1.25rem;padding:1rem 1.5rem;background:var(--surface2);border-radius:12px;border:1px solid var(--border);animation:fadeUp 0.6s 0.3s both}
        .legend-title{font-size:0.78rem;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.1em}
        .legend-item{display:flex;align-items:center;gap:0.5rem;font-size:0.82rem;color:var(--muted)}
        .legend-dot{width:10px;height:10px;border-radius:50%}

        /* ── Course Cards ── */
        .courses-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:1.75rem;margin-bottom:2rem}
        .course-card{background:var(--surface);border-radius:18px;overflow:hidden;border:1px solid var(--border);transition:all 0.35s;animation:fadeUp 0.6s ease both}
        .course-card:hover{border-color:var(--accent2);transform:translateY(-6px);box-shadow:0 16px 40px rgba(99,102,241,0.2)}
        .thumb-wrapper{position:relative;overflow:hidden}
        .course-thumbnail{width:100%;height:175px;object-fit:cover;display:block;transition:transform 0.5s}
        .thumb-placeholder{width:100%;height:175px;background:linear-gradient(135deg,#312e81,#1e1b4b);display:flex;align-items:center;justify-content:center;font-size:3rem;color:rgba(255,255,255,0.15)}
        .course-card:hover .course-thumbnail{transform:scale(1.05)}
        .thumb-overlay{position:absolute;inset:0;background:linear-gradient(to top,rgba(10,15,30,0.7) 0%,transparent 50%)}
        .course-status-badge{position:absolute;top:0.85rem;right:0.85rem;padding:0.4rem 0.85rem;border-radius:20px;font-size:0.75rem;font-weight:700;z-index:2;display:flex;align-items:center;gap:0.35rem;backdrop-filter:blur(12px);border:1px solid rgba(255,255,255,0.15)}
        .badge-LIVE{background:rgba(16,185,129,0.85);color:#fff}
        .badge-DRAFT{background:rgba(100,116,139,0.85);color:#fff}
        .badge-PENDING{background:rgba(245,158,11,0.85);color:#fff}
        .badge-REJECTED{background:rgba(239,68,68,0.85);color:#fff}
        .status-dot{width:7px;height:7px;border-radius:50%;background:currentColor}
        .badge-LIVE .status-dot{animation:blink 1.5s ease-in-out infinite}
        @keyframes blink{0%,100%{opacity:1}50%{opacity:0.3}}
        .status-info-bar{padding:0.5rem 1.25rem;font-size:0.76rem;font-weight:500;display:flex;align-items:center;gap:0.5rem;border-bottom:1px solid var(--border)}
        .sib-LIVE{background:rgba(16,185,129,0.08);color:#34d399}
        .sib-DRAFT{background:rgba(100,116,139,0.08);color:#94a3b8}
        .sib-PENDING{background:rgba(245,158,11,0.1);color:#fbbf24}
        .sib-REJECTED{background:rgba(239,68,68,0.08);color:#f87171}
        .course-info{padding:1.25rem}
        .course-top{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:0.6rem}
        .course-category-tag{display:inline-block;padding:0.25rem 0.7rem;background:rgba(99,102,241,0.15);color:var(--accent2);border-radius:20px;font-size:0.72rem;font-weight:700;text-transform:uppercase;letter-spacing:0.06em}
        .course-title{font-size:1rem;font-weight:700;margin-bottom:0.65rem;line-height:1.4;letter-spacing:-0.01em}
        .course-meta{display:flex;gap:1rem;margin-bottom:1rem;color:var(--muted);font-size:0.8rem;flex-wrap:wrap}
        .course-meta span{display:flex;align-items:center;gap:0.3rem}
        .course-stats-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:0.5rem;margin-bottom:1rem}
        .stat-box{background:var(--bg);border-radius:10px;padding:0.65rem;text-align:center;border:1px solid var(--border)}
        .stat-box-value{font-size:1rem;font-weight:700}
        .stat-box-label{font-size:0.68rem;color:var(--muted);margin-top:0.15rem;text-transform:uppercase;letter-spacing:0.05em}
        .course-actions{display:flex;gap:0.5rem}
        .btn-action{flex:1;padding:0.65rem 0.5rem;border:1px solid var(--border);background:transparent;color:var(--muted);border-radius:10px;font-weight:600;cursor:pointer;transition:all 0.25s;display:flex;align-items:center;justify-content:center;gap:0.4rem;font-family:'Inter',sans-serif;font-size:0.82rem;text-decoration:none}
        .btn-edit{border-color:rgba(245,158,11,0.3)}.btn-edit:hover{border-color:#f59e0b;background:rgba(245,158,11,0.1);color:#fbbf24;transform:translateY(-2px)}
        .btn-view{border-color:rgba(59,130,246,0.3)}.btn-view:hover{border-color:#3b82f6;background:rgba(59,130,246,0.1);color:#60a5fa;transform:translateY(-2px)}
        .btn-preview{border-color:rgba(139,92,246,0.3)}.btn-preview:hover{border-color:#8b5cf6;background:rgba(139,92,246,0.1);color:#a78bfa;transform:translateY(-2px)}
        .btn-details{border-color:rgba(245,158,11,0.3)}.btn-details:hover{border-color:#f59e0b;background:rgba(245,158,11,0.1);color:#fbbf24;transform:translateY(-2px)}
        .wf-submit{width:100%;margin-top:0.65rem;padding:0.62rem;border-radius:10px;font-weight:700;cursor:pointer;transition:all 0.25s;display:flex;align-items:center;justify-content:center;gap:0.5rem;font-family:'Inter',sans-serif;font-size:0.8rem;border:1px dashed rgba(99,102,241,0.5);color:var(--accent2);background:rgba(99,102,241,0.07)}
        .wf-submit:hover{background:rgba(99,102,241,0.18);border-color:var(--accent)}
        .wf-resubmit{border-color:rgba(239,68,68,0.4)!important;color:#f87171!important;background:rgba(239,68,68,0.05)!important}
        .wf-resubmit:hover{background:rgba(239,68,68,0.12)!important;border-color:#ef4444!important}

        /* ── Empty ── */
        .empty-state{text-align:center;padding:4rem 2rem;background:var(--surface);border-radius:16px;border:1px solid var(--border)}
        .empty-state i{font-size:4rem;margin-bottom:1rem;opacity:0.3;display:block}
        .empty-state h3{font-size:1.4rem;margin-bottom:0.5rem}
        .empty-state p{color:var(--muted);margin-bottom:1.5rem}

        /* ── Toast ── */
        .toast{position:fixed;bottom:2rem;right:2rem;background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:0.9rem 1.4rem;border-radius:12px;box-shadow:0 8px 30px rgba(0,0,0,0.4);z-index:9999;transform:translateY(100px);opacity:0;transition:all 0.35s;font-size:0.875rem;display:flex;align-items:center;gap:0.6rem;max-width:320px}
        .toast.show{transform:translateY(0);opacity:1}

        /* ── Alert ── */
        .alert{padding:1rem 1.5rem;border-radius:12px;margin-bottom:1.5rem;display:flex;align-items:center;gap:0.75rem;font-size:0.9rem;font-weight:500;animation:fadeUp 0.4s ease;transition:opacity 0.6s ease,transform 0.6s ease,margin 0.4s ease,padding 0.4s ease,max-height 0.4s ease;overflow:hidden;max-height:100px}
        .alert.hide{opacity:0;transform:translateY(-10px);max-height:0;margin-bottom:0;padding-top:0;padding-bottom:0}
        .alert-success{background:rgba(16,185,129,0.12);border:1px solid rgba(16,185,129,0.3);color:#34d399}
        .alert-error{background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);color:#f87171}

        /* SHARED MODAL BASE */
        .modal-overlay{position:fixed;inset:0;background:rgba(5,8,20,0.88);backdrop-filter:blur(10px);z-index:6000;display:flex;align-items:center;justify-content:center;padding:1.5rem;opacity:0;pointer-events:none;transition:opacity 0.3s}
        .modal-overlay.open{opacity:1;pointer-events:all}
        .modal{background:var(--surface);border:1px solid var(--border);border-radius:22px;width:100%;max-width:660px;max-height:92vh;overflow-y:auto;box-shadow:0 30px 90px rgba(0,0,0,0.7);transform:translateY(28px) scale(0.97);transition:all 0.35s cubic-bezier(0.34,1.56,0.64,1)}
        .modal-overlay.open .modal{transform:translateY(0) scale(1)}
        .modal-header{padding:1.75rem 2rem 1.25rem;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;position:sticky;top:0;background:var(--surface);z-index:10;border-radius:22px 22px 0 0}
        .modal-eyebrow{font-size:0.68rem;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;margin-bottom:0.35rem}
        .modal-title-text{font-size:1.2rem;font-weight:800;letter-spacing:-0.02em;line-height:1.3;word-break:break-word}
        .modal-close{background:var(--surface2);border:1px solid var(--border);color:var(--muted);width:36px;height:36px;border-radius:10px;cursor:pointer;font-size:0.95rem;display:flex;align-items:center;justify-content:center;transition:all 0.2s;flex-shrink:0}
        .modal-close:hover{color:#f87171;border-color:var(--red);background:rgba(239,68,68,0.1)}
        .modal-body{padding:1.75rem 2rem}
        .modal-footer{padding:1.2rem 2rem;border-top:1px solid var(--border);background:var(--surface);position:sticky;bottom:0;display:flex;gap:0.75rem;border-radius:0 0 22px 22px}

        /* EDIT MODAL */
        .status-pill{display:inline-flex;align-items:center;gap:0.4rem;padding:0.3rem 0.85rem;border-radius:20px;font-size:0.75rem;font-weight:700}
        .sp-LIVE{background:rgba(16,185,129,0.15);color:#34d399;border:1px solid rgba(16,185,129,0.3)}
        .sp-DRAFT{background:rgba(100,116,139,0.15);color:#94a3b8;border:1px solid rgba(100,116,139,0.3)}
        .sp-REJECTED{background:rgba(239,68,68,0.12);color:#f87171;border:1px solid rgba(239,68,68,0.3)}

        .thumb-section-label{font-size:0.7rem;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent2);display:flex;align-items:center;gap:0.4rem;margin-bottom:0.85rem}

        /* Drop zone */
        .drop-zone{border:2px dashed rgba(99,102,241,0.28);border-radius:12px;padding:1.4rem;text-align:center;cursor:pointer;transition:all 0.25s;background:rgba(99,102,241,0.03)}
        .drop-zone:hover,.drop-zone.drag-over{border-color:var(--accent);background:rgba(99,102,241,0.09)}
        .drop-zone i{font-size:1.9rem;color:rgba(99,102,241,0.38);margin-bottom:0.4rem;display:block}
        .drop-title{font-size:0.86rem;font-weight:600;color:var(--muted);margin-bottom:0.2rem}
        .drop-sub{font-size:0.72rem;color:var(--slate)}
        .drop-zone input[type=file]{display:none}
        .file-preview-img{width:100%;height:110px;object-fit:cover;border-radius:10px;border:1px solid var(--border);display:none;margin-top:0.75rem}
        .file-info-bar{margin-top:0.65rem;padding:0.6rem 0.9rem;background:rgba(16,185,129,0.1);border:1px solid rgba(16,185,129,0.25);border-radius:9px;font-size:0.78rem;color:#34d399;display:none;align-items:center;gap:0.5rem}
        .file-info-bar button{margin-left:auto;background:none;border:none;color:#f87171;cursor:pointer;font-size:0.8rem}

        /* Form fields */
        .form-grid-2{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
        .field-group{display:flex;flex-direction:column;gap:0.42rem;margin-bottom:0.8rem}
        .field-label{font-size:0.68rem;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:var(--muted)}
        .field-input,.field-select,.field-textarea{padding:0.75rem 1rem;border:1px solid var(--border);border-radius:10px;background:var(--bg);color:var(--text);font-family:'Inter',sans-serif;font-size:0.9rem;transition:all 0.25s;width:100%}
        .field-input:focus,.field-select:focus,.field-textarea:focus{outline:none;border-color:var(--accent);box-shadow:0 0 0 3px rgba(99,102,241,0.15)}
        .field-input::placeholder,.field-textarea::placeholder{color:var(--slate)}
        .field-select{cursor:pointer}
        .field-textarea{resize:vertical;min-height:88px;line-height:1.6}
        .divider{height:1px;background:var(--border);margin:0.9rem 0}
        .section-label{font-size:0.7rem;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;color:var(--accent2);display:flex;align-items:center;gap:0.4rem;margin-bottom:0.9rem}

        /* Footer btns */
        .btn-save{flex:1;padding:0.88rem;background:linear-gradient(135deg,#6366f1,#4f46e5);color:white;border:none;border-radius:12px;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;font-size:0.9rem;transition:all 0.3s;display:flex;align-items:center;justify-content:center;gap:0.5rem;box-shadow:0 4px 15px rgba(99,102,241,0.35)}
        .btn-save:hover{transform:translateY(-2px);box-shadow:0 8px 25px rgba(99,102,241,0.5)}
        .btn-cancel-modal{padding:0.88rem 1.2rem;background:transparent;border:1px solid var(--border);color:var(--muted);border-radius:12px;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;font-size:0.875rem;transition:all 0.2s}
        .btn-cancel-modal:hover{border-color:var(--red);color:#f87171;background:rgba(239,68,68,0.06)}

        /* View / Preview / Details modals */
        .view-thumb{border-radius:14px;overflow:hidden;position:relative;margin-bottom:1.5rem}
        .view-thumb img{width:100%;height:200px;object-fit:cover;display:block}
        .view-thumb-placeholder{width:100%;height:200px;background:linear-gradient(135deg,#312e81,#1e1b4b);display:flex;align-items:center;justify-content:center;font-size:3rem;color:rgba(255,255,255,0.2)}
        .view-thumb-overlay{position:absolute;inset:0;background:linear-gradient(to top,rgba(10,15,30,0.75),transparent 55%);display:flex;align-items:flex-end;padding:1.25rem 1.5rem}
        .view-price-tag{font-size:1.5rem;font-weight:800}
        .view-stats-row{display:grid;grid-template-columns:repeat(3,1fr);gap:0.75rem;margin-bottom:1.5rem}
        .view-stat{background:var(--bg);border-radius:12px;padding:1rem;text-align:center;border:1px solid var(--border)}
        .view-stat-val{font-size:1.25rem;font-weight:800}
        .view-stat-lbl{font-size:0.68rem;color:var(--muted);text-transform:uppercase;letter-spacing:0.06em;margin-top:0.2rem}
        .view-desc{color:var(--muted);font-size:0.88rem;line-height:1.65;margin-bottom:1.4rem}
        .view-tags{display:flex;gap:0.5rem;flex-wrap:wrap;margin-bottom:1.5rem}
        .view-tag{background:var(--bg);border:1px solid var(--border);border-radius:8px;padding:0.3rem 0.7rem;font-size:0.77rem;color:var(--muted);display:flex;align-items:center;gap:0.35rem}
        .view-actions{display:flex;gap:0.75rem}
        .btn-enroll{flex:1;padding:0.85rem;background:linear-gradient(135deg,#10b981,#059669);color:white;border:none;border-radius:12px;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;font-size:0.9rem;transition:all 0.3s}
        .btn-enroll:hover{transform:translateY(-2px);box-shadow:0 8px 22px rgba(16,185,129,0.4)}
        .btn-share{padding:0.85rem 1.2rem;background:transparent;border:1px solid var(--border);color:var(--muted);border-radius:12px;font-weight:600;cursor:pointer;font-family:'Inter',sans-serif;font-size:0.875rem;transition:all 0.2s}
        .btn-share:hover{border-color:var(--accent2);color:var(--text)}
        .sec-label{font-size:0.72rem;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;color:var(--muted);margin-bottom:0.75rem}
        .dp-modal .modal{max-width:720px}
        .dp-hero{border-radius:16px;overflow:hidden;position:relative;margin-bottom:1.5rem}
        .dp-hero img{width:100%;height:220px;object-fit:cover;display:block}
        .dp-hero-placeholder{width:100%;height:220px;background:linear-gradient(135deg,#312e81,#1e1b4b);display:flex;align-items:center;justify-content:center;font-size:4rem;color:rgba(255,255,255,0.2)}
        .dp-hero-grad{position:absolute;inset:0;background:linear-gradient(135deg,rgba(10,15,30,0.72) 0%,rgba(10,15,30,0.2) 100%)}
        .dp-hero-content{position:absolute;inset:0;padding:1.5rem;display:flex;flex-direction:column;justify-content:flex-end}
        .dp-hero-cat{display:inline-block;padding:0.22rem 0.65rem;background:rgba(99,102,241,0.85);color:#fff;border-radius:20px;font-size:0.68rem;font-weight:700;text-transform:uppercase;letter-spacing:0.06em;margin-bottom:0.6rem;width:fit-content}
        .dp-hero-title{font-size:1.2rem;font-weight:800;color:#fff;line-height:1.35;letter-spacing:-0.01em;margin-bottom:0.5rem}
        .dp-hero-meta{display:flex;gap:1rem;font-size:0.78rem;color:rgba(255,255,255,0.75);flex-wrap:wrap}
        .dp-hero-meta span{display:flex;align-items:center;gap:0.3rem}
        .dp-price-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:1.25rem;flex-wrap:wrap;gap:0.75rem}
        .dp-price{font-size:2rem;font-weight:800;letter-spacing:-0.04em;color:var(--text)}
        .dp-price-sub{font-size:0.78rem;color:var(--muted);margin-top:0.15rem}
        .dp-enroll-btn{padding:0.8rem 1.75rem;background:linear-gradient(135deg,#6366f1,#4f46e5);color:white;border:none;border-radius:12px;font-weight:700;cursor:not-allowed;font-family:'Inter',sans-serif;font-size:0.9rem;opacity:0.6;display:flex;align-items:center;gap:0.5rem}
        .dp-stats-row{display:grid;grid-template-columns:repeat(4,1fr);gap:0.75rem;margin-bottom:1.5rem}
        .dp-stat{background:var(--surface2);border-radius:12px;padding:0.85rem;text-align:center;border:1px solid var(--border)}
        .dp-stat-val{font-size:1.1rem;font-weight:800;color:var(--text)}
        .dp-stat-lbl{font-size:0.65rem;color:var(--muted);text-transform:uppercase;letter-spacing:0.06em;margin-top:0.2rem}
        .dp-section{margin-bottom:1.4rem}
        .dp-section-title{font-size:0.82rem;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;color:var(--muted);margin-bottom:0.75rem;display:flex;align-items:center;gap:0.5rem}
        .dp-desc{font-size:0.88rem;color:var(--muted);line-height:1.7;background:var(--surface2);border-radius:12px;padding:1rem 1.1rem;border:1px solid var(--border)}
        .dp-includes{display:grid;grid-template-columns:1fr 1fr;gap:0.5rem}
        .dp-include-item{display:flex;align-items:center;gap:0.6rem;font-size:0.82rem;color:var(--muted);padding:0.5rem 0.75rem;background:var(--surface2);border-radius:9px;border:1px solid var(--border)}
        .dp-include-item i{color:#34d399;font-size:0.8rem;flex-shrink:0}
        .dp-watermark-bar{background:linear-gradient(90deg,rgba(139,92,246,0.12),rgba(99,102,241,0.12));border:1px dashed rgba(139,92,246,0.35);border-radius:12px;padding:0.85rem 1.2rem;margin-bottom:1.5rem;display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap}
        .dp-watermark-left{display:flex;align-items:center;gap:0.65rem;font-size:0.83rem;color:#c4b5fd;font-weight:500}
        .btn-submit-review{padding:0.72rem 1.4rem;background:linear-gradient(135deg,#6366f1,#4f46e5);color:white;border:none;border-radius:10px;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;font-size:0.85rem;transition:all 0.3s;display:flex;align-items:center;gap:0.5rem;white-space:nowrap}
        .btn-submit-review:hover{transform:translateY(-1px);box-shadow:0 6px 20px rgba(99,102,241,0.5)}
        .dtl-banner{border-radius:14px;padding:1.1rem 1.25rem;margin-bottom:1.5rem;display:flex;align-items:flex-start;gap:0.9rem}
        .dtl-banner-pending{background:rgba(245,158,11,0.08);border:1px solid rgba(245,158,11,0.3)}
        .dtl-banner-rejected{background:rgba(239,68,68,0.08);border:1px solid rgba(239,68,68,0.3)}
        .dtl-banner-icon{font-size:1.5rem;flex-shrink:0}
        .dtl-banner-heading{font-size:0.92rem;font-weight:700;margin-bottom:0.3rem}
        .dtl-banner-pending .dtl-banner-heading{color:#fbbf24}
        .dtl-banner-rejected .dtl-banner-heading{color:#f87171}
        .dtl-banner-text{font-size:0.82rem;color:var(--muted);line-height:1.55}
        .dtl-feedback{background:rgba(239,68,68,0.06);border:1px solid rgba(239,68,68,0.25);border-radius:12px;padding:1rem 1.2rem;margin-bottom:1.5rem}
        .dtl-feedback-lbl{font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.1em;color:#f87171;margin-bottom:0.5rem;display:flex;align-items:center;gap:0.4rem}
        .dtl-feedback-text{font-size:0.875rem;color:var(--text);line-height:1.65}
        .dtl-timeline{position:relative;padding-left:1.5rem;margin-bottom:1.5rem}
        .dtl-timeline::before{content:'';position:absolute;left:0;top:0;bottom:0;width:2px;background:var(--border);border-radius:2px}
        .dtl-tl-item{position:relative;padding-bottom:1.2rem}
        .dtl-tl-item:last-child{padding-bottom:0}
        .dtl-tl-dot{position:absolute;left:-1.78rem;top:3px;width:14px;height:14px;border-radius:50%;border:2px solid var(--bg)}
        .dot-done{background:#10b981}.dot-pulse{background:#f59e0b;animation:blink 1.5s ease-in-out infinite}.dot-wait{background:var(--slate)}.dot-rejected{background:#ef4444}
        .dtl-tl-text{font-size:0.875rem;font-weight:600}
        .dtl-tl-sub{font-size:0.77rem;color:var(--muted);margin-top:0.12rem}
        .dtl-info-grid{display:grid;grid-template-columns:1fr 1fr;gap:0.75rem;margin-bottom:1.5rem}
        .dtl-info-cell{background:var(--bg);border-radius:10px;padding:0.85rem 1rem;border:1px solid var(--border)}
        .dtl-info-lbl{font-size:0.68rem;text-transform:uppercase;letter-spacing:0.08em;color:var(--slate);margin-bottom:0.25rem}
        .dtl-info-val{font-size:0.9rem;font-weight:600}
        .btn-resubmit{width:100%;padding:0.85rem;background:linear-gradient(135deg,#6366f1,#4f46e5);color:white;border:none;border-radius:12px;font-weight:700;cursor:pointer;font-family:'Inter',sans-serif;font-size:0.9rem;transition:all 0.3s;display:flex;align-items:center;justify-content:center;gap:0.6rem;text-decoration:none}
        .btn-resubmit:hover{transform:translateY(-2px);box-shadow:0 8px 24px rgba(99,102,241,0.5)}

        @media(max-width:768px){
            .main-content{margin-left:0;padding:1rem}.stats-row{grid-template-columns:1fr 1fr}.courses-grid{grid-template-columns:1fr}
            .header-content{flex-direction:column;align-items:flex-start}.filter-group{flex-direction:column;align-items:stretch}
            .modal{border-radius:16px}.form-grid-2{grid-template-columns:1fr}.dp-stats-row{grid-template-columns:1fr 1fr}
        }
    </style>

    <!-- Show page as soon as DOM + inline CSS ready — don't wait for FA or fonts -->
    <script>document.addEventListener('DOMContentLoaded',function(){document.documentElement.style.visibility='visible'});</script>
</head>
<body>
<div class="animated-bg"></div>
<jsp:include page="sidebar.jsp"/>

<!-- ── Main ── -->
<main class="main-content">
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${successMessage}</div>
        <span id="flash-success" style="display:none">${successMessage}</span>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
        <span id="flash-error" style="display:none">${errorMessage}</span>
    </c:if>

    <div class="page-header">
        <div class="header-content">
            <div>
                <h1 class="header-title">My Courses</h1>
                <p class="header-sub">Manage and track all your courses in one place</p>
            </div>
            <a href="${pageContext.request.contextPath}/instructor/create-course" class="btn-primary"><i class="fas fa-plus"></i> Create New Course</a>
        </div>
    </div>

    <!-- Stats -->
    <c:set var="totalEnrollmentSum" value="0"/>
    <c:set var="totalEarningsSum"   value="0"/>
    <c:set var="liveCount"    value="0"/>
    <c:set var="pendingCount" value="0"/>
    <c:forEach var="c" items="${courses}">
        <c:set var="totalEnrollmentSum" value="${totalEnrollmentSum + (c.totalEnrollments != null ? c.totalEnrollments : 0)}"/>
        <c:set var="totalEarningsSum"   value="${totalEarningsSum   + ((c.totalEnrollments != null ? c.totalEnrollments : 0) * (c.price != null ? c.price : 0))}"/>
        <c:if test="${c.status == 'LIVE'}"    ><c:set var="liveCount"    value="${liveCount    + 1}"/></c:if>
        <c:if test="${c.status == 'PENDING'}" ><c:set var="pendingCount" value="${pendingCount + 1}"/></c:if>
    </c:forEach>
    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-top"><div class="stat-icon" style="background:rgba(99,102,241,0.15);color:var(--accent2)"><i class="fas fa-book"></i></div></div>
            <div class="stat-number">${not empty courses ? courses.size() : 0}</div>
            <div class="stat-label">Total Courses</div>
            <div class="stat-trend trend-up"><i class="fas fa-layer-group"></i> ${liveCount} live, ${pendingCount} pending</div>
        </div>
        <div class="stat-card">
            <div class="stat-top"><div class="stat-icon" style="background:rgba(16,185,129,0.15);color:#34d399"><i class="fas fa-users"></i></div></div>
            <div class="stat-number"><fmt:formatNumber value="${totalEnrollmentSum}" groupingUsed="true"/></div>
            <div class="stat-label">Active Students</div>
            <div class="stat-trend trend-up"><i class="fas fa-arrow-up"></i> Across all courses</div>
        </div>
        <div class="stat-card">
            <div class="stat-top"><div class="stat-icon" style="background:rgba(245,158,11,0.15);color:#fbbf24"><i class="fas fa-rupee-sign"></i></div></div>
            <div class="stat-number">&#8377;<fmt:formatNumber value="${totalEarningsSum}" groupingUsed="true" maxFractionDigits="0"/></div>
            <div class="stat-label">Total Earnings</div>
            <div class="stat-trend trend-up"><i class="fas fa-chart-line"></i> Lifetime earnings</div>
        </div>
        <div class="stat-card">
            <div class="stat-top"><div class="stat-icon" style="background:rgba(59,130,246,0.15);color:#60a5fa"><i class="fas fa-check-circle"></i></div></div>
            <div class="stat-number">${liveCount}</div>
            <div class="stat-label">Live Courses</div>
            <c:choose>
                <c:when test="${pendingCount > 0}"><div class="stat-trend trend-info"><i class="fas fa-clock"></i> ${pendingCount} pending review</div></c:when>
                <c:otherwise><div class="stat-trend trend-up"><i class="fas fa-check"></i> All reviewed</div></c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Filter -->
    <div class="filter-bar">
        <div class="filter-group">
            <div class="search-wrapper">
                <i class="fas fa-search search-icon"></i>
                <input type="text" class="search-input" placeholder="Search your courses..." id="searchInput">
            </div>
            <select class="filter-select" id="statusFilter">
                <option value="all">All Status</option>
                <option value="LIVE">Live</option>
                <option value="DRAFT">Draft</option>
                <option value="PENDING">Pending Review</option>
                <option value="REJECTED">Rejected</option>
            </select>
            <select class="filter-select" id="categoryFilter"><option value="all">All Categories</option></select>
        </div>
    </div>

    <!-- Legend -->
    <div class="status-legend">
        <span class="legend-title">Status Guide:</span>
        <div class="legend-item"><span class="legend-dot" style="background:#10b981"></span>Live &#8212; Visible to students</div>
        <div class="legend-item"><span class="legend-dot" style="background:#64748b"></span>Draft &#8212; Work in progress</div>
        <div class="legend-item"><span class="legend-dot" style="background:#f59e0b"></span>Pending &#8212; Awaiting approval</div>
        <div class="legend-item"><span class="legend-dot" style="background:#ef4444"></span>Rejected &#8212; Needs changes</div>
    </div>

    <!-- Courses -->
    <c:choose>
        <c:when test="${not empty courses}">
            <div class="courses-grid" id="coursesGrid">
                <c:forEach var="course" items="${courses}" varStatus="loop">
                    <c:set var="cId"        value="${course.id}"/>
                    <c:set var="cStatus"    value="${course.status}"/>
                    <c:set var="cTitle"     value="${course.title}"/>
                    <c:set var="cCat"       value="${not empty course.category    ? course.category    : 'Uncategorized'}"/>
                    <c:set var="cLevel"     value="${not empty course.level       ? course.level       : 'All Levels'}"/>
                    <c:set var="cDesc"      value="${not empty course.description ? course.description : (not empty course.subtitle ? course.subtitle : 'No description available.')}"/>
                    <c:set var="cThumb"     value="${not empty course.thumbnailUrl ? course.thumbnailUrl : ''}"/>
                    <c:set var="cPrice"     value="${course.price            != null ? course.price            : 0}"/>
                    <c:set var="cStudents"  value="${course.totalEnrollments != null ? course.totalEnrollments : 0}"/>
                    <c:set var="cRating"    value="${course.averageRating    != null ? course.averageRating    : 0}"/>
                    <c:set var="cSections"  value="${course.sections         != null ? course.sections.size()  : 0}"/>
                    <c:set var="cRejection" value="${not empty course.rejectionReason ? course.rejectionReason : ''}"/>
                    <c:set var="cDurRaw"    value="${course.duration != null ? course.duration : 0}"/>
                    <c:set var="cDurH"      value="${cDurRaw.intValue()}"/>
                    <c:set var="cDurM"      value="${((cDurRaw - cDurH) * 60).intValue()}"/>

                    <div class="course-card"
                         data-id="${cId}" data-status="${cStatus}" data-title="${cTitle}"
                         data-category="${cCat}" data-thumb="${cThumb}" data-price="${cPrice}"
                         data-students="${cStudents}" data-rating="${cRating}" data-sections="${cSections}"
                         data-duration="${cDurH}h ${cDurM}m" data-desc="${cDesc}" data-level="${cLevel}"
                         data-rejection="${cRejection}" data-ctx="${pageContext.request.contextPath}"
                         style="animation-delay:${loop.index * 0.07}s">

                        <div class="thumb-wrapper">
                            <c:choose>
                                <c:when test="${not empty cThumb}"><img src="${cThumb}" class="course-thumbnail" alt="${cTitle}"></c:when>
                                <c:otherwise><div class="thumb-placeholder"><i class="fas fa-book-open"></i></div></c:otherwise>
                            </c:choose>
                            <div class="thumb-overlay"></div>
                            <span class="course-status-badge badge-${cStatus}">
                                <span class="status-dot"></span>
                                <c:choose>
                                    <c:when test="${cStatus=='LIVE'}"    >Live</c:when>
                                    <c:when test="${cStatus=='DRAFT'}"   >Draft</c:when>
                                    <c:when test="${cStatus=='PENDING'}" >Pending Review</c:when>
                                    <c:when test="${cStatus=='REJECTED'}">Rejected</c:when>
                                    <c:otherwise>${cStatus}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="status-info-bar sib-${cStatus}">
                            <c:choose>
                                <c:when test="${cStatus=='LIVE'}"    ><i class="fas fa-check-circle"></i> Live &#183; Visible to all students</c:when>
                                <c:when test="${cStatus=='DRAFT'}"   ><i class="fas fa-pen"></i> Work in progress &#183; Not published yet</c:when>
                                <c:when test="${cStatus=='PENDING'}" ><i class="fas fa-hourglass-half"></i> Awaiting admin approval &#183; Editing locked</c:when>
                                <c:when test="${cStatus=='REJECTED'}"><i class="fas fa-times-circle"></i> Rejected &#8212; Fix &amp; resubmit</c:when>
                                <c:otherwise><i class="fas fa-info-circle"></i> ${cStatus}</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="course-info">
                            <div class="course-top"><span class="course-category-tag">${cCat}</span></div>
                            <h3 class="course-title">${cTitle}</h3>
                            <div class="course-meta">
                                <span><i class="fas fa-video"></i> ${cSections} Lectures</span>
                                <span><i class="fas fa-clock"></i> ${cDurH}h ${cDurM}m</span>
                                <c:if test="${cStatus=='LIVE' && cRating > 0}">
                                    <span><i class="fas fa-star" style="color:#f59e0b"></i> <fmt:formatNumber value="${cRating}" maxFractionDigits="1"/></span>
                                </c:if>
                            </div>
                            <div class="course-stats-grid">
                                <div class="stat-box">
                                    <div class="stat-box-value">
                                        <c:choose>
                                            <c:when test="${cStatus=='LIVE'}">${cStudents}</c:when>
                                            <c:otherwise><span style="color:var(--slate)">&#8212;</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="stat-box-label">Students</div>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-box-value">
                                        <c:choose>
                                            <c:when test="${cStatus=='LIVE' && cRating > 0}"><fmt:formatNumber value="${cRating}" maxFractionDigits="1"/></c:when>
                                            <c:otherwise><span style="color:var(--slate)">&#8212;</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="stat-box-label">Rating</div>
                                </div>
                                <div class="stat-box">
                                    <div class="stat-box-value">&#8377;<fmt:formatNumber value="${cPrice}" groupingUsed="true" maxFractionDigits="0"/></div>
                                    <div class="stat-box-label">Price</div>
                                </div>
                            </div>

                            <div class="course-actions">
                                <c:choose>
                                    <c:when test="${cStatus=='LIVE'}">
                                        <button class="btn-action btn-edit"    onclick="openEditModal(this)"><i class="fas fa-edit"></i> Edit</button>
                                        <button class="btn-action btn-view"    onclick="openViewModal(this)"><i class="fas fa-eye"></i> View</button>
                                    </c:when>
                                    <c:when test="${cStatus=='DRAFT'}">
                                        <button class="btn-action btn-edit"    onclick="openEditModal(this)"><i class="fas fa-edit"></i> Edit</button>
                                        <button class="btn-action btn-preview" onclick="openPreviewModal(this)"><i class="fas fa-eye"></i> Preview</button>
                                    </c:when>
                                    <c:when test="${cStatus=='PENDING'}">
                                        <button class="btn-action btn-details" onclick="openDetailsModal(this)"><i class="fas fa-info-circle"></i> View Details</button>
                                        <button class="btn-action btn-preview" onclick="openPreviewModal(this)"><i class="fas fa-eye"></i> Preview</button>
                                    </c:when>
                                    <c:when test="${cStatus=='REJECTED'}">
                                        <button class="btn-action btn-edit"    onclick="openEditModal(this)"><i class="fas fa-edit"></i> Fix &amp; Edit</button>
                                        <button class="btn-action btn-details" onclick="openDetailsModal(this)"><i class="fas fa-info-circle"></i> Details</button>
                                    </c:when>
                                </c:choose>
                            </div>

                            <c:if test="${cStatus=='REJECTED'}">
                                <form method="post" action="${pageContext.request.contextPath}/instructor/my-courses/submit-review" style="margin-top:0.65rem">
                                    <input type="hidden" name="courseId" value="${cId}">
                                    <button type="submit" class="wf-submit wf-resubmit"><i class="fas fa-redo"></i> Fix Done? Resubmit for Review</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <div class="empty-state" id="noResults" style="display:none">
                <i class="fas fa-search"></i><h3>No courses found</h3><p>Try adjusting your filters or search term</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="fas fa-book-open"></i><h3>No courses yet</h3>
                <p>Create your first course to start teaching students.</p>
                <a href="${pageContext.request.contextPath}/instructor/create-course" class="btn-primary" style="margin-top:1rem;display:inline-flex"><i class="fas fa-plus"></i> Create Course</a>
            </div>
        </c:otherwise>
    </c:choose>
</main>


<!-- ════════════════════════════════════════════════════════════
     EDIT MODAL
════════════════════════════════════════════════════════════ -->
<div class="modal-overlay" id="editModal">
    <div class="modal" style="max-width:700px">

        <div class="modal-header">
            <div style="flex:1;min-width:0">
                <div class="modal-eyebrow" style="color:#fbbf24"><i class="fas fa-pen-nib"></i> Edit Course</div>
                <div class="modal-title-text" id="em-header-title">Course Title</div>
            </div>
            <div style="display:flex;align-items:center;gap:0.75rem;flex-shrink:0">
                <span class="status-pill" id="em-status-pill">—</span>
                <button class="modal-close" onclick="closeModal('editModal')"><i class="fas fa-times"></i></button>
            </div>
        </div>

        <div class="modal-body">
            <form id="editCourseForm" method="post" action="" enctype="multipart/form-data">
                <input type="hidden" name="courseId"     id="em-id">
                <input type="hidden" name="thumbnailUrl" id="em-final-url">

                <!-- ══ THUMBNAIL — Upload only ══ -->
                <div class="thumb-section-label"><i class="fas fa-image"></i> Course Thumbnail</div>

                <div class="drop-zone" id="em-drop-zone"
                     onclick="document.getElementById('em-file-input').click()"
                     ondragover="dzDragOver(event)"
                     ondragleave="dzDragLeave(event)"
                     ondrop="dzDrop(event)">
                    <i class="fas fa-cloud-upload-alt"></i>
                    <div class="drop-title">Drop image here or click to browse</div>
                    <div class="drop-sub">JPG &middot; PNG &middot; WEBP &nbsp;|&nbsp; Max 5 MB &nbsp;|&nbsp; Recommended 1280&times;720 px</div>
                    <input type="file" id="em-file-input" name="thumbnailFile"
                           accept="image/jpeg,image/png,image/webp"
                           onchange="onFileSelect(this)">
                </div>
                <img id="em-file-preview" class="file-preview-img" src="" alt="">
                <div class="file-info-bar" id="em-file-info">
                    <i class="fas fa-check-circle"></i>
                    <span id="em-file-name"></span>
                    <button type="button" onclick="clearFile()"><i class="fas fa-times"></i></button>
                </div>

                <div class="divider"></div>

                <!-- ══ COURSE DETAILS ══ -->
                <div class="section-label"><i class="fas fa-info-circle"></i> Course Details</div>

                <div class="field-group">
                    <label class="field-label">Course Title</label>
                    <input type="text" class="field-input" name="title" id="em-title" placeholder="Enter course title">
                </div>

                <div class="form-grid-2">
                    <div class="field-group">
                        <label class="field-label">Category</label>
                        <select class="field-select" name="category" id="em-category">
                            <option value="Development">Development</option>
                            <option value="Design">Design</option>
                            <option value="Business">Business</option>
                            <option value="Marketing">Marketing</option>
                            <option value="Finance">Finance</option>
                            <option value="IT &amp; Software">IT &amp; Software</option>
                            <option value="Photography">Photography</option>
                            <option value="Music">Music</option>
                            <option value="Health">Health &amp; Fitness</option>
                            <option value="Lifestyle">Lifestyle</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="field-group">
                        <label class="field-label">Difficulty</label>
                        <select class="field-select" name="level" id="em-level">
                            <option value="Beginner">Beginner</option>
                            <option value="Intermediate">Intermediate</option>
                            <option value="Advanced">Advanced</option>
                            <option value="All Levels">All Levels</option>
                        </select>
                    </div>
                </div>

                <div class="form-grid-2">
                    <div class="field-group">
                        <label class="field-label">Price (&#8377;)</label>
                        <input type="number" class="field-input" name="price" id="em-price" placeholder="e.g. 4999" min="0">
                    </div>
                    <div class="field-group">
                        <label class="field-label">Lectures</label>
                        <input type="number" class="field-input" name="sections" id="em-sections" placeholder="e.g. 42" min="0">
                    </div>
                </div>

                <div class="field-group">
                    <label class="field-label">Duration</label>
                    <input type="text" class="field-input" name="duration" id="em-duration" placeholder="e.g. 6h 30m">
                </div>

                <div class="field-group">
                    <label class="field-label">Description</label>
                    <textarea class="field-textarea" name="description" id="em-description" placeholder="Short description of your course..."></textarea>
                </div>

            </form>
        </div><!-- /modal-body -->

        <div class="modal-footer">
            <button class="btn-cancel-modal" onclick="closeModal('editModal')"><i class="fas fa-times"></i> Cancel</button>
            <button class="btn-save" onclick="submitEdit()"><i class="fas fa-save"></i> Save Changes</button>
        </div>
    </div>
</div>


<!-- ════════════════════════════════════════════════════════════
     VIEW MODAL (LIVE)
════════════════════════════════════════════════════════════ -->
<div class="modal-overlay" id="viewModal">
    <div class="modal">
        <div class="modal-header">
            <div><div class="modal-eyebrow" style="color:#34d399"><i class="fas fa-globe"></i> Live Course Page</div><div class="modal-title-text" id="vm-title"></div></div>
            <button class="modal-close" onclick="closeModal('viewModal')"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body">
            <div class="view-thumb">
                <img id="vm-img" src="" alt="" style="display:none;width:100%;height:200px;object-fit:cover">
                <div id="vm-img-ph" class="view-thumb-placeholder"><i class="fas fa-book-open"></i></div>
                <div class="view-thumb-overlay"><span class="view-price-tag" id="vm-price"></span></div>
            </div>
            <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.25rem">
                <span class="course-category-tag" id="vm-cat"></span>
                <span style="display:inline-flex;align-items:center;gap:0.4rem;padding:0.3rem 0.8rem;border-radius:20px;font-size:0.78rem;font-weight:700;background:rgba(16,185,129,0.15);color:#34d399;border:1px solid rgba(16,185,129,0.3)">
                    <i class="fas fa-circle" style="font-size:0.45rem;animation:blink 1.5s ease-in-out infinite"></i> Live
                </span>
            </div>
            <div class="sec-label">Course Stats</div>
            <div class="view-stats-row">
                <div class="view-stat"><div class="view-stat-val" id="vm-students"></div><div class="view-stat-lbl">Students</div></div>
                <div class="view-stat"><div class="view-stat-val" id="vm-rating"></div><div class="view-stat-lbl">Rating</div></div>
                <div class="view-stat"><div class="view-stat-val" id="vm-lectures"></div><div class="view-stat-lbl">Lectures</div></div>
            </div>
            <div class="sec-label">About this Course</div>
            <p class="view-desc" id="vm-desc"></p>
            <div class="view-tags">
                <span class="view-tag"><i class="fas fa-clock"></i> <span id="vm-duration"></span></span>
                <span class="view-tag"><i class="fas fa-layer-group"></i> <span id="vm-level"></span></span>
                <span class="view-tag"><i class="fas fa-certificate"></i> Certificate included</span>
                <span class="view-tag"><i class="fas fa-infinity"></i> Lifetime access</span>
            </div>
            <div class="view-actions">
                <button class="btn-enroll" onclick="showToast('&#127891;','Enrollment flow opened!')">Enroll Now</button>
                <button class="btn-share"  onclick="showToast('&#128279;','Course link copied!')"><i class="fas fa-share-alt"></i> Share</button>
            </div>
        </div>
    </div>
</div>

<!-- ════════════════════════════════════════════════════════════
     PREVIEW MODAL (DRAFT/PENDING)
════════════════════════════════════════════════════════════ -->
<div class="modal-overlay dp-modal" id="previewModal">
    <div class="modal">
        <div class="modal-header">
            <div><div class="modal-eyebrow" style="color:#a78bfa"><i class="fas fa-eye"></i> Course Preview</div><div class="modal-title-text" id="pv-title"></div></div>
            <button class="modal-close" onclick="closeModal('previewModal')"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" style="padding-top:1.25rem">
            <div class="dp-watermark-bar">
                <div class="dp-watermark-left"><i class="fas fa-eye-slash"></i><span id="pv-watermark-text"></span></div>
                <div id="pv-action"></div>
            </div>
            <div class="dp-hero">
                <img id="pv-img" src="" alt="" style="display:none;width:100%;height:220px;object-fit:cover">
                <div id="pv-img-ph" class="dp-hero-placeholder"><i class="fas fa-book-open"></i></div>
                <div class="dp-hero-grad"></div>
                <div class="dp-hero-content">
                    <span class="dp-hero-cat" id="pv-cat"></span>
                    <div class="dp-hero-title" id="pv-hero-title"></div>
                    <div class="dp-hero-meta">
                        <span><i class="fas fa-video"></i> <span id="pv-lec"></span> Lectures</span>
                        <span><i class="fas fa-clock"></i> <span id="pv-dur"></span></span>
                        <span><i class="fas fa-signal"></i> <span id="pv-level"></span></span>
                    </div>
                </div>
            </div>
            <div class="dp-price-row">
                <div><div class="dp-price" id="pv-price"></div><div class="dp-price-sub">One-time payment &#183; Lifetime access</div></div>
                <button class="dp-enroll-btn" disabled><i class="fas fa-lock"></i> Enroll Now</button>
            </div>
            <div class="dp-stats-row">
                <div class="dp-stat"><div class="dp-stat-val">&#8212;</div><div class="dp-stat-lbl">Students</div></div>
                <div class="dp-stat"><div class="dp-stat-val">&#8212;</div><div class="dp-stat-lbl">Rating</div></div>
                <div class="dp-stat"><div class="dp-stat-val" id="pv-stat-lec"></div><div class="dp-stat-lbl">Lectures</div></div>
                <div class="dp-stat"><div class="dp-stat-val" id="pv-stat-dur"></div><div class="dp-stat-lbl">Duration</div></div>
            </div>
            <div class="dp-section">
                <div class="dp-section-title"><i class="fas fa-align-left"></i> About this Course</div>
                <div class="dp-desc" id="pv-desc"></div>
            </div>
            <div class="dp-section">
                <div class="dp-section-title"><i class="fas fa-gift"></i> What's Included</div>
                <div class="dp-includes">
                    <div class="dp-include-item"><i class="fas fa-check-circle"></i> Lifetime access</div>
                    <div class="dp-include-item"><i class="fas fa-check-circle"></i> Certificate of completion</div>
                    <div class="dp-include-item"><i class="fas fa-check-circle"></i> Downloadable resources</div>
                    <div class="dp-include-item"><i class="fas fa-check-circle"></i> Mobile &amp; desktop access</div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ════════════════════════════════════════════════════════════
     DETAILS MODAL (PENDING/REJECTED)
════════════════════════════════════════════════════════════ -->
<div class="modal-overlay" id="detailsModal">
    <div class="modal" style="max-width:580px">
        <div class="modal-header">
            <div><div class="modal-eyebrow" id="dtl-eyebrow"></div><div class="modal-title-text" id="dtl-title"></div></div>
            <button class="modal-close" onclick="closeModal('detailsModal')"><i class="fas fa-times"></i></button>
        </div>
        <div class="modal-body" id="dtl-body"></div>
    </div>
</div>

<!-- Toast -->
<div class="toast" id="toastEl"><span id="toastIcon"></span><span id="toastMsg"></span></div>

<script>
/* ─── Helpers ─── */
const $ = id => document.getElementById(id);
const tx = (id,v) => { const e=$(id); if(e) e.textContent=v; };
function cardData(btn){ return btn.closest?.('.course-card')?.dataset ?? null; }
function setThumb(imgId,phId,src){
    const img=$(imgId),ph=$(phId);
    if(src&&src.trim()){ img.src=src; img.style.display='block'; ph.style.display='none'; }
    else { img.style.display='none'; ph.style.display='flex'; }
}
function openModal(id){ $(id).classList.add('open'); document.body.style.overflow='hidden'; }
function closeModal(id){ $(id).classList.remove('open'); document.body.style.overflow=''; }

document.querySelectorAll('.modal-overlay').forEach(o=>
    o.addEventListener('click',e=>{ if(e.target===o) closeModal(o.id); })
);
document.addEventListener('keydown',e=>{
    if(e.key==='Escape') document.querySelectorAll('.modal-overlay.open').forEach(o=>closeModal(o.id));
});

/* ════════════════════════════
   EDIT MODAL
════════════════════════════ */
function openEditModal(btn){
    const d = cardData(btn);
    if(!d) return;

    /* Header + status pill */
    tx('em-header-title', d.title);
    const pillMap = {'LIVE':['sp-LIVE','🟢 Live'],'DRAFT':['sp-DRAFT','⚫ Draft'],'REJECTED':['sp-REJECTED','🔴 Rejected']};
    const [cls,lbl] = pillMap[d.status]||['sp-DRAFT',d.status];
    const pill = $('em-status-pill');
    pill.className='status-pill '+cls; pill.textContent=lbl;

    /* Reset file picker */
    clearFile();

    /* Keep existing thumb URL in hidden field (server uses it if no new file uploaded) */
    $('em-final-url').value = d.thumb||'';

    /* Form fields */
    $('em-id').value          = d.id;
    $('em-title').value       = d.title;
    $('em-price').value       = d.price;
    $('em-sections').value    = d.sections;
    $('em-duration').value    = d.duration;
    $('em-description').value = d.desc;
    ['em-category','em-level'].forEach(id=>{
        const sel=$(id), key=id==='em-category'?'category':'level';
        [...sel.options].forEach((o,i)=>{ if(o.value===d[key]) sel.selectedIndex=i; });
    });

    /* Form action */
    $('editCourseForm').action = (d.ctx||'')+'/instructor/edit-course';

    openModal('editModal');
}

/* ── File upload ── */
function dzDragOver(e){ e.preventDefault(); $('em-drop-zone').classList.add('drag-over'); }
function dzDragLeave(){ $('em-drop-zone').classList.remove('drag-over'); }
function dzDrop(e){
    e.preventDefault(); $('em-drop-zone').classList.remove('drag-over');
    const f=e.dataTransfer.files[0]; if(f) processFile(f);
}
function onFileSelect(input){ if(input.files&&input.files[0]) processFile(input.files[0]); }
function processFile(file){
    if(!file.type.startsWith('image/')){ showToast('❌','Please select an image file.'); return; }
    if(file.size>5*1024*1024){ showToast('❌','File too large. Max 5 MB.'); return; }
    const reader=new FileReader();
    reader.onload=e=>{
        const src=e.target.result;
        $('em-file-preview').src=src; $('em-file-preview').style.display='block';
        $('em-file-info').style.display='flex';
        $('em-file-name').textContent=file.name+' ('+(file.size/1024).toFixed(0)+' KB)';
        /* Clear URL field so server uses the uploaded file */
        $('em-final-url').value='';
        showToast('📷','Photo selected: '+file.name);
    };
    reader.readAsDataURL(file);
}
function clearFile(){
    const fi=$('em-file-input'); if(fi) fi.value='';
    const fp=$('em-file-preview'); if(fp){ fp.src=''; fp.style.display='none'; }
    const info=$('em-file-info'); if(info) info.style.display='none';
}

function submitEdit(){
    if(!$('em-title').value.trim()){ showToast('⚠️','Course title cannot be empty!'); $('em-title').focus(); return; }
    showToast('💾','Saving changes…');
    setTimeout(()=>$('editCourseForm').submit(),350);
}

/* ════════════════════════════
   VIEW MODAL
════════════════════════════ */
function openViewModal(btn){
    const d=cardData(btn); if(!d) return;
    tx('vm-title',d.title); tx('vm-cat',d.category);
    tx('vm-price','₹'+Number(d.price).toLocaleString('en-IN'));
    tx('vm-students',d.students);
    tx('vm-rating',Number(d.rating)>0?Number(d.rating).toFixed(1)+' ⭐':'—');
    tx('vm-lectures',d.sections); tx('vm-duration',d.duration);
    tx('vm-level',d.level); tx('vm-desc',d.desc);
    setThumb('vm-img','vm-img-ph',d.thumb);
    openModal('viewModal');
}

/* ════════════════════════════
   PREVIEW MODAL
════════════════════════════ */
function openPreviewModal(btn){
    const d=cardData(btn); if(!d) return;
    tx('pv-title',d.title); tx('pv-cat',d.category); tx('pv-hero-title',d.title);
    tx('pv-lec',d.sections); tx('pv-dur',d.duration); tx('pv-level',d.level);
    tx('pv-price','₹'+Number(d.price).toLocaleString('en-IN'));
    tx('pv-stat-lec',d.sections); tx('pv-stat-dur',d.duration); tx('pv-desc',d.desc);
    setThumb('pv-img','pv-img-ph',d.thumb);
    tx('pv-watermark-text',d.status==='DRAFT'?'Only you can see this — students will see it when Live':'Under review — will go Live after admin approval');
    const ad=$('pv-action'); ad.innerHTML='';
    if(d.status==='DRAFT'){
        const f=document.createElement('form'); f.method='post';
        f.action=(d.ctx||'')+'/instructor/my-courses/submit-review';
        const hi=document.createElement('input'); hi.type='hidden'; hi.name='courseId'; hi.value=d.id;
        const sb=document.createElement('button'); sb.type='submit'; sb.className='btn-submit-review';
        sb.innerHTML='<i class="fas fa-paper-plane"></i> Submit for Review';
        f.appendChild(hi); f.appendChild(sb); ad.appendChild(f);
    } else {
        const sp=document.createElement('span');
        sp.style.cssText='font-size:0.78rem;color:#fbbf24;font-weight:600;display:flex;align-items:center;gap:0.4rem';
        sp.innerHTML='<i class="fas fa-hourglass-half"></i> Under Review';
        ad.appendChild(sp);
    }
    openModal('previewModal');
}

/* ════════════════════════════
   DETAILS MODAL
════════════════════════════ */
function openDetailsModal(btn){
    const d=cardData(btn); if(!d) return;
    tx('dtl-title',d.title);
    const eyebrow=$('dtl-eyebrow'),body=$('dtl-body');
    const el=(tag,txt,cls,sty)=>{ const e=document.createElement(tag);if(cls)e.className=cls;if(sty)e.style.cssText=sty;if(txt!==undefined)e.textContent=txt;return e; };
    const ht=(tag,mk,cls,sty)=>{ const e=document.createElement(tag);if(cls)e.className=cls;if(sty)e.style.cssText=sty;e.innerHTML=mk;return e; };
    body.innerHTML='';

    if(d.status==='REJECTED'){
        eyebrow.innerHTML='<i class="fas fa-times-circle"></i> Review Status'; eyebrow.style.color='#f87171';
        body.appendChild(ht('div','<div class="dtl-banner-icon">❌</div><div><div class="dtl-banner-heading">Course Rejected</div><div class="dtl-banner-text">Please fix the issues below and resubmit.</div></div>','dtl-banner dtl-banner-rejected'));
        if(d.rejection&&d.rejection.trim()){
            const fb=document.createElement('div'); fb.className='dtl-feedback';
            fb.appendChild(ht('div','<i class="fas fa-comment-alt"></i> Admin Feedback','dtl-feedback-lbl'));
            fb.appendChild(el('div',d.rejection,'dtl-feedback-text')); body.appendChild(fb);
        }
        body.appendChild(ht('div','TIMELINE','sec-label','margin-bottom:0.75rem'));
        body.appendChild(ht('div',
            '<div class="dtl-tl-item"><div class="dtl-tl-dot dot-done"></div><div class="dtl-tl-text">Course submitted for review</div></div>'+
            '<div class="dtl-tl-item"><div class="dtl-tl-dot dot-done"></div><div class="dtl-tl-text">Automated checks passed</div></div>'+
            '<div class="dtl-tl-item"><div class="dtl-tl-dot dot-rejected"></div><div class="dtl-tl-text" style="color:#f87171">Course Rejected</div><div class="dtl-tl-sub">Fix issues and resubmit</div></div>',
            'dtl-timeline'));
        const grid=document.createElement('div'); grid.className='dtl-info-grid';
        [['Lectures',d.sections],['Duration',d.duration],['Price','₹'+Number(d.price).toLocaleString('en-IN')],['Status','Rejected']].forEach(([lbl,val])=>{
            const cell=ht('div','<div class="dtl-info-lbl">'+lbl+'</div>','dtl-info-cell');
            const ve=el('div',val,'dtl-info-val'); if(lbl==='Status') ve.style.color='#f87171';
            cell.appendChild(ve); grid.appendChild(cell);
        });
        body.appendChild(grid);
        const editBtn=document.createElement('button');
        editBtn.className='btn-resubmit'; editBtn.type='button';
        editBtn.innerHTML='<i class="fas fa-edit"></i> Fix &amp; Edit Course';
        editBtn.onclick=()=>{
            closeModal('detailsModal');
            const card=document.querySelector('.course-card[data-id="'+d.id+'"]');
            if(card) openEditModal({closest:()=>card});
        };
        body.appendChild(editBtn);
    } else {
        eyebrow.innerHTML='<i class="fas fa-hourglass-half"></i> Review Status'; eyebrow.style.color='#fbbf24';
        body.appendChild(ht('div',
            '<div class="dtl-banner-icon">⏳</div><div><div class="dtl-banner-heading">Review In Progress</div><div class="dtl-banner-text">Awaiting admin decision. Editing locked.<br>Estimated: <strong style="color:#fbbf24">48 hours</strong></div></div>',
            'dtl-banner dtl-banner-pending'));
        body.appendChild(ht('div','REVIEW TIMELINE','sec-label','margin-bottom:0.75rem'));
        const tl=ht('div',
            '<div class="dtl-tl-item"><div class="dtl-tl-dot dot-done"></div><div class="dtl-tl-text">Submitted for review</div><div class="dtl-tl-sub" id="_tlsub"></div></div>'+
            '<div class="dtl-tl-item"><div class="dtl-tl-dot dot-done"></div><div class="dtl-tl-text">Automated checks passed</div><div class="dtl-tl-sub">Content policy verified</div></div>'+
            '<div class="dtl-tl-item"><div class="dtl-tl-dot dot-pulse"></div><div class="dtl-tl-text">Manual review in progress</div></div>'+
            '<div class="dtl-tl-item"><div class="dtl-tl-dot dot-wait"></div><div class="dtl-tl-text" style="color:var(--slate)">Final decision pending</div></div>',
            'dtl-timeline');
        body.appendChild(tl);
        const sub=tl.querySelector('#_tlsub'); if(sub) sub.textContent=d.sections+' lectures · '+d.duration;
        const grid=document.createElement('div'); grid.className='dtl-info-grid';
        [['Est. Review Time','48 hours'],['Lectures',d.sections],['Duration',d.duration],['Price','₹'+Number(d.price).toLocaleString('en-IN')]].forEach(([lbl,val])=>{
            const cell=ht('div','<div class="dtl-info-lbl">'+lbl+'</div>','dtl-info-cell');
            cell.appendChild(el('div',val,'dtl-info-val')); grid.appendChild(cell);
        });
        body.appendChild(grid);
    }
    openModal('detailsModal');
}

/* Toast */
let _tt;
function showToast(icon,msg){
    tx('toastIcon',icon); tx('toastMsg',msg);
    $('toastEl').classList.add('show');
    clearTimeout(_tt); _tt=setTimeout(()=>$('toastEl').classList.remove('show'),3200);
}

/* Filters */
function buildCategoryOptions(){
    const seen=new Set(),sel=$('categoryFilter');
    document.querySelectorAll('.course-card').forEach(c=>{
        const cat=c.dataset.category;
        if(cat&&!seen.has(cat)){ seen.add(cat); const o=document.createElement('option'); o.value=cat; o.textContent=cat; sel.appendChild(o); }
    });
}
buildCategoryOptions();

function filterCourses(){
    const s=$('searchInput').value.toLowerCase(), sv=$('statusFilter').value, cv=$('categoryFilter').value;
    let n=0;
    document.querySelectorAll('.course-card').forEach(c=>{
        const ok=c.dataset.title.toLowerCase().includes(s)&&(sv==='all'||c.dataset.status===sv)&&(cv==='all'||c.dataset.category===cv);
        c.style.display=ok?'':'none'; if(ok)n++;
    });
    const grid=$('coursesGrid'),nr=$('noResults');
    if(grid) grid.style.display=n?'grid':'none';
    if(nr)   nr.style.display=n?'none':'block';
}
['searchInput','statusFilter','categoryFilter'].forEach(id=>{
    const e=$(id); if(e) e.addEventListener(id==='searchInput'?'input':'change',filterCourses);
});

/* Single load handler — flash messages + alert auto-dismiss */
window.addEventListener('load', function() {

    /* Show toast for server flash messages (safe — no inline JS string injection) */
    var successEl = document.getElementById('flash-success');
    var errorEl   = document.getElementById('flash-error');
    if (successEl) showToast('✅', successEl.textContent.trim());
    if (errorEl)   showToast('❌', errorEl.textContent.trim());

    /* Auto-dismiss alert banners after 3 s */
    var alertEls = document.querySelectorAll('.alert');
    for (var i = 0; i < alertEls.length; i++) {
        (function(el) {
            setTimeout(function() {
                el.classList.add('hide');
                setTimeout(function() { if (el.parentNode) el.parentNode.removeChild(el); }, 600);
            }, 3000);
        })(alertEls[i]);
    }
});

/* Sidebar JS handled by sidebar.jsp */
</script>
</body>
</html>
