<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("admin_login.jsp?error=access_denied");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> activities = (List<Map<String, Object>>) request.getAttribute("activities");
    if (activities == null) activities = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Logs | Apex Console</title>
    <link rel="stylesheet" href="css/styles.css?v=2.0">
    <style>
        .log-table { width:100%; border-collapse:collapse; font-size:0.85rem; }
        .log-table thead tr { background:var(--bg-sidebar); border-bottom:2px solid var(--border); }
        .log-table th { text-align:left; padding:0.9rem 1rem; font-size:0.75rem; font-weight:600;
                        text-transform:uppercase; letter-spacing:0.05em; color:var(--text-secondary); }
        .log-table tbody tr { border-bottom:1px solid var(--border-light); vertical-align:middle;
                              transition:background 0.15s; }
        .log-table tbody tr:hover { background:var(--bg-sidebar); }
        .log-table td { padding:0.85rem 1rem; }

        /* Action badge colors */
        .badge-action { display:inline-flex; align-items:center; gap:0.35rem; padding:0.3rem 0.65rem;
                        border-radius:99px; font-size:0.73rem; font-weight:600; white-space:nowrap; }
        .badge-login        { background:#dbeafe; color:#1d4ed8; }
        .badge-logout       { background:#f1f5f9; color:#475569; }
        .badge-restrict     { background:#fef3c7; color:#92400e; }
        .badge-activate     { background:#dcfce7; color:#166534; }
        .badge-promote      { background:#ede9fe; color:#6d28d9; }
        .badge-delete       { background:#fee2e2; color:#b91c1c; }
        .badge-provision    { background:#fce7f3; color:#9d174d; }
        .badge-system       { background:#f0f9ff; color:#0369a1; }
        .badge-default      { background:var(--bg-sidebar); color:var(--text-secondary);
                              border:1px solid var(--border); }

        .ts { font-family:monospace; font-size:0.8rem; color:var(--text-muted); }
        .user-name { font-weight:600; font-size:0.88rem; }
        .user-email { font-size:0.75rem; color:var(--text-secondary); margin-top:0.15rem; }
        .detail-text { color:var(--text-secondary); max-width:320px; }

        .stats-bar { display:flex; gap:1.5rem; margin-bottom:1.5rem; flex-wrap:wrap; }
        .stat-pill { background:var(--bg-sidebar); border:1px solid var(--border);
                     border-radius:99px; padding:0.4rem 1rem; font-size:0.8rem;
                     display:flex; align-items:center; gap:0.4rem; }
        .stat-pill strong { color:var(--text-primary); }
        .stat-pill span   { color:var(--text-secondary); }

        .empty-state { padding:5rem 2rem; text-align:center; color:var(--text-muted); }
        .empty-icon  { font-size:3rem; margin-bottom:1rem; }
    </style>
</head>
<body>
    <jsp:include page="includes/navbar.jsp" />

    <div class="page-wrapper">
        <div class="page-header">
            <p class="page-label">Audit Trail</p>
            <h1 class="page-title">System Activity Logs</h1>
            <p class="page-subtitle">Complete history of administrative actions and system events.</p>
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
                    <a href="scraper_status.jsp">Scraper Status</a>
                    <a href="system_logs" class="active">System Logs</a>
                    <a href="index.jsp" class="link-primary">← Switch to User View</a>
                </nav>
            </aside>

            <!-- Main Content -->
            <div class="content-area">
                <%
                    // Compute quick stats
                    int loginCount = 0, adminActionCount = 0, systemCount = 0;
                    for (Map<String, Object> a : activities) {
                        String ac = a.get("action") != null ? a.get("action").toString() : "";
                        if ("LOGIN".equals(ac) || "LOGOUT".equals(ac)) loginCount++;
                        else if (ac.startsWith("SYSTEM_") || "SCRAPER_RUN".equals(ac) || "ALERT_SENT".equals(ac)) systemCount++;
                        else adminActionCount++;
                    }
                %>
                <div class="section-header">
                    <h2 class="section-title">Log Entries</h2>
                    <span class="badge" style="background:var(--primary-light); color:var(--primary); font-size:0.8rem;">
                        <%= activities.size() %> entries
                    </span>
                </div>

                <!-- Stats bar -->
                <div class="stats-bar">
                    <div class="stat-pill">📊 <strong><%= activities.size() %></strong> <span>Total Events</span></div>
                    <div class="stat-pill">🔑 <strong><%= loginCount %></strong> <span>Auth Events</span></div>
                    <div class="stat-pill">⚙️ <strong><%= adminActionCount %></strong> <span>Admin Actions</span></div>
                    <div class="stat-pill">🤖 <strong><%= systemCount %></strong> <span>System Events</span></div>
                </div>

                <div class="card" style="padding:0; overflow:hidden;">
                    <table class="log-table">
                        <thead>
                            <tr>
                                <th style="width:170px;">Timestamp</th>
                                <th style="width:190px;">Actor</th>
                                <th style="width:160px;">Action</th>
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (activities.isEmpty()) { %>
                            <tr>
                                <td colspan="4">
                                    <div class="empty-state">
                                        <div class="empty-icon">📋</div>
                                        <p style="font-size:1rem; font-weight:600;">No log entries yet</p>
                                        <p style="font-size:0.85rem; margin-top:0.5rem;">Activity will appear here as users log in and admins take actions.</p>
                                    </div>
                                </td>
                            </tr>
                            <% } else { for (Map<String, Object> act : activities) {
                                String ts = act.get("timestamp") != null
                                    ? act.get("timestamp").toString().replace("T", " ").substring(0, Math.min(19, act.get("timestamp").toString().length()))
                                    : "N/A";
                                String action = act.get("action") != null ? act.get("action").toString() : "";
                                String badgeClass;
                                String icon;
                                switch (action) {
                                    case "LOGIN":          badgeClass = "badge-login";     icon = "🔑"; break;
                                    case "LOGOUT":         badgeClass = "badge-logout";    icon = "🚪"; break;
                                    case "RESTRICT_USER":  badgeClass = "badge-restrict";  icon = "🚫"; break;
                                    case "ACTIVATE_USER":  badgeClass = "badge-activate";  icon = "✅"; break;
                                    case "PROMOTE_USER":   badgeClass = "badge-promote";   icon = "⬆️"; break;
                                    case "DELETE_USER":    badgeClass = "badge-delete";    icon = "🗑️"; break;
                                    case "PROVISION_ADMIN":badgeClass = "badge-provision"; icon = "👤"; break;
                                    case "SYSTEM_BOOT":
                                    case "SCRAPER_RUN":
                                    case "ALERT_SENT":     badgeClass = "badge-system";    icon = "🤖"; break;
                                    default:               badgeClass = "badge-default";   icon = "📝"; break;
                                }
                            %>
                            <tr>
                                <td><span class="ts"><%= ts %></span></td>
                                <td>
                                    <div class="user-name"><%= act.get("name") != null ? act.get("name") : "Unknown" %></div>
                                    <div class="user-email"><%= act.get("email") != null ? act.get("email") : "" %></div>
                                </td>
                                <td>
                                    <span class="badge-action <%= badgeClass %>">
                                        <%= icon %> <%= action.replace("_", " ") %>
                                    </span>
                                </td>
                                <td class="detail-text"><%= act.get("details") != null ? act.get("details") : "—" %></td>
                            </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <footer class="page-footer">
            <p>&copy; 2026 Apex Control &bull; System Administration Module</p>
        </footer>
    </div>
</body>
</html>
