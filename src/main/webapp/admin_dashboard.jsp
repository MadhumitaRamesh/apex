<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("admin_login.jsp?error=access_denied");
        return;
    }

    // Data is pre-loaded by AdminServlet
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> userList = (List<Map<String, Object>>) request.getAttribute("userList");
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> activities = (List<Map<String, Object>>) request.getAttribute("activities");
    @SuppressWarnings("unchecked")
    Map<String, Integer> analytics = (Map<String, Integer>) request.getAttribute("analytics");

    if (userList == null) userList = new ArrayList<>();
    if (activities == null) activities = new ArrayList<>();
    if (analytics == null) analytics = new HashMap<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Apex Console</title>
    <link rel="stylesheet" href="css/styles.css?v=2.0">
</head>
<body>
    <jsp:include page="includes/navbar.jsp" />

    <div class="page-wrapper">
        <div class="page-header">
            <p class="page-label">Administrative Overview</p>
            <h1 class="page-title">System Console</h1>
            <p class="page-subtitle">Manage users, monitor system health, and oversee market scrapers.</p>
        </div>

        <div class="page-grid">
            <!-- Admin Sidebar -->
            <aside class="sidebar">
                <p class="sidebar-title">Admin Identity</p>
                <div class="stat-item">
                    <div class="stat-label">Name</div>
                    <div class="stat-value"><%= session.getAttribute("userName") %></div>
                </div>
                <div class="stat-item">
                    <div class="stat-label">Access Level</div>
                    <div class="stat-value" style="color: var(--danger);">System Administrator</div>
                </div>

                <p class="sidebar-title" style="margin-top:2rem;">Management Utilities</p>
                <nav class="quick-links">
                    <a href="admin_dashboard" class="active">Overview &amp; Users</a>
                    <a href="scraper_status.jsp">Scraper Status</a>
                    <a href="system_logs">System Logs</a>
                    <a href="index.jsp" class="link-primary">← Switch to User View</a>
                </nav>
            </aside>

            <!-- Admin Main Content -->
            <div class="content-area">
                <div class="section-header" style="display:flex; justify-content:space-between; align-items:center;">
                    <h2 class="section-title">Registered Users</h2>
                    <button class="btn btn-primary btn-sm"
                        onclick="document.getElementById('provisionModal').style.display='flex'">+ Provision New Admin</button>
                </div>

                <!-- Provision Modal -->
                <div id="provisionModal"
                    style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
                    <div class="card" style="width:100%; max-width:400px; padding:2rem;">
                        <h3 style="margin-bottom:1.5rem;">Provision New Administrator</h3>
                        <form action="admin" method="POST">
                            <input type="hidden" name="action" value="provision">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" name="name" required placeholder="John Doe">
                            </div>
                            <div class="form-group">
                                <label>Email Identifier</label>
                                <input type="email" name="email" required placeholder="admin@apex.tech">
                            </div>
                            <div class="form-group">
                                <label>Security Key</label>
                                <input type="password" name="password" required placeholder="••••••••">
                            </div>
                            <div style="display:flex; gap:1rem; margin-top:1.5rem;">
                                <button type="submit" class="btn btn-primary btn-full">Create Admin Account</button>
                                <button type="button" class="btn btn-outline btn-full"
                                    onclick="document.getElementById('provisionModal').style.display='none'">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>

                <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"
                    style="background:#dcfce7; color:#166534; padding:0.75rem; border-radius:6px; margin-bottom:1rem; font-size:0.9rem; border:1px solid #bbf7d0;">
                    Action completed successfully!
                </div>
                <% } %>
                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error"
                    style="background:#fee2e2; color:#b91c1c; padding:0.75rem; border-radius:6px; margin-bottom:1rem; font-size:0.9rem; border:1px solid #fecaca;">
                    Error: <%= request.getParameter("error") %>
                </div>
                <% } %>

                <!-- Users Table -->
                <div class="card" style="padding:0; overflow:hidden;">
                    <table style="width:100%; border-collapse:collapse; font-size:0.9rem;">
                        <thead style="background:var(--bg-sidebar); border-bottom:1px solid var(--border);">
                            <tr>
                                <th style="text-align:left; padding:1rem;">Name</th>
                                <th style="text-align:left; padding:1rem;">Email</th>
                                <th style="text-align:left; padding:1rem;">Role</th>
                                <th style="text-align:left; padding:1rem;">Status</th>
                                <th style="text-align:right; padding:1rem;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Map<String, Object> u : userList) {
                                String role = (String) u.get("role");
                                if (role == null) role = "user";
                                String status = (String) u.get("status");
                                if (status == null) status = "active";
                                String uId = (String) u.get("_id");
                                String roleBg    = "admin".equals(role)   ? "#fee2e2" : "#f1f5f9";
                                String roleColor = "admin".equals(role)   ? "#991b1b" : "#475569";
                                String statusBg  = "active".equals(status)? "#f0fdf4" : "#fef2f2";
                                String statusColor="active".equals(status)? "#16a34a" : "#dc2626";
                            %>
                            <tr style="border-bottom:1px solid var(--border-light);">
                                <td style="padding:1rem;"><strong><%= u.get("name") %></strong></td>
                                <td style="padding:1rem; color:var(--text-secondary);"><%= u.get("email") %></td>
                                <td style="padding:1rem;">
                                    <span class="badge" style="background:<%= roleBg %>; color:<%= roleColor %>;"><%= role %></span>
                                </td>
                                <td style="padding:1rem;">
                                    <span class="badge" style="background:<%= statusBg %>; color:<%= statusColor %>;"><%= status %></span>
                                </td>
                                <td style="padding:1rem; text-align:right; display:flex; justify-content:flex-end; gap:0.5rem;">
                                    <form action="admin" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="restrict">
                                        <input type="hidden" name="userId" value="<%= uId %>">
                                        <input type="hidden" name="currentStatus" value="<%= status %>">
                                        <button type="submit" class="btn btn-sm"
                                            style="font-size:0.8rem; background:#f1f5f9; color:var(--text-secondary);">
                                            <%= "active".equals(status) ? "Restrict" : "Activate" %>
                                        </button>
                                    </form>
                                    <% if (!"admin".equals(role)) { %>
                                    <form action="admin" method="POST" style="display:inline;">
                                        <input type="hidden" name="action" value="promote">
                                        <input type="hidden" name="userId" value="<%= uId %>">
                                        <button type="submit" class="btn btn-sm"
                                            style="font-size:0.8rem; background:var(--primary-light); color:var(--primary);">Promote</button>
                                    </form>
                                    <% } %>
                                    <form action="admin" method="POST" style="display:inline;"
                                        onsubmit="return confirm('Are you sure you want to delete this user?');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="<%= uId %>">
                                        <button type="submit" class="btn btn-sm"
                                            style="font-size:0.8rem; background:#fef2f2; color:var(--danger);">Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Stats Strip -->
                <div class="features-grid" style="margin-top:2rem;">
                    <div class="feature-card">
                        <div class="feature-value"><%= userList.size() %></div>
                        <div class="feature-label">Total Users</div>
                        <p class="feature-desc">Managed across Apex platform.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-value" style="color:var(--success);">Active</div>
                        <div class="feature-label">Scraper Engine</div>
                        <p class="feature-desc">All threads operating within normal parameters.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-value">2ms</div>
                        <div class="feature-label">DB Latency</div>
                        <p class="feature-desc">Firebase Realtime performance health.</p>
                    </div>
                </div>

                <!-- Activities & Analytics -->
                <div class="page-grid" style="grid-template-columns:1fr 1fr; margin-top:2rem; gap:2rem;">

                    <!-- Recent Activities -->
                    <div class="content-area">
                        <div class="section-header">
                            <h2 class="section-title">Recent Activities</h2>
                        </div>
                        <div class="card" style="max-height:400px; overflow-y:auto; padding:0;">
                            <% if (activities.isEmpty()) { %>
                            <div style="padding:2rem; text-align:center; color:var(--text-muted); font-size:0.9rem;">
                                No activity records found.
                            </div>
                            <% } else { for (Map<String, Object> act : activities) {
                                String ts = act.get("timestamp") != null
                                    ? act.get("timestamp").toString().replace("T", " ").substring(0, Math.min(16, act.get("timestamp").toString().length()))
                                    : "";
                            %>
                            <div style="padding:1rem; border-bottom:1px solid var(--border-light);">
                                <div style="display:flex; justify-content:space-between; align-items:start;">
                                    <strong style="font-size:0.9rem;"><%= act.get("name") %></strong>
                                    <span style="font-size:0.75rem; color:var(--text-muted);"><%= ts %></span>
                                </div>
                                <p style="font-size:0.85rem; color:var(--primary); margin:0.2rem 0;"><%= act.get("action") %></p>
                                <p style="font-size:0.8rem; color:var(--text-secondary);"><%= act.get("details") %></p>
                            </div>
                            <% } } %>
                        </div>
                    </div>

                    <!-- Most Scouted Items -->
                    <div class="content-area">
                        <div class="section-header">
                            <h2 class="section-title">Most Scouted Items</h2>
                        </div>
                        <div class="card" style="padding:0;">
                            <% if (analytics.isEmpty()) { %>
                            <div style="padding:2rem; text-align:center; color:var(--text-muted); font-size:0.9rem;">
                                No scouting data found.
                            </div>
                            <% } else {
                                List<Map.Entry<String, Integer>> sortedItems = new ArrayList<>(analytics.entrySet());
                                sortedItems.sort((e1, e2) -> e2.getValue().compareTo(e1.getValue()));
                                int count = 0;
                                for (Map.Entry<String, Integer> entry : sortedItems) {
                                    if (count++ >= 8) break;
                            %>
                            <div style="padding:1rem; border-bottom:1px solid var(--border-light); display:flex; justify-content:space-between; align-items:center;">
                                <span style="font-size:0.85rem; font-weight:500; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width:70%;">
                                    <%= entry.getKey() %>
                                </span>
                                <span class="badge" style="background:var(--primary-light); color:var(--primary);">
                                    <%= entry.getValue() %> Scouts
                                </span>
                            </div>
                            <% } } %>
                        </div>
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