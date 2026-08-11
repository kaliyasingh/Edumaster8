<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    // Set current page for sidebar highlighting
    request.setAttribute("currentPage", "dashboard");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>EduMaster Pro | Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style type="text/css">
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', sans-serif;
    background: #0a0e1a;
    color: #e2e8f0;
    overflow-x: hidden;
}

.animated-bg {
    position: fixed;
    inset: 0;
    z-index: 0;
    pointer-events: none;
    background: radial-gradient(circle at 20% 50%, rgba(99, 102, 241, 0.08) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(139, 92, 246, 0.08) 0%, transparent 50%);
}

/* Main Content Styles */
.main {
    margin-left: 280px;
    min-height: 100vh;
    position: relative;
    z-index: 1;
    transition: margin-left 0.3s;
}

.top-bar {
    background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(139, 92, 246, 0.1));
    backdrop-filter: blur(20px);
    padding: 2rem 3rem;
    border-bottom: 1px solid rgba(99, 102, 241, 0.2);
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.2);
    position: sticky;
    top: 0;
    z-index: 100;
    animation: slideDown 0.6s;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 1.5rem;
}

.page-title h1 {
    font-size: 2.2rem;
    font-weight: 800;
    background: linear-gradient(135deg, #fff, #a5b4fc);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 0.5rem;
}

.page-title p {
    color: #94a3b8;
    font-size: 1.05rem;
}

.content {
    max-width: 1400px;
    margin: 0 auto;
    padding: 2.5rem 3rem;
    animation: fadeIn 0.6s;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.row {
    display: grid;
    gap: 1.5rem;
}

.row-4 {
    grid-template-columns: repeat(4, minmax(0, 1fr));
}

.row-2 {
    grid-template-columns: repeat(2, minmax(0, 1fr));
}

.card {
    background: rgba(30, 41, 59, 0.5);
    backdrop-filter: blur(20px);
    border-radius: 20px;
    padding: 2rem;
    border: 1px solid rgba(99, 102, 241, 0.2);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    transition: all 0.3s;
}

.card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 40px rgba(99, 102, 241, 0.3);
}

/* Stat Cards */
.stat-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.stat-label {
    color: #94a3b8;
    font-size: 0.9rem;
    font-weight: 500;
    margin-bottom: 0.5rem;
}

.stat-value {
    font-size: 2rem;
    font-weight: 800;
    background: linear-gradient(135deg, #fff, #a5b4fc);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.stat-icon {
    width: 60px;
    height: 60px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
}

.stat-icon.purple {
    background: linear-gradient(135deg, rgba(99, 102, 241, 0.2), rgba(139, 92, 246, 0.2));
    color: #a5b4fc;
}

.stat-icon.green {
    background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(5, 150, 105, 0.2));
    color: #6ee7b7;
}

.stat-icon.blue {
    background: linear-gradient(135deg, rgba(59, 130, 246, 0.2), rgba(37, 99, 235, 0.2));
    color: #93c5fd;
}

.stat-icon.orange {
    background: linear-gradient(135deg, rgba(245, 158, 11, 0.2), rgba(217, 119, 6, 0.2));
    color: #fcd34d;
}

/* Action Cards */
.action-card {
    background: rgba(30, 41, 59, 0.5);
    backdrop-filter: blur(20px);
    border: 2px dashed rgba(99, 102, 241, 0.3);
    border-radius: 16px;
    padding: 2rem;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
    text-decoration: none;
    color: #94a3b8;
    transition: all 0.3s;
}

.action-card:hover {
    border-color: #6366f1;
    background: rgba(99, 102, 241, 0.1);
    transform: translateY(-5px);
    color: #e2e8f0;
}

.action-top {
    display: flex;
    align-items: center;
    gap: 0.6rem;
}

.action-icon {
    width: 40px;
    height: 40px;
    border-radius: 10px;
    background: rgba(99, 102, 241, 0.1);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #6366f1;
    font-size: 1.2rem;
    transition: all 0.3s;
}

.action-card:hover .action-icon {
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    color: white;
}

.action-label {
    font-weight: 600;
    font-size: 1rem;
}

.action-desc {
    font-size: 0.85rem;
    color: #94a3b8;
}

/* Analytics */
.analytics-card .section-title {
    font-size: 1.25rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.analytics-card .section-title i {
    color: #6366f1;
}

.analytics-bars {
    display: flex;
    align-items: flex-end;
    gap: 0.5rem;
    height: 200px;
    background: rgba(15, 23, 42, 0.4);
    border-radius: 12px;
    padding: 1.5rem;
}

.analytics-bar {
    flex: 1;
    border-radius: 6px 6px 0 0;
    background: linear-gradient(to top, #4f46e5, #6366f1);
}

.analytics-footer {
    margin-top: 1rem;
    display: flex;
    justify-content: space-between;
    font-size: 0.85rem;
    color: #94a3b8;
}

.section-title {
    font-size: 1.25rem;
    font-weight: 700;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.section-title i {
    color: #6366f1;
}

/* Table */
table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.9rem;
}

th, td {
    padding: 1rem;
    text-align: left;
    border-bottom: 1px solid rgba(99, 102, 241, 0.1);
}

th {
    font-weight: 600;
    color: #a5b4fc;
    font-size: 0.85rem;
}

tr:last-child td {
    border-bottom: none;
}

tbody tr {
    transition: all 0.3s;
}

tbody tr:hover {
    background: rgba(99, 102, 241, 0.05);
}

.badge {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.4rem 0.9rem;
    border-radius: 20px;
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
}

.badge-live {
    background: rgba(16, 185, 129, 0.2);
    color: #6ee7b7;
    border: 1px solid rgba(16, 185, 129, 0.3);
}

.badge-pending {
    background: rgba(245, 158, 11, 0.2);
    color: #fcd34d;
    border: 1px solid rgba(245, 158, 11, 0.3);
}

/* Activity List */
.activity-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.activity-item {
    padding: 1.25rem;
    border-radius: 14px;
    background: rgba(15, 23, 42, 0.4);
    border: 1px solid transparent;
    transition: all 0.3s;
    display: flex;
    justify-content: space-between;
    gap: 1rem;
}

.activity-item:hover {
    background: rgba(99, 102, 241, 0.1);
    border-color: rgba(99, 102, 241, 0.3);
}

.activity-main {
    font-size: 0.9rem;
}

.activity-main strong {
    color: #e2e8f0;
}

.activity-meta {
    font-size: 0.85rem;
    color: #94a3b8;
    margin-top: 0.25rem;
}

.activity-time {
    font-size: 0.75rem;
    color: #64748b;
    white-space: nowrap;
}

/* Responsive */
@media (max-width: 1200px) {
    .row-4 {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 900px) {
    .row-2 {
        grid-template-columns: 1fr;
    }
    
    .main {
        margin-left: 0;
    }
    
    .content {
        padding: 1.5rem;
    }
    
    .top-bar {
        padding: 1.5rem;
    }
    
    .page-header {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .row-4 {
        grid-template-columns: 1fr;
    }
}
    </style>
</head>
<body>
    <div class="animated-bg"></div>

    <!-- Include Reusable Sidebar -->
    <jsp:include page="sidebar.jsp"/>

    <main class="main">
        <div class="top-bar">
            <div class="page-header">
                <div class="page-title">
                    <h1>Welcome back,user 👋</h1>
                    <p>Here's what's happening with your courses today</p>
                </div>
            </div>
        </div>

        <div class="content">
            <!-- Stats Section -->
            <section class="row row-4" style="margin-bottom:2.5rem;">
                <div class="card stat-card">
                    <div class="stat-info">
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value">₹30K</div>
                    </div>
                    <div class="stat-icon green">
                        <i class="fas fa-rupee-sign"></i>
                    </div>
                </div>
                <div class="card stat-card">
                    <div class="stat-info">
                        <div class="stat-label">Total Students</div>
                        <div class="stat-value">50</div>
                    </div>
                    <div class="stat-icon purple">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                </div>
                <div class="card stat-card">
                    <div class="stat-info">
                        <div class="stat-label">Active Courses</div>
                        <div class="stat-value">12</div>
                    </div>
                    <div class="stat-icon orange">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <div class="card stat-card">
                    <div class="stat-info">
                        <div class="stat-label">Average Rating</div>
                        <div class="stat-value">4.8</div>
                    </div>
                    <div class="stat-icon blue">
                        <i class="fas fa-star"></i>
                    </div>
                </div>
            </section>

            <!-- Quick Actions -->
            <section class="row row-4" style="margin-bottom:2.5rem;">
                <a href="/instructor/create-course" class="card action-card">
                    <div class="action-top">
                        <div class="action-icon"><i class="fas fa-plus"></i></div>
                        <div class="action-label">Create New Course</div>
                    </div>
                    <p class="action-desc">Start a fresh course with curriculum, videos and resources</p>
                </a>
                <a href="/instructor/course-content" class="card action-card">
                    <div class="action-top">
                        <div class="action-icon"><i class="fas fa-upload"></i></div>
                        <div class="action-label">Upload Content</div>
                    </div>
                    <p class="action-desc">Add lectures, PDFs and Source code</p>
                </a>
                <a href="#" class="card action-card">
                    <div class="action-top">
                        <div class="action-icon"><i class="fas fa-clipboard-check"></i></div>
                        <div class="action-label">Grade Assignments</div>
                    </div>
                    <p class="action-desc">Review pending submissions and give feedback</p>
                </a>
                <a href="#" class="card action-card">
                    <div class="action-top">
                        <div class="action-icon"><i class="fas fa-comments"></i></div>
                        <div class="action-label">Answer Questions</div>
                    </div>
                    <p class="action-desc">Respond to student queries in course discussions</p>
                </a>
            </section>

            <!-- Analytics Graph -->
            <section class="card analytics-card" style="margin-bottom:2rem;">
                <div class="section-title">
                    <i class="fas fa-chart-line"></i><span>Weekly Enrollments</span>
                </div>
                <div class="analytics-bars">
                    <div class="analytics-bar" style="height:35%;"></div>
                    <div class="analytics-bar" style="height:55%;"></div>
                    <div class="analytics-bar" style="height:48%;"></div>
                    <div class="analytics-bar" style="height:70%;"></div>
                    <div class="analytics-bar" style="height:62%;"></div>
                    <div class="analytics-bar" style="height:82%;"></div>
                    <div class="analytics-bar" style="height:100%;"></div>
                </div>
                <div class="analytics-footer">
                    <span>Mon</span><span>Tue</span><span>Wed</span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span>
                </div>
            </section>

            <!-- Bottom Section -->
            <section class="row row-2">
                <!-- Top Courses Table -->
                <div class="card">
                    <div class="section-title">
                        <i class="fas fa-book-open"></i><span>Top Performing Courses</span>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Course</th>
                                <th>Students</th>
                                <th>Revenue</th>
                                <th>Rating</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Java Complete Masterclass</td>
                                <td>847</td>
                                <td>₹84.7K</td>
                                <td>4.8</td>
                                <td><span class="badge badge-live"><i class="fas fa-circle"></i> Live</span></td>
                            </tr>
                            <tr>
                                <td>Python for Data Science</td>
                                <td>632</td>
                                <td>₹82.1K</td>
                                <td>4.9</td>
                                <td><span class="badge badge-live"><i class="fas fa-circle"></i> Live</span></td>
                            </tr>
                            <tr>
                                <td>Node.js Backend Development</td>
                                <td>521</td>
                                <td>₹78.1K</td>
                                <td>4.7</td>
                                <td><span class="badge badge-live"><i class="fas fa-circle"></i> Live</span></td>
                            </tr>
                            <tr>
                                <td>React JS Bootcamp</td>
                                <td>416</td>
                                <td>₹52.3K</td>
                                <td>4.6</td>
                                <td><span class="badge badge-pending"><i class="fas fa-clock"></i> Pending</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Recent Activity -->
                <div class="card">
                    <div class="section-title">
                        <i class="fas fa-bolt"></i><span>Recent Activity</span>
                    </div>
                    <div class="activity-list">
                        <div class="activity-item">
                            <div class="activity-main">
                                <div>New enrollment in <strong>Java Masterclass</strong></div>
                                <div class="activity-meta">Sarah Johnson purchased the course</div>
                            </div>
                            <div class="activity-time">2m ago</div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-main">
                                <div>5-star review added</div>
                                <div class="activity-meta">Mike Chen rated <strong>Python for Data Science</strong></div>
                            </div>
                            <div class="activity-time">15m ago</div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-main">
                                <div>Assignments submitted</div>
                                <div class="activity-meta">5 new submissions to grade</div>
                            </div>
                            <div class="activity-time">1h ago</div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-main">
                                <div>New question in Q&A</div>
                                <div class="activity-meta">React JS Bootcamp discussion</div>
                            </div>
                            <div class="activity-time">3h ago</div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-main">
                                <div>Milestone reached</div>
                                <div class="activity-meta">Java course crossed 800 students</div>
                            </div>
                            <div class="activity-time">5h ago</div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>
</body>
</html>