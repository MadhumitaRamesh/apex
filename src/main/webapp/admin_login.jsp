<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Login | Apex Control</title>
        <link rel="stylesheet" href="css/styles.css?v=2.0">
        <style>
            :root {
                --primary: #1e293b;
                --primary-hover: #0f172a;
            }
        </style>
    </head>

    <body>
        <jsp:include page="includes/navbar.jsp" />

        <div class="auth-page" style="background: #f8fafc;">
            <div class="auth-card" style="border-top: 4px solid #1e293b;">
                <p class="auth-eyebrow" style="color: #64748b;">Internal Access Only</p>
                <h1 class="auth-title">Admin Console</h1>
                <p class="auth-subtitle">Credential verification required for system-level access.</p>

                <% if (request.getAttribute("error") !=null) { %>
                    <div class="alert alert-error"
                        style="background:#fee2e2; color:#b91c1c; padding:0.75rem; border-radius:6px; margin-bottom:1rem; font-size:0.9rem; border:1px solid #fecaca;">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                        <form action="auth" method="POST">
                            <input type="hidden" name="action" value="login">

                            <div class="form-group">
                                <label for="email">Admin Identifier</label>
                                <input type="email" id="email" name="email" required placeholder="admin@apex.tech">
                            </div>

                            <div class="form-group">
                                <label for="password">Security Key</label>
                                <input type="password" id="password" name="password" required placeholder="••••••••">
                            </div>

                            <button type="submit" class="btn btn-primary btn-full"
                                style="margin-top:0.5rem; background: var(--primary); padding:0.8rem;">
                                Authenticate Admin
                            </button>
                        </form>

                        <p class="auth-footer"
                            style="margin-top:1.5rem; text-align:center; font-size:0.85rem; color:#94a3b8;">
                            Unauthorized access attempts are monitored and logged.
                        </p>
            </div>
        </div>
    </body>

    </html>