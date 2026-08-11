<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar Navigation -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-graduation-cap"></i>
        <span>EduMaster</span>
    </div>
    
    <nav class="nav-section">
        <!-- Dashboard -->
        <a href="/instructor/dashboard" class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-th-large"></i>
            <span>Dashboard</span>
        </a>

        <!-- My Courses -->
        <a href="/instructor/my-courses" class="nav-link ${currentPage == 'my-courses' ? 'active' : ''}">
            <i class="fas fa-book-open"></i>
            <span>My Courses</span>
        </a>

        <!-- Create Course -->
        <a href="/instructor/create-course" class="nav-link ${currentPage == 'create-course' ? 'active' : ''}">
            <i class="fas fa-plus-circle"></i>
            <span>Create Course</span>
        </a>

        <!-- Course Content -->
        <a href="/instructor/course-content" class="nav-link ${currentPage == 'course-content' ? 'active' : ''}">
            <i class="fas fa-folder-open"></i>
            <span>Course Content</span>
        </a>

        <!-- Students -->
        <a href="/instructor/students" class="nav-link ${currentPage == 'students' ? 'active' : ''}">
            <i class="fas fa-users"></i>
            <span>Students</span>
        </a>

        <!-- Earnings -->
        <a href="/instructor/earnings" class="nav-link ${currentPage == 'earnings' ? 'active' : ''}">
            <i class="fas fa-wallet"></i>
            <span>Earnings</span>
        </a>

        <!-- Reviews -->
        <a href="/instructor/reviews" class="nav-link ${currentPage == 'reviews' ? 'active' : ''}">
            <i class="fas fa-comment-dots"></i>
            <span>Reviews</span>
        </a>

        <!-- Analytics -->
        <a href="/instructor/assignment" class="nav-link ${currentPage == 'analytics' ? 'active' : ''}">
            <i class="fas fa-chart-line"></i>
            <span>Assignmnet</span>
        </a>

        <!-- Settings -->
        <a href="/instructor/settings" class="nav-link ${currentPage == 'settings' ? 'active' : ''}">
            <i class="fas fa-cog"></i>
            <span>Settings</span>
        </a>

		<!-- Logout -->
		<a href="${pageContext.request.contextPath}/instructor/logout-confirm" class="nav-link">
		    <i class="fas fa-sign-out-alt"></i>
		    <span>Logout</span>
		</a>
    </nav>
</aside>

<!-- Sidebar CSS -->
<style>
.sidebar{width:280px;position:fixed;top:0;left:0;bottom:0;background:linear-gradient(180deg,rgba(30,41,59,0.95) 0%,rgba(15,23,42,0.95) 100%);backdrop-filter:blur(20px);border-right:1px solid rgba(99,102,241,0.2);z-index:1000;overflow-y:auto;box-shadow:4px 0 40px rgba(0,0,0,0.5);transition:margin-left 0.3s}
.sidebar-brand{padding:2rem 1.5rem;border-bottom:1px solid rgba(99,102,241,0.2);display:flex;align-items:center;gap:0.75rem;font-weight:800;font-size:1.5rem;background:linear-gradient(135deg,rgba(99,102,241,0.2),rgba(139,92,246,0.2))}
.sidebar-brand i{font-size:1.8rem;background:linear-gradient(135deg,#6366f1,#8b5cf6);-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.nav-section{padding:1.5rem 0}
.nav-link{color:#94a3b8;padding:1rem 1.5rem;font-weight:500;display:flex;align-items:center;text-decoration:none;border-left:3px solid transparent;transition:all 0.3s;position:relative}
.nav-link::before{content:'';position:absolute;left:0;top:0;bottom:0;width:0;background:linear-gradient(90deg,rgba(99,102,241,0.2),transparent);transition:width 0.3s}
.nav-link:hover::before{width:100%}
.nav-link:hover{color:#fff;border-left-color:#6366f1;transform:translateX(4px)}
.nav-link.active{color:#fff;background:rgba(99,102,241,0.15);border-left-color:#6366f1;box-shadow:0 0 30px rgba(99,102,241,0.3)}
.nav-link i{width:28px;margin-right:0.85rem;transition:transform 0.3s}
.nav-link:hover i{transform:scale(1.2)}
.sidebar::-webkit-scrollbar{width:6px}
.sidebar::-webkit-scrollbar-track{background:rgba(15,23,42,0.5)}
.sidebar::-webkit-scrollbar-thumb{background:linear-gradient(180deg,#6366f1,#8b5cf6);border-radius:10px}
@media (max-width:900px){
.sidebar{margin-left:-280px}
.sidebar.active{margin-left:0}}
</style>

<script>
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    if (sidebar) {
        sidebar.classList.toggle('active');
    }
}
</script>