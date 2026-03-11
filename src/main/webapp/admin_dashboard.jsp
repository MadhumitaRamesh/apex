<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                        <div class="stat-value">
                            <%= session.getAttribute("userName") %>
                        </div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-label">Access Level</div>
                        <div class="stat-value" style="color: var(--danger);">System Administrator</div>
                    </div>

                    <p class="sidebar-title" style="margin-top:2rem;">Management Utilities</p>
                    <nav class="quick-links">
                        <a href="admin_dashboard.jsp" class="active">Overview & Users</a>
                        <a href="#">Scraper Status</a>
                        <a href="#">System Logs</a>
                        <a href="index.jsp" class="link-primary">← Switch to User View</a>
                    </nav>
                </aside>

                <!-- Admin Main Content -->
                <div class="content-area">
                    <div class="section-header"
                        style="display:flex; justify-content:space-between; align-items:center;">
                        <h2 class="section-title">Registered Users</h2>
                        <button class="btn btn-primary btn-sm">+ Provision New Admin</button>
                    </div>

                    <% com.google.firebase.database.DatabaseReference
                        usersRef=com.google.firebase.database.FirebaseDatabase.getInstance().getReference("users");
                        java.util.concurrent.CompletableFuture<java.util.List<java.util.Map<String, Object>>> userFuture
                        =
                        new java.util.concurrent.CompletableFuture<>();

                            usersRef.addListenerForSingleValueEvent(new
                            com.google.firebase.database.ValueEventListener() {
                            @Override
                            public void onDataChange(com.google.firebase.database.DataSnapshot snapshot) {
                            java.util.List<java.util.Map<String, Object>> users = new java.util.ArrayList<>();
                                    for (com.google.firebase.database.DataSnapshot snap : snapshot.getChildren()) {
                                    java.util.Map<String, Object> u = (java.util.Map<String, Object>) snap.getValue();
                                            if (u != null) {
                                            u.put("_id", snap.getKey());
                                            users.add(u);
                                            }
                                            }
                                            userFuture.complete(users);
                                            }
                                            @Override
                                            public void onCancelled(com.google.firebase.database.DatabaseError error) {
                                            userFuture.completeExceptionally(error.toException());
                                            }
                                            });

                                            try {
                                            java.util.List<java.util.Map<String, Object>> userList = userFuture.get(8,
                                                java.util.concurrent.TimeUnit.SECONDS);
                                                %>

                                                <div class="card" style="padding:0;">
                                                    <table
                                                        style="width:100%; border-collapse: collapse; font-size:0.9rem;">
                                                        <thead
                                                            style="background:var(--bg-sidebar); border-bottom:1px solid var(--border);">
                                                            <tr>
                                                                <th style="text-align:left; padding:1rem;">Name</th>
                                                                <th style="text-align:left; padding:1rem;">Email</th>
                                                                <th style="text-align:left; padding:1rem;">Permissions
                                                                </th>
                                                                <th style="text-align:right; padding:1rem;">Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (java.util.Map<String, Object> u : userList) {
                                                                String role = (String) u.get("role");
                                                                if (role == null) role = "user";
                                                                %>
                                                                <tr
                                                                    style="border-bottom:1px solid var(--border-light);">
                                                                    <td style="padding:1rem;"><strong>
                                                                            <%= u.get("name") %>
                                                                        </strong></td>
                                                                    <td
                                                                        style="padding:1rem; color:var(--text-secondary);">
                                                                        <%= u.get("email") %>
                                                                    </td>
                                                                    <td style="padding:1rem;">
                                                                        <span class="badge"
                                                                            style="background:<%= role.equals(" admin")
                                                                            ? "#fee2e2" : "#f1f5f9" %>; color:<%=
                                                                                role.equals("admin") ? "#991b1b"
                                                                                : "#475569" %>;">
                                                                                <%= role %>
                                                                        </span>
                                                                    </td>
                                                                    <td style="padding:1rem; text-align:right;">
                                                                        <a href="#"
                                                                            style="color:var(--primary); font-weight:600; margin-right:1rem;">Edit</a>
                                                                        <a href="#"
                                                                            style="color:var(--danger); font-weight:600;">Restrict</a>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>

                                                <div class="features-grid" style="margin-top:2rem;">
                                                    <div class="feature-card">
                                                        <div class="feature-value">
                                                            <%= userList.size() %>
                                                        </div>
                                                        <div class="feature-label">Total Users</div>
                                                        <p class="feature-desc">Managed across Apex platform.</p>
                                                    </div>
                                                    <div class="feature-card">
                                                        <div class="feature-value" style="color:var(--success);">Active
                                                        </div>
                                                        <div class="feature-label">Scraper Engine</div>
                                                        <p class="feature-desc">All threads operating within normal
                                                            parameters.</p>
                                                    </div>
                                                    <div class="feature-card">
                                                        <div class="feature-value">2ms</div>
                                                        <div class="feature-label">DB Latency</div>
                                                        <p class="feature-desc">Firebase Realtime performance health.
                                                        </p>
                                                    </div>
                                                </div>

                                                <% } catch (Exception e) { %>
                                                    <div class="alert alert-error">Failed to fetch system data: <%=
                                                            e.getMessage() %>
                                                    </div>
                                                    <% } %>
                </div>
            </div>

            <footer class="page-footer">
                <p>&copy; 2026 Apex Control &bull; System Administration Module</p>
            </footer>
        </div>
    </body>

    </html>