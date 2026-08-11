<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EduMaster</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Chart.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
    
    <style>
        /* THEME VARIABLES - Only for main content area */
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

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body {
            background: var(--bg-body);
            color: var(--text-main);
            overflow-x: hidden;
            transition: background 0.3s ease, color 0.3s ease;
        }

        .animated-bg {
            position: fixed;
            inset: 0;
            z-index: 0;
            pointer-events: none;
            background: var(--animated-bg);
            transition: background 0.3s ease;
        }

        /* MAIN CONTENT */
        .main {
            margin-left: 280px;
            min-height: 100vh;
            position: relative;
            z-index: 1;
            transition: margin-left 0.3s;
        }

        .top-bar {
            background: var(--bg-header);
            backdrop-filter: blur(20px);
            padding: 2rem 3rem;
            border-bottom: 1px solid var(--border);
            box-shadow: 0 4px 30px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 100;
            transition: all 0.3s;
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
            background: linear-gradient(135deg, var(--text-main), var(--primary-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .page-title p {
            color: var(--text-light);
            font-size: 1.05rem;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.6rem 1rem;
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: 999px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .user-profile:hover {
            border-color: var(--primary);
            box-shadow: 0 0 20px rgba(99,102,241,0.3);
        }

        .avatar {
            width: 40px;
            height: 40px;
            background: radial-gradient(circle at 0 0, #4f46e5, #ec4899);
            color: #fff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.9rem;
            border: 2px solid rgba(249,250,251,0.9);
        }

        .user-info {
            text-align: right;
        }

        .user-info div:first-child {
            font-weight: 600;
            font-size: 0.9rem;
            color: var(--text-main);
        }

        .user-info div:last-child {
            font-size: 0.7rem;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.16em;
        }

        .content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2.5rem 3rem;
        }

        /* STATS GRID */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            inset: -40%;
            background: radial-gradient(circle at top left, rgba(79,70,229,0.15), transparent 60%);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .stat-card:hover::before { opacity: 1; }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 40px rgba(99,102,241,0.2);
        }

        .stat-content {
            position: relative;
            z-index: 1;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 0.85rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, var(--text-main), var(--primary-light));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .trend {
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.3rem 0.7rem;
            border-radius: 999px;
            background: rgba(16,185,129,0.15);
            border: 1px solid rgba(16,185,129,0.3);
            color: var(--success);
        }

        .trend.warning {
            background: rgba(245,158,11,0.15);
            border-color: rgba(245,158,11,0.3);
            color: var(--warning);
        }

        .stat-icon {
            position: absolute;
            right: 1.5rem;
            top: 1.5rem;
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            background: linear-gradient(135deg, rgba(99,102,241,0.2), rgba(139,92,246,0.2));
            color: var(--primary-light);
            z-index: 1;
        }

        .stat-icon.green {
            background: linear-gradient(135deg, rgba(16,185,129,0.2), rgba(5,150,105,0.2));
            color: var(--success);
        }

        .stat-icon.orange {
            background: linear-gradient(135deg, rgba(245,158,11,0.2), rgba(217,119,6,0.2));
            color: var(--warning);
        }

        .stat-icon.red {
            background: linear-gradient(135deg, rgba(239,68,68,0.2), rgba(185,28,28,0.2));
            color: var(--danger);
        }

        /* CHARTS */
        .charts-row {
            display: grid;
            grid-template-columns: 2fr 1.2fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .chart-card {
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            transition: all 0.3s;
        }

        .chart-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 40px rgba(99,102,241,0.2);
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-main);
        }

        .chart-title i {
            color: var(--primary);
        }

        .chart-header select {
            padding: 0.5rem 1rem;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: var(--bg-card);
            color: var(--text-main);
            font-size: 0.85rem;
            cursor: pointer;
            outline: none;
        }

        .chart-canvas {
            height: 300px;
            position: relative;
        }

        /* TABLE */
        .table-container {
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            border: 1px solid var(--border);
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: all 0.3s;
        }

        .table-container:hover {
            box-shadow: 0 12px 40px rgba(99,102,241,0.2);
        }

        .table-header {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-title {
            font-size: 1.25rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--text-main);
        }

        .table-title i {
            color: var(--primary);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            text-align: left;
            padding: 1rem 2rem;
            font-size: 0.8rem;
            text-transform: uppercase;
            color: var(--text-light);
            font-weight: 600;
            border-bottom: 1px solid var(--border);
            background: rgba(99,102,241,0.05);
        }

        td {
            padding: 1rem 2rem;
            border-bottom: 1px solid var(--border);
            color: var(--text-main);
            font-size: 0.9rem;
        }

        tr:hover td {
            background: rgba(99,102,241,0.05);
        }

        .status {
            padding: 0.4rem 0.9rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            text-transform: uppercase;
        }

        .status.active {
            background: rgba(16,185,129,0.2);
            color: var(--success);
            border: 1px solid rgba(16,185,129,0.3);
        }

        .status.pending {
            background: rgba(245,158,11,0.2);
            color: var(--warning);
            border: 1px solid rgba(245,158,11,0.3);
        }

        .status.failed {
            background: rgba(239,68,68,0.2);
            color: var(--danger);
            border: 1px solid rgba(239,68,68,0.3);
        }

        .btn {
            padding: 0.6rem 1.5rem;
            border-radius: 999px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 0.85rem;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--primary-light);
        }

        .btn-outline:hover {
            background: rgba(99,102,241,0.15);
            border-color: var(--primary);
        }

        /* RESPONSIVE */
        @media (max-width: 1024px) {
            .charts-row {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 900px) {
            .main {
                margin-left: 0;
            }
            .content {
                padding: 1.5rem;
            }
            .top-bar {
                padding: 1.5rem;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>

    <!-- INCLUDE SIDEBAR -->
    <%@ include file="sidebar.jsp" %>

    <!-- MAIN CONTENT -->
    <main class="main">
        <div class="top-bar">
            <div class="page-header">
                <div class="page-title">
                    <h1>Overview</h1>
                    <p>Live snapshot of platform users, revenue, courses and reviews</p>
                </div>
                <div class="user-profile">
                    <div class="user-info">
                        <div>Admin User</div>
                        <div>Super Admin</div>
                    </div>
                    <div class="avatar">AU</div>
                </div>
            </div>
        </div>

        <div class="content">
            <!-- STATS -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Total Users</div>
                        <div class="stat-value">50</div>
                        <span class="trend">
                            <i class="fas fa-arrow-up"></i> 
                        </span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-rupee-sign"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value">₹30K</div>
                        <span class="trend">
                            <i class="fas fa-arrow-up"></i>
                        </span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Active Courses</div>
                        <div class="stat-value">20</div>
                        <span class="trend">
                            <i class="fas fa-plus"></i>
                        </span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon red">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Pending Reviews</div>
                        <div class="stat-value">5</div>
                        <span class="trend warning">
                            <i class="fas fa-circle-exclamation"></i> Requires attention
                        </span>
                    </div>
                </div>
            </div>

            <!-- CHARTS -->
            <div class="charts-row">
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">
                            <i class="fas fa-chart-line"></i>
                            Revenue Analytics
                        </h3>
                        <select>
                            <option>This Year</option>
                            <option>Last 6 Months</option>
                            <option>Last Month</option>
                        </select>
                    </div>
                    <div class="chart-canvas">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">
                            <i class="fas fa-chart-pie"></i>
                            User Demographics
                        </h3>
                    </div>
                    <div class="chart-canvas">
                        <canvas id="pieChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- TABLE -->
            <div class="table-container">
                <div class="table-header">
                    <h3 class="table-title">
                        <i class="fas fa-bolt"></i>
                        Recent Activity
                    </h3>
                    <button class="btn btn-outline">View All</button>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Action</th>
                            <th>Target</th>
                            <th>Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <strong>John Doe</strong><br>
                                <small style="color:var(--text-light)">Instructor</small>
                            </td>
                            <td>Created Course</td>
                            <td>Java Masterclass 2024</td>
                            <td>Just now</td>
                            <td><span class="status pending"><i class="fas fa-clock"></i> Pending</span></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Sarah Smith</strong><br>
                                <small style="color:var(--text-light)">Student</small>
                            </td>
                            <td>Purchased</td>
                            <td>React Native Pro</td>
                            <td>2 mins ago</td>
                            <td><span class="status active"><i class="fas fa-circle"></i> Success</span></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Mike Ross</strong><br>
                                <small style="color:var(--text-light)">Student</small>
                            </td>
                            <td>Login Failed</td>
                            <td>IP: 192.168.1.5</td>
                            <td>15 mins ago</td>
                            <td><span class="status failed"><i class="fas fa-times"></i> Failed</span></td>
                        </tr>
                        <tr>
                            <td>
                                <strong>Emily Johnson</strong><br>
                                <small style="color:var(--text-light)">Instructor</small>
                            </td>
                            <td>Updated Content</td>
                            <td>Python for Data Science</td>
                            <td>30 mins ago</td>
                            <td><span class="status active"><i class="fas fa-circle"></i> Success</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- DASHBOARD JAVASCRIPT -->
    <script>
        let revenueChart = null;
        let pieChart = null;

        // Get current theme
        function getCurrentTheme() {
            return document.documentElement.getAttribute('data-theme') || 'theme1';
        }

        // Check if dark theme
        function isDarkTheme() {
            return getCurrentTheme() !== 'theme3';
        }

        // Revenue Chart
        function initRevenueChart() {
            const ctx = document.getElementById('revenueChart').getContext('2d');
            const dark = isDarkTheme();
            
            if (revenueChart) {
                revenueChart.destroy();
            }
            
            revenueChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'Revenue',
                        data: [45000, 52000, 48000, 61000, 58000, 67000, 72000, 69000, 75000, 81000, 78000, 85000],
                        borderColor: '#6366f1',
                        backgroundColor: (context) => {
                            const ctx = context.chart.ctx;
                            const gradient = ctx.createLinearGradient(0, 0, 0, 300);
                            gradient.addColorStop(0, 'rgba(99, 102, 241, 0.3)');
                            gradient.addColorStop(1, 'rgba(99, 102, 241, 0)');
                            return gradient;
                        },
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#6366f1',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 5,
                        pointHoverRadius: 7
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: {
                            backgroundColor: dark ? 'rgba(30, 41, 59, 0.95)' : 'rgba(255, 255, 255, 0.95)',
                            titleColor: dark ? '#e2e8f0' : '#1e293b',
                            bodyColor: dark ? '#94a3b8' : '#64748b',
                            borderColor: '#6366f1',
                            borderWidth: 1,
                            padding: 12,
                            displayColors: false,
                            callbacks: {
                                label: (context) => '₹' + context.parsed.y.toLocaleString()
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                color: dark ? '#94a3b8' : '#64748b',
                                callback: (value) => '₹' + (value / 1000) + 'k'
                            },
                            grid: {
                                color: dark ? 'rgba(99, 102, 241, 0.1)' : 'rgba(99, 102, 241, 0.05)',
                                drawBorder: false
                            }
                        },
                        x: {
                            ticks: { color: dark ? '#94a3b8' : '#64748b' },
                            grid: { display: false }
                        }
                    }
                }
            });
        }

        // Pie Chart
        function initPieChart() {
            const ctx = document.getElementById('pieChart').getContext('2d');
            const dark = isDarkTheme();
            
            if (pieChart) {
                pieChart.destroy();
            }
            
            pieChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Students', 'Instructors', 'Admins'],
                    datasets: [{
                        data: [18450, 5893, 250],
                        backgroundColor: ['#6366f1', '#10b981', '#f59e0b'],
                        borderColor: dark ? '#1e293b' : '#ffffff',
                        borderWidth: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                color: dark ? '#e2e8f0' : '#1e293b',
                                padding: 15,
                                font: { size: 13, weight: '600' },
                                usePointStyle: true,
                                pointStyle: 'circle'
                            }
                        },
                        tooltip: {
                            backgroundColor: dark ? 'rgba(30, 41, 59, 0.95)' : 'rgba(255, 255, 255, 0.95)',
                            titleColor: dark ? '#e2e8f0' : '#1e293b',
                            bodyColor: dark ? '#94a3b8' : '#64748b',
                            borderColor: '#6366f1',
                            borderWidth: 1,
                            padding: 12,
                            callbacks: {
                                label: (context) => {
                                    const label = context.label || '';
                                    const value = context.parsed || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((value / total) * 100).toFixed(1);
                                    return label + ': ' + value.toLocaleString() + ' (' + percentage + '%)';
                                }
                            }
                        }
                    },
                    cutout: '65%'
                }
            });
        }

        // Initialize charts
        window.addEventListener('load', () => {
            initRevenueChart();
            initPieChart();
        });

        // Listen for theme changes from sidebar
        window.addEventListener('themeChanged', () => {
            initRevenueChart();
            initPieChart();
        });
    </script>
</body>
</html>
