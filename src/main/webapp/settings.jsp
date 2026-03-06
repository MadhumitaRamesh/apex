<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Settings — Apex</title>
        <link rel="stylesheet" href="css/styles.css?v=2.0">
        <style>
            .settings-container {
                max-width: 650px;
                margin: 2rem auto;
                padding: 0 1.5rem;
            }

            .settings-card {
                background: #fff;
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                padding: 2rem;
                margin-bottom: 1.5rem;
            }

            .settings-title {
                font-size: 1.25rem;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .form-group {
                margin-bottom: 1.25rem;
            }

            .form-label {
                display: block;
                font-size: 0.85rem;
                font-weight: 600;
                color: #64748b;
                margin-bottom: 0.5rem;
            }

            .form-input {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid #e2e8f0;
                border-radius: 8px;
                font-size: 0.95rem;
                color: #1e293b;
                transition: all 0.2s;
            }

            .form-input:focus {
                outline: none;
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
            }

            .btn-save {
                background: #2563eb;
                color: #fff;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s;
            }

            .btn-save:hover {
                background: #1d4ed8;
            }

            .alert-toast {
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1.5rem;
                font-size: 0.9rem;
            }

            .alert-success {
                background: #dcfce7;
                color: #16a34a;
                border: 1px solid #bbf7d0;
            }

            .alert-error {
                background: #fee2e2;
                color: #dc2626;
                border: 1px solid #fecaca;
            }

            .toggle-group {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem 0;
                border-bottom: 1px solid #f1f5f9;
            }

            .toggle-group:last-child {
                border-bottom: none;
            }
        </style>
    </head>

    <body>
        <jsp:include page="includes/navbar.jsp" />

        <div class="page-wrapper">
            <div class="settings-container">
                <div class="page-header" style="text-align: left; margin-bottom: 2rem;">
                    <a href="dashboard.jsp" class="back-link">&#8592; Back to Hub</a>
                    <h1 class="page-title">Settings & Alerts</h1>
                    <p class="page-subtitle">Manage your scout profile and market monitoring preferences.</p>
                </div>

                <% if ("updated".equals(request.getParameter("success"))) { %>
                    <div class="alert-toast alert-success">Profile updated successfully!</div>
                    <% } %>
                        <% if (request.getParameter("error") !=null) { %>
                            <div class="alert-toast alert-error">Update failed. Please try again.</div>
                            <% } %>

                                <!-- Account Settings -->
                                <div class="settings-card">
                                    <h2 class="settings-title">👤 Account Management</h2>
                                    <form action="auth" method="POST">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="email" value="${user}">

                                        <div class="form-group">
                                            <label class="form-label">Email Address</label>
                                            <input type="text" class="form-input" value="${user}" disabled
                                                style="background:#f8fafc;">
                                            <p style="font-size:0.7rem; color:#94a3b8; margin-top:0.4rem;">Email cannot
                                                be changed.</p>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Scout Name (Username)</label>
                                            <input type="text" name="name" class="form-input" value="${userName}"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">New Password</label>
                                            <input type="password" name="password" class="form-input"
                                                placeholder="Leave blank to keep current">
                                        </div>

                                        <button type="submit" class="btn-save">Update Profile</button>
                                    </form>
                                </div>

                                <!-- Notification Settings -->
                                <div class="settings-card">
                                    <h2 class="settings-title">🔔 Price Alerts</h2>
                                    <p style="font-size:0.85rem; color:#64748b; margin-bottom:1.5rem;">
                                        Configure how Apex notifies you when target prices are reached.
                                    </p>

                                    <div class="toggle-group">
                                        <div>
                                            <div style="font-weight:600; color:#1e293b; font-size:0.9rem;">Price Drop
                                                Alerts</div>
                                            <div style="font-size:0.75rem; color:#94a3b8;">Notify me when a tracked item
                                                drops below 10%</div>
                                        </div>
                                        <input type="checkbox" checked>
                                    </div>

                                    <div class="toggle-group">
                                        <div>
                                            <div style="font-weight:600; color:#1e293b; font-size:0.9rem;">Weekly Market
                                                Report</div>
                                            <div style="font-size:0.75rem; color:#94a3b8;">Summary of trends for your
                                                saved categories</div>
                                        </div>
                                        <input type="checkbox">
                                    </div>

                                    <div class="toggle-group">
                                        <div>
                                            <div style="font-weight:600; color:#1e293b; font-size:0.9rem;">Browser
                                                Notifications</div>
                                            <div style="font-size:0.75rem; color:#94a3b8;">Instant alerts while browsing
                                                the marketplace</div>
                                        </div>
                                        <input type="checkbox" checked>
                                    </div>
                                </div>

            </div>

            <footer class="page-footer">
                <p>&copy; 2026 Apex Analytics &bull; Secure Profile Management</p>
            </footer>
        </div>
    </body>

    </html>