<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign In | Apex</title>
        <meta name="description" content="Sign in to your Apex account to access market intelligence.">
        <link rel="stylesheet" href="css/styles.css?v=2.0">
    </head>

    <body>
        <jsp:include page="includes/navbar.jsp" />

        <div class="auth-page">
            <div class="auth-card">
                <p class="auth-eyebrow">Secure Access</p>
                <h1 class="auth-title">Welcome back</h1>
                <p class="auth-subtitle">Sign in to access your market intelligence dashboard.</p>

                <% if (request.getAttribute("error") !=null) { %>
                    <div class="alert alert-error"
                        style="background:#fee2e2; color:#b91c1c; padding:0.75rem; border-radius:6px; margin-bottom:1rem; font-size:0.9rem; border:1px solid #fecaca;">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                        <% if (request.getParameter("success") !=null) { %>
                            <div class="alert alert-success"
                                style="background:#dcfce7; color:#15803d; padding:0.75rem; border-radius:6px; margin-bottom:1rem; font-size:0.9rem; border:1px solid #bbf7d0;">
                                Registration successful! Please sign in.
                            </div>
                            <% } %>

                                <form action="auth" method="POST">
                                    <input type="hidden" name="action" value="login">

                                    <div class="form-group">
                                        <label for="email">Email Address</label>
                                        <input type="email" id="email" name="email" required
                                            placeholder="you@example.com">
                                    </div>

                                    <div class="form-group">
                                        <label for="password">Password</label>
                                        <input type="password" id="password" name="password" required
                                            placeholder="••••••••">
                                    </div>

                                    <button type="submit" class="btn btn-primary btn-full"
                                        style="margin-top:0.5rem;padding:0.8rem; width:100%; cursor:pointer;">
                                        Sign In
                                    </button>
                                </form>

                                <p class="auth-footer"
                                    style="margin-top:1.5rem; text-align:center; font-size:0.9rem; color:#64748b;">
                                    Don't have an account? <a href="register.jsp"
                                        style="color:#2563eb; text-decoration:none; font-weight:500;">Create one</a>
                                </p>
            </div>
        </div>
    </body>

    </html>