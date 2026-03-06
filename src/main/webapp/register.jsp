<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Account | Apex</title>
        <meta name="description" content="Create your free Apex account and start tracking market prices instantly.">
        <link rel="stylesheet" href="css/styles.css?v=2.0">
    </head>

    <body>
        <jsp:include page="includes/navbar.jsp" />

        <div class="auth-page">
            <div class="auth-card">
                <p class="auth-eyebrow">Join Apex</p>
                <h1 class="auth-title">Create your account</h1>
                <p class="auth-subtitle">Join Apex and start making smarter buying decisions.</p>

                <% if (request.getAttribute("error") !=null) { %>
                    <div class="alert alert-error"
                        style="background:#fee2e2; color:#b91c1c; padding:0.75rem; border-radius:6px; margin-bottom:1rem; font-size:0.9rem; border:1px solid #fecaca;">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                        <form action="auth" method="POST">
                            <input type="hidden" name="action" value="register">

                            <div class="form-group">
                                <label for="name">Full Name</label>
                                <input type="text" id="name" name="name" required placeholder="Your Name">
                            </div>

                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" id="email" name="email" required placeholder="you@example.com">
                            </div>

                            <div class="form-group">
                                <label for="password">Password</label>
                                <input type="password" id="password" name="password" required
                                    placeholder="Create a strong password">
                            </div>

                            <button type="submit" class="btn btn-primary btn-full"
                                style="margin-top:0.5rem;padding:0.8rem; width:100%; cursor:pointer;">
                                Create Account
                            </button>
                        </form>

                        <p class="auth-footer"
                            style="margin-top:1.5rem; text-align:center; font-size:0.9rem; color:#64748b;">
                            Already have an account? <a href="login.jsp"
                                style="color:#2563eb; text-decoration:none; font-weight:500;">Sign in</a>
                        </p>
            </div>
        </div>
    </body>

    </html>