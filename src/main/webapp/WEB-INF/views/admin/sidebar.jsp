<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- SIDEBAR STYLES -->
<style>
    /* Sidebar theme variables - Normal and Extra Dark options */
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

    .theme-buttons {
        display: flex;
        gap: 0.48rem;
        flex-direction: column;
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

    @media (max-width: 900px) {
        .sidebar {
            margin-left: -280px;
        }
        .sidebar.open {
            margin-left: 0;
        }
    }
</style>

<!-- SIDEBAR HTML -->
<nav class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-graduation-cap"></i>
        <span>EduMaster</span>
    </div>
    
    <div class="nav-section">
        <!-- Dashboard -->
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link <%= request.getRequestURI().contains("/dashboard") ? "active" : "" %>">
            <i class="fas fa-th-large"></i> Dashboard
        </a>

        <!-- MANAGEMENT Section -->
        <div class="nav-section-title">Management</div>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link <%= request.getRequestURI().contains("/users") ? "active" : "" %>">
            <i class="fas fa-users"></i> User Management
        </a>
        <a href="${pageContext.request.contextPath}/admin/courses" class="nav-link <%= request.getRequestURI().contains("/courses") ? "active" : "" %>">
            <i class="fas fa-book-open"></i> Course Approval
        </a>
        <a href="${pageContext.request.contextPath}/admin/instructors" class="nav-link <%= request.getRequestURI().contains("/instructors") ? "active" : "" %>">
            <i class="fas fa-chalkboard-teacher"></i> Instructors
        </a>

        <!-- FINANCE Section -->
        <div class="nav-section-title">Finance</div>
        <a href="${pageContext.request.contextPath}/admin/transactions" class="nav-link <%= request.getRequestURI().contains("/transactions") ? "active" : "" %>">
            <i class="fas fa-exchange-alt"></i> Transactions
        </a>
        <a href="${pageContext.request.contextPath}/admin/payouts" class="nav-link <%= request.getRequestURI().contains("/payouts") ? "active" : "" %>">
            <i class="fas fa-wallet"></i> Payouts
        </a>
        <a href="${pageContext.request.contextPath}/admin/refunds" class="nav-link <%= request.getRequestURI().contains("/refunds") ? "active" : "" %>">
            <i class="fas fa-undo"></i> Refunds
        </a>

        <!-- SYSTEM Section -->
        <div class="nav-section-title">System</div>
        <a href="${pageContext.request.contextPath}/admin/settings" class="nav-link <%= request.getRequestURI().contains("/settings") ? "active" : "" %>">
            <i class="fas fa-cog"></i> Settings
        </a>
        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="nav-link <%= request.getRequestURI().contains("/audit") ? "active" : "" %>">
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

<!-- SIDEBAR JAVASCRIPT -->
<script>
    // Page Theme Switcher Function
    function setTheme(theme, btn) {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('edumaster-theme', theme);
        
        document.querySelectorAll('.theme-btn').forEach(b => b.classList.remove('active'));
        if(btn) btn.classList.add('active');
        
        // Trigger custom event for dashboard to update charts
        window.dispatchEvent(new CustomEvent('themeChanged', { detail: { theme } }));
    }
    
    // Sidebar Theme Switcher Function
    function setSidebarTheme(sidebarTheme, btn) {
        document.documentElement.setAttribute('data-sidebar', sidebarTheme);
        localStorage.setItem('edumaster-sidebar-theme', sidebarTheme);
        
        document.querySelectorAll('.sidebar-theme-btn').forEach(b => b.classList.remove('active'));
        if(btn) btn.classList.add('active');
    }

    // Load saved themes on page load
    (function() {
        // Load page theme
        const savedTheme = localStorage.getItem('edumaster-theme') || 'theme1';
        document.documentElement.setAttribute('data-theme', savedTheme);
        
        document.querySelectorAll('.theme-btn').forEach(btn => {
            if (btn.dataset.theme === savedTheme) {
                btn.classList.add('active');
            }
        });
        
        // Load sidebar theme
        const savedSidebarTheme = localStorage.getItem('edumaster-sidebar-theme') || 'normal';
        document.documentElement.setAttribute('data-sidebar', savedSidebarTheme);
        
        document.querySelectorAll('.sidebar-theme-btn').forEach(btn => {
            if (btn.dataset.sidebar === savedSidebarTheme) {
                btn.classList.add('active');
            }
        });
    })();
</script>
