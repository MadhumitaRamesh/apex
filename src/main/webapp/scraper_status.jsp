<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("admin_login.jsp?error=access_denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scraper Status | Apex Console</title>
    <link rel="stylesheet" href="css/styles.css?v=2.0">
</head>
<body>
    <jsp:include page="includes/navbar.jsp" />

    <div class="page-wrapper">
        <div class="page-header">
            <p class="page-label">System Performance</p>
            <h1 class="page-title">Scraper Engine Status</h1>
            <p class="page-subtitle">Monitor the health and performance of independent market scrapers.</p>
        </div>

        <div class="page-grid">
            <!-- Sidebar -->
            <aside class="sidebar">
                <p class="sidebar-title">Admin Identity</p>
                <div class="stat-item">
                    <div class="stat-label">Name</div>
                    <div class="stat-value"><%= session.getAttribute("userName") %></div>
                </div>
                
                <p class="sidebar-title" style="margin-top:2rem;">Management Utilities</p>
                <nav class="quick-links">
                    <a href="admin_dashboard">Overview &amp; Users</a>
                    <a href="scraper_status.jsp" class="active">Scraper Status</a>
                    <a href="system_logs.jsp">System Logs</a>
                    <a href="index.jsp" class="link-primary">← Switch to User View</a>
                </nav>
            </aside>

            <!-- Main Content -->
            <div class="content-area">
                <div class="section-header">
                    <h2 class="section-title">Active Scraper Threads</h2>
                </div>

                <div class="card" style="padding:0; overflow:hidden;">
                    <table style="width:100%; border-collapse:collapse; font-size:0.9rem;">
                        <thead style="background:var(--bg-sidebar); border-bottom:1px solid var(--border);">
                            <tr>
                                <th style="text-align:left; padding:1rem;">Scraper Name</th>
                                <th style="text-align:left; padding:1rem;">Target Platform</th>
                                <th style="text-align:left; padding:1rem;">Last Run</th>
                                <th style="text-align:left; padding:1rem;">Latency</th>
                                <th style="text-align:right; padding:1rem;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr style="border-bottom:1px solid var(--border-light);">
                                <td style="padding:1rem;"><strong>Amazon Prime Scraper</strong></td>
                                <td style="padding:1rem;">amazon.in</td>
                                <td style="padding:1rem; color:var(--text-secondary);">Just now</td>
                                <td style="padding:1rem; color:var(--success);">1.2s</td>
                                <td style="padding:1rem; text-align:right;">
                                    <span class="badge" style="background:#f0fdf4; color:#16a34a;">Healthy</span>
                                </td>
                            </tr>
                            <tr style="border-bottom:1px solid var(--border-light);">
                                <td style="padding:1rem;"><strong>Flipkart Rome Scraper</strong></td>
                                <td style="padding:1rem;">flipkart.com</td>
                                <td style="padding:1rem; color:var(--text-secondary);">2 mins ago</td>
                                <td style="padding:1rem; color:var(--success);">0.8s</td>
                                <td style="padding:1rem; text-align:right;">
                                    <span class="badge" style="background:#f0fdf4; color:#16a34a;">Healthy</span>
                                </td>
                            </tr>
                            <tr style="border-bottom:1px solid var(--border-light);">
                                <td style="padding:1rem;"><strong>Price History Aggregator</strong></td>
                                <td style="padding:1rem;">Internal</td>
                                <td style="padding:1rem; color:var(--text-secondary);">10 mins ago</td>
                                <td style="padding:1rem; color:var(--primary);">0.2s</td>
                                <td style="padding:1rem; text-align:right;">
                                    <span class="badge" style="background:#f0fdf4; color:#16a34a;">Healthy</span>
                                </td>
                            </tr>
                            <tr style="border-bottom:1px solid var(--border-light);">
                                <td style="padding:1rem;"><strong>Reliance Digital Scraper</strong></td>
                                <td style="padding:1rem;">reliancedigital.in</td>
                                <td style="padding:1rem; color:var(--text-secondary);">Disconnected</td>
                                <td style="padding:1rem; color:var(--text-muted);">N/A</td>
                                <td style="padding:1rem; text-align:right;">
                                    <span class="badge" style="background:#fef2f2; color:#dc2626;">Offline</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="features-grid" style="margin-top:2rem;">
                    <div class="feature-card">
                        <div class="feature-value" style="color:var(--success);">3/4</div>
                        <div class="feature-label">Active Threads</div>
                        <p class="feature-desc">Scrapers currently polling for price updates.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-value">98.2%</div>
                        <div class="feature-label">Success Rate</div>
                        <p class="feature-desc">Last 24 hours of scrape operations.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-value">850ms</div>
                        <div class="feature-label">Avg Latency</div>
                        <p class="feature-desc">Mean response time across all platforms.</p>
                    </div>
                </div>
            </div>
        </div>

        <footer class="page-footer">
            <p>&copy; 2026 Apex Control &bull; System Administration Module</p>
        </footer>
    </div>
</body>
</html>
